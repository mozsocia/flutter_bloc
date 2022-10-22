
todo_state.dart
```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_cubit.dart';

class TodoState {
  List<Task> allTasks;
  TodoState({
    required this.allTasks,
  });
}

class TodoInitial extends TodoState {
  TodoInitial()
      : super(allTasks: [
          Task(title: 'task one'),
          Task(title: 'task two'),
        ]);
}

```
todo_cubit.dart
```dart
import 'package:bloc/bloc.dart';
import 'package:flutter_tasks_app/models/task.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  void AddTask(Task task) {
    emit(TodoState(
      allTasks: List.from(state.allTasks)..add(task),
    ));
  }

  void UpdateTask(Task task) {
    final int index = state.allTasks.indexOf(task);

    List<Task> allTasks = List.from(state.allTasks)..remove(task);

    task.isDone == false
        ? allTasks.insert(index, task.copyWith(isDone: true))
        : allTasks.insert(index, task.copyWith(isDone: false));

    emit(TodoState(allTasks: allTasks));
  }

  void DeleteTask(Task task) {
    emit(TodoState(allTasks: List.from(state.allTasks)..remove(task)));
  }
}
```


Task.dart

```dart
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task extends Equatable {
  final String title;
  final bool? isDone;
  final bool? isDeleted;
  Task({
    required this.title,
    this.isDone = false,
    this.isDeleted = false,
  });

  Task copyWith({
    String? title,
    bool? isDone,
    bool? isDeleted,
  }) {
    return Task(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
      'isDeleted': isDeleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      isDone: map['isDone'] != null ? map['isDone'] as bool : null,
      isDeleted: map['isDeleted'] != null ? map['isDeleted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [title, isDone, isDeleted];
}

```



-----------------------------

main.dart
```dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/todo_cubit.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(),
      child: MaterialApp(
        title: 'Flutter Tasks App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TasksScreen(),
      ),
    );
  }
}

```

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/add_task_screen.dart';
import 'package:flutter_tasks_app/widgets/taks_list.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AddTaskScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Chip(
              label: Text(
                'Tasks:',
              ),
            ),
          ),
          TaskList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

```


```dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/todo_cubit.dart';
import 'package:flutter_tasks_app/models/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        List<Task> tasksList = state.allTasks;
        print("builder run");
        return Expanded(
          child: ListView.builder(
            itemCount: tasksList.length,
            itemBuilder: (context, index) {
              var task = tasksList[index];
              return ListTile(
                title: Text(task.title),
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    context.read<TodoCubit>().UpdateTask(task);
                  },
                ),
                trailing: OutlinedButton(
                  onPressed: () {
                    context.read<TodoCubit>().DeleteTask(task);
                  },
                  child: Icon(
                    Icons.delete,
                    size: 24.0,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

```

```dart

import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/cubit/todo_cubit.dart';
import 'package:flutter_tasks_app/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    Key? key,
  }) : super(key: key);

  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Add Task',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            autofocus: true,
            controller: titleController,
            decoration: InputDecoration(
              label: Text('Title'),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  var task = Task(title: titleController.text);
                  context.read<TodoCubit>().AddTask(task);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

```

















-----------------------
-----------------------
------------------

```dart
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task extends Equatable {
  final String title;
  final bool? isDone;
  final bool? isDeleted;
  Task({
    required this.title,
    this.isDone = false,
    this.isDeleted = false,
  });

  Task copyWith({
    String? title,
    bool? isDone,
    bool? isDeleted,
  }) {
    return Task(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
      'isDeleted': isDeleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      isDone: map['isDone'] != null ? map['isDone'] as bool : null,
      isDeleted: map['isDeleted'] != null ? map['isDeleted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [title, isDone, isDeleted];
}
```

