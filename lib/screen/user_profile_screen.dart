import 'package:cryptino/data/model/user.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key, this.user});
  List<User>? user;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<User>? userList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userList = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ارزهای دیجیتال'),
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: userList!.length,
          itemBuilder: (context, index) {
            return Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                color: Colors.amber,
                child: Center(
                    child: Text(
                  userList![index].name,
                  style: const TextStyle(fontSize: 18),
                )));
          },
        )));
  }
}
