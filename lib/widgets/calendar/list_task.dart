// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTask extends StatelessWidget {
  const ListTask({
    super.key,
    required this.task,
    required this.count,
  });

  final Task task;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TasksService>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.remove_red_eye_rounded,
              size: 35,
            ),
            if (task.finish)
              const Icon(
                Icons.check_circle,
                size: 45,
                color: Colors.green,
              ),
          ],
        ),
        onTap: () {
          tasksService.selectTask = task.copy();
          Navigator.pushNamed(context, DetailsCalendarScreen.routeName);
        },
      ),
    );
  }
}
