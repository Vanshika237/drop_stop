import 'dart:math';

import 'package:drop_stop/hive_utility.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() async {
  await Hive.initFlutter();
  await hiveUtility.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drop Stop',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var prompts = [
    "Phir se phone gira diya?",
    'Paise ped pe nahi ugte buddy',
    "Umar badhti jaa rahi hai par harkaton mein koi sudhar nahi",
    "GET IT TOGETHER, WILL YA?",
    "This is abuse.",
    "Pahaad se hi fek do na?",
    "Screen zinda hai?",
    "Screen guard ka full paisa vasool",
    "Aur kitna maar khaau?"
  ];

  bool countFall = true;

  @override
  void initState() {
    accelerometerEvents.listen((event) {
      var acceleration =
          sqrt((pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)));
      if (acceleration < 2.0) {
        if (countFall) {
          hiveUtility.addCount();
          countFall = false;
          if (mounted) {
            setState(() {});
          }
        }
      } else {
        countFall = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = hiveUtility.getCount();
    var random = Random();
    int index = random.nextInt(9);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    count == 0
                        ? "How does it feel being God's favourite?"
                        : prompts[index],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text('$count',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 34)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                splashRadius: 16,
                tooltip: "Say Hi!",
                onPressed: () async {
                  var url = "https://vanshika237.github.io/";
                  try {
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw "Could not launch $url";
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
                icon: Icon(Icons.waving_hand_outlined,
                    color: Colors.white.withOpacity(0.5))),
          )
        ],
      ),
    );
  }
}
