package com.jiocoders.jio_inet

import com.jiocoders.jio_inet.inet.INet
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class JioInetMethodChannelHandler(private val iNet: INet) : MethodChannel.MethodCallHandler {

    init {
        requireNotNull(iNet) { "Connectivity must not be null" }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "inet_type" -> result.success(iNet.networkTypes)

            else -> result.notImplemented()

        }
    }
}