import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'dart:math';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: NotesPage(),
));

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }
  _refreshData() async {
    final n = await DatabaseHelper.instance.readAllNotes();
    final c = await DatabaseHelper.instance.readAllCategories();
    setState(() {
      notes = n;
      categories = c;
    });
  }
  _addNote() async {
    if (categories.isNotEmpty) {
      final random = Random();
      final randomCategory = categories[random.nextInt(categories.length)];

      String noteTitle = "Нова замітка";
      String noteContent = "Текст замітки...";

      if (randomCategory.name == "Навчання") {
        noteTitle = "Пара з КПП";
        noteContent = "Олег Палка топ";
      }

      await DatabaseHelper.instance.createNote(Note(
        title: noteTitle,
        content: noteContent,
        categoryId: randomCategory.id!,
      ));

      _refreshData();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Мої Нотатки"),
        backgroundColor: Colors.deepPurple[50],
      ),
      body: notes.isEmpty
          ? Center(child: Text("Нотаток поки немає. Натисніть +"))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final cat = categories.firstWhere(
                (c) => c.id == notes[index].categoryId,
            orElse: () => Category(name: "Невідомо"),
          );

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(notes[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${cat.name} | ${notes[index].content}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  await DatabaseHelper.instance.deleteNote(notes[index].id!);
                  _refreshData();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}