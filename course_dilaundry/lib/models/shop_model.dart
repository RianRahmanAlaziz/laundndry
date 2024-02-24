class ShopModel {
  ShopModel({
    required this.id,
    required this.image,
    required this.name,
    required this.location,
    required this.city,
    required this.delivery,
    required this.pickup,
    required this.categories,
    required this.whatsapp,
    required this.description,
    required this.price_cuci_komplit,
    this.price_dry_clean,
    this.price_cuci_satuan,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String image;
  String name;
  String location;
  String city;
  List<String> categories;
  bool delivery;
  bool pickup;
  String whatsapp;
  String description;
  double price_cuci_komplit;
  double? price_dry_clean;
  double? price_cuci_satuan;
  double rate;
  DateTime createdAt;
  DateTime updatedAt;

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        location: json["location"],
        city: json["city"],
        delivery: json["delivery"] == 1,
        pickup: json["pickup"] == 1,
        categories: json['categories'].cast<String>(),
        whatsapp: json["whatsapp"],
        description: json["description"],
        price_cuci_komplit: json["price_cuci_komplit"]?.toDouble(),
        price_dry_clean: json["price_dry_clean"]?.toDouble(),
        price_cuci_satuan: json["price_cuci_satuan"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "location": location,
        "city": city,
        "delivery": delivery ? 1 : 0,
        "pickup": pickup ? 1 : 0,
        "whatsapp": whatsapp,
        "description": description,
        "categories": categories,
        "price_cuci_komplit": price_cuci_komplit,
        "price_dry_clean": price_dry_clean,
        "price_cuci_satuan": price_cuci_satuan,
        "rate": rate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
