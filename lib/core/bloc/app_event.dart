part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class UpdateState extends AppEvent {
  final AppState state;

  UpdateState({this.state});

  @override
  List<Object> get props => [state];
}

class InitData extends AppEvent {
  final int numberItemsInStock, numberItemsDisplay;

  InitData({this.numberItemsInStock, this.numberItemsDisplay});

  @override
  List<Object> get props => [numberItemsInStock, numberItemsDisplay];
}

class GetPeoples extends AppEvent {
  final int quantity;
  final Function(List<People>) onSuccess;
  final Function onError;

  GetPeoples({this.quantity = 0, this.onSuccess, this.onError});

  @override
  List<Object> get props => [quantity, onSuccess, onError];
}

class TakePeoplesFromStock extends AppEvent {
  final int quantity;

  TakePeoplesFromStock({this.quantity = 0});

  @override
  List<Object> get props => [quantity];
}

class AddPeopleToStock extends AppEvent {
  final List<People> peoples;

  AddPeopleToStock({this.peoples = const []});

  @override
  List<Object> get props => [peoples];
}

class AddPeoplesToFavorite extends AppEvent {
  final List<People> peoples;

  AddPeoplesToFavorite({this.peoples = const []});

  @override
  List<Object> get props => [peoples];
}

class RemoveFirstPeople extends AppEvent {
  final bool insertToFavorite;

  RemoveFirstPeople({this.insertToFavorite = false});

  @override
  List<Object> get props => [insertToFavorite];
}

class SaveFavoriteToLocal extends AppEvent {
  SaveFavoriteToLocal();

  @override
  List<Object> get props => null;
}

class GetFavoriteFromLocal extends AppEvent {
  GetFavoriteFromLocal();

  @override
  List<Object> get props => null;
}

class AddMessages extends AppEvent {
  final List<String> messages;
  AddMessages({this.messages = const []});

  @override
  List<Object> get props => [messages];
}

class PopMessage extends AppEvent {
  PopMessage();

  @override
  List<Object> get props => null;
}
