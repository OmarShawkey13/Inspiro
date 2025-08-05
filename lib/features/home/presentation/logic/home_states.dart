import 'package:inspiro/features/home/data/models/quote_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeThemeAppState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeErrorState extends HomeStates {
  final String error;

  HomeErrorState(this.error);
}

class HomeSuccessState extends HomeStates {
  final QuoteModel quote;

  HomeSuccessState(this.quote);
}