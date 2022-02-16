import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'data_model/todo.dart';
import 'data_model/user.dart';

abstract class AbstractUserRepository {
  /// Throws [NetworkException].
  Future fetchUser();
  Future fetchUserTodos(int userId);
}

class UserRepository implements AbstractUserRepository {
  @override
  Future fetchUser() async{
    try {
      var response =
      await get("https://jsonplaceholder.typicode.com/users").timeout(const Duration(seconds: 5));

      var jsonData = jsonDecode(response.body);
      List<User> users = [];

      for (var u in jsonData) {
        User user = User(id: u["id"],
            name: u["name"],
            phone: u["phone"],
            email: u["email"],
            street: u["address"],
            city: "gg",
            zipcode: "gg");
        users.add(user);
      }

      return users;
    } catch(e) {
      print("problem  fetching data");
      throw NetworkException();
    }

  }

  @override
  Future fetchUserTodos(int userId) async{
    String userIdString = userId.toString();

    try {
      var response =
      await get("https://jsonplaceholder.typicode.com/todos?userId=$userIdString").timeout(const Duration(seconds: 5));

      var jsonData = jsonDecode(response.body);
      List<Todo> todos = [];

      for (var u in jsonData) {
        Todo todo = Todo(
            id: u["id"],
          userId: u["userId"],
          completed: u["completed"],
          title: u["title"]
        );
        todos.add(todo);
      }

      return todos;
    } catch(e) {
      print("problem  fetching data");
      throw NetworkException();
    }


  }



}

class NetworkException implements Exception {}