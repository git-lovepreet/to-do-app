import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Color darkColor = Color(0xFF081F5C);
  Color lightColor = Colors.indigo.shade300;

  List todoList =[
    ['Drink Coffee',false],
    ['Slide left to delete',false]
  ];
  //TextEditingController addc =TextEditingController();


  //List todoList = [];
  TextEditingController addc = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  // Load the todo list from SharedPreferences
  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoListString = prefs.getString('todoList');
    if (todoListString != null) {
      setState(() {
        todoList = json.decode(todoListString);
      });
    } else {
      todoList = [['Drink Coffee', false], ['Slide left to delete', false]];
    }
  }

  // Save the todo list to SharedPreferences
  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todoListString = json.encode(todoList);
    await prefs.setString('todoList', todoListString);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        title: Text('Do It',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor:darkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: ListView.builder(
            itemCount:todoList.length,itemBuilder: (context,index){
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(onPressed: (context){
                      setState(() {
                        todoList.removeAt(index);
                        _saveTodoList();
                      });
                    },
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(15),),


                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: darkColor,
                  ),

                  child: Row(
                    children: [
                      Checkbox(value: todoList[index][1], onChanged: (value){
                        return setState(() {
                          todoList[index][1] = value;
                          _saveTodoList();

                        });

                      },
                        checkColor: darkColor,
                        activeColor: Colors.white,
                        side: BorderSide(color: Colors.white,width: 2),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(todoList[index][0],
                              softWrap: true,
                              style:  TextStyle(
                                  color: Colors.white,
                              fontSize: 18,
                                  decoration:todoList[index][1] ?TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: Colors.white,
                                  decorationThickness: 2),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: addc,
                decoration: InputDecoration(
                  hintText: 'Add Here',
                  filled: true,
                  fillColor: Colors.indigo.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: darkColor
                    ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: darkColor
                    ),
                      borderRadius: BorderRadius.circular(25)
                  ),


            
                ),
              ),
            ),
          ),
          FloatingActionButton(onPressed: () {
            setState(() {
              if(addc.text!=''){
              todoList.add([addc.text,false]);
              addc.clear();
              _saveTodoList();
              }
            });

          },
            child: Icon(Icons.add),

          ),
        ],
      ),
    );
  }
}
