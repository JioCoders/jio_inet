package com.jiocoders.jio_inet.inet

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi

/** Reports connectivity related information such as connectivity type and wifi information.  */
class INet(val connectivityManager: ConnectivityManager) {

    companion object {
        const val INET_NONE: String = "none"
        const val INET_WIFI: String = "wifi"
        const val INET_MOBILE: String = "mobile"
        const val INET_ETHERNET: String = "ethernet"
        const val INET_BLUETOOTH: String = "bluetooth"
        const val INET_VPN: String = "vpn"
        const val INET_OTHER: String = "other"
    }

    val networkTypes: List<String>
        get() {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val network = connectivityManager.activeNetwork
                return getCapabilitiesFromNetwork(network)
            } else {
                // For legacy versions, return a single type as before or adapt similarly if multiple types
                // need to be supported
                return networkTypesLegacy
            }
        }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    fun getCapabilitiesFromNetwork(network: Network?): List<String> {
        val capabilities = connectivityManager.getNetworkCapabilities(network)
        return getCapabilitiesList(capabilities)
    }

    @NonNull
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    fun getCapabilitiesList(capabilities: NetworkCapabilities?): List<String> {
        val types: MutableList<String> = ArrayList()
        if (capabilities == null
            || !capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        ) {
            types.add(INET_NONE)
            return types
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
            || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI_AWARE)
        ) {
            types.add(INET_WIFI)
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
            types.add(INET_ETHERNET)
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
            types.add(INET_VPN)
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
            types.add(INET_MOBILE)
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_BLUETOOTH)) {
            types.add(INET_BLUETOOTH)
        }
        if (types.isEmpty()
            && capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        ) {
            types.add(INET_OTHER)
        }
        if (types.isEmpty()) {
            types.add(INET_NONE)
        }
        return types
    }

    @get:Suppress("deprecation")
    private val networkTypesLegacy: List<String>
        get() {
            // handle type for Android versions less than Android 6
            val info = connectivityManager.activeNetworkInfo
            val types: MutableList<String> = ArrayList()
            if (info == null || !info.isConnected) {
                types.add(INET_NONE)
                return types
            }
            val type = info.type
            when (type) {
                ConnectivityManager.TYPE_BLUETOOTH -> types.add(INET_BLUETOOTH)
                ConnectivityManager.TYPE_ETHERNET -> types.add(INET_ETHERNET)
                ConnectivityManager.TYPE_WIFI, ConnectivityManager.TYPE_WIMAX -> types.add(
                    INET_WIFI
                )

                ConnectivityManager.TYPE_VPN -> types.add(INET_VPN)
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_DUN, ConnectivityManager.TYPE_MOBILE_HIPRI -> types.add(
                    INET_MOBILE
                )

                else -> types.add(INET_OTHER)
            }
            return types
        }

    }