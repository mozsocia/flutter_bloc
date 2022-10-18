```dart

import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

Future<void> main() async {
  final cubit = CounterCubit();

  print(cubit.state);

  // final subscription = cubit.listen(print);  // old version syntex
  final subscription = cubit.stream.listen(print); // 1


  cubit.increment();
  cubit.increment();
  cubit.increment();
  cubit.increment();
  cubit.increment();

  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await cubit.close();
}


```