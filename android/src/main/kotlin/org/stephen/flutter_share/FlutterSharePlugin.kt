package org.stephen.flutter_share

import android.app.Activity
import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterSharePlugin : MethodCallHandler {
    companion object {
        var activity: Activity? = null;

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_share")
            channel.setMethodCallHandler(FlutterSharePlugin())
            activity = registrar.activity()
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            call.method == "share" -> {
                var title = call.argument<String>("title")
                val url = call.argument<String>("url")
                var intent = Intent()
                intent.action = Intent.ACTION_SEND
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
                    intent.`package`="com.tencent.mm"
                }
                intent.putExtra(Intent.EXTRA_TEXT, title)
                intent.putExtra(Intent.EXTRA_SUBJECT, url)
                intent.type = "text/plain"
                var chooseIntent = Intent.createChooser(intent, null)
                activity?.startActivity(chooseIntent)

            }
            else -> result.notImplemented()
        }
    }
}
