import 'dart:math';

import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:cookbook/physic_simulation/physic_simulation.dart';
import 'package:cookbook/tinder_card/tinder_cards.dart';
import 'package:cookbook/wave/wave_home.dart';
import 'package:cookbook/zoom_drawer/zoom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'animation_page_route/animation_page_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //must include it for excel example
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventsCalendarCubit(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          buildButtonNavigator(
              context, 'Animation page route', const AnimationPageHome()),
          buildButtonNavigator(context, 'Tinder cards', const TinderCards()),
          buildButtonNavigator(
              context, 'Physic simulation', const PhysicSimulation()),
          buildButtonNavigator(
              context, 'Zoom drawer', const ZoomDrawer(maxSlideScale: 0.8)),
          buildButtonNavigator(context, 'Wave animation', const WaveHome()),
        ],
      ),
    );
  }
}

Widget buildButtonNavigator(BuildContext context, String title, Widget page) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ElevatedButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            )),
        child: Text(title)),
  );
}

Color randomColor() {
  var rand = Random();
  return Color.fromARGB(
      255, 50 + rand.nextInt(200), rand.nextInt(256), 100 + rand.nextInt(150));
}
