import 'dart:math';

import 'package:flutter/material.dart';
const Duration durationToReverse=Duration(seconds: 5);
const Duration durationToForward=Duration(seconds: 3);
const Duration durationToChangeWidget=Duration(milliseconds: 200);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Create a Tween that goes from 0.0 to 1.0
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    // Apply the tween to the controller
    _animation = tween.animate(_controller);

    // Add a delay of 2 seconds before starting the animation in reverse


    // Listen for animation status changes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes, reverse it
        Future.delayed(durationToReverse, () {
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(durationToForward, () {
          _controller.forward();
        });
        // When the animation is dismissed (reversed), start it again
      }
    });
    Future.delayed(durationToForward, () {
      _controller.forward();
    });
    // Start the animation
  }

  @override
  void dispose() {
    // Dispose of the animation controller when not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Test Animation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 500,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if(_animation.value>0.5)FadeTransition(
                            opacity:_animation,
                            child: Image.asset("assets/G_PIC_icons.png")),
                        Transform.rotate(
                          angle: (_animation.value -1) * (0.5) * -pi,
                          child:AnimatedCrossFade(
                                duration: durationToChangeWidget,
                                firstChild: Image.asset(
                                  "assets/Group 100 (2).png",
                                  fit: BoxFit.cover,
                                ),
                                secondChild: RotatedBox(
                                    quarterTurns: 3,
                                    child: Image.asset("assets/Group 100.png")),
                                crossFadeState: _animation.value > 0.5
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                              )
                            )
                        //
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

