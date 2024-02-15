import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import 'package:time_countdown/timer_countdown/data/local_db/children_db/children_db.dart';

DateTime now = DateTime.now();

class ChildModel extends Equatable {
  final String name;
  final DateTime childBirthday;
  final bool gender;
  final int childId;

  const ChildModel(this.childId,
      {required this.name, required this.childBirthday, required this.gender});

  ChildModel.withDefaults()
      : childId = 0,
        name = '',
        childBirthday = DateTime.now(),
        gender = true;

  ChildModel.fromLocal(ChildrenData data)
      : name = data.name,
        childBirthday = data.babyBirthday,
        gender = data.gender,
        childId = data.id;

  ChildrenCompanion childModeloChildrenCompanion() {
    final nameChildrenCompanion = Value<String>(name);
    final birthDay = Value<DateTime>(childBirthday);
    final babyGender = Value<bool>(gender);

    return ChildrenCompanion(
        name: nameChildrenCompanion,
        babyBirthday: birthDay,
        gender: babyGender);
  }

  @override
  List<Object?> get props => [name, childBirthday, gender];

  @override
  String toString() {
    return 'name:$name,childDateTime:$childBirthday,gender:${getGender(isMale: gender)},babyID :$childId';
  }
}

String getGender({required bool isMale}) {
  return isMale ? 'мальчик' : 'девушка';
}
