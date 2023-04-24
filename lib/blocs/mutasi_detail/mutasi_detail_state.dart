part of 'mutasi_detail_bloc.dart';

@immutable
abstract class MutasiDetailState {}

class MutasiDetailInitial extends MutasiDetailState {}

class MutasiDetailLoading extends MutasiDetailState {}

class MutasiDetailLoaded extends MutasiDetailState {
  final MutasiModel data;

  MutasiDetailLoaded({required this.data});
}

class MutasiDetailError extends MutasiDetailState {
  final String message;

  MutasiDetailError({required this.message});
}
