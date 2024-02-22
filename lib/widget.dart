import 'package:flutter/material.dart';
import 'package:note_app/db_helper.dart';

bool? isYes;

class CustomButton extends StatefulWidget {
  final String title;
  final String des;
  final id;
  final getData;

  CustomButton(
      {required this.title, required this.des, this.id, required this.getData});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 8),
      ]),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18))),
            backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(32, 36, 37, 1))),
        onPressed: () => showDes(context, widget.id),
        child: Text(
          widget.title,
          style: TextStyle(
              fontSize: 25, color: Color.fromRGBO(215, 209, 209, 1.0)),
        ),
      ),
    );
  }

  showDes(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Color.fromRGBO(225, 213, 201, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(widget.title, style: TextStyle(fontSize: 25)),
                      SizedBox(
                          width:double.infinity,
                          child: Divider(
                              color: Colors.black,
                            thickness:1,
                              )),
                      Text(
                        widget.des,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      print("delete ckiked");
                      Navigator.pop(context);
                      deleteOnpress();
                    },
                    icon: Icon(
                        color: Color.fromRGBO(192, 149, 80, 1), Icons.delete),
                  ),
                  IconButton(
                      color: Color.fromRGBO(192, 149, 80, 1),
                      onPressed: () {
                        editeButton();
                      },
                      icon: Icon(Icons.edit)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  editeButton() {
    return showDialog(
      context: context,
      builder: (_) {
        final titleController = TextEditingController();
        final desController = TextEditingController();
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Title",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 149, 80, 1)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                ),
                MaterialButton(
                  onPressed: () async {
                    await DbHelper.editNote(
                      id: widget.id,
                      title: titleController.text,
                      des: desController.text,
                    );
                    Navigator.of(context).popUntil(
                        ModalRoute.withName('/')); // بستن همه دیالوگ‌ها
                  },
                  child: Text("Add Note"),
                  color: Color.fromRGBO(225, 213, 201, 1),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  deleteOnpress() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          icon: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent,
                    offset: Offset(2, 2),
                    blurRadius: 20,
                  )
                ]),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          title: Text("Delete Note"),
          content: Text(
              "Your are going to delete (${widget.title}) note.Are you sure?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No,Keep It"),
              color: Color.fromRGBO(225, 213, 201, 1),
            ),
            MaterialButton(
              onPressed: () async {
                await DbHelper.deleteNote(widget.id);
                Navigator.pop(context);
                widget.getData();
              },
              child: Text("Yes,Delete", style: TextStyle(color: Colors.white)),
              color: Colors.red[800],
            ),
          ],
        );
      },
    );
  }
}

