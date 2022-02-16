import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lightspeed_voice_task/data/data_model/user.dart';
import 'package:lightspeed_voice_task/data/user_repository.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';




class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _userRepository;

  UsersBloc(this._userRepository) : super(UsersInitial());

  @override
  Stream<UsersState> mapEventToState(
      UsersEvent event,
      ) async* {
    if (event is GetUsers) {
      try {
        yield const Loading();
        if(await _userRepository.fetchUser() == null){
          yield UsersError('could not get data');
        } else {
          yield Loading();
          yield UsersLoaded(_userRepository.fetchUser());
        }

      } catch(e)  {
        print("yielding UsersError State");
        yield const UsersError("Couldn't fetch users. Is the device online?");
      }
    } else if (event is GetTodos) {
      try {
        yield const Loading();
        if(await _userRepository.fetchUserTodos(event.userId) == null){
          yield UsersError('could not get data');
        } else {
          yield Loading();
          yield TodosLoaded(_userRepository.fetchUserTodos(event.userId));
        }

      } catch(e)  {
        print("yielding UsersError State");
        yield const UsersError("Couldn't fetch todos. Is the device online?");
      }
    }
  }
}

/*
final compFuture = users;
if(compFuture == null){
yield UsersError('ther was a problem');
} else {
yield UsersLoaded(users);
}*/
