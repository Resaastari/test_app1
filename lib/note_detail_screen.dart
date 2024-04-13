import 'package:flutter/material.dart';
import 'note_model.dart';
import 'database_helper.dart';
import 'edit_note_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final dbHelper = DatabaseHelper();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  File? _mediaFile;
  TextEditingController _additionalTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _additionalTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: widget.note),
                ),
              );

              // Jika perubahan disimpan, perbarui nilai objek Note di layar ini
              if (result == true) {
                setState(() {
                  _titleController.text = widget.note.title;
                  _contentController.text = widget.note.content;
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Latar belakang gambar
          Image.asset(
            'assets/icon2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Konten di atas gambar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _uploadMedia,
                  icon: Icon(Icons.camera),
                  label: Text('Tambah Media'),
                ),
                SizedBox(height: 20),
                if (_mediaFile != null)
                  Column(
                    children: [
                      Divider(),
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          _mediaFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                TextField(
                  controller: _additionalTextController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Tulis lebih banyak di sini...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Simpan Data'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadMedia() async {
    final picker = ImagePicker();
    final pickedMedia = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Tambah Media'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _mediaFile = File(pickedImage.path);
                    });
                  }
                },
                child: Text('Ambil Foto'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _mediaFile = File(pickedImage.path);
                    });
                  }
                },
                child: Text('Pilih dari Galeri'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    // Implementasi penyimpanan data di sini
    // Misalnya, menyimpan _additionalTextController.text ke database atau penyimpanan lokal
    // Anda dapat menggunakan dbHelper atau metode penyimpanan yang sesuai
  }
}
