part of 'app_bloc.dart';

class AppState {
  final List<People> peoples;
  final List<People> favorite;

  AppState({this.peoples, this.favorite});

  AppState copyWith({
    List<People> dataStock,
    List<People> peoples,
    List<People> favorite,
  }) =>
      new AppState(
        peoples: peoples ?? this.peoples,
        favorite: favorite ?? this.favorite,
      );
}
