import 'package:flutter/material.dart';

/// Raíz de LOOP. Pantallas de auth y flujos se irán colgando aquí.
class LoopApp extends StatelessWidget {
  const LoopApp({super.key});

  static const Color _seedBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedBlue),
        useMaterial3: true,
      ),
      home: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatelessWidget {
  const _HomeShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LOOP')),
      body: Center(
        child: Text(
          'Base del proyecto lista.\nSiguiente: flujo de inicio de sesión (ver docs/).',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
