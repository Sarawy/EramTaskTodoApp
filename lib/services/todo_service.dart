import 'dart:convert';
import 'dart:io';
import 'package:erammediatask/utils/snacbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class ApiService {
  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on SocketException catch (_) {
      internet = false;
    }
    return internet;
  }

  Future<List<TodoModel>> getTodo() async {
    String url = "https://eram-flutter-assessment-backend.onrender.com/todos";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      List<TodoModel> todoList = [];
      for (var todo in result) {
        TodoModel todoModel = TodoModel(
            title: todo["title"],
            id: todo["id"],
            isCompleted: todo["completed"]);
        todoList.add(todoModel);
      }
      return todoList;
    }
    return [];
  }

  Future addTodo(BuildContext context, String title) async {
    String url = "https://eram-flutter-assessment-backend.onrender.com/todos";
    Map<String, dynamic> body = {
      "title": title,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      TodoModel tm = TodoModel(
          id: result["id"],
          title: result["title"],
          isCompleted: result["completed"]);
      openSnacbar(context, 'ToDo Added Successfully !');

      return [tm];
    } else {
      openSnacbar(context, 'Something Went Wrong!\nPlease Try Again Later');

      return [];
    }
  }

  Future<bool> deleteTodo(int id, BuildContext context) async {
    String url =
        "https://eram-flutter-assessment-backend.onrender.com/todos/$id";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 204) {
      openSnacbar(context, 'ToDo Deleted Successfully !');
      return true;
    } else {
      openSnacbar(context, 'Something Went Wrong!\nPlease Try Again Later');
      return false;
    }
  }

  Future editTodo(
      BuildContext context, String title, int id, bool completed) async {
    String url =
        "https://eram-flutter-assessment-backend.onrender.com/todos/$id";
    var body = {
      "title": title,
      "completed": completed ? true : false,
    };
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      openSnacbar(context, 'ToDo Edited Successfully !');
      return true;
    } else {
      openSnacbar(context, 'Something Went Wrong!\nPlease Try Again Later');
      return false;
    }
  }
}
