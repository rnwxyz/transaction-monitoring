class MutasiModel {
  late String id;
  late String tanggal;
  late int jumlah;
  late String harga;
  late String noTransaksi;
  late String namaTransaksi;
  late String item;
  late String satuan;
  late String gudang;
  late String namaUnitProduksi;

  MutasiModel(
      {required this.id,
      required this.tanggal,
      required this.jumlah,
      required this.harga,
      required this.noTransaksi,
      required this.namaTransaksi,
      required this.item,
      required this.satuan,
      required this.gudang,
      required this.namaUnitProduksi});

  MutasiModel.fromJson(Map<String, dynamic> json) {
    id = json['id_mutasi_barang'];
    tanggal = json['tanggal_mutasi'];
    jumlah = int.parse(json['jumlah']);
    harga = json['harga'];
    noTransaksi = json['no_ref_transaksi'];
    namaTransaksi = json['nama_transaksi'];
    item = json['nama_item'];
    satuan = json['nama_satuan'];
    gudang = json['nama_gudang'];
    namaUnitProduksi = json['nama_unit_produksi'];
  }
}

class FilterMutasiModel {
  late String tanggalAwal;
  late String tanggalSelesai;
  late String idGudang;
  late String idItem;

  FilterMutasiModel(
      {required this.tanggalAwal,
      required this.tanggalSelesai,
      required this.idGudang,
      required this.idItem});

  Map<String, dynamic> toJson() {
    return {
      "tanggal_mutasi_mulai": tanggalAwal,
      "tanggal_mutasi_selesai": tanggalSelesai,
      "id_gudang": idGudang,
      "id_item": idItem,
    };
  }
}
