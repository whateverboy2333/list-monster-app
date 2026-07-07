import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:account_domain/account_domain.dart';
import 'package:companion_contract/companion_contract.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sprite_runtime/sprite_runtime.dart';
import 'package:task_domain/task_domain.dart';
import 'package:ui_kit/ui_kit.dart';

import 'account/account_session_controller.dart';
import 'companion_snapshot/android_widget_bridge.dart';
import 'companion_snapshot/companion_snapshot_refresh_service.dart';
import 'desktop_pet/desktop_pet.dart';
import 'language_preference_store.dart';
import 'task_system_controller.dart';

void main(List<String> args) {
  if (args.contains(desktopPetWindowArgument)) {
    runApp(
      DesktopPetWindowApp(
        snapshotSource: ArgumentDesktopPetSnapshotSource.fromArguments(args),
      ),
    );
    return;
  }

  runApp(const ListMonsterApp());
}

enum AppLanguage { zh, en }

extension on AppLanguage {
  String get code {
    return switch (this) {
      AppLanguage.zh => 'zh',
      AppLanguage.en => 'en',
    };
  }

  Locale get locale {
    return switch (this) {
      AppLanguage.zh => const Locale('zh', 'CN'),
      AppLanguage.en => const Locale('en'),
    };
  }
}

AppLanguage? _languageFromCode(String? code) {
  return switch (code) {
    'zh' => AppLanguage.zh,
    'en' => AppLanguage.en,
    _ => null,
  };
}

class AppLanguageScope extends InheritedWidget {
  const AppLanguageScope({
    super.key,
    required this.language,
    required this.strings,
    required this.onLanguageChanged,
    required super.child,
  });

  final AppLanguage language;
  final AppStrings strings;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static AppLanguageScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'AppLanguageScope is missing.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppLanguageScope oldWidget) {
    return language != oldWidget.language || strings != oldWidget.strings;
  }
}

extension AppLanguageContext on BuildContext {
  AppLanguageScope get languageScope => AppLanguageScope.of(this);
  AppStrings get s => languageScope.strings;
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isZh => language == AppLanguage.zh;

  String pick(String zh, String en) => isZh ? zh : en;

  String get appTitle => pick('清单怪兽', 'List Monster');
  String get tabToday => pick('今日', 'Today');
  String get tabLongTerm => pick('长期', 'Long-term');
  String get tabMonster => pick('怪兽', 'Monster');
  String get tabMe => pick('我的', 'Me');
  String get mePlaceholder => pick(
    '游客、通知、勿扰和桌宠开关会在后续节点接入。',
    'Guest mode, notifications, focus mode, and desktop pet settings will arrive in later nodes.',
  );
  String get accountSubtitle =>
      pick('本地模拟账号与同步入口。', 'Local simulated account and sync entry points.');
  String get accountStatusLabel => pick('账号状态', 'Account status');
  String get accountStatusGuest => pick('游客', 'Guest');
  String get accountStatusRegistered => pick('已登录', 'Signed in');
  String get accountStatusDeletionPending =>
      pick('注销冷静期', 'Deletion cooling-off');
  String get accountStatusDeleted => pick('已注销', 'Deleted');
  String get accountIdLabel => pick('账号 ID', 'Account ID');
  String get deletionEffectiveAt => pick('生效时间', 'Effective at');
  String get localSimulatedLogin => pick('本地模拟登录', 'Local simulated login');
  String get requestDeletion => pick('申请注销', 'Request deletion');
  String get cancelDeletion => pick('取消注销', 'Cancel deletion');
  String get generateSnapshot => pick('生成本地快照', 'Generate local snapshot');
  String get snapshotGenerated => pick('快照已写入本地存储', 'Snapshot saved locally');
  String get readOnlyTitle => pick('冷静期只读', 'Read-only cooling-off');
  String get readOnlyMessage => pick(
    '账号正在注销冷静期，只能取消注销后继续操作。',
    'This account is in deletion cooling-off. Cancel deletion before editing.',
  );
  String get pendingMergeTitle => pick('确认合并游客数据', 'Confirm guest data merge');
  String mergePreview(int guestTaskCount, int cloudTaskCount) => pick(
    '检测到游客有 $guestTaskCount 条本地数据，模拟云端有 $cloudTaskCount 条数据，需要你确认合并。',
    'Guest has $guestTaskCount local item(s) and the mock cloud has $cloudTaskCount item(s). Confirm before merging.',
  );
  String get confirmMerge => pick('确认合并', 'Confirm merge');
  String get cancelMerge => pick('取消合并', 'Cancel merge');
  String get signedInMessage =>
      pick('已完成本地模拟登录', 'Local simulated login complete');
  String get mergeCancelledMessage =>
      pick('已取消合并，两侧数据未变', 'Merge cancelled; both sides are unchanged');
  String get mergeConfirmedMessage => pick('游客数据已合并', 'Guest data merged');
  String get deletionRequestedMessage =>
      pick('已进入注销冷静期', 'Deletion cooling-off started');
  String get deletionCancelledMessage => pick('已取消注销', 'Deletion cancelled');
  String mockCloudDataCount(int count) =>
      pick('模拟云端数据：$count 条', 'Mock cloud data: $count item(s)');

  String get todaySubtitle => pick('把小事喂给小单。', 'Feed small tasks to Xiaodan.');
  String get firstTaskWaiting =>
      pick('小单正在等第一个任务', 'Xiaodan is waiting for the first task');
  String get newTaskLabel => pick('今天要完成什么', 'What needs to get done today?');
  String get addToToday => pick('加入今日', 'Add to Today');
  String get todayTasks => pick('今日任务', 'Today Tasks');
  String get noTodayTasks => pick(
    '今日没有待处理任务。已放下或删除的任务可在下方恢复。',
    'No active tasks today. Let-go or deleted tasks can be restored below.',
  );
  String get cancelledTasks => pick('已放下', 'Let Go');
  String get deletedTasks => pick('已删除', 'Deleted');

  String get newTaskOptions => pick('新任务选项', 'New Task Options');
  String get newTaskOptionsHint => pick(
    '只应用到下一次新增的任务；已有任务可在任务行修改。',
    'Only applies to the next new task. Existing tasks can be edited in their row.',
  );
  String get repeatPlaceholder => pick('新任务重复占位', 'Repeat placeholder');
  String get repeatPlaceholderHint => pick(
    '保存 repeatRuleId，不生成重复实例',
    'Stores repeatRuleId without generating repeated tasks.',
  );
  String get reminderIntent => pick('新任务提醒意图', 'Reminder intent');
  String get reminderIntentHint => pick(
    '只记录提醒计划，不调度系统通知',
    'Records the reminder plan without scheduling system notifications.',
  );
  String get highPriorityTask => pick('高优先级任务', 'High priority task');
  String get highPriorityTaskHint =>
      pick('当日第 1-5 个可奖励任务给 +15 XP', '+15 XP for the first 5 rewardable tasks');
  String get highPriorityShort => pick('高优先级', 'High priority');
  String get reminderTime => pick('提醒时间', 'Reminder time');
  String get invalidReminderTime =>
      pick('请输入 00:00-23:59', 'Enter 00:00-23:59');

