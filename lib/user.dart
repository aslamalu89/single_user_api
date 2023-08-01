import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic> userData = {};

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users/2'));

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
      });
    } else {
      // Handle errors here
      print('Failed to load user data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Center(
        child: userData.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userData['data']['avatar']),
            ),
            SizedBox(height: 16),
            Text(
              '${userData['data']['first_name']} ${userData['data']['last_name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: ${userData['data']['email']}'),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
