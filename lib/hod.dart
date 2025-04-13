import 'package:flutter/material.dart';

class hod extends StatefulWidget {
  const hod({super.key});

  @override
  State<hod> createState() => _hodState();
}

class _hodState extends State<hod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'HOD Page',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hodpage');
              },
              child: const Text('Go to HOD Page'),
            ),
          ],
        ),
      ),
    );
  }
}