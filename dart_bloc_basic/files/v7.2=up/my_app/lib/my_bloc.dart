import 'package:bloc/bloc.dart';

abstract class CounterEvent {}

class Increment extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}

Future<void> main(List<String> args) async {
  final bloc = CounterBloc();

  // see init value
  print(bloc.state); // 0

  // subscription
  final subscription = bloc.stream.listen(print);

  bloc.add(Increment());
  bloc.add(Increment());
  bloc.add(Increment());
  bloc.add(Increment());

  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await bloc.close();
}
