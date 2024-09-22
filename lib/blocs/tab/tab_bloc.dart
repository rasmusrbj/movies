import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class TabEvent {}

class TabChanged extends TabEvent {
  final int index;
  TabChanged(this.index);
}

// States
class TabState {
  final int currentIndex;
  TabState(this.currentIndex);
}

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabState(0)) {
    on<TabChanged>((event, emit) {
      emit(TabState(event.index));
    });
  }
}