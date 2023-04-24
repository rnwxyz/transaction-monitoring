import 'dart:ffi';

import 'package:app_monitoring_transaction/blocs/mutasi_detail/mutasi_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MutasiDetailScreen extends StatefulWidget {
  final int id;
  const MutasiDetailScreen({super.key, required this.id});

  @override
  State<MutasiDetailScreen> createState() => _MutasiDetailScreenState();
}

class _MutasiDetailScreenState extends State<MutasiDetailScreen> {
  @override
  void initState() {
    context.read<MutasiDetailBloc>().add(MutasiDetailGetEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Detail Transaksi',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.lightBlue,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: BlocConsumer<MutasiDetailBloc, MutasiDetailState>(
                  builder: (context, state) {
                    if (state is MutasiDetailLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MutasiDetailLoaded) {
                      DateTime tanggal =
                          DateFormat('yyyy-MM-dd').parse(state.data.tanggal);
                      final Color qtyColor;
                      final String qty;
                      final int qtyPositif;
                      if (state.data.jumlah > 0) {
                        qty = '+${state.data.jumlah}';
                        qtyColor = Colors.green;
                        qtyPositif = state.data.jumlah;
                      } else {
                        qty = '${state.data.jumlah}';
                        qtyColor = Colors.red;
                        qtyPositif = state.data.jumlah * -1;
                      }
                      final double harga = double.parse(state.data.harga);
                      final String hargaFormat;
                      hargaFormat =
                          NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                              .format(harga);
                      return Column(
                        children: [
                          const SizedBox(height: 20, width: double.infinity),
                          Text(
                            state.data.namaTransaksi,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          ListTile(
                            title: const Text(
                              'No Transaksi',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              state.data.noTransaksi,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Tanggal Transaksi',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              DateFormat('EEEE, d MMMM yyyy', "id_ID")
                                  .format(tanggal),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Nama Barang',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              state.data.item,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Unit Produksi',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              state.data.namaUnitProduksi,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Gudang',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              state.data.gudang,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Qty Barang',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              "$qty ${state.data.satuan}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: qtyColor),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Harga Satuan',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              hargaFormat,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                const Text(
                                  'Akumulasi Nilai Barang',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: qtyColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    NumberFormat.currency(
                                            locale: 'id', symbol: 'Rp. ')
                                        .format(qtyPositif * harga),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else if (state is MutasiDetailError) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else {
                      return const Center(
                        child: Text('Error'),
                      );
                    }
                  },
                  listener: (context, state) {},
                )),
          ),
        ),
      ),
    );
  }
}
