import '../../domains/entities/shiping_address_entity.dart';

class ShippingAddressModel {
  String? address;
  String? floor;
  String? city;
  String? phone;
  String? name;
  String? email;

  ShippingAddressModel({
    this.address,
    this.floor,
    this.city,
    this.phone,
    this.name,
    this.email,
  });

  factory ShippingAddressModel.fromEntity(ShipingAddressEntity entity) {
    return ShippingAddressModel(
      address: entity.address,
      floor: entity.floor,
      city: entity.city,
      phone: entity.phone,
      name: entity.name,
      email: entity.email,
    );
  }
  Map<String, String?> toJson() {
    return {
      'address': address,
      'floor': floor,
      'city': city,
      'phone': phone,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return '$address $floor $city';
  }
}
