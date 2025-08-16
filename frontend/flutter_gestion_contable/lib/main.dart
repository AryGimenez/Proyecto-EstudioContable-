// lib/main.dart

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screensy/login/login_handler.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON decoding

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estudio Contable',
      theme: AppTheme.lightTheme,
      home: const MyHomePage(), // Changed home to MyHomePage for demonstration
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _backendResponse = 'Waiting for backend response...';

  Future<void> _fetchDataFromBackend() async {
    final Uri apiUrl = Uri.parse('http://localhost:8000/'); // Replace with your backend URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _backendResponse = 'Backend says: ${data['message']}'; // Adjust based on your backend response
        });
      } else {
        setState(() {
          _backendResponse = 'Error fetching data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _backendResponse = 'Could not connect to backend: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Frontend'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _backendResponse,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDataFromBackend,
              child: const Text('Fetch Data from Backend'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Login Screen:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: LoginHandler(), // Your original login screen
              ),
            ),
          ],
        ),
      ),
    );
  }
}