class ItemModel {
  late int id;
  late String nama;
  late String kode;

  ItemModel({
    required this.id,
    required this.nama,
    required this.kode,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id_item_buaso']);
    nama = json['nama_item'];
    kode = json['kode_item'];
  }
}
