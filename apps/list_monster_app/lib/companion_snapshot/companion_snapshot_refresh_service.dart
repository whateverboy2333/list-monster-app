import 'package:companion_contract/companion_contract.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_builder.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';

enum CompanionSnapshotRefreshTrigger {
  appOpened,
  taskCreated,
  taskCompleted,
  taskCompletionUndone,
  taskRestored,
  growthChanged,
  manual,
}

enum CompanionSnapshotReadState { fresh, needsRefresh }

class CompanionSnapshotReadResult {
  const CompanionSnapshotReadResult._({
    required this.state,
    required this.snapshot,
  });

  const CompanionSnapshotReadResult.fresh(CompanionSnapshot snapshot)
    : this._(state: CompanionSnapshotReadState.fresh, snapshot: snapshot);

  const CompanionSnapshotReadResult.needsRefresh({CompanionSnapshot? snapshot})
    : this._(
        state: CompanionSnapshotReadState.needsRefresh,
        snapshot: snapshot,
      );

  final CompanionSnapshotReadState state;
  final CompanionSnapshot? snapshot;

  bool get needsRefresh => state == CompanionSnapshotReadState.needsRefresh;
}

class CompanionSnapshotRefreshService {
  CompanionSnapshotRefreshService({
    required this.localStore,
    CompanionSnapshotWidgetBridge? widgetBridge,
  }) : widgetBridge =
           widgetBridge ?? MethodChannelCompanionSnapshotWidgetBridge();

  final LocalStorePort localStore;
  final CompanionSnapshotWidgetBridge widgetBridge;

  Future<CompanionSnapshot> refresh(
    TaskSystemController controller, {
    DateTime? generatedAt,
    int staleAfterSeconds = defaultCompanionSnapshotStaleAfterSeconds,
    bool hideTaskTitlesOutsideApp = true,
    CompanionDesktopPetState desktopPetState =
        CompanionDesktopPetState.disabled,
    bool dndActive = false,
    CompanionStyleLine styleLine = CompanionStyleLine.soft,
  }) async {
    final snapshot = buildCompanionSnapshot(
      controller,
      generatedAt: generatedAt,
      staleAfterSeconds: staleAfterSeconds,
      hideTaskTitlesOutsideApp: hideTaskTitlesOutsideApp,
      desktopPetState: desktopPetState,
      dndActive: dndActive,
      styleLine: styleLine,
    );
    final localSnapshot = _toLocalSnapshot(snapshot);
    await localStore.saveCompanionSnapshot(localSnapshot);
    await widgetBridge.persistSnapshot(localSnapshot);
    return snapshot;
  }

  Future<CompanionSnapshot> refreshForTrigger(
    TaskSystemController controller,
    CompanionSnapshotRefreshTrigger trigger, {
    DateTime? generatedAt,
    int staleAfterSeconds = defaultCompanionSnapshotStaleAfterSeconds,
    bool hideTaskTitlesOutsideApp = true,
    CompanionDesktopPetState desktopPetState =
        CompanionDesktopPetState.disabled,
    bool dndActive = false,
    CompanionStyleLine styleLine = CompanionStyleLine.soft,
  }) {
    switch (trigger) {
      case CompanionSnapshotRefreshTrigger.appOpened:
      case CompanionSnapshotRefreshTrigger.taskCreated:
      case CompanionSnapshotRefreshTrigger.taskCompleted:
      case CompanionSnapshotRefreshTrigger.taskCompletionUndone:
      case CompanionSnapshotRefreshTrigger.taskRestored:
      case CompanionSnapshotRefreshTrigger.growthChanged:
      case CompanionSnapshotRefreshTrigger.manual:
        return refresh(
          controller,
          generatedAt: generatedAt,
          staleAfterSeconds: staleAfterSeconds,
          hideTaskTitlesOutsideApp: hideTaskTitlesOutsideApp,
          desktopPetState: desktopPetState,
          dndActive: dndActive,
          styleLine: styleLine,
        );
    }
  }

  Future<CompanionSnapshotReadResult> read({DateTime? now}) async {
    final readAt = (now ?? DateTime.now()).toUtc();
    final localSnapshot = await localStore.readCompanionSnapshot(now: readAt);
    if (localSnapshot == null) {
      return const CompanionSnapshotReadResult.needsRefresh();
    }

    final snapshot = CompanionSnapshot.fromJson(localSnapshot.payload);
    if (localSnapshot.isExpired(readAt) || snapshot.isExpiredAt(readAt)) {
      return CompanionSnapshotReadResult.needsRefresh(snapshot: snapshot);
    }

    return CompanionSnapshotReadResult.fresh(snapshot);
  }
}

LocalCompanionSnapshot _toLocalSnapshot(CompanionSnapshot snapshot) {
  return LocalCompanionSnapshot(
    snapshotId: snapshot.snapshotId,
    generatedAt: snapshot.generatedAt,
    expiresAt: snapshot.generatedAt.add(
      Duration(seconds: snapshot.staleAfterSeconds),
    ),
    payload: snapshot.toJson(),
  );
}
