import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> downloadPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/4'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Post.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Ошибка загрузки Post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = downloadPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Информация из сервера',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Вывод информации'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(height: 30,),
                    Container(decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.green),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Text(snapshot.data!.title, style: TextStyle(fontSize: 10),)),
                    SizedBox(height: 40,),
                    Container(decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Text(snapshot.data!.body, style: TextStyle(fontSize: 10))),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}