  String get longTermTasks => pick('长期任务', 'Long-term Tasks');
  String get longTermSubtitle => pick(
    '超过一天的目标，先拆成每日可完成的小任务。',
    'Break goals spanning more than one day into daily steps.',
  );
  String get createLongTermTask => pick('创建长期任务', 'Create Long-term Task');
  String get emptyLongTerm => pick(
    '还没有长期任务。创建时先写目标，再拆成每天的小任务。',
    'No long-term tasks yet. Start with a goal, then break it into daily steps.',
  );
  String get editDateAndBreakdown => pick('编辑日期与拆解', 'Edit Dates and Steps');
  String get completedChildOutsideRange => pick(
    '不能把已完成的拆解任务排除出长期任务日期范围。',
    'Completed steps cannot be excluded from the long-term date range.',
  );
  String get longTermSaveFailed => pick(
    '长期任务日期没有保存，请检查日期和拆解项。',
    'Long-term dates were not saved. Check the dates and steps.',
  );
  String get adjustLongTermDates => pick('调整长期任务日期', 'Adjust Long-term Dates');
  String activeChildrenOutsideRange(int count) => pick(
    '新的日期范围会排除 $count 个未完成拆解任务。保存后这些任务会被放下，不产生 XP。',
    'The new date range excludes $count unfinished step(s). After saving, they will be let go and will not grant XP.',
  );
  String get cancelSave => pick('取消保存', 'Cancel');
  String get confirmSave => pick('确认保存', 'Save');
  String get pickDateSemanticPrefix => pick('选择', 'Select ');
  String get createLongTermDialog => pick('创建长期任务', 'Create Long-term Task');
  String get editLongTermDialog => pick('编辑长期任务', 'Edit Long-term Task');
  String get longTermGoal => pick('长期目标', 'Long-term Goal');
  String get longTermGoalHint =>
      pick('例如：准备考试', 'Example: Prepare for an exam');
  String get requiredLongTermGoal => pick('请输入长期目标', 'Enter a long-term goal');
  String get startDate => pick('开始日期', 'Start Date');
  String get dueDate => pick('截止日期', 'End Date');
  String generatedDailyTasks(int count) =>
      pick('当前会生成 $count 个每日拆解任务', '$count daily step(s) will be generated');
  String get breakdownRoute => pick('拆解路线', 'Breakdown Route');
  String get manualBreakdown => pick('手动拆解', 'Manual');
  String get aiBreakdownLater => pick('AI 拆解（后续）', 'AI Breakdown (Later)');
  String get breakdownHint => pick(
    '手动拆解会按天生成对应日期的任务；AI 拆解会在后续版本根据目标生成草案。',
    'Manual breakdown creates dated daily tasks. AI breakdown will draft steps from the goal in a later version.',
  );
  String dayTaskLabel(int day) => pick('第 $day 天任务', 'Day $day Task');
  String requiredDayTask(int day) =>
      pick('请输入第 $day 天任务', 'Enter the day $day task');
  String get cancel => pick('取消', 'Cancel');
  String get create => pick('创建', 'Create');
  String get save => pick('保存', 'Save');
  String get pickStartDate => pick('选择开始日期', 'Select Start Date');
  String get pickDueDate => pick('选择截止日期', 'Select End Date');
  String get confirm => pick('确定', 'OK');
  String get startPrep => pick('启动准备', 'Kickoff');
  String get finalCheck => pick('收尾检查', 'Final Check');
  String get progressOutput => pick('推进产出', 'Progress Output');
  String stepHint(int index, int dayCount) {
    if (index == 0) {
      return pick(
        '$startPrep：整理资料、明确范围、列出第一步',
        '$startPrep: collect materials, clarify scope, define the first step',
      );
    }
    if (index == dayCount - 1) {
      return pick(
        '$finalCheck：复盘检查、完成提交、整理成果',
        '$finalCheck: review, submit, and organize the result',
      );
    }
    return pick(
      '$progressOutput：完成一个可检查的小成果',
      '$progressOutput: finish one checkable output',
    );
  }

  String get cleanupTitle => pick('无压清理', 'No-pressure Cleanup');
  String get cleanupHint => pick(
    '今天暂时做不完的任务，可以先放下，不产生 XP 惩罚。',
    'Tasks that cannot be done today can be let go without XP punishment.',
  );
  String get letGoUnfinished => pick('放下未完成', 'Let Go Unfinished');
  String get undoLastCleanup => pick('撤销最近清理', 'Undo Last Cleanup');
  String taskCount(int count) => pick('$count 个任务', '$count task(s)');
  String get empty => pick('暂无', 'None');
  String get restore => pick('恢复', 'Restore');

  String taskStatus(TaskStatus status) {
    return switch (status) {
      TaskStatus.active => pick('进行中', 'Active'),
      TaskStatus.completed => pick('已完成', 'Completed'),
      TaskStatus.cancelled => pick('已放下', 'Let Go'),
      TaskStatus.deleted => pick('已删除', 'Deleted'),
    };
  }

  String longTermStatus(LongTermTaskStatus status) {
    return switch (status) {
      LongTermTaskStatus.active => pick('进行中', 'Active'),
      LongTermTaskStatus.achieved => pick('已完成', 'Completed'),
      LongTermTaskStatus.cancelled => pick('已取消', 'Cancelled'),
      LongTermTaskStatus.deleted => pick('已删除', 'Deleted'),
    };
  }

  String monsterMood(MonsterMood mood) {
    return switch (mood) {
      MonsterMood.idle => pick('空闲', 'Idle'),
      MonsterMood.energetic => pick('元气', 'Energetic'),
      MonsterMood.expecting => pick('期待', 'Expecting'),
      MonsterMood.sleeping => pick('睡觉', 'Sleeping'),
      MonsterMood.missing => pick('想念', 'Missing'),
    };
  }

  String monsterStage(MonsterStage stage) {
    return switch (stage) {
      MonsterStage.egg => pick('怪兽蛋', 'Monster Egg'),
      MonsterStage.child => pick('幼年', 'Child'),
      MonsterStage.teen => pick('少年', 'Teen'),
      MonsterStage.adult => pick('成年', 'Adult'),
    };
  }

  String monsterAction(MonsterSnapshot monster, String fallback) {
    if (language == AppLanguage.zh) {
      return fallback;
    }
    return switch (monster.moodState) {
      MonsterMood.expecting => 'Waiting for a task',
      MonsterMood.energetic => 'Full of energy',
      MonsterMood.sleeping => 'Sleeping',
      MonsterMood.missing => 'Missing you',
      MonsterMood.idle => 'Waiting',
    };
  }

  String get completedPrefix => pick('完成', 'Done');
  String get setRepeatPlaceholder => pick('设为重复占位', 'Set repeat placeholder');
  String get cancelRepeatPlaceholder =>
      pick('取消重复占位', 'Cancel repeat placeholder');
  String get setReminderTime => pick('设置提醒时间', 'Set reminder time');
  String get undoCompletion => pick('撤销完成', 'Undo completion');
  String get letGoTask => pick('放下任务', 'Let go task');
  String get deleteTask => pick('删除任务', 'Delete task');
  String reminderSubtitle(String? dueTime) =>
      pick('提醒 ${dueTime ?? '已设置'}', 'Reminder ${dueTime ?? 'set'}');
  String get repeatPlaceholderShort => pick('重复占位', 'Repeat placeholder');
  String get longTermChild => pick('长期拆解', 'Long-term step');
  String get clear => pick('清除', 'Clear');
  String todayXpCap(int xp) => pick(
    '今日 XP $xp/${XpPolicy.dailyFormalXpCap}',
    'Today XP $xp/${XpPolicy.dailyFormalXpCap}',
  );
  String streakDays(int days) => pick('连续 $days 天', '$days-day streak');
  String get streakNeutralHint => pick(
    '中断也不会扣经验，今天重新开始也很好。',
    'Breaks never remove XP. Starting again today is okay.',
  );
  String dailySummaryTitle(DailyTaskSummary summary) {
    if (language == AppLanguage.zh) {
      return summary.feedbackText;
    }
    return 'Yesterday you completed ${summary.completedEligibleTaskCount} task(s). Xiaodan remembered.';
  }

