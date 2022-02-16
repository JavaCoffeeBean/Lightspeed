
part of 'users_bloc.dart';

@immutable
abstract class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class Loading extends UsersState {
  const Loading();
}


class UsersLoaded extends UsersState {
  final Future userFuture;
   const UsersLoaded(this.userFuture);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsersLoaded && o.userFuture == userFuture;
  }

  @override
  int get hashCode => userFuture.hashCode;
}

class TodosLoaded extends UsersState {
  final Future todosFuture;
  const TodosLoaded(this.todosFuture);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodosLoaded && o.todosFuture == todosFuture;
  }

  @override
  int get hashCode => todosFuture.hashCode;
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsersError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}