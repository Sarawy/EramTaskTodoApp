import 'package:erammediatask/models/todo_model.dart';
import 'package:erammediatask/providers/todos_bloc.dart';
import 'package:erammediatask/widgets/todo_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers:  [
      ChangeNotifierProvider<TodoProvider>(
        create: (context) => TodoProvider(),
      ),


    ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Eram Media Task'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<TodoProvider>().getTodo();
    super.initState();
  }
  void _showTextInputDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What is Your Next Task'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                print(textController.text);
               await context.read<TodoProvider>().addTodo(textController.text, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
        actions: [IconButton(onPressed: (){    context.read<TodoProvider>().getTodo();
        }, icon: const Icon(Icons.refresh))],
      ),
      body:context.watch<TodoProvider>().isLoading?Center(child: CircularProgressIndicator(),):Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
       Expanded(
         child: ListView.separated(

      itemCount:
            context.watch<TodoProvider>().todoList.length,
      shrinkWrap: true, scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
          TodoModel todo = context.watch<TodoProvider>().todoList[index];


          return TodoCard(model: todo,);
      },
      separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5);
      },
         ),
       ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTextInputDialog(context);

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
