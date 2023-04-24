part of 'mutasi_detail_bloc.dart';

@immutable
abstract class MutasiDetailEvent {}

class MutasiDetailGetEvent extends MutasiDetailEvent {
  final int id;

  MutasiDetailGetEvent({required this.id});
}