  String cumulativeRewardTitle(CumulativeActiveRewardEvent reward) => pick(
    '累计 ${reward.activeDayCount} 天完成任务，奖励 +${reward.xpAmount} XP',
    '${reward.activeDayCount} active days, +${reward.xpAmount} XP reward',
  );
  String get petMonster => pick('摸摸小单', 'Pet Xiaodan');
  String sleepPetProgress(int count, int threshold) =>
      pick('睡梦中 $count/$threshold', 'Sleeping $count/$threshold');
  String petReaction(MonsterPetReactionEvent reaction) {
    if (reaction.reactionKey == 'wake_up') {
      return pick('小单慢慢醒来了', 'Xiaodan is waking up');
    }
    if (reaction.touchCountInSleep > 0) {
      return pick('小单翻了个身，继续睡', 'Xiaodan turns over and keeps sleeping');
    }
    return pick('小单蹭了蹭你的手', 'Xiaodan leans into your hand');
  }

  String milestoneTitle(DailyTaskMilestone milestone) {
    if (language == AppLanguage.zh) {
      return milestone.title;
    }
    return switch (milestone.milestoneKey) {
      'small_start' => 'Nice Start',
      'fruitful_day' => 'Fruitful Day',
      _ => milestone.title,
    };
  }

  String get monsterSubtitle =>
      pick('小单的成长只来自真实完成。', 'Xiaodan only grows from real completed tasks.');
  String levelLine(MonsterSnapshot monster) => pick(
    '等级 ${monster.level} · ${monsterMood(monster.moodState)}',
    'Level ${monster.level} · ${monsterMood(monster.moodState)}',
  );
}

class ListMonsterApp extends StatefulWidget {
  const ListMonsterApp({
    super.key,
    this.taskSystemController,
    this.accountSessionController,
    this.desktopPetWindowPort,
    this.androidWidgetBridge,
    this.openedAt,
  });

  final TaskSystemController? taskSystemController;
  final AccountSessionController? accountSessionController;
  final DesktopPetWindowPort? desktopPetWindowPort;
  final CompanionSnapshotWidgetBridge? androidWidgetBridge;
  final DateTime? openedAt;

  @override
  State<ListMonsterApp> createState() => _ListMonsterAppState();
}

class _ListMonsterAppState extends State<ListMonsterApp> {
  final LanguagePreferenceStore _languageStore = LanguagePreferenceStore();
  AppLanguage _language = AppLanguage.zh;

  @override
  void initState() {
    super.initState();
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    final storedLanguage = _languageFromCode(
      await _languageStore.readLanguageCode(),
    );
    if (!mounted || storedLanguage == null || storedLanguage == _language) {
      return;
    }
    setState(() => _language = storedLanguage);
  }

  Future<void> _changeLanguage(AppLanguage language) async {
    if (_language != language) {
      setState(() => _language = language);
    }
    await _languageStore.writeLanguageCode(language.code);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_language);
    return AppLanguageScope(
      language: _language,
      strings: strings,
      onLanguageChanged: _changeLanguage,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: strings.appTitle,
        locale: _language.locale,
        supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ListMonsterTheme.light(),
        home: ListMonsterShell(
          taskSystemController: widget.taskSystemController,
          accountSessionController: widget.accountSessionController,
          desktopPetWindowPort: widget.desktopPetWindowPort,
          androidWidgetBridge: widget.androidWidgetBridge,
          openedAt: widget.openedAt,
        ),
      ),
    );
  }
}

class ListMonsterShell extends StatefulWidget {
  const ListMonsterShell({
    super.key,
    this.taskSystemController,
    this.accountSessionController,
    this.desktopPetWindowPort,
    this.androidWidgetBridge,
    this.openedAt,
  });

  final TaskSystemController? taskSystemController;
  final AccountSessionController? accountSessionController;
  final DesktopPetWindowPort? desktopPetWindowPort;
  final CompanionSnapshotWidgetBridge? androidWidgetBridge;
  final DateTime? openedAt;

  @override
  State<ListMonsterShell> createState() => _ListMonsterShellState();
}

class _ListMonsterShellState extends State<ListMonsterShell> {
  int _tabIndex = 0;
  late final TaskSystemController _taskSystem;
  late final bool _ownsTaskSystem;
  late final AccountSessionController _accountSession;
  late final bool _ownsAccountSession;
  late final CompanionSnapshotRefreshService _companionSnapshotService;
  late final DesktopPetController _desktopPetController;
  late final CompanionSnapshotWidgetBridge _androidWidgetBridge;

  @override
  void initState() {
    super.initState();
    _taskSystem = widget.taskSystemController ?? TaskSystemController();
    _ownsTaskSystem = widget.taskSystemController == null;
    _accountSession =
        widget.accountSessionController ?? AccountSessionController();
    _ownsAccountSession = widget.accountSessionController == null;
    _androidWidgetBridge =
        widget.androidWidgetBridge ??
        MethodChannelCompanionSnapshotWidgetBridge();
    _companionSnapshotService = CompanionSnapshotRefreshService(
      localStore: _accountSession.localStore,
      widgetBridge: _androidWidgetBridge,
    );
    _desktopPetController = DesktopPetController(
      windowPort:
          widget.desktopPetWindowPort ??
          const MethodChannelDesktopPetWindowPort(),
    );
    _accountSession.restore();
    _taskSystem.recordAppOpened(widget.openedAt ?? DateTime.now());
    _androidWidgetBridge.setWidgetLaunchIntentHandler(
      _handleAndroidWidgetLaunchIntent,
    );
    unawaited(_consumeInitialAndroidWidgetLaunchIntent());
  }

