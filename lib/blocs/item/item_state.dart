part of 'item_bloc.dart';

@immutable
abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<ItemModel> item;

  ItemLoaded({required this.item});
}

class ItemError extends ItemState {
  final String message;

  ItemError({required this.message});
}
