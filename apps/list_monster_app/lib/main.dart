import 'package:flutter/material.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sprite_runtime/sprite_runtime.dart';
import 'package:task_domain/task_domain.dart';
import 'package:ui_kit/ui_kit.dart';

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

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const TodayTab(),
      const PlaceholderTab(title: '清单', message: '收集箱、自建清单和最近 7 天会从这里展开。'),
      const PlaceholderTab(title: '怪兽', message: 'XP、等级、状态和动作会在节点 3 接入。'),
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

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    const draft = TaskDraft(title: '写下今天第一件小事');
    const mood = MonsterMood.expecting;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const ListMonsterSectionHeader(
          title: '今日',
          subtitle: '先把核心闭环的舞台搭起来。',
        ),
        const SizedBox(height: 20),
        MonsterSpritePlaceholder(
          moodLabel: mood.label,
          actionLabel: '等待任务完成反馈',
        ),
        const SizedBox(height: 20),
        Text(
          '小单正在等第一个任务',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '节点 3 会从这里跑通：创建任务 -> 完成任务 -> XP 增长 -> 怪兽状态变化。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_task_outlined),
          label: Text(draft.title),
        ),
      ],
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

