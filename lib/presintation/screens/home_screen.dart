import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:test_pr/data/note_model.dart';
import 'package:test_pr/logic/db.dart';
import 'edit_screen.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Notes> notes = [];
  bool isLoading = false;

  final List<Color> notesColors = [
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => isLoading = true);
    final data = await DBHelper.readNotes();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  Future<void> _deleteNote(Notes note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper.deleteNote(note);
      _loadNotes();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              children: const [
                Icon(Icons.delete_outline, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Note deleted successfully",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notes",
          style: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.orange, size: width * 0.07),
            onPressed: _loadNotes,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isLoading
              ? Center(
            child: Lottie.asset(
              "assets/animations/Loading3.json",
              width: width * 0.5,
              height: height * 0.25,
            ),
          )
              : notes.isEmpty
              ? Center(
            child: Text(
              'No notes yet',
              style: TextStyle(
                fontSize: width * 0.045,
                color: Colors.black54,
              ),
            ),
          )
              : MasonryGridView.count(
            crossAxisCount: width > 600 ? 3 : 2,
            mainAxisSpacing: width * 0.03,
            crossAxisSpacing: width * 0.03,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final color = notesColors[index % notesColors.length];

              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(note: note),
                    ),
                  );
                  if (result == 'updated' || result == 'deleted') {
                    _loadNotes();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.grey,
                                size: width * 0.06),
                            onPressed: () => _deleteNote(note),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.008),
                      Text(
                        note.description,
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: Colors.black87,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height * 0.008),
                      Text(
                        DateFormat('MMM d, yyyy')
                            .format(note.createdAt),
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteScreen()),
          );

          if (result != null) {
            final newNote = Notes(
              title: result["title"],
              description: result["description"],
              createdAt: DateTime.now(),
            );
            await DBHelper.createNote(newNote);
            _loadNotes();
          }
        },
        child: Icon(Icons.add, color: Colors.orange, size: width * 0.08),
      ),
    );
  }
}
