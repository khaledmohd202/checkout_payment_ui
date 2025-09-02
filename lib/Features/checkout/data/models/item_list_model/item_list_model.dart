import 'details.dart';

class ItemListModel {
  String? total;
  String? currency;
  Details? details;

  ItemListModel({this.total, this.currency, this.details});

  factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
    total: json['total'] as String?,
    currency: json['currency'] as String?,
    details: json['details'] == null
        ? null
        : Details.fromJson(json['details'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'currency': currency,
    'details': details?.toJson(),
  };
}
