import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Restapi extends StatefulWidget {
  const Restapi({super.key});

  @override
  State<Restapi> createState() => _RestapiState();
}
class _RestapiState extends State<Restapi> {
  List<dynamic> users = [];
  int page = 1;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2=$page'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newUsers = jsonData['data'];
        setState(() {
          users.addAll(newUsers);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load users');
    }
  }

  Future<void> _loadMoreUsers() async {
    page++;
    await fetchUsers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users List')),
      body: ListView.builder(
        itemCount: users.length + 1,
        itemBuilder: (context, index) {
          if (index < users.length) {
            final user = users[index];
            return ListTile(
              title: Text(user['first_name']),
              subtitle: Text(user['email']),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
              ),
            );
          } else {
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          }
        },

      ),
    );
  }
}
