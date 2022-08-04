import 'dart:convert';

import 'package:database/screen/data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  List<Map<String, dynamic>> l2 = [];
  TextEditingController T_name = TextEditingController();
  TextEditingController T_no = TextEditingController();
  TextEditingController T_std = TextEditingController();
  TextEditingController T_address = TextEditingController();
  XFile? f1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    DBhelper dbHelper = DBhelper();
    List<Map<String, dynamic>> l1 = await dbHelper.readDB();
    setState(() {
      l2 = l1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    f1 = await picker.pickImage(source: ImageSource.gallery);
                  },
                  child: Text("Pick Image")),
              ElevatedButton(
                child: Text("Insert"),
                onPressed: () async {
                  String imgdata = base64Encode(
                    await f1!.readAsBytes(),
                  );
                  DBhelper db = DBhelper();
                  var res = await db.insert(
                      "Krinal", "1234", "10", "Surat", "$imgdata");
                  getData();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("$res")));
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: l2.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text("${l2[index]['id']}"),
                        title: Text("${l2[index]['name']}"),
                        subtitle: Text(
                            "${l2[index]['no']},${l2[index]['std']},${l2[index]['Address']}"),
                        trailing: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Container(
                                height:20,
                                  width: 20,
                                  child: Image.memory(
                                      base64Decode(l2[index]['img']))),
                              IconButton(
                                onPressed: () {
                                  T_name = TextEditingController(
                                      text: l2[index]['name']);
                                  T_no = TextEditingController(
                                      text: l2[index]['no']);
                                  T_std = TextEditingController(
                                      text: l2[index]['std']);
                                  T_address = TextEditingController(
                                      text: l2[index]['Address']);

                                  updateDielog(l2[index]['id']);

                                  getData();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DBhelper().deletDB(
                                    l2[index]['id'],
                                  );
                                  getData();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDielog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: T_name,
                    decoration: InputDecoration(
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: T_no,
                    decoration: InputDecoration(
                      hintText: "No",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: T_std,
                    decoration: InputDecoration(
                      hintText: "std",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: T_address,
                    decoration: InputDecoration(
                      hintText: "Address",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DBhelper().updateDB(id, T_name.text, T_no.text,
                          T_std.text, T_address.text);
                      getData();
                      Navigator.pop(context);
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
