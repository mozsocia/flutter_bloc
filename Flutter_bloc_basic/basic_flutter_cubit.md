```dart
class DiceFaceCubit extends Cubit<int?> {
  DiceFaceCubit() : super(null);

  void rollDice() {
    int number;
    do {
      number = Random().nextInt(6);
    } while (number == 0);
    emit(number);
  }
}

```

```dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DiceFaceCubit(),
        )
      ],
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}
```

```dart

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(200, 100)),
            onPressed: () {
              // context.read<DiceFaceCubit>().rollDice();
              BlocProvider.of<DiceFaceCubit>(context).rollDice();
            },
            child: Text(
              "Roll Dice",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: BlocBuilder<DiceFaceCubit, int?>(
              builder: (context, state) {
                return Text(
                  state != null ? "$state" : "click",
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text("${context.watch<DiceFaceCubit>().state}"),
        ],
      ),
    );
  }
}
```


-------------------------
-------------------------
----------------------

```dart
class DiceFaceCubit extends Cubit<int?> {
  DiceFaceCubit() : super(null);

  void rollDice() {
    int number;
    do {
      number = Random().nextInt(6);
    } while (number == 0);
    emit(number);
  }
}

class ColorCubit extends Cubit<MaterialColor> {
  ColorCubit() : super(Colors.amber);
}

```

```dart

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DiceFaceCubit(),
        ),
        BlocProvider(
          create: (_) => ColorCubit(),
        )
      ],
      child: MaterialApp(
        home: const HomePage2(),
      ),
    );
  }
}
```

```dart

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(200, 100)),
            onPressed: () {
              // context.read<DiceFaceCubit>().rollDice();
              BlocProvider.of<DiceFaceCubit>(context).rollDice();
            },
            child: Text(
              "Roll Dice",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Builder(
              builder: (context) {
                final numberState = context.watch<DiceFaceCubit>().state;
                final colorState = context.watch<ColorCubit>().state;

                return Text(
                  numberState != null ? "$numberState" : "click",
                  style: TextStyle(color: colorState),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

