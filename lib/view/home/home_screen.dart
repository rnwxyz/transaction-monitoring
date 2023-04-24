import 'package:app_monitoring_transaction/blocs/auth/auth_bloc.dart';
import 'package:app_monitoring_transaction/blocs/gudang/gudang_bloc.dart';
import 'package:app_monitoring_transaction/blocs/item/item_bloc.dart';
import 'package:app_monitoring_transaction/blocs/mutasi/mutasi_bloc.dart';
import 'package:app_monitoring_transaction/model/gudang_model.dart';
import 'package:app_monitoring_transaction/model/item_model.dart';
import 'package:app_monitoring_transaction/model/mutasi_model.dart';
import 'package:app_monitoring_transaction/view/auth/login_screen.dart';
import 'package:app_monitoring_transaction/view/home/mutasi_detail_screen.dart';
import 'package:app_monitoring_transaction/view/home/resume_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final dateStartController = TextEditingController();
  final dateEndController = TextEditingController();
  final dateRangeController = TextEditingController();
  final itemController = TextEditingController();
  final gudangController = TextEditingController();
  final scrollController = ScrollController();
  FilterMutasiModel? filter;

  List<MutasiModel> mutasi = [];
  String search = '';

  DateTimeRange curentDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void dispose() {
    searchController.dispose();
    dateRangeController.dispose();
    dateStartController.dispose();
    dateEndController.dispose();
    itemController.dispose();
    gudangController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          context
              .read<MutasiBloc>()
              .add(MutasiGetEvent(loadMore: true, q: search, filter: filter));
        }
      },
    );
    context.read<GudangBloc>().add(GudangGetEvent());
    context.read<ItemBloc>().add(ItemGetEvent());
    context.read<MutasiBloc>().add(MutasiGetEvent(loadMore: false, q: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Monitoring Transaksi',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[200],
        width: 250,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Image(
                image: AssetImage("assets/bhawana.png"),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.inventory_sharp),
              title: Text(
                'Transaksi',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined_outlined),
              title: const Text('Resume', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ResumeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar', style: TextStyle(fontSize: 18)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Keluar'),
                      content: const Text('Apakah anda yakin ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<AuthBloc>().add(Logout());
                          },
                          child: BlocConsumer<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return const Text('Ya');
                              }
                            },
                            listener: (context, state) {
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                  ),
                                );
                              }
                              if (state is AuthInitial) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'cari',
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          onFieldSubmitted: (value) {
                            search = value;
                            context.read<MutasiBloc>().add(
                                  MutasiGetEvent(
                                    loadMore: false,
                                    q: search,
                                    filter: filter,
                                  ),
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Filter',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Tanggal Mutasi')),
                                        const SizedBox(height: 5),
                                        TextFormField(
                                          onTap: () async {
                                            final dateSelected =
                                                await showDateRangePicker(
                                              context: context,
                                              initialDateRange: curentDateRange,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2050),
                                            );
                                            curentDateRange =
                                                dateSelected ?? curentDateRange;
                                            dateRangeController.text =
                                                '${DateFormat('yyyy/MM/dd').format(curentDateRange.start)} - ${DateFormat('yyyy/MM/dd').format(curentDateRange.end)}';
                                            dateStartController.text =
                                                DateFormat('yyyy-MM-dd').format(
                                                    curentDateRange.start);
                                            dateEndController.text =
                                                DateFormat('yyyy-MM-dd').format(
                                                    curentDateRange.end);
                                          },
                                          readOnly: true,
                                          controller: dateRangeController,
                                          decoration: InputDecoration(
                                            hintText: 'tanggal',
                                            suffixIcon:
                                                const Icon(Icons.date_range),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Item Barang')),
                                        const SizedBox(height: 5),
                                        BlocConsumer<ItemBloc, ItemState>(
                                          builder: (context, state) {
                                            if (state is GudangLoading) {
                                              return const CircularProgressIndicator();
                                            } else if (state is ItemLoaded) {
                                              return DropdownSearch<ItemModel?>(
                                                  items: state.item,
                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      hintText: 'pilih item',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 16,
                                                              vertical: 8),
                                                    ),
                                                  ),
                                                  itemAsString: (item) =>
                                                      "${item!.kode} | ${item.nama}",
                                                  onChanged: (value) {
                                                    itemController.text =
                                                        value?.id.toString() ??
                                                            "";
                                                  },
                                                  popupProps:
                                                      const PopupProps.menu(
                                                          showSearchBox: true),
                                                  selectedItem: itemController
                                                              .text !=
                                                          ""
                                                      ? state.item.firstWhere(
                                                          (element) =>
                                                              element.id
                                                                  .toString() ==
                                                              itemController
                                                                  .text)
                                                      : null);
                                            } else if (state is ItemError) {
                                              return Text(state.message);
                                            } else {
                                              return const Text('error');
                                            }
                                          },
                                          listener: (context, state) {},
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Gudang Transaksi')),
                                        const SizedBox(height: 5),
                                        BlocConsumer<GudangBloc, GudangState>(
                                          builder: (context, state) {
                                            if (state is GudangLoading) {
                                              return const CircularProgressIndicator();
                                            } else if (state is GudangLoaded) {
                                              return DropdownSearch<
                                                  GudangModel?>(
                                                items: state.gudang,
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    hintText: 'pilih gudang',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 16,
                                                            vertical: 8),
                                                  ),
                                                ),
                                                itemAsString: (item) =>
                                                    item!.nama,
                                                onChanged: (value) {
                                                  gudangController.text =
                                                      value?.id.toString() ??
                                                          "";
                                                },
                                                popupProps:
                                                    const PopupProps.menu(
                                                        showSearchBox: true),
                                                selectedItem: gudangController
                                                            .text !=
                                                        ""
                                                    ? state.gudang.firstWhere(
                                                        (element) =>
                                                            element.id
                                                                .toString() ==
                                                            gudangController
                                                                .text)
                                                    : null,
                                              );
                                            } else {
                                              return const Text('error');
                                            }
                                          },
                                          listener: (context, state) {},
                                        ),
                                        const SizedBox(height: 30),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              )),
                                              onPressed: () {
                                                filter = FilterMutasiModel(
                                                    tanggalAwal:
                                                        dateStartController
                                                            .text,
                                                    tanggalSelesai:
                                                        dateEndController.text,
                                                    idGudang:
                                                        gudangController.text,
                                                    idItem:
                                                        itemController.text);
                                                if (filter!.tanggalAwal == '' &&
                                                    filter!.tanggalSelesai ==
                                                        '' &&
                                                    filter!.idGudang == '' &&
                                                    filter!.idItem == '') {
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                context.read<MutasiBloc>().add(
                                                      MutasiGetEvent(
                                                        loadMore: false,
                                                        q: searchController
                                                            .text,
                                                        filter: filter,
                                                      ),
                                                    );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Filter'),
                                            ),
                                            const SizedBox(width: 20),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  )),
                                              onPressed: () {
                                                dateRangeController.clear();
                                                itemController.clear();
                                                gudangController.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('reset'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_alt_off, size: 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<MutasiBloc, MutasiState>(
                    builder: (context, state) {
                      if (state is MutasiInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: state is MutasiLoading
                                ? mutasi.length + 1
                                : mutasi.length,
                            itemBuilder: (context, index) {
                              if (index == mutasi.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final noTr = mutasi[index].noTransaksi;
                                final id = mutasi[index].id;
                                final tglTr = mutasi[index].tanggal;
                                final qty = mutasi[index].jumlah;
                                final item = mutasi[index].item;
                                final gudang = mutasi[index].gudang;
                                final int idInt = int.parse(id);
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    minLeadingWidth: 1,
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MutasiDetailScreen(
                                              id: idInt,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(noTr,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          const SizedBox(height: 10),
                                          Text(item),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text("$tglTr   $gudang"),
                                    trailing: Text(
                                      qty > 0 ? '+$qty' : '$qty',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            qty > 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is MutasiError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                          ),
                        );
                      }
                      if (state is MutasiLoadeMore) {
                        mutasi = state.mutasi;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
