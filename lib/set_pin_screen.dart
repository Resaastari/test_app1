// set_pin_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPinScreen extends StatefulWidget {
  final void Function(String) onPinSet; // Tambahkan parameter onPinSet

  const SetPinScreen(
      {Key? key, required this.onPinSet, required SharedPreferences prefs})
      : super(key: key);

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set PIN'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _pinController,
                decoration: InputDecoration(labelText: 'Enter PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _savePin(_pinController.text);
                },
                child: Text('Set PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
    // Setelah menyimpan PIN, panggil fungsi onPinSet yang diberikan oleh widget induk
    widget.onPinSet(pin);
    // Navigasi kembali ke halaman sebelumnya
    Navigator.pop(context);
  }
}
