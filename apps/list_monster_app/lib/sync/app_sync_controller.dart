import 'package:companion_contract/companion_contract.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_builder.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';

class AppSyncController {
  const AppSyncController({required this.localStore});

  final LocalStorePort localStore;

  Future<CompanionSnapshot> generateCompanionSnapshot(
    TaskSystemController controller, {
    DateTime? generatedAt,
  }) async {
    final snapshot = buildCompanionSnapshot(
      controller,
      generatedAt: generatedAt,
    );
    await localStore.saveCompanionSnapshot(
      LocalCompanionSnapshot(
        snapshotId: snapshot.snapshotId,
        generatedAt: snapshot.generatedAt,
        expiresAt: snapshot.generatedAt.add(
          Duration(seconds: snapshot.staleAfterSeconds),
        ),
        payload: snapshot.toJson(),
      ),
    );
    return snapshot;
  }
}
