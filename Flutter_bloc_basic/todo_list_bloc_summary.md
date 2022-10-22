```dart
class TasksState  {
  final List<Task> allTasks;
  TasksState({this.allTasks = const <Task>[]});

}

class TaskInitial extends TasksState {
  TaskInitial()
      : super(
          allTasks: [
            Task(title: 'task one'),
            Task(title: 'task two'),
          ],
        );
}

```

```dart
abstract class TasksEvent {
  const TasksEvent();

}

class AddTask extends TasksEvent {
  final Task task;
  AddTask({
    required this.task,
  });

}

class UpdateTask extends TasksEvent {
  final Task task;
  UpdateTask({
    required this.task,
  });


}

class DeleteTask extends TasksEvent {
  final Task task;
  DeleteTask({
    required this.task,
  });


}

```
```dart

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  // TasksBloc() : super(TaskInitial()) {    // this line or below for initial
  TasksBloc()
      : super(TasksState(allTasks: [
          Task(title: 'task one'),
          Task(title: 'task two'),
        ])) {
    //
    // all event change start below
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    emit(TasksState(
      allTasks: List.from(state.allTasks)..add(event.task),
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;
    final int index = state.allTasks.indexOf(task);

    List<Task> allTasks = List.from(state.allTasks)..remove(task);

    task.isDone == false
        ? allTasks.insert(index, task.copyWith(isDone: true))
        : allTasks.insert(index, task.copyWith(isDone: false));

    emit(TasksState(allTasks: allTasks));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    emit(TasksState(allTasks: List.from(state.allTasks)..remove(event.task)));
  }
}
```

```dart

class Task {
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

}

```


```dart 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksBloc(),
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

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);
    ...
    ...
    ...
}





class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
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
                    context.read<TasksBloc>().add(UpdateTask(task: task));
                  },
                ),
                trailing: OutlinedButton(
                  onPressed: () {
                    context.read<TasksBloc>().add(DeleteTask(task: task));
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


class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    Key? key,
  }) : super(key: key);

  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        .....
            ElevatedButton(
            onPressed: () {
                var task = Task(title: titleController.text);
                context.read<TasksBloc>().add(AddTask(task: task));
                Navigator.pop(context);
            },
            child: Text('Add'),
              ),
        .....
    );
  }
}


```


