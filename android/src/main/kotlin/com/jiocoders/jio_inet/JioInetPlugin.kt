package com.jiocoders.jio_inet

import android.content.Context
import android.net.ConnectivityManager
import com.jiocoders.jio_inet.inet.INet
import com.jiocoders.jio_inet.inet.INetReceiver
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** JioInetPlugin */
class JioInetPlugin: FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel: EventChannel

  private var iNetReceiver: INetReceiver? = null
  private var appContext: Context? = null


  override fun onAttachedToEngine(flutterBinding: FlutterPlugin.FlutterPluginBinding) {
    this.appContext = flutterBinding.applicationContext
    methodChannel = MethodChannel(flutterBinding.binaryMessenger, "com.jiocoders/jio_inet")
    eventChannel = EventChannel(flutterBinding.binaryMessenger, "com.jiocoders/jio_inet_status")

    setupChannels(this.appContext!!)
  }

  private fun setupChannels(context: Context) {
    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    var iNet: INet = INet(cm)

    val methodChannelHandler = JioInetMethodChannelHandler(iNet)
    iNetReceiver = INetReceiver(context, iNet)

    methodChannel.setMethodCallHandler(methodChannelHandler)
    eventChannel.setStreamHandler(iNetReceiver)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    iNetReceiver!!.onCancel(null)
    iNetReceiver = null
  }
}
