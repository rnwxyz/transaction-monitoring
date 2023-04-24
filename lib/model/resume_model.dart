class ResumeModel {
  late String bulan;
  late String tahun;
  late int totalTransaksi;

  ResumeModel({
    required this.bulan,
    required this.tahun,
    required this.totalTransaksi,
  });

  ResumeModel.fromJson(Map<String, dynamic> json) {
    bulan = toMonth(json['bulan']);
    tahun = json['tahun'];
    totalTransaksi = int.parse(json['total_transaksi']);
  }

  String toMonth(raw) {
    switch (raw) {
      case "01":
        return "Jan";
      case "02":
        return "Feb";
      case "03":
        return "Mar";
      case "04":
        return "Apr";
      case "05":
        return "Mei";
      case "06":
        return "Jun";
      case "07":
        return "Jul";
      case "08":
        return "Agu";
      case "09":
        return "Sep";
      case "10":
        return "Okt";
      case "11":
        return "Nov";
      case "12":
        return "Des";
      default:
        return "Jan";
    }
  }
}
