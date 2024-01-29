import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';
import 'screens/note_screen.dart';
import 'screens/users_screen.dart';

void main() {
  runApp(const NoteApp());
}

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taker App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const NoteList(),
      routes: {
        NoteList.routeName: (ctx) => const NoteList(),
        NoteScreen.routeName: (ctx) => const NoteScreen(),
        UsersScreen.routeName: (ctx) => UsersScreen(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
