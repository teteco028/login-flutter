import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onChanged,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 8, right: 12),
        leading: Checkbox(
          value: task.completed,
          onChanged: onChanged,
          activeColor: const Color(0xFF35E0C1),
          checkColor: const Color(0xFF090B14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.completed ? const Color(0xFF858BA0) : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            decorationColor: const Color(0xFF858BA0),
          ),
        ),
        trailing: IconButton(
          tooltip: 'Excluir tarefa',
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFFF7188),
          ),
        ),
      ),
    );
  }
}
