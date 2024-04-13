import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app1/home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen(
      {Key? key, required this.onPinEntered, required SharedPreferences prefs})
      : super(key: key);

  final void Function(String enteredPin) onPinEntered;

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late String _pin; // Variable to store entered PIN

  @override
  void initState() {
    super.initState();
    _pin = ''; // Initialize PIN as empty string
  }

  void _addNumber(String number) {
    setState(() {
      if (_pin.length < 4) {
        _pin += number; // Append the entered number to PIN
      }
    });
  }

  void _removeNumber() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(
            0, _pin.length - 1); // Remove the last digit from PIN
      }
    });
  }

  void _submitPin() {
    if (_pin.length == 4) {
      widget.onPinEntered(_pin); // Call the callback function with entered PIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()), // Navigate to home screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter PIN'), // App bar title
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue, // Background color blue
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon.png', // Image path
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  _pin.replaceAll(
                      RegExp(r'.'), '•'), // Replace digits with dots
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 64, height: 64),
                    _buildNumberButton('0'),
                    _buildBackButton(),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitPin, // Submit button onPressed handler
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // Button text color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: Text('Submit'), // Button text
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _addNumber(number), // Add number onTap handler
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300], // Button color
          shape: BoxShape.circle, // Circle shape
        ),
        width: 64,
        height: 64,
        child: Center(
          child: Text(
            number,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: _removeNumber, // Back button onTap handler
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red, // Button color
          shape: BoxShape.circle, // Circle shape
        ),
        width: 64,
        height: 64,
        child: Center(
          child: Icon(Icons.backspace, color: Colors.white),
        ),
      ),
    );
  }
}
