import 'package:flutter/material.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sprite_runtime/sprite_runtime.dart';
import 'package:task_domain/task_domain.dart';
import 'package:ui_kit/ui_kit.dart';

import 'node3_core_loop.dart';

void main() {
  runApp(const ListMonsterApp());
}

class ListMonsterApp extends StatelessWidget {
  const ListMonsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '清单怪兽',
      theme: ListMonsterTheme.light(),
      home: const ListMonsterShell(),
    );
  }
}

class ListMonsterShell extends StatefulWidget {
  const ListMonsterShell({super.key});

  @override
  State<ListMonsterShell> createState() => _ListMonsterShellState();
}

class _ListMonsterShellState extends State<ListMonsterShell> {
  int _tabIndex = 0;
  late final CoreLoopController _coreLoop;

  @override
  void initState() {
    super.initState();
    _coreLoop = CoreLoopController();
  }

  @override
  void dispose() {
    _coreLoop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodayTab(controller: _coreLoop),
      const PlaceholderTab(title: '清单', message: '收集箱、自建清单和最近 7 天会从这里展开。'),
      MonsterTab(controller: _coreLoop),
      const PlaceholderTab(title: '我的', message: '游客、通知、勿扰和桌宠开关会在后续节点接入。'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('清单怪兽')),
      body: tabs[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), label: '今日'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: '清单'),
          NavigationDestination(icon: Icon(Icons.egg_alt_outlined), label: '怪兽'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}

class TodayTab extends StatefulWidget {
  const TodayTab({super.key, required this.controller});

  final CoreLoopController controller;

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final milestone = controller.latestMilestone;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ListMonsterSectionHeader(
                title: '今日',
                subtitle: '把小事喂给小单。',
              ),
              const SizedBox(height: 20),
              MonsterSpritePlaceholder(
                moodLabel: controller.monster.moodState.label,
                actionLabel: controller.hasTasks ? '等待完成' : '获得怪兽蛋',
              ),
              const SizedBox(height: 16),
              _MonsterStatusStrip(controller: controller),
              const SizedBox(height: 20),
              if (!controller.hasTasks)
                Text(
                  '小单正在等第一个任务',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (!controller.hasTasks) const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '今天要完成什么',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _createTask(),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _createTask,
                icon: const Icon(Icons.add_task_outlined),
                label: const Text('加入今日'),
              ),
              const SizedBox(height: 24),
              if (controller.hasTasks)
                ...controller.tasks.map(
                  (task) => _TaskTile(
                    task: task,
                    onComplete: () => controller.completeTask(task.id),
                  ),
                ),
              if (milestone != null) ...[
                const SizedBox(height: 20),
                _MilestoneCard(milestone: milestone),
              ],
            ],
          ),
        );
      },
    );
  }

  void _createTask() {
    widget.controller.createTask(_titleController.text);
    _titleController.clear();
  }
}

class _MonsterStatusStrip extends StatelessWidget {
  const _MonsterStatusStrip({required this.controller});

  final CoreLoopController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(controller.monster.stage.label)),
              Chip(label: Text(controller.monster.moodState.label)),
            ],
          ),
        ),
        Text(
          '+${controller.todayXp} XP',
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onComplete,
  });

  final TaskItem task;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: task.isCompleted,
      onChanged: task.isCompleted ? null : (_) => onComplete(),
      title: Text(task.title),
      subtitle: task.isCompleted ? const Text('已投喂小单') : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
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
                milestone.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonsterTab extends StatelessWidget {
  const MonsterTab({super.key, required this.controller});

  final CoreLoopController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final monster = controller.monster;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ListMonsterSectionHeader(
              title: '怪兽',
              subtitle: '小单的成长只来自真实完成。',
            ),
            const SizedBox(height: 20),
            MonsterSpritePlaceholder(
              moodLabel: monster.moodState.label,
              actionLabel: monster.stage.label,
            ),
            const SizedBox(height: 20),
            Text(monster.stage.label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('等级 ${monster.level} · ${monster.moodState.label}'),
            const SizedBox(height: 8),
            Text('${monster.currentLevelXp} / ${monster.xpToNextLevel} XP'),
          ],
        );
      },
    );
  }
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
