package com.example.random_roll_call

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {

    private val CHANNEL_BACK = "android/back/desktop"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.dartExecutor.let {
            MethodChannel(it, CHANNEL_BACK).setMethodCallHandler { methodCall, result ->
                if (methodCall.method == "backDesktop") {
                    result.success(true)
                    moveTaskToBack(false)
                }
            }

        }
    }
}