library;

import 'dart:convert';

import 'package:companion_contract/companion_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_refresh_service.dart';

const desktopPetWindowArgument = '--desktop-pet-window';
const desktopPetSnapshotArgumentPrefix = '--desktop-pet-snapshot=';

enum DesktopPetAppState {
  on('desktop_pet_on'),
  off('desktop_pet_off');

  const DesktopPetAppState(this.value);

  final String value;
}

enum DesktopPetMotion { normal, low }

abstract interface class DesktopPetWindowPort {
  Future<void> open(CompanionSnapshot snapshot);
  Future<void> close();
}

class MethodChannelDesktopPetWindowPort implements DesktopPetWindowPort {
  const MethodChannelDesktopPetWindowPort({
    MethodChannel channel = const MethodChannel(
      'list_monster_app/desktop_pet_window',
    ),
  }) : this._(channel);

  const MethodChannelDesktopPetWindowPort._(this._channel);

  final MethodChannel _channel;

  @override
  Future<void> open(CompanionSnapshot snapshot) async {
    try {
      await _channel.invokeMethod<bool>('openDesktopPet', {
        'snapshot': encodeDesktopPetSnapshot(snapshot),
      });
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> close() async {
    try {
      await _channel.invokeMethod<bool>('closeDesktopPet');
    } on MissingPluginException {
      return;
    }
  }
}

class DesktopPetController extends ChangeNotifier {
  DesktopPetController({required DesktopPetWindowPort windowPort})
    : this._(windowPort);

  DesktopPetController._(this._windowPort);

  final DesktopPetWindowPort _windowPort;
  DesktopPetAppState _state = DesktopPetAppState.off;

  DesktopPetAppState get state => _state;
  String get stateValue => _state.value;
  bool get isOn => _state == DesktopPetAppState.on;

  Future<void> open(CompanionSnapshot snapshot) async {
    await _windowPort.open(snapshot);
    _setState(DesktopPetAppState.on);
  }

  Future<void> close() async {
    await _windowPort.close();
    _setState(DesktopPetAppState.off);
  }

  void _setState(DesktopPetAppState state) {
    if (_state == state) {
      return;
    }
    _state = state;
    notifyListeners();
  }
}

abstract interface class DesktopPetSnapshotSource {
  Future<CompanionSnapshotReadResult> read();
}

class ServiceDesktopPetSnapshotSource implements DesktopPetSnapshotSource {
  const ServiceDesktopPetSnapshotSource({required this.service});

  final CompanionSnapshotRefreshService service;

  @override
  Future<CompanionSnapshotReadResult> read() {
    return service.read();
  }
}

class ArgumentDesktopPetSnapshotSource implements DesktopPetSnapshotSource {
  const ArgumentDesktopPetSnapshotSource({required this.snapshot});

  factory ArgumentDesktopPetSnapshotSource.fromArguments(List<String> args) {
    for (final arg in args) {
      if (arg.startsWith(desktopPetSnapshotArgumentPrefix)) {
        return ArgumentDesktopPetSnapshotSource(
          snapshot: decodeDesktopPetSnapshot(
            arg.substring(desktopPetSnapshotArgumentPrefix.length),
          ),
        );
      }
    }
    return const ArgumentDesktopPetSnapshotSource(snapshot: null);
  }

  final CompanionSnapshot? snapshot;

  @override
  Future<CompanionSnapshotReadResult> read() async {
    final value = snapshot;
    if (value == null) {
      return const CompanionSnapshotReadResult.needsRefresh();
    }
    return CompanionSnapshotReadResult.fresh(value);
  }
}

String encodeDesktopPetSnapshot(CompanionSnapshot snapshot) {
  return base64Url.encode(utf8.encode(jsonEncode(snapshot.toJson())));
}

CompanionSnapshot decodeDesktopPetSnapshot(String encoded) {
  final decoded = utf8.decode(base64Url.decode(encoded));
  return CompanionSnapshot.fromJson(
    jsonDecode(decoded) as Map<String, Object?>,
  );
}

class DesktopPetViewModel {
  const DesktopPetViewModel({
    required this.monsterName,
    required this.stageLabel,
    required this.moodLabel,
    required this.progressLabel,
    required this.reminderText,
    required this.motion,
    required this.showReminderBubble,
    required this.playsSound,
    required this.usesStrongFeedback,
  });

  factory DesktopPetViewModel.fromSnapshot(CompanionSnapshot snapshot) {
    final dndActive = snapshot.dndActive;
    return DesktopPetViewModel(
      monsterName: snapshot.monsterName,
      stageLabel: _stageLabel(snapshot.stage),
      moodLabel: _moodLabel(snapshot.moodState),
      progressLabel:
          '${snapshot.todayCompletedTasks}/${snapshot.todayTotalTasks}',
      reminderText: _genericReminderText(snapshot),
      motion: dndActive ? DesktopPetMotion.low : DesktopPetMotion.normal,
      showReminderBubble: !dndActive && snapshot.todayRemainingTasks > 0,
      playsSound: false,
      usesStrongFeedback: false,
    );
  }

  final String monsterName;
  final String stageLabel;
  final String moodLabel;
  final String progressLabel;
  final String reminderText;
  final DesktopPetMotion motion;
  final bool showReminderBubble;
  final bool playsSound;
  final bool usesStrongFeedback;

  bool get isLowMotion => motion == DesktopPetMotion.low;
}

class DesktopPetWindowApp extends StatelessWidget {
  const DesktopPetWindowApp({super.key, required this.snapshotSource});

  final DesktopPetSnapshotSource snapshotSource;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List Monster Desktop Pet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4f7cff)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: DesktopPetSnapshotView(snapshotSource: snapshotSource),
        ),
      ),
    );
  }
}

