package com.listmonster.list_monster_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var widgetBridgeChannel: MethodChannel? = null
    private var initialWidgetLaunchIntent: Map<String, Any?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initialWidgetLaunchIntent = widgetLaunchIntentFrom(intent)
        widgetBridgeChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WIDGET_BRIDGE_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "persistCompanionSnapshot" -> {
                        val payloadJson = call.argument<String>("payloadJson")
                        if (payloadJson.isNullOrBlank()) {
                            result.error(
                                "invalid_payload",
                                "payloadJson is required",
                                null,
                            )
                            return@setMethodCallHandler
                        }
                        persistCompanionSnapshot(payloadJson)
                        result.success(null)
                    }
                    "consumeInitialWidgetLaunchIntent" -> {
                        result.success(initialWidgetLaunchIntent)
                        initialWidgetLaunchIntent = null
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val widgetLaunchIntent = widgetLaunchIntentFrom(intent) ?: return
        widgetBridgeChannel?.invokeMethod("widgetLaunchIntent", widgetLaunchIntent)
    }

    private fun persistCompanionSnapshot(payloadJson: String) {
        getSharedPreferences(WIDGET_PREFERENCES_NAME, MODE_PRIVATE)
            .edit()
            .putString(WIDGET_PAYLOAD_KEY, payloadJson)
            .apply()

        sendBroadcast(
            Intent(WIDGET_REFRESH_ACTION).setPackage(packageName),
        )
    }

    private fun widgetLaunchIntentFrom(intent: Intent?): Map<String, Any?>? {
        if (intent == null) {
            return null
        }

        val destination = intent.getStringExtra(EXTRA_DESTINATION)
            ?: intent.data?.host
            ?: return null
        if (destination != DESTINATION_TODAY && destination != DESTINATION_MONSTER) {
            return null
        }

        val refreshRequested =
            intent.getBooleanExtra(EXTRA_REFRESH_COMPANION_SNAPSHOT, false) ||
                intent.data?.getQueryParameter("refresh") == "companion_snapshot"
        val widgetId = intent.getIntExtra("widgetId", -1).takeIf { it >= 0 }
            ?: intent.data?.getQueryParameter("widgetId")?.toIntOrNull()

        return mapOf(
            "destination" to destination,
            "refreshCompanionSnapshot" to refreshRequested,
            "source" to (intent.data?.getQueryParameter("source") ?: "android_widget"),
            "widgetId" to widgetId,
        )
    }

    companion object {
        private const val WIDGET_BRIDGE_CHANNEL = "list_monster/companion_snapshot_widget"
        private const val WIDGET_PREFERENCES_NAME = "list_monster_companion_snapshot"
        private const val WIDGET_PAYLOAD_KEY = "payload_json"
        private const val WIDGET_REFRESH_ACTION =
            "com.listmonster.list_monster_app.widget.REFRESH_COMPANION_WIDGET"
        private const val EXTRA_DESTINATION = "list_monster_destination"
        private const val EXTRA_REFRESH_COMPANION_SNAPSHOT =
            "list_monster_refresh_companion_snapshot"
        private const val DESTINATION_TODAY = "today"
        private const val DESTINATION_MONSTER = "monster"
    }
}
