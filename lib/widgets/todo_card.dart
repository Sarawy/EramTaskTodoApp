import 'package:erammediatask/models/todo_model.dart';
import 'package:erammediatask/providers/todos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatelessWidget {
  TodoCard({Key? key, required this.model}) : super(key: key);
  final TodoModel model;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool selected = model.isCompleted!;
        textController.text = model.title!;
        showBarModalBottomSheet(
            elevation: 3,
            duration: Duration(milliseconds: 500),
            context: context,
            builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    padding: EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Task Number: ' + model.id.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF2c2c2c),
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: CheckboxListTile(
                                    value: selected,
                                    title: Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Color(0xFF2c2c2c),
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                    onChanged: (value) =>
                                        setState(() => selected = value!)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Title: ',
                                  style: TextStyle(
                                    color: Color(0xFF2c2c2c),
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: TextField(
                                  controller: textController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text('Update'),
                                onPressed: () async {
                                  await context.read<TodoProvider>().editTodo(
                                      textController.text,
                                      context,
                                      model!.id!,
                                      selected);

                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () async {
                                  await context
                                      .read<TodoProvider>()
                                      .deleteTodo(model.id!, context);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }));
      },
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(
                        Icons.task,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        model.title ?? '',
                        style: TextStyle(
                          color: Color(0xFF2c2c2c),
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                model.isCompleted!
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8.0),
                        child: Icon(
                          Icons.task_alt,
                          color: Colors.green,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            )),
      ),
    );
  }
}
