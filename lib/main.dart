import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/logo.dart';
import 'package:stopwatch/stopwatch.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: logo(),
      ),
    );
  }
}
