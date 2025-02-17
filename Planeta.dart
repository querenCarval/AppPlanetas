
class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? apelido;

  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  void atualizarTamanho(double novoTamanho) {
    tamanho = novoTamanho;
  }

  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      apelido: map['apelido'],
    ); // Ponto e vírgula adicionado aqui
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }

  Planeta.vazio()
      : nome = '',
        tamanho = 0,
        distancia = 0;
}
