part of 'mutasi_bloc.dart';

abstract class MutasiEvent {}

class MutasiGetEvent extends MutasiEvent {
  final bool loadMore;
  final String q;
  final FilterMutasiModel? filter;

  MutasiGetEvent({
    required this.loadMore,
    required this.q,
    this.filter,
  });
}
