import 'package:equatable/equatable.dart';
import 'package:example/core/models/people_location.dart';
import 'package:example/core/models/people_name.dart';

class People extends Equatable {
  final PeopleLocation location;
  final PeopleName name;
  final String username;
  final String password;
  final String picture;
  final String phone;
  final String cell;

  const People({
    this.location,
    this.name,
    this.username,
    this.password,
    this.picture,
    this.phone,
    this.cell,
  });

  String get fullName => '${name.title}.${name.first} ${name.last}';

  String get address =>
      '${location.state}, ${location.street}, ${location.city}';

  People.fromJson(dynamic json)
      : location = PeopleLocation.fromJson(json['location']),
        name = PeopleName.fromJson(json['name']),
        username = json['username'],
        password = json['password'],
        picture = json['picture'],
        phone = json['phone'],
        cell = json['cell'];

  Map<String, dynamic> toJson() => {
        'user': {
          'location': location,
          'name': name,
          'username': username,
          'password': password,
          'picture': picture,
          'phone': phone,
          'cell': cell,
        }
      };

  @override
  List<Object> get props => [
        location,
        name,
        username,
        password,
        picture,
        phone,
        cell,
      ];
}
