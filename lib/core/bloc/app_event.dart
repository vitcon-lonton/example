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

class GetPeoples extends AppEvent {
  final int amount;
  final Function(List<People>) onSuccess;
  final Function onError;

  GetPeoples({this.amount, this.onSuccess, this.onError});

  @override
  List<Object> get props => [amount, onSuccess, onError];
}

class TakePeoplesFromStock extends AppEvent {
  final int amount;

  TakePeoplesFromStock({this.amount});

  @override
  List<Object> get props => [amount];
}

class AddPeopleToStock extends AppEvent {
  final List<People> peoples;

  AddPeopleToStock({this.peoples});

  @override
  List<Object> get props => [peoples];
}

class AddPeoplesToFavorite extends AppEvent {
  final List<People> peoples;

  AddPeoplesToFavorite({this.peoples});

  @override
  List<Object> get props => [peoples];
}

class RemoveFirstPeople extends AppEvent {
  RemoveFirstPeople();

  @override
  List<Object> get props => null;
}

class SaveFavoriteToLocal extends AppEvent {
  SaveFavoriteToLocal();

  @override
  List<Object> get props => null;
}
