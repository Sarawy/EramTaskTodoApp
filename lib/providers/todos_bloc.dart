import 'package:erammediatask/utils/snacbar.dart';
import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  Future<void> addTodo(String title, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _todoList.addAll(await ApiService().addTodo(context, title));
    _isLoading = false;
    notifyListeners();
  }

  void getTodo() async {
    _todoList.clear();
    _isLoading = true;
    notifyListeners();
    _todoList.addAll(await ApiService().getTodo());
    _isLoading = false;
    notifyListeners();
    print(_todoList.length);
  }

  Future deleteTodo(int id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _todoList.removeWhere((todoItem) => todoItem.id == id);
    bool isDeleted = await ApiService().deleteTodo(id, context);
    if (isDeleted) {
      _todoList.removeWhere((todoItem) => todoItem.id == id);
    }
    _isLoading = false;

    notifyListeners();
  }

  //
  Future<void> editTodo(
      String title, BuildContext context, int id, bool completed) async {
    _isLoading = true;
    notifyListeners();

    bool isUpdated = await ApiService().editTodo(context, title, id, completed);
    if (isUpdated) {
      int index = _todoList.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todoList[index].title = title;
        _todoList[index].isCompleted = completed;
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
