import 'package:flutter/material.dart';
import 'menu_data.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'My Bakery',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(title: 'My Bakery'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text(title),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) => MenuItem(
                      name: menuItems[index]["name"] ?? "",
                      description: menuItems[index]["description"] ?? "",
                      imageUrl: menuItems[index]["imageUrl"] ?? "",
                      price: menuItems[index]["price"] ?? ""))),
          MyDogButton()
        ]));
  }
}

class MyDogButton extends StatefulWidget {
  @override
  State<MyDogButton> createState() => DynamicDogButton();
}

class DynamicDogButton extends State<MyDogButton> {
  bool isPressed = false;
  String randDogImageUrl = "";
  String buttonText = "Click for a random dog!";
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          ElevatedButton(
            style: style,
            onPressed: () {
              fetchMeADog(http.Client());
            },
            child: Text(buttonText),
          ),
          const SizedBox(height: 20),
          if (isPressed) Image.network(randDogImageUrl),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void fetchMeADog(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    // Use the compute function to run parsePhotos in a separate isolate.

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      setState(() {
        isPressed = true;
        final parsed = jsonDecode(response.body);
        randDogImageUrl = parsed['message'].toString();
        buttonText = "Here is your random dog!";
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  const MenuItem(
      {Key? key,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(imageUrl),
          Text(name),
          Text(description),
          Text(price),
          SizedBox(height: 50),
        ]);
  }
}

// Future<RandomDogPhoto> fetchRandomDog(http.Client client) async {
//   final response =
//       await client.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

//   // Use the compute function to run parsePhotos in a separate isolate.

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.

//     print(response.body);

//     final parsed = jsonDecode(response.body);
//     return RandomDogPhoto.fromJson(parsed);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// class RandomDogPhoto {
//   final String imageUrl;

//   const RandomDogPhoto({
//     required this.imageUrl,
//   });

//   factory RandomDogPhoto.fromJson(Map<String, dynamic> json) {
//     return RandomDogPhoto(imageUrl: json['message'] as String);
//   }
// }
