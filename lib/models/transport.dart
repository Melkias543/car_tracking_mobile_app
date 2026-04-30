import 'dart:convert';

class Transport {
  final String id;
  final String name;
  final String type;
  final String origin;
  final String status;
  final String arrivalTime;
  final String destination;

  Transport({
    required this.id,
    required this.name,
    required this.type,
    required this.origin,
    required this.status,
    required this.arrivalTime,
    required this.destination,
  });

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? 'bus',
        origin: json['origin'] ?? '',
        status: json['status'] ?? 'On Time',
        arrivalTime: json['arrivalTime'] ?? '--:--',
        destination: json['destination'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'origin': origin,
        'status': status,
        'arrivalTime': arrivalTime,
        'destination': destination,
      };

  String toJsonString() => jsonEncode(toJson());

  static Transport fromJsonString(String s) => Transport.fromJson(jsonDecode(s));
}
