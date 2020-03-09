import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example/core/models/models.dart';
import 'package:example/core/repositories/reposotories.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  PeopleRepository _peopleRepository = new PeopleRepository();
  FavoriteRepository _favoriteRepository = new FavoriteRepository();
  StreamController<String> _messageController = new StreamController();

  List<People> dataStock = [];

  Stream<String> get message => _messageController.stream;

  @override
  AppState get initialState => AppState(peoples: [], favorite: []);

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);

    _messageController.sink.add(error);
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is UpdateState) yield* _mapUpdateStateEvent(event);
    if (event is GetPeoples) _mapGetPeoplesEvent(event);
    if (event is InitData) _mapInitDataEvent(event);
    if (event is TakePeoplesFromStock) _mapTakePeoplesFromStockEvent(event);
    if (event is AddPeopleToStock) _mapAddPeopleToStockEvent(event);
    if (event is RemoveFirstPeople) _mapRemoveFirstPeopleEvent(event);
    if (event is AddPeoplesToFavorite) _mapAddPeoplesToFavoriteEvent(event);
    if (event is SaveFavoriteToLocal) _mapSaveFavoriteToLocalEvent(event);
    if (event is GetFavoriteFromLocal) _mapGetFavoriteFromLocalEvent(event);
  }

  Stream<AppState> _mapUpdateStateEvent(UpdateState event) async* {
    AppState newState = event.state;

    if (newState != state) yield newState;
  }

  void _mapGetPeoplesEvent(GetPeoples event) {
    _peopleRepository
        .getRandomPeoples(quantity: event.quantity)
        .then(event.onSuccess)
        .catchError(
      (e) {
        if (event.onError != null) {
          event.onError(e);
        } else {
          _addMessage("Get people from API failed");
        }
      },
    );
  }

  void _mapInitDataEvent(InitData event) {
    GetPeoples eventGetPeoples = GetPeoples(
      quantity: event.numberItemsInStock,
      onSuccess: (peoples) {
        add(AddPeopleToStock(peoples: peoples));
        add(TakePeoplesFromStock(quantity: event.numberItemsDisplay));
      },
    );

    add(GetFavoriteFromLocal());

    add(eventGetPeoples);
  }

  /// Take peoples data from dataStock(remove) and insert to people list [AppState]
  void _mapTakePeoplesFromStockEvent(TakePeoplesFromStock event) {
    // Get data from state
    AppState newState = state.copyWith();

    // Find and remove peoples from dataStock and insert to list people
    List<People> peoples = dataStock.getRange(0, event.quantity - 1).toList();
    dataStock.removeRange(0, event.quantity - 1);
    newState.peoples.addAll(peoples);

    // Create new state and notify update state
    UpdateState eventUpdateState = new UpdateState(state: newState);
    add(eventUpdateState);
  }

  /// Insert data to dataStock
  void _mapAddPeopleToStockEvent(AddPeopleToStock event) {
    dataStock.addAll(event.peoples);
  }

  /// We will fetch 1 people from api to data stock, and
  /// remove first people in people list [AppState]
  void _mapRemoveFirstPeopleEvent(RemoveFirstPeople event) {
    AppState newState = state.copyWith();

    GetPeoples eventGetPeoples = GetPeoples(
      quantity: 1,
      onSuccess: (peoples) {
        add(AddPeopleToStock(peoples: peoples));
      },
    );

    add(eventGetPeoples);

    if (dataStock.isNotEmpty) {
      People people = dataStock.removeAt(0);

      newState.peoples.add(people);
    }

    People people = newState.peoples.removeAt(0);

    UpdateState eventUpdateState = UpdateState(state: newState);

    // If option insert to favorite is true, then insert to favorite list
    if (event.insertToFavorite) add(AddPeoplesToFavorite(peoples: [people]));

    // Update new state
    add(eventUpdateState);
  }

  /// Add peoples to favorite list [AppState]
  void _mapAddPeoplesToFavoriteEvent(AddPeoplesToFavorite event) {
    AppState newState = state.copyWith();

    newState.favorite.addAll(event.peoples);

    add(SaveFavoriteToLocal());

    // Update new state
    add(UpdateState(state: newState));
  }

  /// Add peoples to favorite list [AppState]
  void _mapSaveFavoriteToLocalEvent(SaveFavoriteToLocal event) {
    AppState newState = state.copyWith();

    _favoriteRepository
        .updateFavoriteToSF(newState.favorite)
        .then((_) => _addMessage('Save favorite to local success'))
        .catchError((e) => _addMessage('Cant save favorite to local'));
  }

  /// Add peoples to favorite list [AppState]
  void _mapGetFavoriteFromLocalEvent(GetFavoriteFromLocal event) {
    _favoriteRepository.getFavoriteFromSF().then(
      (peoples) {
        add(AddPeoplesToFavorite(peoples: peoples));
        _addMessage('Get favorite from local success');
      },
    ).catchError(
      (e) => _addMessage('Cant get people from local'),
    );
  }

  void _addMessage(String message) {
    print(message);
    _messageController.sink.add(message);
  }

  @override
  Future<void> close() async {
    await _messageController.close();

    return super.close();
  }
}
