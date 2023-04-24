import 'package:app_monitoring_transaction/blocs/auth/auth_bloc.dart';
import 'package:app_monitoring_transaction/blocs/resume/resume_bloc.dart';
import 'package:app_monitoring_transaction/model/resume_model.dart';
import 'package:app_monitoring_transaction/view/auth/login_screen.dart';
import 'package:app_monitoring_transaction/view/home/home_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  int tahun = DateTime.now().year;
  @override
  void initState() {
    context.read<ResumeBloc>().add(ResumeGetEvent(tahun: tahun));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Resume Transaksi',
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
            ListTile(
              leading: const Icon(Icons.inventory_sharp),
              title: const Text(
                'Transaksi',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.insert_chart_outlined_outlined),
              title: Text('Resume', style: TextStyle(fontSize: 18)),
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
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Pilih Tahun',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownSearch<int>(
                  items: const [2025, 2024, 2023, 2022, 2021, 2020, 2019, 2018],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: 'pilih tahun',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                  onChanged: (value) {
                    tahun = value!;
                    context
                        .read<ResumeBloc>()
                        .add(ResumeGetEvent(tahun: tahun));
                  },
                  popupProps: const PopupProps.menu(),
                  selectedItem: tahun,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 500,
                  child: BlocConsumer<ResumeBloc, ResumeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is ResumeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ResumeLoaded) {
                        final data = state.data;
                        return SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          title:
                              ChartTitle(text: 'Data Transaksi Tahun $tahun'),
                          // Enable tooltip
                          legend: Legend(
                              isVisible: true, position: LegendPosition.bottom),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<ResumeModel, String>>[
                            ColumnSeries<ResumeModel, String>(
                              dataSource: data,
                              xValueMapper: (ResumeModel resume, _) =>
                                  resume.bulan,
                              yValueMapper: (ResumeModel resume, _) =>
                                  resume.totalTransaksi,
                              name: 'Transaksi',
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color.fromRGBO(0, 170, 255, 1),
                                  Color.fromRGBO(0, 170, 255, 0.5),
                                ],
                                stops: <double>[0.1, 0.7],
                              ),
                            ),

                            // start line from 0
                          ],
                        );
                      } else if (state is ResumeError) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
