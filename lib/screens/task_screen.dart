import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_tile.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    required this.selectedDate,
    required this.tasks,
    required this.onTasksChanged,
    super.key,
  });

  final DateTime selectedDate;
  final List<Task> tasks;
  final VoidCallback onTasksChanged;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String get _formattedDate {
    const weekdays = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo',
    ];
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    final date = widget.selectedDate;
    return '${weekdays[date.weekday - 1]}, ${date.day} de '
        '${months[date.month - 1]}';
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A2031),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Nova tarefa',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(controller.text.trim());
              }
            },
            decoration: const InputDecoration(
              labelText: 'O que você precisa fazer?',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Digite o nome da tarefa.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(controller.text.trim());
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (title == null || title.isEmpty || !mounted) return;
    setState(() {
      widget.tasks.add(Task(title: title));
    });
    widget.onTasksChanged();
  }

  void _toggleTask(Task task, bool? completed) {
    setState(() {
      task.completed = completed ?? false;
    });
    widget.onTasksChanged();
  }

  void _deleteTask(Task task) {
    setState(() {
      widget.tasks.remove(task);
    });
    widget.onTasksChanged();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = sortTasks(widget.tasks);
    final pendingCount = tasks.where((task) => !task.completed).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar ao calendário',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Tarefas do dia',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: const Color(0xFF35E0C1),
        foregroundColor: const Color(0xFF090B14),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: tasks.isEmpty
                ? _EmptyState(
                    formattedDate: _formattedDate,
                    onAddTask: _addTask,
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    children: [
                      Text(
                        _formattedDate,
                        style: const TextStyle(
                          color: Color(0xFF35E0C1),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pendingCount == 0
                            ? 'Tudo em dia!'
                            : '$pendingCount ${pendingCount == 1 ? 'tarefa' : 'tarefas'} pela frente',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (pendingCount > 0) ...[
                        const _SectionLabel(
                          title: 'PENDENTES',
                          color: Color(0xFFB79AFF),
                          icon: Icons.radio_button_unchecked_rounded,
                        ),
                        const SizedBox(height: 12),
                        for (final task
                            in tasks.where((task) => !task.completed))
                          TaskTile(
                            task: task,
                            onChanged: (value) => _toggleTask(task, value),
                            onDelete: () => _deleteTask(task),
                          ),
                      ],
                      if (pendingCount > 0 && pendingCount < tasks.length)
                        const SizedBox(height: 12),
                      if (pendingCount < tasks.length) ...[
                        const _SectionLabel(
                          title: 'CONCLUÍDAS',
                          color: Color(0xFF35E0C1),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                        for (final task
                            in tasks.where((task) => task.completed))
                          TaskTile(
                            task: task,
                            onChanged: (value) => _toggleTask(task, value),
                            onDelete: () => _deleteTask(task),
                          ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.color,
    required this.icon,
  });

  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.formattedDate,
    required this.onAddTask,
  });

  final String formattedDate;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFB79AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Um espaço em branco.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione a primeira tarefa para $formattedDate.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF9BA2B7), height: 1.5),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: 220,
            child: FilledButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar tarefa'),
            ),
          ),
        ],
      ),
    );
  }
}