  @override
  void dispose() {
    _androidWidgetBridge.setWidgetLaunchIntentHandler(null);
    _desktopPetController.dispose();
    if (_ownsAccountSession) {
      _accountSession.dispose();
    }
    if (_ownsTaskSystem) {
      _taskSystem.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    final tabs = [
      TodayTab(controller: _taskSystem, accountSession: _accountSession),
      LongTermTab(controller: _taskSystem, accountSession: _accountSession),
      MonsterTab(controller: _taskSystem, accountSession: _accountSession),
      MeTab(
        accountSession: _accountSession,
        taskSystem: _taskSystem,
        desktopPetController: _desktopPetController,
        refreshCompanionSnapshot: _refreshCompanionSnapshot,
        refreshDesktopPetSnapshot: _refreshDesktopPetSnapshot,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        actions: const [_LanguageToggle(), SizedBox(width: 12)],
      ),
      body: tabs[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            label: strings.tabToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            label: strings.tabLongTerm,
          ),
          NavigationDestination(
            icon: const Icon(Icons.egg_alt_outlined),
            label: strings.tabMonster,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: strings.tabMe,
          ),
        ],
      ),
    );
  }

  Future<CompanionSnapshot> _refreshDesktopPetSnapshot(
    CompanionDesktopPetState state,
  ) {
    return _companionSnapshotService.refreshForTrigger(
      _taskSystem,
      CompanionSnapshotRefreshTrigger.manual,
      desktopPetState: state,
    );
  }

  Future<CompanionSnapshot> _refreshCompanionSnapshot() {
    return _companionSnapshotService.refreshForTrigger(
      _taskSystem,
      CompanionSnapshotRefreshTrigger.manual,
    );
  }

  Future<void> _consumeInitialAndroidWidgetLaunchIntent() async {
    final intent = await _androidWidgetBridge
        .consumeInitialWidgetLaunchIntent();
    if (intent != null) {
      await _handleAndroidWidgetLaunchIntent(intent);
    }
  }

  Future<void> _handleAndroidWidgetLaunchIntent(
    AndroidWidgetLaunchIntent intent,
  ) async {
    if (!mounted) {
      return;
    }

    final nextTabIndex = intent.opensMonster ? 2 : 0;
    if (_tabIndex != nextTabIndex) {
      setState(() => _tabIndex = nextTabIndex);
    }

    if (intent.refreshCompanionSnapshot) {
      await _refreshCompanionSnapshot();
    }
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    final scope = context.languageScope;
    return SegmentedButton<AppLanguage>(
      showSelectedIcon: false,
      style: const ButtonStyle(
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: const [
        ButtonSegment(value: AppLanguage.zh, label: Text('中')),
        ButtonSegment(value: AppLanguage.en, label: Text('EN')),
      ],
      selected: {scope.language},
      onSelectionChanged: (selection) =>
          scope.onLanguageChanged(selection.single),
    );
  }
}

class TodayTab extends StatefulWidget {
  const TodayTab({
    super.key,
    required this.controller,
    required this.accountSession,
  });

  final TaskSystemController controller;
  final AccountSessionController accountSession;

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reminderTimeController = TextEditingController(
    text: '20:00',
  );
  bool _withTaskReminder = false;
  bool _withRepeatPlaceholder = false;
  bool _withHighPriority = false;
  String? _reminderTimeError;

  @override
  void dispose() {
    _titleController.dispose();
    _reminderTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, widget.accountSession]),
      builder: (context, _) {
        final strings = context.s;
        final controller = widget.controller;
        final readOnly = widget.accountSession.isReadOnly;
        final milestone = controller.latestMilestone;
        final todayTasks = controller.todayTasks;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListMonsterSectionHeader(
                title: strings.tabToday,
                subtitle: strings.todaySubtitle,
              ),
              const SizedBox(height: 20),
              MonsterSpritePlaceholder(
                moodLabel: strings.monsterMood(controller.monster.moodState),
                actionLabel: strings.monsterAction(
                  controller.monster,
                  controller.monsterActionLabel,
                ),
              ),
              const SizedBox(height: 16),
              _MonsterStatusStrip(controller: controller),
              const SizedBox(height: 20),
              if (!controller.hasTasks)
                Text(
                  strings.firstTaskWaiting,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (!controller.hasTasks) const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: strings.newTaskLabel,
                  border: const OutlineInputBorder(),
                ),
                onTap: readOnly ? () => _showReadOnlySnack(context) : null,
                onSubmitted: (_) =>
                    readOnly ? _showReadOnlySnack(context) : _createTask(),
              ),
              const SizedBox(height: 12),
              _NewTaskOptions(
                enabled: !readOnly,
                highPriorityEnabled: _withHighPriority,
                reminderEnabled: _withTaskReminder,
                repeatEnabled: _withRepeatPlaceholder,
                reminderTimeController: _reminderTimeController,
                reminderTimeError: _reminderTimeError,
                onHighPriorityChanged: (value) =>
                    setState(() => _withHighPriority = value),
                onReminderEnabledChanged: (value) {
                  setState(() {
                    _withTaskReminder = value;
                    if (!value) {
                      _reminderTimeError = null;
                    }
                  });
                },
                onRepeatChanged: (value) =>
                    setState(() => _withRepeatPlaceholder = value),
                onReminderTimeChanged: (_) =>
                    setState(() => _reminderTimeError = null),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: readOnly
                    ? () => _showReadOnlySnack(context)
                    : _createTask,
                icon: const Icon(Icons.add_task_outlined),
                label: Text(strings.addToToday),
              ),
              const SizedBox(height: 24),
              Text(
                strings.todayTasks,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (todayTasks.isEmpty && controller.hasTasks)
                Text(strings.noTodayTasks),
              if (todayTasks.isNotEmpty)
                ...todayTasks.map(
                  (task) => _TaskTile(
                    task: task,
                    enabled: !readOnly,
                    onReadOnly: () => _showReadOnlySnack(context),
                    onComplete: () => controller.completeTask(task.id),
                    onUndo: () => controller.undoCompletion(task.id),
                    onCancel: () => controller.cancelTask(task.id),
                    onDelete: () => controller.deleteTask(task.id),
                    onToggleRepeat: () => controller.setTaskRepeatPlaceholder(
                      task.id,
                      task.repeatRuleId == null,
                    ),
                    onReminderChanged: (reminderTime) =>
                        controller.setTaskReminderIntent(task.id, reminderTime),
                  ),
                ),
              if (milestone != null) ...[
                const SizedBox(height: 20),
                _MilestoneCard(milestone: milestone),
              ],
              if (controller.latestDailySummary != null) ...[
                const SizedBox(height: 12),
                _DailySummaryCard(summary: controller.latestDailySummary!),
              ],
              if (controller.latestCumulativeReward != null) ...[
                const SizedBox(height: 12),
                _CumulativeRewardCard(
                  reward: controller.latestCumulativeReward!,
                ),
              ],
              const SizedBox(height: 24),
              _TodayCleanupActions(
                controller: controller,
                enabled: !readOnly,
                onReadOnly: () => _showReadOnlySnack(context),
              ),
              const SizedBox(height: 16),
              _RecoverableSection(
                title: strings.cancelledTasks,
                tasks: controller.cancelledTasks,
                enabled: !readOnly,
                onReadOnly: () => _showReadOnlySnack(context),
                onRestore: controller.restoreTask,
              ),
              _RecoverableSection(
                title: strings.deletedTasks,
                tasks: controller.deletedTasks,
                enabled: !readOnly,
                onReadOnly: () => _showReadOnlySnack(context),
                onRestore: controller.restoreTask,
              ),
            ],
          ),
        );
      },
    );
  }

  void _createTask() {
    final reminderTime = _withTaskReminder
        ? _normalizeReminderTimeInput(_reminderTimeController.text)
        : null;
    if (_withTaskReminder && reminderTime == null) {
      setState(() => _reminderTimeError = context.s.invalidReminderTime);
      return;
    }

    widget.controller.createTask(
      _titleController.text,
      priority: _withHighPriority ? TaskPriority.high : TaskPriority.none,
      reminderTime: reminderTime,
      repeatRuleId: _withRepeatPlaceholder
          ? TaskSystemController.repeatPlaceholderRuleId
          : null,
    );
    _titleController.clear();
  }
}

