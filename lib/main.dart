import 'package:app_monitoring_transaction/blocs/auth/auth_bloc.dart';
import 'package:app_monitoring_transaction/blocs/gudang/gudang_bloc.dart';
import 'package:app_monitoring_transaction/blocs/item/item_bloc.dart';
import 'package:app_monitoring_transaction/blocs/mutasi/mutasi_bloc.dart';
import 'package:app_monitoring_transaction/blocs/mutasi_detail/mutasi_detail_bloc.dart';
import 'package:app_monitoring_transaction/blocs/resume/resume_bloc.dart';
import 'package:app_monitoring_transaction/view/auth/login_screen.dart';
import 'package:app_monitoring_transaction/view/home/mutasi_detail_screen.dart';
import 'package:app_monitoring_transaction/view/home/resume_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => MutasiBloc(),
        ),
        BlocProvider(
          create: (context) => GudangBloc(),
        ),
        BlocProvider(
          create: (context) => ItemBloc(),
        ),
        BlocProvider(
          create: (context) => MutasiDetailBloc(),
        ),
        BlocProvider(
          create: (context) => ResumeBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
