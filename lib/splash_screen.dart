import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pin_screen.dart'; // Import file PinScreen.dart
import 'set_pin_screen.dart'; // Import file SetPinScreen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() async {
    // Menunda navigasi selama 5 detik
    await Future.delayed(Duration(seconds: 5));

    _checkPinStatus();
  }

  void _checkPinStatus() async {
    bool isPinSet =
        await _isPinSet(); // Metode untuk memeriksa apakah PIN telah ditetapkan

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isPinSet) {
      // Jika PIN telah ditetapkan, navigasikan ke halaman "Masukkan PIN"
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PinScreen(
          onPinEntered: _onPinEntered, // Menambahkan argument onPinEntered
          prefs: prefs, // Menambahkan parameter prefs
        ),
      ));
    } else {
      // Jika PIN belum ditetapkan, navigasikan ke halaman "Set PIN"
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SetPinScreen(
          onPinSet: _onPinSet, // Menambahkan argument onPinSet
          prefs: prefs, // Menambahkan parameter prefs
        ),
      ));
    }
  }

  Future<bool> _isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin') != null;
  }

  void _onPinEntered(String enteredPin) {
    // Tindakan yang akan diambil setelah pengguna memasukkan PIN
    // Contoh: memeriksa kecocokan PIN dan melakukan navigasi ke halaman berikutnya
  }

  void _onPinSet(String pin) {
    // Tindakan yang akan diambil setelah pengguna menetapkan PIN
    // Contoh: menyimpan PIN ke SharedPreferences atau melakukan navigasi ke halaman berikutnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon.png', // Ganti dengan path dari asset gambar
              width: 175,
              height: 175,
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang DI Notepad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
