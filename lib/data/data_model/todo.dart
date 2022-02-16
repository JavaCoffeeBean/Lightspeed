import 'package:meta/meta.dart';

class Todo {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  Todo({
    @required this.userId,
    @required this.id,
    @required this.title,
    @required this.completed,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Todo &&
        o.userId == userId &&
        o.id == id &&
        o.title == title &&
        o.completed == completed;
  }

  @override
  int get hashCode => userId.hashCode ^ id.hashCode ^ title.hashCode ^ completed.hashCode;
}