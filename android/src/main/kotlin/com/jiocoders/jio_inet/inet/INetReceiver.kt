package com.jiocoders.jio_inet.inet

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager.NetworkCallback
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/**
 * The INetReceiver receives the network updates and send them to the UIThread
 * through an [EventChannel.EventSink]
 *
 * Use [ ][EventChannel.setStreamHandler] to set up the receiver.
 */
class INetReceiver(
    private val context: Context,
    private val iNet: INet
) :
    BroadcastReceiver(), EventChannel.StreamHandler {
    private var events: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var networkCallback: NetworkCallback? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.events = events
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            networkCallback =
                object : NetworkCallback() {
                    override fun onAvailable(network: Network) {
                        // onAvailable is called when the phone switches to a new network
                        // e.g. the phone was offline and gets wifi connection
                        // or the phone was on wifi and now switches to mobile.
                        // The plugin sends the current capability connection to the users.
                        sendEvent(iNet.getCapabilitiesFromNetwork(network))
                    }

                    override fun onCapabilitiesChanged(
                        network: Network, networkCapabilities: NetworkCapabilities
                    ) {
                        // This callback is called multiple times after a call to onAvailable
                        // this also causes multiple callbacks to the Flutter layer.
                        sendEvent(iNet.getCapabilitiesList(networkCapabilities))
                    }

                    override fun onLost(network: Network) {
                        // This callback is called when a capability is lost.
                        //
                        // The provided Network object contains information about the
                        // network capability that has been lost, so we cannot use it.
                        //
                        // Instead, post the current network but with a delay long enough
                        // that we avoid a race condition.
                        sendCurrentStatusWithDelay()
                    }
                }
            iNet.connectivityManager.registerDefaultNetworkCallback(networkCallback!!)
        } else {
            context.registerReceiver(this, IntentFilter(CONNECTIVITY_ACTION))
        }
        // Need to emit first event with connectivity types without waiting for first change in system
        // that might happen much later
        sendEvent(iNet.networkTypes)
    }

    override fun onCancel(arguments: Any?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (networkCallback != null) {
                iNet.connectivityManager.unregisterNetworkCallback(networkCallback!!)
                networkCallback = null
            }
        } else {
            try {
                context.unregisterReceiver(this)
            } catch (e: Exception) {
                // listen never called, ignore the error
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (events != null) {
            events?.success(iNet.networkTypes)
        }
    }

    private fun sendEvent(networkTypes: List<String>) {
        val runnable = Runnable { events?.success(networkTypes) }
        // Emit events on main thread
        mainHandler.post(runnable)
    }

    private fun sendCurrentStatusWithDelay() {
        val runnable = Runnable { events?.success(iNet.networkTypes) }
        // Emit events on main thread
        // 500 milliseconds to avoid race conditions
        mainHandler.postDelayed(runnable, 500)
    }

    companion object {
        const val CONNECTIVITY_ACTION: String = "android.net.conn.CONNECTIVITY_CHANGE"
    }
}