class Task {
  Task({
    required this.title,
    this.completed = false,
  });

  final String title;
  bool completed;
}

List<Task> sortTasks(Iterable<Task> tasks) {
  final sortedTasks = List<Task>.of(tasks);
  sortedTasks.sort((first, second) {
    if (first.completed != second.completed) {
      return first.completed ? 1 : -1;
    }
    return first.title.toLowerCase().compareTo(second.title.toLowerCase());
  });
  return sortedTasks;
}