class _NewTaskOptions extends StatelessWidget {
  const _NewTaskOptions({
    required this.enabled,
    required this.highPriorityEnabled,
    required this.reminderEnabled,
    required this.repeatEnabled,
    required this.reminderTimeController,
    required this.reminderTimeError,
    required this.onHighPriorityChanged,
    required this.onReminderEnabledChanged,
    required this.onRepeatChanged,
    required this.onReminderTimeChanged,
  });

  final bool enabled;
  final bool highPriorityEnabled;
  final bool reminderEnabled;
  final bool repeatEnabled;
  final TextEditingController reminderTimeController;
  final String? reminderTimeError;
  final ValueChanged<bool> onHighPriorityChanged;
  final ValueChanged<bool> onReminderEnabledChanged;
  final ValueChanged<bool> onRepeatChanged;
  final ValueChanged<String> onReminderTimeChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.newTaskOptions,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(strings.newTaskOptionsHint),
            const SizedBox(height: 8),
            SwitchListTile(
              value: highPriorityEnabled,
              onChanged: enabled ? onHighPriorityChanged : null,
              title: Text(strings.highPriorityTask),
              subtitle: Text(strings.highPriorityTaskHint),
              secondary: const Icon(Icons.priority_high_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              value: repeatEnabled,
              onChanged: enabled ? onRepeatChanged : null,
              title: Text(strings.repeatPlaceholder),
              subtitle: Text(strings.repeatPlaceholderHint),
              secondary: const Icon(Icons.repeat_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              value: reminderEnabled,
              onChanged: enabled ? onReminderEnabledChanged : null,
              title: Text(strings.reminderIntent),
              subtitle: Text(strings.reminderIntentHint),
              secondary: const Icon(Icons.notifications_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            if (reminderEnabled)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: reminderTimeController,
                  enabled: enabled,
                  decoration: InputDecoration(
                    labelText: strings.reminderTime,
                    hintText: '20:30',
                    errorText: reminderTimeError,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: onReminderTimeChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LongTermTab extends StatelessWidget {
  const LongTermTab({
    super.key,
    required this.controller,
    required this.accountSession,
  });

  final TaskSystemController controller;
  final AccountSessionController accountSession;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, accountSession]),
      builder: (context, _) {
        final strings = context.s;
        final readOnly = accountSession.isReadOnly;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListMonsterSectionHeader(
              title: strings.longTermTasks,
              subtitle: strings.longTermSubtitle,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: readOnly
                  ? () => _showReadOnlySnack(context)
                  : () => _showCreateLongTermTaskDialog(context, controller),
              icon: const Icon(Icons.add_task_outlined),
              label: Text(strings.createLongTermTask),
            ),
            const SizedBox(height: 20),
            if (controller.longTermTasks.isEmpty) Text(strings.emptyLongTerm),
            ...controller.longTermTasks.map((task) {
              final childTasks = controller.longTermChildTasks(
                task.longTermTaskId,
              );

              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: Text(task.title),
                subtitle: Text(
                  '${_formatDateRange(task.startDate, task.dueDate)} · '
                  '${task.completedTaskCount}/${task.totalTaskCount} · '
                  '${strings.longTermStatus(task.status)}',
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: task.status == LongTermTaskStatus.active
                          ? readOnly
                                ? () => _showReadOnlySnack(context)
                                : () => _showEditLongTermTaskDialog(
                                    context,
                                    controller,
                                    task,
                                    childTasks,
                                  )
                          : null,
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: Text(strings.editDateAndBreakdown),
                    ),
                  ),
                  ...childTasks.map(
                    (childTask) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(_formatMonthDay(childTask.scheduledDate)),
                      title: Text(childTask.title),
                      subtitle: Text(strings.taskStatus(childTask.status)),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Future<void> _showCreateLongTermTaskDialog(
    BuildContext context,
    TaskSystemController controller,
  ) async {
    final plan = await showDialog<_LongTermTaskPlan>(
      context: context,
      builder: (context) =>
          _LongTermTaskDialog(initialStartDate: controller.today),
    );
    if (plan == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    controller.createLongTermTask(
      plan.title,
      startDate: plan.startDate,
      dueDate: plan.dueDate,
      childTaskTitles: plan.childTaskTitles,
      breakdownSource: LongTermBreakdownSource.manual,
    );
  }

  Future<void> _showEditLongTermTaskDialog(
    BuildContext context,
    TaskSystemController controller,
    LongTermTask task,
    List<TaskItem> childTasks,
  ) async {
    final plan = await showDialog<_LongTermTaskPlan>(
      context: context,
      builder: (context) => _LongTermTaskDialog(
        initialStartDate: task.startDate,
        initialPlan: _LongTermTaskPlan(
          title: task.title,
          startDate: task.startDate,
          dueDate: task.dueDate,
          childTaskTitles: childTasks.map((child) => child.title).toList(),
        ),
      ),
    );
    if (plan == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    final completedOutsideRange = childTasks
        .where(
          (child) =>
              child.isCompleted &&
              !_isDateWithinRange(
                child.scheduledDate,
                plan.startDate,
                plan.dueDate,
              ),
        )
        .length;
    if (completedOutsideRange > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.s.completedChildOutsideRange)),
      );
      return;
    }

    final activeOutsideRange = childTasks
        .where(
          (child) =>
              child.status == TaskStatus.active &&
              !_isDateWithinRange(
                child.scheduledDate,
                plan.startDate,
                plan.dueDate,
              ),
        )
        .length;
    if (activeOutsideRange > 0) {
      final confirmed = await _confirmLongTermDateEdit(
        context,
        affectedCount: activeOutsideRange,
      );
      if (!context.mounted) {
        return;
      }
      if (!confirmed) {
        return;
      }
    }

    final updated = controller.updateLongTermTaskPlan(
      task.longTermTaskId,
      title: plan.title,
      startDate: plan.startDate,
      dueDate: plan.dueDate,
      childTaskTitles: plan.childTaskTitles,
    );
    if (!updated && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.s.longTermSaveFailed)));
    }
  }

  Future<bool> _confirmLongTermDateEdit(
    BuildContext context, {
    required int affectedCount,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.s.adjustLongTermDates),
        content: Text(context.s.activeChildrenOutsideRange(affectedCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.s.cancelSave),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.s.confirmSave),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _LongTermTaskPlan {
  const _LongTermTaskPlan({
    required this.title,
    required this.startDate,
    required this.dueDate,
    required this.childTaskTitles,
  });

  final String title;
  final DateTime startDate;
  final DateTime dueDate;
  final List<String> childTaskTitles;
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    return Semantics(
      button: true,
      label: '${strings.pickDateSemanticPrefix}$label',
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          child: Text(_formatDateInput(value)),
        ),
      ),
    );
  }
}

class _LongTermTaskDialog extends StatefulWidget {
  const _LongTermTaskDialog({required this.initialStartDate, this.initialPlan});

  final DateTime initialStartDate;
  final _LongTermTaskPlan? initialPlan;

  @override
  State<_LongTermTaskDialog> createState() => _LongTermTaskDialogState();
}

class _LongTermTaskDialogState extends State<_LongTermTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _stepControllers = [];
  late DateTime _startDate;
  late DateTime _dueDate;
  int _dayCount = 3;

  @override
  void initState() {
    super.initState();
    final initialPlan = widget.initialPlan;
    final initialStartDate = initialPlan?.startDate ?? widget.initialStartDate;
    final initialDueDate =
        initialPlan?.dueDate ?? initialStartDate.add(const Duration(days: 2));
    _titleController.text = initialPlan?.title ?? '';
    _startDate = _dateOnly(initialStartDate);
    _dueDate = _dateOnly(initialDueDate);
    _dayCount = _dateRangeLength(_startDate, _dueDate) ?? 3;
    _syncStepControllers();
    final childTaskTitles = initialPlan?.childTaskTitles ?? const <String>[];
    for (
      var index = 0;
      index < childTaskTitles.length && index < _stepControllers.length;
      index++
    ) {
      _stepControllers[index].text = childTaskTitles[index];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    return AlertDialog(
      title: Text(
        widget.initialPlan == null
            ? strings.createLongTermDialog
            : strings.editLongTermDialog,
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: strings.longTermGoal,
                    hintText: strings.longTermGoalHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _hasText(value) ? null : strings.requiredLongTermGoal,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        key: const ValueKey('long-term-start-date-picker'),
                        label: strings.startDate,
                        value: _startDate,
                        onTap: _pickStartDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerField(
                        key: const ValueKey('long-term-due-date-picker'),
                        label: strings.dueDate,
                        value: _dueDate,
                        onTap: _pickDueDate,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    strings.generatedDailyTasks(_dayCount),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.breakdownRoute,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(strings.manualBreakdown),
                      selected: true,
                    ),
                    InputChip(
                      label: Text(strings.aiBreakdownLater),
                      isEnabled: false,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_tree_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strings.breakdownHint,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _stepControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _stepControllers[index],
                      decoration: InputDecoration(
                        labelText: strings.dayTaskLabel(index + 1),
                        hintText: _stepHint(index),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => _hasText(value)
                          ? null
                          : strings.requiredDayTask(index + 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(
            widget.initialPlan == null ? strings.create : strings.save,
          ),
        ),
      ],
    );
  }

  void _syncStepControllers() {
    while (_stepControllers.length < _dayCount) {
      _stepControllers.add(TextEditingController());
    }
    while (_stepControllers.length > _dayCount) {
      _stepControllers.removeLast().dispose();
    }
  }

  void _applyDateRange(DateTime startDate, DateTime dueDate) {
    final nextStartDate = _dateOnly(startDate);
    final nextDueDate = _dateOnly(dueDate);
    final nextDayCount = _dateRangeLength(nextStartDate, nextDueDate);
    if (nextDayCount == null) {
      return;
    }
    setState(() {
      _startDate = nextStartDate;
      _dueDate = nextDueDate;
      _dayCount = nextDayCount;
      _syncStepControllers();
    });
  }

  Future<void> _pickStartDate() async {
    final selectedDate = await _showLongTermDatePicker(
      helpText: context.s.pickStartDate,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) {
      return;
    }

    final nextStartDate = _dateOnly(selectedDate);
    var nextDueDate = _dueDate;
    if (!nextDueDate.isAfter(nextStartDate)) {
      final preservedDays = _dayCount > 1 ? _dayCount - 1 : 1;
      nextDueDate = nextStartDate.add(Duration(days: preservedDays));
    }
    _applyDateRange(nextStartDate, nextDueDate);
  }

  Future<void> _pickDueDate() async {
    final firstDueDate = _startDate.add(const Duration(days: 1));
    final selectedDate = await _showLongTermDatePicker(
      helpText: context.s.pickDueDate,
      initialDate: _dueDate.isBefore(firstDueDate) ? firstDueDate : _dueDate,
      firstDate: firstDueDate,
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) {
      return;
    }

    _applyDateRange(_startDate, selectedDate);
  }

  Future<DateTime?> _showLongTermDatePicker({
    required String helpText,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: context.s.cancel,
      confirmText: context.s.confirm,
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      _LongTermTaskPlan(
        title: _titleController.text.trim(),
        startDate: _startDate,
        dueDate: _dueDate,
        childTaskTitles: _stepControllers
            .map((controller) => controller.text.trim())
            .toList(growable: false),
      ),
    );
  }

  String _stepHint(int index) => context.s.stepHint(index, _dayCount);
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

String _formatMonthDay(DateTime value) => '${value.month}/${value.day}';

String _formatDateRange(DateTime startDate, DateTime dueDate) {
  return '${_formatMonthDay(startDate)}-${_formatMonthDay(dueDate)}';
}

String _formatDateInput(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

int? _dateRangeLength(DateTime startDate, DateTime dueDate) {
  if (!dueDate.isAfter(startDate)) {
    return null;
  }
  return dueDate.difference(startDate).inDays + 1;
}

bool _isDateWithinRange(DateTime value, DateTime startDate, DateTime dueDate) {
  final date = DateTime(value.year, value.month, value.day);
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
  return !date.isBefore(start) && !date.isAfter(due);
}

class _TodayCleanupActions extends StatelessWidget {
  const _TodayCleanupActions({
    required this.controller,
    required this.enabled,
    required this.onReadOnly,
  });

  final TaskSystemController controller;
  final bool enabled;
  final VoidCallback onReadOnly;

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.cleanupTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(strings.cleanupHint),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: controller.activeTasks.isEmpty
                  ? null
                  : enabled
                  ? controller.applyNoPressureCleanup
                  : onReadOnly,
              icon: const Icon(Icons.self_improvement_outlined),
              label: Text(strings.letGoUnfinished),
            ),
            OutlinedButton.icon(
              onPressed: enabled ? controller.undoLastBatchCleanup : onReadOnly,
              icon: const Icon(Icons.undo_outlined),
              label: Text(strings.undoLastCleanup),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecoverableSection extends StatelessWidget {
  const _RecoverableSection({
    required this.title,
    required this.tasks,
    required this.enabled,
    required this.onReadOnly,
    required this.onRestore,
  });

  final String title;
  final List<TaskItem> tasks;
  final bool enabled;
  final VoidCallback onReadOnly;
  final ValueChanged<String> onRestore;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(context.s.taskCount(tasks.length)),
      children: [
        if (tasks.isEmpty)
          Align(alignment: Alignment.centerLeft, child: Text(context.s.empty)),
        ...tasks.map(
          (task) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(task.title),
            subtitle: Text(context.s.taskStatus(task.status)),
            trailing: TextButton(
              onPressed: enabled ? () => onRestore(task.id) : onReadOnly,
              child: Text(context.s.restore),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonsterStatusStrip extends StatelessWidget {
  const _MonsterStatusStrip({required this.controller});

  final TaskSystemController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final strings = context.s;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(strings.monsterStage(controller.monster.stage))),
              Chip(
                label: Text(strings.monsterMood(controller.monster.moodState)),
              ),
              Chip(
                label: Text(
                  '${strings.completedPrefix} ${controller.completedRewardableCount}',
                ),
              ),
              Chip(label: Text(strings.todayXpCap(controller.todayXp))),
              Chip(
                label: Text(
                  strings.streakDays(controller.streak.currentStreakDays),
                ),
              ),
            ],
          ),
        ),
        Text('+${controller.todayXp} XP', style: textTheme.titleMedium),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.enabled,
    required this.onReadOnly,
    required this.onComplete,
    required this.onUndo,
    required this.onCancel,
    required this.onDelete,
    required this.onToggleRepeat,
    required this.onReminderChanged,
  });

  final TaskItem task;
  final bool enabled;
  final VoidCallback onReadOnly;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onToggleRepeat;
  final ValueChanged<String?> onReminderChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          value: task.isCompleted,
          onChanged: task.isCompleted
              ? null
              : (_) => enabled ? onComplete() : onReadOnly(),
          title: Text(task.title),
          subtitle: Text(_subtitle(context)),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: task.repeatRuleId == null
                    ? strings.setRepeatPlaceholder
                    : strings.cancelRepeatPlaceholder,
                onPressed: enabled ? onToggleRepeat : onReadOnly,
                icon: const Icon(Icons.repeat_outlined),
              ),
              IconButton(
                tooltip: strings.setReminderTime,
                onPressed: enabled
                    ? () => _showReminderDialog(context)
                    : onReadOnly,
                icon: const Icon(Icons.notifications_outlined),
              ),
              if (task.isCompleted)
                IconButton(
                  tooltip: strings.undoCompletion,
                  onPressed: enabled ? onUndo : onReadOnly,
                  icon: const Icon(Icons.undo_outlined),
                ),
              if (task.status == TaskStatus.active)
                IconButton(
                  tooltip: strings.letGoTask,
                  onPressed: enabled ? onCancel : onReadOnly,
                  icon: const Icon(Icons.self_improvement_outlined),
                ),
              IconButton(
                tooltip: strings.deleteTask,
                onPressed: enabled ? onDelete : onReadOnly,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
        const Divider(height: 16),
      ],
    );
  }

  Future<void> _showReminderDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) =>
          _ReminderTimeDialog(initialTime: task.dueTime ?? '20:00'),
    );

