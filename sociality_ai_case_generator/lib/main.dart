import 'package:flutter/material.dart';
import 'pages/backend_playground.dart';

void main() => runApp(const BackendApp());

class BackendApp extends StatelessWidget {
  const BackendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backend Testing',
      home: const _TempHome(),
    );
  }
}

class _TempHome extends StatelessWidget {
  const _TempHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showBackendPlayground(context),
          child: const Text('Open Backend Playground'),
        ),
      ),
    );
  }
}