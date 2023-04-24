part of 'mutasi_bloc.dart';

abstract class MutasiState {}

class MutasiInitial extends MutasiState {}

class MutasiLoading extends MutasiState {}

class MutasiLoadeMore extends MutasiState {
  final List<MutasiModel> mutasi;

  MutasiLoadeMore({required this.mutasi});
}

class MutasiError extends MutasiState {
  final String message;

  MutasiError({required this.message});
}
