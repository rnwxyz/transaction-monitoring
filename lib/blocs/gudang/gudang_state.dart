part of 'gudang_bloc.dart';

@immutable
abstract class GudangState {}

class GudangInitial extends GudangState {}

class GudangLoading extends GudangState {}

class GudangLoaded extends GudangState {
  final List<GudangModel> gudang;

  GudangLoaded({required this.gudang});
}

class GudangError extends GudangState {
  final String message;

  GudangError({required this.message});
}
