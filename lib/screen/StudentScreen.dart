import 'package:database/screen/data.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("Insert"),
            onPressed: () async {
              DBhelper db = DBhelper();
              var res = await db.insert("Krinal", "1234", "10", "Surat");
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$res")));
            },
          ),
        ),
      ),
    );
  }
}
