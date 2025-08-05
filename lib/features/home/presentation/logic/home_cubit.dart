import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspiro/core/network/local/cache_helper.dart';
import 'package:inspiro/core/network/remote/dio_helper.dart';
import 'package:inspiro/features/home/data/models/quote_model.dart';
import 'package:inspiro/features/home/presentation/logic/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  bool isDark = false;

  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(HomeChangeThemeAppState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark);
      emit(HomeChangeThemeAppState());
    }
  }

  QuoteModel? quote;

  void getQuote() async {
    emit(HomeLoadingState());
    final result = await DioHelper.getData(
      url: 'quotes',
    );

    result.fold(
      (failure) {
        debugPrint('HomeCubit.getQuote error: $failure');
        emit(HomeErrorState(failure));
      },
      (response) {
        quote = QuoteModel.fromJson(response.data[0]);
        emit(HomeSuccessState(quote!));
      },
    );
  }
}
