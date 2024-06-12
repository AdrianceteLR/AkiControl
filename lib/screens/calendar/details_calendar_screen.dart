// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, depend_on_referenced_packages, use_build_context_synchronously

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsCalendarScreen extends StatelessWidget {
  static String routeName = 'DetailsCalendar';

  const DetailsCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TasksService>(context);

    return ChangeNotifierProvider(
      create: (context) => TaskFormProvider(taskService.selectTask),
      child: _DetailsCalendarScreen(tasksService: taskService),
    );
  }
}

class _DetailsCalendarScreen extends StatelessWidget {
  const _DetailsCalendarScreen({
    required this.tasksService,
  });

  final TasksService tasksService;

  @override
  Widget build(BuildContext context) {
    final taskForm = Provider.of<TaskFormProvider>(context);

    final task = taskForm.task;
    DateTime dateTime = DateTime.parse(task.day!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
      ),
      body: Stack(
        children: [
          const HomeBackground(),
          Column(
            children: [
              Expanded(
                child: TaskForm(
                  date: dateTime,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // TERMINAR / GUARDAR
                    ElevatedButton(
                      onPressed: tasksService.isSaving
                          ? null
                          // GUARDAR
                          : () async {
                              if (taskForm.isEditing) {
                                if (!taskForm.isValidForm()) return;
                                task.finish = false;

                                await dialogs(
                                  context,
                                  title: 'Modificada correctamente',
                                );

                                await tasksService
                                    .saveOrCreateTask(taskForm.task);
                                taskForm.isEditing = false;
                              }
                              // TERMINAR
                              else {
                                if (task.finish) {
                                  task.finish = false;
                                } else {
                                  task.finish = true;
                                  Navigator.of(context).pop(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: const CalendarScreen(),
                                        );
                                      },
                                    ),
                                  );
                                }
                                await tasksService
                                    .saveOrCreateTask(taskForm.task);
                              }
                            },
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(5),
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                      ),
                      child: Text(
                        taskForm.isEditing
                            ? 'Guardar'
                            : task.finish
                                ? 'No terminada'
                                : 'Terminar',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    // EDITAR / CANCELAR
                    ElevatedButton(
                      onPressed: () {
                        if (taskForm.isEditing) {
                          taskForm.restoreOriginalTask();
                        }
                        taskForm.isEditing = !taskForm.isEditing;
                        taskForm.notifyListeners();
                      },
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(5),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orange),
                      ),
                      child: Text(
                        taskForm.isEditing ? 'Cancelar' : 'Editar',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    // ELIMINAR
                    ElevatedButton(
                      onPressed: taskForm.isEditing
                          ? null
                          : () async {
                              await dialogs(
                                context,
                                title: 'Eliminada correctamente',
                              );
                              await _deleteTask(context, taskForm.task.id);
                            },
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(5),
                        backgroundColor: MaterialStatePropertyAll(
                            taskForm.isEditing ? Colors.grey : Colors.red),
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _deleteTask(BuildContext context, String? taskId) async {
  if (taskId != null) {
    await Provider.of<TasksService>(context, listen: false).deleteTask(taskId);
    Navigator.pop(context);
  }
}
