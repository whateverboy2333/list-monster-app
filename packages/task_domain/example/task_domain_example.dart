import 'package:task_domain/task_domain.dart';

void main() {
  const draft = TaskDraft(title: '写下今天第一件小事');

  print(draft.canCreate);
}