class DesktopPetSnapshotView extends StatelessWidget {
  const DesktopPetSnapshotView({super.key, required this.snapshotSource});

  final DesktopPetSnapshotSource snapshotSource;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanionSnapshotReadResult>(
      future: snapshotSource.read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = snapshot.data;
        final companionSnapshot = result?.snapshot;
        if (companionSnapshot == null) {
          return const _DesktopPetEmptyState();
        }

        return _DesktopPetSnapshotBody(
          model: DesktopPetViewModel.fromSnapshot(companionSnapshot),
        );
      },
    );
  }
}

class _DesktopPetSnapshotBody extends StatelessWidget {
  const _DesktopPetSnapshotBody({required this.model});

  final DesktopPetViewModel model;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final duration = model.isLowMotion
        ? Duration.zero
        : const Duration(milliseconds: 240);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedContainer(
          key: ValueKey(model.motion),
          duration: duration,
          curve: Curves.easeOut,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: model.isLowMotion
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    model.isLowMotion
                        ? Icons.nightlight_round
                        : Icons.egg_alt_outlined,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.monsterName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text('${model.stageLabel} - ${model.moodLabel}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progressValue(model.progressLabel),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('Today $model.progressLabel'),
              if (model.showReminderBubble) ...[
                const SizedBox(height: 16),
                DecoratedBox(
                  key: const ValueKey('desktop-pet-reminder-bubble'),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(model.reminderText),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopPetEmptyState extends StatelessWidget {
  const _DesktopPetEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Waiting for a companion snapshot.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

String _genericReminderText(CompanionSnapshot snapshot) {
  if (snapshot.dndActive) {
    return 'Quietly keeping you company.';
  }
  if (snapshot.todayRemainingTasks > 0) {
    return 'A gentle check-in is ready.';
  }
  return 'All clear for now.';
}

String _stageLabel(CompanionStage stage) {
  return switch (stage) {
    CompanionStage.egg => 'Egg',
    CompanionStage.child => 'Child',
    CompanionStage.teen => 'Teen',
    CompanionStage.adult => 'Adult',
  };
}

String _moodLabel(CompanionMoodState mood) {
  return switch (mood) {
    CompanionMoodState.idle => 'Idle',
    CompanionMoodState.energetic => 'Energetic',
    CompanionMoodState.expecting => 'Expecting',
    CompanionMoodState.sleeping => 'Sleeping',
    CompanionMoodState.missing => 'Missing',
  };
}

double? _progressValue(String progressLabel) {
  final segments = progressLabel.split('/');
  if (segments.length != 2) {
    return null;
  }
  final completed = int.tryParse(segments.first);
  final total = int.tryParse(segments.last);
  if (completed == null || total == null || total <= 0) {
    return null;
  }
  return (completed / total).clamp(0, 1).toDouble();
}
