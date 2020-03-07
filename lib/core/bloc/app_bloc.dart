import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example/core/models/models.dart';
import 'package:example/core/repositories/reposotories.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  PeopleRepository _repository = new PeopleRepository();
  List<People> dataStock = [];

  @override
  AppState get initialState => AppState(peoples: [], favorite: []);

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(stacktrace.toString());
  }

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is UpdateState) yield* _mapUpdateStateEvent(event);
    if (event is GetPeoples) _mapGetPeoplesEvent(event);
    if (event is TakePeoplesFromStock) _mapTakePeoplesFromStock(event);
    if (event is AddPeopleToStock) _mapAddPeopleToStock(event);
    if (event is RemoveFirstPeople) _mapRemoveFirstPeople(event);
    if (event is AddPeoplesToFavorite) _mapAddPeoplesToFavorite(event);
    if (event is SaveFavoriteToLocal) _mapSaveFavoriteToLocal(event);
  }

  Stream<AppState> _mapUpdateStateEvent(UpdateState event) async* {
    AppState newState = event.state;

    if (newState != state) yield newState;
  }

  void _mapGetPeoplesEvent(GetPeoples event) {
    _repository
        .getRandomPeoples(amount: event.amount)
        .then(event.onSuccess)
        .catchError(event.onError ?? (e) {});
  }

  /// Take peoples data from dataStock(remove) and insert to people list [AppState]
  void _mapTakePeoplesFromStock(TakePeoplesFromStock event) {
    // Get data from state
    AppState newState = state.copyWith();

    // Find and remove peoples from dataStock and insert to list people
    List<People> peoples = dataStock.getRange(0, event.amount - 1).toList();
    dataStock.removeRange(0, event.amount - 1);
    newState.peoples.addAll(peoples);

    // Create new state and notify update state
    UpdateState eventUpdateState = new UpdateState(state: newState);
    add(eventUpdateState);
  }

  /// Insert data to dataStock
  void _mapAddPeopleToStock(AddPeopleToStock event) {
    dataStock.addAll(event.peoples);
  }

  /// We will fetch 1 people from api to data stock, and
  /// remove first people in people list [AppState]
  void _mapRemoveFirstPeople(RemoveFirstPeople event) {
    AppState newState = state.copyWith();

    GetPeoples eventGetPeoples = GetPeoples(
      amount: 1,
      onSuccess: (peoples) {
        add(AddPeopleToStock(peoples: peoples));
      },
      onError: (e) {},
    );

    add(eventGetPeoples);

    if (dataStock.isNotEmpty) {
      People people = dataStock.removeAt(0);

      newState.peoples.add(people);
    }

    People people = newState.peoples.removeAt(0);

    UpdateState eventUpdateState = UpdateState(state: newState);

    add(AddPeoplesToFavorite(peoples: [people]));
    // Update new state
    add(eventUpdateState);
  }

  /// Add peoples to favorite list [AppState]
  void _mapAddPeoplesToFavorite(AddPeoplesToFavorite event) {
    AppState newState = state.copyWith();

    newState.favorite.addAll(event.peoples);

    // Update new state
    add(UpdateState(state: newState));
  }

  /// Add peoples to favorite list [AppState]
  void _mapSaveFavoriteToLocal(SaveFavoriteToLocal event) {
    AppState newState = state.copyWith();
  }
}