    if (result == null) {
      return;
    }
    onReminderChanged(_normalizeReminderTimeInput(result));
  }

  String _subtitle(BuildContext context) {
    final strings = context.s;
    final parts = <String>[strings.taskStatus(task.status)];
    if (task.reminderId != null) {
      parts.add(strings.reminderSubtitle(task.dueTime));
    }
    if (task.repeatRuleId != null) {
      parts.add(strings.repeatPlaceholderShort);
    }
    if (task.priority == TaskPriority.high) {
      parts.add(strings.highPriorityShort);
    }
    if (task.parentLongTermTaskId != null) {
      parts.add(strings.longTermChild);
    }
    return parts.join(' · ');
  }
}

class _ReminderTimeDialog extends StatefulWidget {
  const _ReminderTimeDialog({required this.initialTime});

  final String initialTime;

  @override
  State<_ReminderTimeDialog> createState() => _ReminderTimeDialogState();
}

class _ReminderTimeDialogState extends State<_ReminderTimeDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _reminderTimeController;

  @override
  void initState() {
    super.initState();
    _reminderTimeController = TextEditingController(text: widget.initialTime);
  }

  @override
  void dispose() {
    _reminderTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.s;
    return AlertDialog(
      title: Text(strings.setReminderTime),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reminderTimeController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: strings.reminderTime,
            hintText: '20:30',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) {
            if (_normalizeReminderTimeInput(value ?? '') == null) {
              return strings.invalidReminderTime;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(''),
          child: Text(strings.clear),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_reminderTimeController.text);
            }
          },
          child: Text(strings.save),
        ),
      ],
    );
  }
}

