import 'package:database/screen/data.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  List<Map<String, dynamic>> l2 = [];

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
                child: Text("Insert"),
                onPressed: () async {
                  DBhelper db = DBhelper();
                  var res = await db.insert("Krinal", "1234", "10", "Surat");
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
                        subtitle:
                            Text("${l2[index]['no']},${l2[index]['std']}"),
                        trailing: Text("${l2[index]['Address']}"),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
