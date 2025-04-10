part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddOrganizationEvent extends AdminEvent {
  final String name;
  final String email;
  final String countryCode;
  final String phone;
  final String address;
  final String orgId;
  final String ownerName;
  final String ownerCountryCode;
  final String ownerPhone;
  final String ownerAddress;
  final String ownerEmail;

  AddOrganizationEvent({
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.address,
    required this.orgId,
    required this.ownerName,
    required this.ownerCountryCode,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.ownerEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "countryCode": countryCode,
      "phone": phone,
      "address": address,
      "org_id": orgId,
      "owner": {
        "name": ownerName,
        "countryCode": ownerCountryCode,
        "phone_no": ownerPhone,
        "address": ownerAddress,
        "email": ownerEmail,
      }
    };
  }

  @override
  List<Object?> get props => [name, email, countryCode, phone, address, orgId, ownerName, ownerCountryCode, ownerPhone, ownerAddress, ownerEmail];
}
