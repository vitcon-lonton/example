import 'package:example/core/models/models.dart';
import 'package:example/core/providers/network/network.dart';

class PeopleRepository {
  final PeopleProvider _peopleProvider = new PeopleProvider();

  Future<People> getRandomPeople() => _peopleProvider.getRandomPeople();

  Future<List<People>> getRandomPeoples({int amount = 1}) {
    List<Future<People>> request =
        List(amount).map((_) => getRandomPeople()).toList();

    return Future.wait(request);
  }
}
