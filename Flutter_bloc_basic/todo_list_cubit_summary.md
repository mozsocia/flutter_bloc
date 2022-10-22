
todo_state.dart
```dart

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

class Task  {
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



-----------------------------

main.dart
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


class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);

  ........
}

```


```dart


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


class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    Key? key,
  }) : super(key: key);

  final titleController = TextEditingController();

    ...
              ElevatedButton(
                onPressed: () {
                  var task = Task(title: titleController.text);
                  context.read<TodoCubit>().AddTask(task);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
          
    ...
    );
  }
}

```
