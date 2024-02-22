import 'package:flutter/material.dart';
import 'package:note_app/db_helper.dart';
import 'package:note_app/widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List notes = [];

  getData() async {
    final data = await DbHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 213, 201, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(192, 149, 80, 1),
        title: Text("Note App"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(notes.length, (index) {
          return CustomButton(
            title: "${notes[index]["title"]}",
            des: "${notes[index]["description"]}",
            id: notes[index]["id"],
            getData: getData(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addBox();
        },
        backgroundColor: Color.fromRGBO(192, 149, 80, 1),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        color: Color.fromRGBO(192, 149, 80, 1),
        child: Container(
          height: 60,
        ),
      ),
    );
  }

  ///for add data
  addBox() {
    final titleController = TextEditingController();
    final desController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 149, 80, 1))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: desController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Description",
                        contentPadding: EdgeInsets.symmetric(vertical: 50),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 149, 80, 1))),
                        focusColor: Colors.black,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      int res = await DbHelper.addNote(
                          title: titleController.text, des: desController.text);
                      if (res > 0) {
                        titleController.clear();
                        desController.clear();
                        print("res is: $res");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Note Add Sucssesfully!")));
                        setState(() {
                          getData();
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text("Add Note"),
                    color: Color.fromRGBO(225, 213, 201, 1),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        });
  }
}