String? _normalizeReminderTimeInput(String value) {
  final match = RegExp(
    r'^([01]?\d|2[0-3]):([0-5]\d)$',
  ).firstMatch(value.trim());
  if (match == null) {
    return null;
  }

  final hour = int.parse(match.group(1)!);
  final minute = match.group(2)!;
  return '${hour.toString().padLeft(2, '0')}:$minute';
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.milestone});

  final DailyTaskMilestone milestone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.s.milestoneTitle(milestone),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({required this.summary});

  final DailyTaskSummary summary;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCard(
      icon: Icons.history_toggle_off_outlined,
      text: context.s.dailySummaryTitle(summary),
    );
  }
}

class _CumulativeRewardCard extends StatelessWidget {
  const _CumulativeRewardCard({required this.reward});

  final CumulativeActiveRewardEvent reward;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCard(
      icon: Icons.local_fire_department_outlined,
      text: context.s.cumulativeRewardTitle(reward),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class MonsterTab extends StatelessWidget {
  const MonsterTab({
    super.key,
    required this.controller,
    required this.accountSession,
  });

  final TaskSystemController controller;
  final AccountSessionController accountSession;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, accountSession]),
      builder: (context, _) {
        final monster = controller.monster;
        final strings = context.s;
        final readOnly = accountSession.isReadOnly;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListMonsterSectionHeader(
              title: strings.tabMonster,
              subtitle: strings.monsterSubtitle,
            ),
            const SizedBox(height: 20),
            MonsterSpritePlaceholder(
              moodLabel: strings.monsterMood(monster.moodState),
              actionLabel: strings.monsterStage(monster.stage),
            ),
            const SizedBox(height: 20),
            Text(
              strings.monsterStage(monster.stage),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(strings.levelLine(monster)),
            const SizedBox(height: 8),
            Text('${monster.currentLevelXp} / ${monster.xpToNextLevel} XP'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(strings.todayXpCap(controller.todayXp))),
                Chip(
                  label: Text(
                    strings.streakDays(controller.streak.currentStreakDays),
                  ),
                ),
                if (monster.moodState == MonsterMood.sleeping)
                  Chip(
                    label: Text(
                      strings.sleepPetProgress(
                        controller.sleepPetCount,
                        monster.wakeUpThreshold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: readOnly
                  ? () => _showReadOnlySnack(context)
                  : () => controller.petMonster(),
              icon: const Icon(Icons.touch_app_outlined),
              label: Text(strings.petMonster),
            ),
            if (controller.latestPetReaction != null) ...[
              const SizedBox(height: 12),
              Text(strings.petReaction(controller.latestPetReaction!)),
            ],
            const SizedBox(height: 12),
            Text(strings.streakNeutralHint),
          ],
        );
      },
    );
  }
}

class MeTab extends StatelessWidget {
  const MeTab({
    super.key,
    required this.accountSession,
    required this.taskSystem,
    required this.desktopPetController,
    required this.refreshCompanionSnapshot,
    required this.refreshDesktopPetSnapshot,
  });

