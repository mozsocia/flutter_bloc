https://www.youtube.com/watch?v=Auh7fVk_CX4


<br>
app_states.dart

```dart
class CounterStates {
  int counter;
  CounterStates({required this.counter});
}

class InitialState extends CounterStates {
InitialState() : super(counter: 0);
}

```
app_events.dart

```dart
abstract class CounterEvents {}

class Increment extends CounterEvents {}

class Decrement extends CounterEvents {}
```

```dart
import 'package:bloc_prac/app_events.dart';
import 'package:bloc_prac/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBlocs extends Bloc<CounterEvents, CounterStates> {
  CounterBlocs() : super(InitialState()) {
    on<Increment>((event, emit) {
      emit(CounterStates(counter: state.counter + 1));
    });

    on<Decrement>((event, emit) {
      emit(CounterStates(counter: state.counter - 1));
    });
  }
}
```

main.dart

```dart

import 'package:bloc_prac/app_blocs.dart';
import 'package:bloc_prac/app_events.dart';
import 'package:bloc_prac/app_states.dart';
import 'package:bloc_prac/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBlocs(),
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterBlocs, CounterStates>(builder: (context, state) {
        return Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.counter.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () =>
                        BlocProvider.of<CounterBlocs>(context).add(Increment()),
                    child: const Icon(Icons.add)),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () =>
                        BlocProvider.of<CounterBlocs>(context).add(Decrement()),
                    child: const Icon(Icons.remove))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("clicked");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondPage()));
              },
              child: const Icon(Icons.skip_next_rounded),
            )
          ],
        );
      }),
    );
  }
}
```


second_page.dart

```dart

import 'package:bloc_prac/app_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterBlocs counterBloc = BlocProvider.of<CounterBlocs>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blocs"),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder(
            bloc: counterBloc,
            builder: (context, state) {
              return Center(
                child: Text(
                  counterBloc.state.counter.toString(),
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }));
  }
}
```

