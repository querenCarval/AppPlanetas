import 'package:flutter/material.dart';

import 'Model/planeta.dart';

import 'controles/controle_planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planeta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Planeta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _lerPlanetas();
  }

  Future<void> _lerPlanetas() async {
    try {
      final resultado = await _controlePlaneta.lerPlanetas();
      setState(() {
        _planetas = resultado.cast<Planeta>();
      });
    } catch (e) {
      print("Erro ao ler planetas: $e");
    }
  }

  Future<void> _incluirPlaneta() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaPlaneta()),
    );
    _lerPlanetas();
  }

  Future<void> _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _lerPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.distancia.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              iconSize: 25.0,
              onPressed: () async {
                if (planeta.id != null) {
                  await _excluirPlaneta(planeta.id!);
                } else {
                  print("Planeta sem ID para exclusão.");
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incluirPlaneta,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaPlaneta extends StatefulWidget {
  const TelaPlaneta({super.key});

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Planeta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: _distanciaController, decoration: const InputDecoration(labelText: "Distância")),
            ElevatedButton(
              onPressed: () async {
                try {
                  final planeta = Planeta(
                    nome: _nomeController.text,
                    distancia: double.parse(_distanciaController.text),
                  );
                  await _controlePlaneta.incluirPlaneta(planeta);
                  Navigator.pop(context);
                } catch (e) {
                  print("Erro ao salvar planeta: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erro ao salvar planeta. Verifique os dados.")),
                  );
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