  final AccountSessionController accountSession;
  final TaskSystemController taskSystem;
  final DesktopPetController desktopPetController;
  final Future<CompanionSnapshot> Function() refreshCompanionSnapshot;
  final Future<CompanionSnapshot> Function(CompanionDesktopPetState state)
  refreshDesktopPetSnapshot;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        accountSession,
        taskSystem,
        desktopPetController,
      ]),
      builder: (context, _) {
        final strings = context.s;
        final account = accountSession.account;
        final readOnly = accountSession.isReadOnly;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListMonsterSectionHeader(
              title: strings.tabMe,
              subtitle: strings.accountSubtitle,
            ),
            const SizedBox(height: 16),
            if (readOnly) ...[
              _ReadOnlyNotice(message: strings.readOnlyMessage),
              const SizedBox(height: 12),
            ],
            _AccountStatusPanel(
              statusLabel: strings.accountStatusLabel,
              statusText: _accountStatusText(strings, account.status),
              accountIdLabel: strings.accountIdLabel,
              accountId: account.accountId,
              effectiveAtLabel: strings.deletionEffectiveAt,
              deletionEffectiveAt: account.deletionEffectiveAt,
            ),
            const SizedBox(height: 12),
            Text(strings.mockCloudDataCount(accountSession.mockCloudTaskCount)),
            if (accountSession.hasPendingMerge) ...[
              const SizedBox(height: 12),
              _PendingMergePanel(
                title: strings.pendingMergeTitle,
                message: strings.mergePreview(
                  accountSession.pendingGuestTaskCount,
                  accountSession.pendingCloudTaskCount,
                ),
                confirmLabel: strings.confirmMerge,
                cancelLabel: strings.cancelMerge,
                onConfirm: () => _confirmMerge(context),
                onCancel: () => _cancelMerge(context),
              ),
            ],
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: readOnly
                      ? () => _showReadOnlySnack(context)
                      : () => _simulateLogin(context),
                  icon: const Icon(Icons.login_outlined),
                  label: Text(strings.localSimulatedLogin),
                ),
                OutlinedButton.icon(
                  onPressed: readOnly
                      ? () => _showReadOnlySnack(context)
                      : () => _generateSnapshot(context),
                  icon: const Icon(Icons.camera_outdoor_outlined),
                  label: Text(strings.generateSnapshot),
                ),
                if (account.canRequestDeletion)
                  OutlinedButton.icon(
                    onPressed: readOnly
                        ? () => _showReadOnlySnack(context)
                        : () => _requestDeletion(context),
                    icon: const Icon(Icons.no_accounts_outlined),
                    label: Text(strings.requestDeletion),
                  ),
                if (account.isDeletionPending)
                  FilledButton.icon(
                    onPressed: () => _cancelDeletion(context),
                    icon: const Icon(Icons.restore_outlined),
                    label: Text(strings.cancelDeletion),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _DesktopPetPanel(
              controller: desktopPetController,
              onOpen: () => _openDesktopPet(context),
              onClose: () => _closeDesktopPet(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _simulateLogin(BuildContext context) async {
    final result = await accountSession.simulateLogin(
      guestTaskCount: taskSystem.tasks.length,
    );
    if (!context.mounted) {
      return;
    }

    switch (result) {
      case SimulatedLoginOutcome.signedIn:
        _showSnack(context, context.s.signedInMessage);
      case SimulatedLoginOutcome.mergeConfirmationRequired:
        await _showMergeConfirmationDialog(context);
      case SimulatedLoginOutcome.readOnlyBlocked:
        _showReadOnlySnack(context);
    }
  }

  Future<void> _showMergeConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.s.pendingMergeTitle),
        content: Text(
          context.s.mergePreview(
            accountSession.pendingGuestTaskCount,
            accountSession.pendingCloudTaskCount,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.s.cancelMerge),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.s.confirmMerge),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed == null) {
      return;
    }
    if (confirmed) {
      await _confirmMerge(context);
    } else {
      await _cancelMerge(context);
    }
  }

  Future<void> _confirmMerge(BuildContext context) async {
    await accountSession.confirmPendingMerge();
    if (context.mounted) {
      _showSnack(context, context.s.mergeConfirmedMessage);
    }
  }

  Future<void> _cancelMerge(BuildContext context) async {
    await accountSession.cancelPendingMerge();
    if (context.mounted) {
      _showSnack(context, context.s.mergeCancelledMessage);
    }
  }

  Future<void> _requestDeletion(BuildContext context) async {
    final requested = await accountSession.requestDeletion();
    if (!context.mounted) {
      return;
    }
    _showSnack(
      context,
      requested
          ? context.s.deletionRequestedMessage
          : context.s.readOnlyMessage,
    );
  }

  Future<void> _cancelDeletion(BuildContext context) async {
    final cancelled = await accountSession.cancelDeletion();
    if (!context.mounted) {
      return;
    }
    if (cancelled) {
      _showSnack(context, context.s.deletionCancelledMessage);
    }
  }

  Future<void> _generateSnapshot(BuildContext context) async {
    await refreshCompanionSnapshot();
    if (context.mounted) {
      _showSnack(context, context.s.snapshotGenerated);
    }
  }

  Future<void> _openDesktopPet(BuildContext context) async {
    final snapshot = await refreshDesktopPetSnapshot(
      CompanionDesktopPetState.enabled,
    );
    await desktopPetController.open(snapshot);
    if (context.mounted) {
      _showSnack(context, desktopPetController.stateValue);
    }
  }

  Future<void> _closeDesktopPet(BuildContext context) async {
    await refreshDesktopPetSnapshot(CompanionDesktopPetState.disabled);
    await desktopPetController.close();
    if (context.mounted) {
      _showSnack(context, desktopPetController.stateValue);
    }
  }
}

class _DesktopPetPanel extends StatelessWidget {
  const _DesktopPetPanel({
    required this.controller,
    required this.onOpen,
    required this.onClose,
  });

  final DesktopPetController controller;
  final Future<void> Function() onOpen;
  final Future<void> Function() onClose;

  @override
  Widget build(BuildContext context) {
    final isOn = controller.isOn;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Desktop pet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text(controller.stateValue)),
                if (isOn)
                  OutlinedButton.icon(
                    key: const ValueKey('desktop-pet-close-button'),
                    onPressed: onClose,
                    icon: const Icon(Icons.close_outlined),
                    label: const Text('Close desktop pet'),
                  )
                else
                  FilledButton.icon(
                    key: const ValueKey('desktop-pet-open-button'),
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new_outlined),
                    label: const Text('Open desktop pet'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountStatusPanel extends StatelessWidget {
  const _AccountStatusPanel({
    required this.statusLabel,
    required this.statusText,
    required this.accountIdLabel,
    required this.accountId,
    required this.effectiveAtLabel,
    required this.deletionEffectiveAt,
  });

  final String statusLabel;
  final String statusText;
  final String accountIdLabel;
  final String accountId;
  final String effectiveAtLabel;
  final DateTime? deletionEffectiveAt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(statusLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(statusText)),
                Chip(label: Text('$accountIdLabel: $accountId')),
              ],
            ),
            if (deletionEffectiveAt != null) ...[
              const SizedBox(height: 8),
              Text(
                '$effectiveAtLabel: ${_formatDateTimeForDisplay(deletionEffectiveAt!)}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingMergePanel extends StatelessWidget {
  const _PendingMergePanel({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(onPressed: onConfirm, child: Text(confirmLabel)),
                TextButton(onPressed: onCancel, child: Text(cancelLabel)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _accountStatusText(AppStrings strings, AccountStatus status) {
  return switch (status) {
    AccountStatus.guest => strings.accountStatusGuest,
    AccountStatus.registered => strings.accountStatusRegistered,
    AccountStatus.deletionPending => strings.accountStatusDeletionPending,
    AccountStatus.deleted => strings.accountStatusDeleted,
  };
}

String _formatDateTimeForDisplay(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.year}-$month-$day $hour:$minute';
}

void _showReadOnlySnack(BuildContext context) {
  _showSnack(context, context.s.readOnlyMessage);
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
