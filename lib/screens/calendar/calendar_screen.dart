// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/services/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:akicontrol/widgets/widgets.dart';

class CalendarScreen extends StatefulWidget {
  static String routeName = 'Calendar';

  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TasksService>(context);

    if (tasksService.isLoading) return const LoadingScreen();

    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFF5EE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_headerDrawer(context), const MenuDrawer()],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const HomeBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      color: Colors.white,
                      child: TableCalendar(
                        locale: 'es_ES',
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2101, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        eventLoader: (day) {
                          return tasksService.getTasksForDay(day);
                        },
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFFE76F51),
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Color.fromARGB(136, 244, 163, 97),
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: TextStyle(
                            color: Colors.red,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          todayTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                          defaultTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextStyle: TextStyle(
                              color: Color(0xFFE76F51),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Color(0xFFE76F51),
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFFE76F51),
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          weekdayStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: _buildTaskList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    final tasksService = Provider.of<TasksService>(context);
    final tasks = tasksService.getTasksForDay(_selectedDay);
    return tasks.isNotEmpty
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTask(
                  task: tasks[index],
                  count: index,
                ),
              );
            },
          )
        : const Center(
            child: Text(
              'No hay tareas para este día',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          );
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final tasksService = Provider.of<TasksService>(context, listen: false);
    final taskForm =
        TaskFormProvider(Task(title: '', description: '', finish: false));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Añadir nueva tarea"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Título de la tarea",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Descripción de la tarea",
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Añadir"),
              onPressed: () async {
                taskForm.task.title = titleController.text;
                taskForm.task.description = descriptionController.text;
                taskForm.task.day = _selectedDay.toIso8601String();

                await tasksService.saveOrCreateTask(taskForm.task);

                await dialogs(
                  context,
                  title: 'Creada correctamente',
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Material _headerDrawer(BuildContext context) {
    return Material(
      color: const Color(0xFFE76F51),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: 25),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                'AkiControl',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
