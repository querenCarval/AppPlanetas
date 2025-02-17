import 'package:flutter/material.dart';

import 'package:myapp/controles/controle_planeta.dart';

import '../Model/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final Function() onFinalizado;
  const TelaPlaneta({super.key, required this.onFinalizado});

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _nomecontroller = TextEditingController();
  final TextEditingController _tamanhocontroller = TextEditingController();
  final TextEditingController _distanciacontroller = TextEditingController();
  final TextEditingController _apelidocontroller = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = Planeta.vazio();
    _nomecontroller.text = 'Terra';
    super.initState();
  }

  @override
  void dispose() {
    _nomecontroller.dispose();
    _tamanhocontroller.dispose();
    _distanciacontroller.dispose();
    _apelidocontroller.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta.toMap());
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      // Correção: Atualiza o objeto _planeta com os valores dos controladores
      _planeta.nome = _nomecontroller.text;
      _planeta.tamanho = double.parse(_tamanhocontroller.text);
      _planeta.distancia = double.parse(_distanciacontroller.text);
      _planeta.apelido = _apelidocontroller.text;

      _inserirPlaneta();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados do planeta salvos com sucesso!\n'),
        ),
      );

      widget.onFinalizado();

      Navigator.of(context).pop();
      
      _nomecontroller.clear();
      _tamanhocontroller.clear();
      _distanciacontroller.clear();
      _apelidocontroller.clear();

      _planeta = Planeta.vazio();
      _formkey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomecontroller,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o nome do planeta';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Removido o onSaved, pois os valores são atualizados diretamente no _submitForm
                  },
                ),
                TextFormField(
                  controller: _tamanhocontroller,
                  decoration: const InputDecoration(labelText: 'Tamanho em Km'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o tamanho do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Removido o onSaved, pois os valores são atualizados diretamente no _submitForm
                  },
                ),
                TextFormField(
                  controller: _distanciacontroller,
                  decoration: const InputDecoration(labelText: 'Distância'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe a distância do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Removido o onSaved, pois os valores são atualizados diretamente no _submitForm
                  },
                ),
                TextFormField(
                  controller: _apelidocontroller,
                  decoration: const InputDecoration(labelText: 'Apelido'),
                  onSaved: (value) {
                    // Removido o onSaved, pois os valores são atualizados diretamente no _submitForm
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
