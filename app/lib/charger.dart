class Charger {
  final int id;
  final int networkId;

  const Charger({required this.id, required this.networkId});

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(id: json['id'], networkId: json['networkId']);
  }
}
