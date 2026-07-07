package com.listmonster.list_monster_app.widget;

import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.TimeZone;

// Glance migration point: keep this read-only snapshot contract when replacing RemoteViews.
final class CompanionSnapshotWidgetStore {
    static final String PREFERENCES_NAME = "list_monster_companion_snapshot";
    static final String KEY_PAYLOAD_JSON = "payload_json";
    static final String ACTION_REFRESH_WIDGET =
            "com.listmonster.list_monster_app.widget.REFRESH_COMPANION_WIDGET";

    private static final String FLUTTER_PREFERENCES_NAME = "FlutterSharedPreferences";
    private static final String[] PAYLOAD_KEYS = {
            KEY_PAYLOAD_JSON,
            "companion_snapshot_payload_json",
            "companion_snapshot_json",
            "flutter.list_monster_companion_snapshot_payload_json",
            "flutter.companion_snapshot_payload_json"
    };

    private CompanionSnapshotWidgetStore() {
    }

    static CompanionWidgetSnapshot read(Context context, long nowMillis) {
        String rawJson = readRawJson(context);
        if (rawJson == null || rawJson.trim().isEmpty()) {
            return CompanionWidgetSnapshot.empty();
        }

        try {
            JSONObject envelope = new JSONObject(rawJson);
            JSONObject payload = envelope.optJSONObject("payload");
            if (payload == null) {
                payload = envelope;
            }

            return CompanionWidgetSnapshot.fromJson(
                    payload,
                    resolveExpired(envelope, payload, nowMillis)
            );
        } catch (JSONException exception) {
            return CompanionWidgetSnapshot.unreadable();
        }
    }

    private static String readRawJson(Context context) {
        String contractValue = readFromPreferences(
                context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
        );
        if (contractValue != null) {
            return contractValue;
        }

        return readFromPreferences(
                context.getSharedPreferences(FLUTTER_PREFERENCES_NAME, Context.MODE_PRIVATE)
        );
    }

    private static String readFromPreferences(SharedPreferences preferences) {
        for (String key : PAYLOAD_KEYS) {
            String value = preferences.getString(key, null);
            if (value != null && !value.trim().isEmpty()) {
                return value;
            }
        }
        return null;
    }

    private static boolean resolveExpired(JSONObject envelope, JSONObject payload, long nowMillis) {
        if (payload.optBoolean("isStale", false)) {
            return true;
        }

        long explicitExpiresAt = parseIsoMillis(envelope.optString("expiresAt", null));
        if (explicitExpiresAt > 0L) {
            return nowMillis >= explicitExpiresAt;
        }

        long generatedAt = parseIsoMillis(payload.optString("generatedAt", null));
        int staleAfterSeconds = payload.optInt("staleAfterSeconds", -1);
        if (generatedAt <= 0L || staleAfterSeconds < 0) {
            return true;
        }

        long staleAfterMillis = staleAfterSeconds * 1000L;
        return nowMillis >= generatedAt + staleAfterMillis;
    }

    private static long parseIsoMillis(String value) {
        if (value == null || value.trim().isEmpty()) {
            return -1L;
        }

        String[] patterns = {
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                "yyyy-MM-dd'T'HH:mm:ss'Z'"
        };
        for (String pattern : patterns) {
            try {
                SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale.US);
                formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
                return formatter.parse(value).getTime();
            } catch (ParseException | NullPointerException ignored) {
                // Try the next CompanionSnapshot timestamp shape.
            }
        }
        return -1L;
    }

    static final class CompanionWidgetSnapshot {
        final SnapshotState state;
        final String monsterName;
        final String stage;
        final String moodState;
        final String actionKey;
        final String widgetFrameAssetId;
        final String lineText;
        final String milestoneTitle;
        final String previousDayFeedbackTitle;
        final String previousDayFeedbackText;
        final int level;
        final int todayCompletedTasks;
        final int todayTotalTasks;
        final int todayRemainingTasks;
        final int currentStreakDays;
        final int bestStreakDays;

        private CompanionWidgetSnapshot(
                SnapshotState state,
                String monsterName,
                String stage,
                String moodState,
                String actionKey,
                String widgetFrameAssetId,
                String lineText,
                String milestoneTitle,
                String previousDayFeedbackTitle,
                String previousDayFeedbackText,
                int level,
                int todayCompletedTasks,
                int todayTotalTasks,
                int todayRemainingTasks,
                int currentStreakDays,
                int bestStreakDays
        ) {
            this.state = state;
            this.monsterName = monsterName;
            this.stage = stage;
            this.moodState = moodState;
            this.actionKey = actionKey;
            this.widgetFrameAssetId = widgetFrameAssetId;
            this.lineText = lineText;
            this.milestoneTitle = milestoneTitle;
            this.previousDayFeedbackTitle = previousDayFeedbackTitle;
            this.previousDayFeedbackText = previousDayFeedbackText;
            this.level = level;
            this.todayCompletedTasks = todayCompletedTasks;
            this.todayTotalTasks = todayTotalTasks;
            this.todayRemainingTasks = todayRemainingTasks;
            this.currentStreakDays = currentStreakDays;
            this.bestStreakDays = bestStreakDays;
        }

        static CompanionWidgetSnapshot fromJson(JSONObject json, boolean expired) {
            return new CompanionWidgetSnapshot(
                    expired ? SnapshotState.EXPIRED : SnapshotState.FRESH,
                    clean(json.optString("monsterName", "")),
                    clean(json.optString("stage", "")),
                    clean(json.optString("moodState", "")),
                    clean(json.optString("actionKey", "")),
                    clean(json.optString("widgetFrameAssetId", "")),
                    clean(json.optString("lineText", "")),
                    clean(json.optString("todayTaskMilestoneTitle", "")),
                    clean(json.optString("previousDayFeedbackTitle", "")),
                    clean(json.optString("previousDayFeedbackText", "")),
                    Math.max(0, json.optInt("level", 0)),
                    Math.max(0, json.optInt("todayCompletedTasks", 0)),
                    Math.max(0, json.optInt("todayTotalTasks", 0)),
                    Math.max(0, json.optInt("todayRemainingTasks", 0)),
                    Math.max(0, json.optInt("currentStreakDays", 0)),
                    Math.max(0, json.optInt("bestStreakDays", 0))
            );
        }

        static CompanionWidgetSnapshot empty() {
            return placeholder(SnapshotState.EMPTY);
        }

        static CompanionWidgetSnapshot unreadable() {
            return placeholder(SnapshotState.UNREADABLE);
        }

        int todayProgressPercent() {
            if (todayTotalTasks <= 0) {
                return 0;
            }
            return Math.min(100, Math.round(todayCompletedTasks * 100f / todayTotalTasks));
        }

        boolean hasPreviousFeedback() {
            return !previousDayFeedbackTitle.isEmpty() || !previousDayFeedbackText.isEmpty();
        }

        boolean hasMilestone() {
            return !milestoneTitle.isEmpty();
        }

        private static CompanionWidgetSnapshot placeholder(SnapshotState state) {
            return new CompanionWidgetSnapshot(
                    state,
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
            );
        }

        private static String clean(String value) {
            if (value == null || "null".equals(value)) {
                return "";
            }
            return value.trim();
        }
    }

    enum SnapshotState {
        FRESH,
        EXPIRED,
        EMPTY,
        UNREADABLE
    }
}
