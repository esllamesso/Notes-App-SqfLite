import 'package:flutter/material.dart';
import 'package:test_pr/data/note_model.dart';
import 'package:test_pr/logic/db.dart';

class EditScreen extends StatefulWidget {
  final Notes note;
  const EditScreen({super.key, required this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
  }

  Future<void> _updateNote() async {
    if (_titleController.text.trim().isEmpty &&
        _descController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    final updatedNote = Notes(
      id: widget.note.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      createdAt: widget.note.createdAt,
    );

    await DBHelper.updateNotes(updatedNote);
    setState(() => _isSaving = false);

    if (!mounted) return;
    Navigator.pop(context, 'updated');

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
            Icon(Icons.tips_and_updates_outlined, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Note updated successfully",
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

  Future<void> _deleteNote() async {
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
      await DBHelper.deleteNote(widget.note);
      if (!mounted) return;
      Navigator.pop(context, 'deleted');

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
          "Edit Note",
          style: TextStyle(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.orange, size: width * 0.07),
            onPressed: _isSaving ? null : _updateNote,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.orange, size: width * 0.07),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: "Title",
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            SizedBox(height: height * 0.015),
            Expanded(
              child: TextField(
                controller: _descController,
                style: TextStyle(fontSize: width * 0.04),
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
