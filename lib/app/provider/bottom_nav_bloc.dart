import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Event
abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();
}

class BottomNavItemSelected extends BottomNavEvent {
  final int index;

  const BottomNavItemSelected(this.index);

  @override
  List<Object> get props => [index];
}

// State
abstract class BottomNavState extends Equatable {
  const BottomNavState();
}

class BottomNavInitial extends BottomNavState {
  @override
  List<Object> get props => [];
}

class BottomNavItemSelectedState extends BottomNavState {
  final int index;

  const BottomNavItemSelectedState(this.index);

  @override
  List<Object> get props => [index];
}

// Bloc
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitial());

  Stream<BottomNavState> mapEventToState(BottomNavEvent event) async* {
    if (event is BottomNavItemSelected) {
      yield BottomNavItemSelectedState(event.index);
    }
  }
}