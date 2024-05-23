import 'dart:convert';

enum SensorStatus { active, inactive }

class PublisherData {
  String id;
  String room;
  String topic;
  SensorStatus status;
  String data;

  PublisherData({
    required this.id,
    required this.room,
    required this.topic,
    required this.status,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room': room,
      'status': status.toString().split('.').last,
      'data': data,
    };
  }

  static PublisherData fromMap(Map<String, dynamic> map) {
    return PublisherData(
      id: map['id'],
      room: map['room'],
      topic: map['topic'],
      status: SensorStatus.values
          .firstWhere((s) => s.toString() == 'SensorStatus.${map['status']}'),
      data: map['data'],
    );
  }

  // JSON string'inden nesne oluşturma
  static PublisherData fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PublisherData(name: $id, room: $room, topic: $topic, status: $status, data: $data)';
}
