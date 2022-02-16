part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsers extends UsersEvent {
  GetUsers();
}

class GetTodos extends UsersEvent {
  final int userId;
  GetTodos(this.userId);
}