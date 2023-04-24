class UnitProduksi {
  late int id;
  late String nama;

  UnitProduksi({required this.id, required this.nama});

  UnitProduksi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }
}
