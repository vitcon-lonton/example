import 'package:equatable/equatable.dart';

class PeopleName extends Equatable {
  final String title;
  final String last;
  final String first;

  PeopleName({this.title, this.last, this.first});

  static PeopleName fromJson(dynamic json) {
    return PeopleName(
      title: json['title'],
      last: json['last'],
      first: json['first'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'last': last,
        'first': first,
      };

  @override
  List<Object> get props => [title, last, first];
}
