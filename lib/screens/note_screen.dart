import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;
  const NoteScreen({Key? key, this.note}) : super(key: key);

  static const routeName = '/noteScreen';

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleTextController = TextEditingController();
  final _noteTextController = TextEditingController();
  var _titleText = '';
  var _noteText = '';

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _noteTextController.dispose();
    super.dispose();
  }

  void _updateTextState() {
    _titleText = _titleTextController.text;
    _noteText = _noteTextController.text;
  }

  void _printTitle() {
    print("Title: $_titleText Note: $_noteText");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController.addListener(_updateTextState);
    _noteTextController.addListener(_updateTextState);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.note != null) {
      _titleTextController.text = widget.note!.title;
      _noteTextController.text = widget.note!.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add a note' : 'Edit Note'),
        backgroundColor: Colors.blue,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Enter a Note Here',
                style: TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextField(
                  controller: _titleTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Note Title',
                  ),
                ),
              ),
              TextField(
                controller: _noteTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Note'),
                ),
                maxLines: 5,
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(widget.note == null ? 'Save Note' : 'Update'),
                      onPressed: () async {
                        if (_titleText.isEmpty || _noteText.isEmpty) {
                          return;
                        }
                        final Note model = Note(
                            title: _titleText,
                            description: _noteText,
                            id: widget.note?.id,
                            user_id: 1);
                        if (widget.note == null) {
                          await DatabaseHelper.addNote(model);
                        } else {
                          await DatabaseHelper.updateNote(model);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
