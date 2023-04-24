import 'package:app_monitoring_transaction/model/api/item_api.dart';
import 'package:app_monitoring_transaction/model/item_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemApi itemApi = ItemApi();
  late SharedPreferences loginData;

  ItemBloc() : super(ItemInitial()) {
    on<ItemGetEvent>(
      (event, emit) async {
        try {
          loginData = await SharedPreferences.getInstance();
          final token = loginData.getString('token') ?? '';
          final List<ItemModel> item = await itemApi.getItem(
            token: token,
          );
          emit(ItemLoaded(item: item));
        } catch (e) {
          emit(
            ItemError(message: e.toString()),
          );
        }
      },
    );
  }
}
