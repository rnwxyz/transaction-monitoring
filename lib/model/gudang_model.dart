class GudangModel {
  late int id;
  late String nama;

  GudangModel({required this.id, required this.nama});

  GudangModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id_gudang']);
    nama = json['nama_gudang'];
  }
}
