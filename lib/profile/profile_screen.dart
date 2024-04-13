import 'dart:io'; // Import untuk operasi file
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_app1/database_helper.dart';
import 'package:test_app1/note_model.dart';

class ProfileScreen extends StatefulWidget {
  final File? initialImageFile;
  final VoidCallback? onMessageReceived; // Parameter untuk panggilan kembali

  const ProfileScreen({Key? key, this.initialImageFile, this.onMessageReceived})
      : super(key: key);

  final String backgroundImage = 'assets/icon2.png';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile; // Variabel untuk menyimpan file gambar profil
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  late final dbHelper = DatabaseHelper(); // Instance helper database

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImageFile;
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _fetchNotesAndEvents(); // Ambil catatan dan acara dari database
    if (widget.onMessageReceived != null) {
      widget.onMessageReceived!();
    }
  }

  void _fetchNotesAndEvents() async {
    List<Note> notes =
        await dbHelper.getNotes(); // Dapatkan catatan dari database
    _buildEventsFromNotes(notes); // Bangun acara dari catatan
  }

  void _buildEventsFromNotes(List<Note> notes) {
    Map<DateTime, List<dynamic>> events = {};
    for (var note in notes) {
      DateTime? date =
          note.timestamp != null ? DateTime.parse(note.timestamp!) : null;
      if (date != null) {
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!
            .add(note.title); // Tambahkan judul catatan ke tanggal yang sesuai
      }
    }
    setState(() {
      _events = events; // Perbarui peta acara
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _saveProfile(); // Simpan profil ketika pengeditan selesai
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Tambah Foto'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _selectImage(ImageSource
                                  .camera); // Pilih gambar dari kamera
                            },
                            child: Text('Gunakan Kamera'),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _selectImage(ImageSource
                                  .gallery); // Pilih gambar dari galeri
                            },
                            child: Text('Pilih dari Galeri'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[100],
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imageFile != null
                      ? null
                      : Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[500],
                        ),
                ),
              ),
              SizedBox(height: 20),
              _isEditing ? _buildInputFields() : _buildProfileData(),
              SizedBox(height: 20),
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Masukkan nama Anda',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Email',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Masukkan email Anda',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfileData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil Anda',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 19),
        Text(
          ' ${_nameController.text}',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          ' ${_emailController.text}',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2024, 12, 31),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: _getEventsForDay,
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      _saveImage(_imageFile!); // Simpan gambar yang dipilih
    }
  }

  void _removeImage() {
    if (_imageFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus gambar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _imageFile = null;
                });
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tidak'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_picture.jpg';
    final newFile =
        await imageFile.copy(imagePath); // Salin gambar ke direktori aplikasi
    setState(() {
      _imageFile = newFile;
    });
  }

  void _saveProfile() {
    // Simpan data profil
    // Contoh: _nameController.text dan _emailController.text
  }
}
