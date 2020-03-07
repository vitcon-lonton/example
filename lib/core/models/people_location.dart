import 'package:equatable/equatable.dart';

class PeopleLocation extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zip;

  const PeopleLocation({this.street, this.city, this.state, this.zip});

  static PeopleLocation fromJson(dynamic json) {
    return PeopleLocation(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  @override
  List<Object> get props => [street, city, state, zip];
}
