class Antrian {
  final int? id;
  final String namaPasien;
  final String tanggal;
  final int nomorAntrian;

  Antrian(
      {this.id,
      required this.namaPasien,
      required this.tanggal,
      required this.nomorAntrian});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaPasien': namaPasien,
      'tanggal': tanggal,
      'nomorAntrian': nomorAntrian,
    };
  }

  @override
  String toString() {
    return 'Antrian{id: $id, namaPasien: $namaPasien, tanggal: $tanggal, nomorAntrian: $nomorAntrian}';
  }
}
