import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';
import '../widgets/note_widget.dart';
import './note_screen.dart';
import '../screens/users_screen.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});
  static const routeName = '/noteList';

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  void openNote(context) async {
    await Navigator.of(context).pushNamed('/noteScreen');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UsersScreen.routeName);
              },
              icon: const Icon(Icons.verified_user))
        ],
      ),
      body: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.getAllNotes(),
        builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => NoteWidget(
                    note: snapshot.data![index],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoteScreen(note: snapshot.data![index]),
                        ),
                      );
                      setState(() {});
                    },
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () async {
                                    await DatabaseHelper.deleteNote(
                                        snapshot.data![index]);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text('Yes'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    }),
                itemCount: snapshot.data!.length,
              );
            }
            return const Center(
              child: Text('No Notes Yes'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNote(context);
        },
        backgroundColor: Colors.blue.shade200,
        child: const Icon(Icons.add_circle_sharp),
      ),
    );
  }
}
