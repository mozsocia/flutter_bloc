import 'package:bloc/bloc.dart';

abstract class CounterEvent {}

class Increment extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event is Increment) {
      yield state + 1;
    }
  }
}

Future<void> main(List<String> args) async {
  final bloc = CounterBloc();

  // see init value
  print(bloc.state); // 0

  // subscription
  final subscription = bloc.listen(print);

  bloc.add(Increment());
  bloc.add(Increment());
  bloc.add(Increment());
  bloc.add(Increment());

  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await bloc.close();
}
