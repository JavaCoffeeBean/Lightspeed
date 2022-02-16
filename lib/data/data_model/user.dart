import 'package:meta/meta.dart';

class User {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  var street;
  final String? city;
  final String? zipcode;

  User({
    @required this.id,
    @required this.name,
    @required this.phone,
    @required this.email,
    @required this.street,
    @required this.city,
    @required this.zipcode,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.id == id &&
        o.name == name &&
        o.phone == phone &&
        o.email == email &&
        o.street == street &&
        o.city == city &&
        o.zipcode == zipcode;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode ^ email.hashCode ^ street.hashCode ^ city.hashCode ^ zipcode.hashCode;
}