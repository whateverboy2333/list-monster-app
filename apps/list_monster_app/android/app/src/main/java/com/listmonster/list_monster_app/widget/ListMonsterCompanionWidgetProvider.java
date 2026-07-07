package com.listmonster.list_monster_app.widget;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.view.View;
import android.widget.RemoteViews;

import com.listmonster.list_monster_app.R;
import com.listmonster.list_monster_app.widget.CompanionSnapshotWidgetStore.CompanionWidgetSnapshot;
import com.listmonster.list_monster_app.widget.CompanionSnapshotWidgetStore.SnapshotState;

public final class ListMonsterCompanionWidgetProvider extends AppWidgetProvider {
    private static final String DESTINATION_MONSTER = "monster";
    private static final String DESTINATION_TODAY = "today";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        if (intent == null
                || !CompanionSnapshotWidgetStore.ACTION_REFRESH_WIDGET.equals(intent.getAction())) {
            return;
        }

        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        ComponentName provider = new ComponentName(context, ListMonsterCompanionWidgetProvider.class);
        for (int appWidgetId : appWidgetManager.getAppWidgetIds(provider)) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }

    private static void updateWidget(
            Context context,
            AppWidgetManager appWidgetManager,
            int appWidgetId
    ) {
        CompanionWidgetSnapshot snapshot = CompanionSnapshotWidgetStore.read(
                context,
                System.currentTimeMillis()
        );
        RemoteViews views = new RemoteViews(
                context.getPackageName(),
                R.layout.list_monster_companion_widget
        );

        bindSnapshot(context, views, snapshot);
        bindClicks(context, views, appWidgetId);
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static void bindSnapshot(
            Context context,
            RemoteViews views,
            CompanionWidgetSnapshot snapshot
    ) {
        views.setTextViewText(R.id.widget_status_badge, statusBadge(context, snapshot));
        views.setTextViewText(R.id.widget_monster_name, monsterTitle(context, snapshot));
        views.setTextViewText(R.id.widget_monster_meta, monsterMeta(context, snapshot));
        views.setTextViewText(R.id.widget_frame_asset, frameAsset(context, snapshot));
        views.setTextViewText(R.id.widget_progress_value, progressValue(context, snapshot));
        views.setProgressBar(R.id.widget_progress_bar, 100, snapshot.todayProgressPercent(), false);
        views.setTextViewText(R.id.widget_message, primaryMessage(context, snapshot));
        views.setTextViewText(R.id.widget_previous_feedback, secondaryMessage(context, snapshot));
        views.setViewVisibility(
                R.id.widget_previous_feedback,
                secondaryMessage(context, snapshot).isEmpty() ? View.GONE : View.VISIBLE
        );
    }

    private static void bindClicks(Context context, RemoteViews views, int appWidgetId) {
        PendingIntent monsterIntent = openAppIntent(context, appWidgetId, DESTINATION_MONSTER);
        PendingIntent todayIntent = openAppIntent(context, appWidgetId, DESTINATION_TODAY);

        views.setOnClickPendingIntent(R.id.widget_monster_frame, monsterIntent);
        views.setOnClickPendingIntent(R.id.widget_today_progress, todayIntent);
        views.setOnClickPendingIntent(R.id.widget_message, todayIntent);
        views.setOnClickPendingIntent(R.id.widget_previous_feedback, todayIntent);
        views.setOnClickPendingIntent(R.id.widget_root, todayIntent);
    }

    private static PendingIntent openAppIntent(
            Context context,
            int appWidgetId,
            String destination
    ) {
        Uri data = Uri.parse("listmonster://" + destination)
                .buildUpon()
                .appendQueryParameter("source", "android_widget")
                .appendQueryParameter("refresh", "companion_snapshot")
                .appendQueryParameter("widgetId", String.valueOf(appWidgetId))
                .build();
        Intent intent = new Intent(Intent.ACTION_VIEW, data);
        intent.setClassName(context.getPackageName(), context.getPackageName() + ".MainActivity");
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.putExtra("list_monster_destination", destination);
        intent.putExtra("list_monster_refresh_companion_snapshot", true);

        int flags = PendingIntent.FLAG_UPDATE_CURRENT;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags |= PendingIntent.FLAG_IMMUTABLE;
        }

        int requestCode = appWidgetId * 10 + (DESTINATION_MONSTER.equals(destination) ? 1 : 2);
        return PendingIntent.getActivity(context, requestCode, intent, flags);
    }

    private static String statusBadge(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.state == SnapshotState.FRESH) {
            return context.getString(R.string.widget_status_live);
        }
        if (snapshot.state == SnapshotState.EXPIRED) {
            return context.getString(R.string.widget_status_expired);
        }
        if (snapshot.state == SnapshotState.UNREADABLE) {
            return context.getString(R.string.widget_status_unreadable);
        }
        return context.getString(R.string.widget_status_empty);
    }

    private static String monsterTitle(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.monsterName.isEmpty()) {
            return context.getString(R.string.widget_monster_placeholder_name);
        }
        return context.getString(
                R.string.widget_monster_title,
                snapshot.monsterName,
                snapshot.level
        );
    }

    private static String monsterMeta(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.state != SnapshotState.FRESH && snapshot.state != SnapshotState.EXPIRED) {
            return context.getString(R.string.widget_monster_placeholder_meta);
        }
        return context.getString(
                R.string.widget_monster_meta,
                fallback(snapshot.stage),
                fallback(snapshot.moodState),
                fallback(snapshot.actionKey)
        );
    }

    private static String frameAsset(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.widgetFrameAssetId.isEmpty()) {
            return context.getString(R.string.widget_frame_placeholder);
        }
        return snapshot.widgetFrameAssetId;
    }

    private static String progressValue(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.state == SnapshotState.EXPIRED) {
            return context.getString(
                    R.string.widget_progress_expired_value,
                    snapshot.todayCompletedTasks,
                    snapshot.todayTotalTasks
            );
        }
        return context.getString(
                R.string.widget_progress_value,
                snapshot.todayCompletedTasks,
                snapshot.todayTotalTasks,
                snapshot.todayRemainingTasks
        );
    }

    private static String primaryMessage(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.state == SnapshotState.EXPIRED) {
            return context.getString(R.string.widget_message_expired);
        }
        if (snapshot.state == SnapshotState.EMPTY) {
            return context.getString(R.string.widget_message_empty);
        }
        if (snapshot.state == SnapshotState.UNREADABLE) {
            return context.getString(R.string.widget_message_unreadable);
        }
        if (snapshot.hasMilestone()) {
            return snapshot.milestoneTitle;
        }
        if (!snapshot.lineText.isEmpty()) {
            return snapshot.lineText;
        }
        return context.getString(R.string.widget_message_default);
    }

    private static String secondaryMessage(Context context, CompanionWidgetSnapshot snapshot) {
        if (snapshot.state != SnapshotState.FRESH && snapshot.state != SnapshotState.EXPIRED) {
            return "";
        }
        if (snapshot.hasPreviousFeedback()) {
            String title = snapshot.previousDayFeedbackTitle;
            String text = snapshot.previousDayFeedbackText;
            if (title.isEmpty()) {
                return text;
            }
            if (text.isEmpty()) {
                return title;
            }
            return context.getString(R.string.widget_previous_feedback_value, title, text);
        }
        return context.getString(
                R.string.widget_streak_value,
                snapshot.currentStreakDays,
                snapshot.bestStreakDays
        );
    }

    private static String fallback(String value) {
        if (value == null || value.isEmpty()) {
            return "-";
        }
        return value;
    }
}
