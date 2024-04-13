import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const _tableName = 'notes';

  // Fungsi getter untuk mengakses database
  Future<Database> get database async {
    // Jika database sudah dibuka sebelumnya, kembalikan instance database yang ada
    if (_database != null) return _database!;

    // Jika belum, inisialisasi database baru dan kembalikan instance database yang baru
    _database = await initDatabase();
    return _database!;
  }

  // Fungsi untuk inisialisasi database
  Future<Database> initDatabase() async {
    // Buka database atau buat database baru jika belum ada
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'), // Lokasi database
      onCreate: (db, version) {
        // Buat tabel 'notes' jika belum ada
        return db.execute(
          "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, content TEXT)",
        );
      },
      version: 1, // Versi database
    );
  }

  // Fungsi untuk menyimpan catatan baru ke database
  Future<void> insertNote(Note note) async {
    final db = await database;
    // Insert data ke tabel 'notes'
    int id = await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Atur algoritma konflik
    );
    note.id = id; // Setel ID yang dihasilkan dari database ke catatan
  }

  // Fungsi untuk mengambil semua catatan dari database
  Future<List<Note>> getNotes() async {
    final db = await database;
    // Query semua data dari tabel 'notes'
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    // Membuat daftar catatan dari hasil query
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        timestamp: '',
      );
    });
  }

  // Fungsi untuk memperbarui catatan yang ada di database
  Future<void> updateNote(Note note) async {
    final db = await database;
    // Update data di tabel 'notes' sesuai dengan ID catatan
    await db.update(
      _tableName,
      note.toMap(),
      where: "id = ?", // Kriteria pembaruan
      whereArgs: [note.id], // Nilai kriteria pembaruan
    );
  }

  // Fungsi untuk menghapus catatan dari database berdasarkan ID
  Future<void> deleteNote(int id) async {
    final db = await database;
    // Hapus catatan dari tabel 'notes' berdasarkan ID
    await db.delete(
      _tableName,
      where: "id = ?", // Kriteria penghapusan
      whereArgs: [id], // Nilai kriteria penghapusan
    );
  }
}
