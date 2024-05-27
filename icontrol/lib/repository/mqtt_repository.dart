import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icontrol/models/publisher.dart';
import 'package:icontrol/repository/room_repository.dart';
import 'package:icontrol/services/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTTRepository extends ChangeNotifier {
  MQTTRepository._();

  static final MQTTRepository instance = MQTTRepository._();

  static final _service = IMQTTService.instance;

  Map<String, PublisherData> publishers = {};

  void init() {
    _service.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final List<String> topic = c![0].topic.split('/');

      final recMess = c[0].payload as MqttPublishMessage;

      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final tempData = json.decode(pt) as Map<String, dynamic>;

      publishers[topic.last] = PublisherData(
        id: topic.last,
        room: topic.length > 1 ? topic[1] : '',
        topic: topic.join('/'),
        status: SensorStatus.values.byName(tempData['status']),
        data: tempData['data'],
      );
      notifyListeners();
    });
  }

  void changeRoom(String sensorID, String roomID) {
    final newTopic =
        roomID.isNotEmpty ? "home/$roomID/$sensorID" : "home/$sensorID";

    final message = "change topic:$newTopic";

    _service.sendMessage(sensorID, message);
  }

  void changeStatus(String sensorID, SensorStatus status) {
    final message = 'change status:${status.name}';

    _service.sendMessage(sensorID, message);
  }

  List<PublisherData> getUncategorizedPublishers() => publishers.values
      .where((publisher) =>
          RoomRepository.instance.rooms
              .any((room) => room.id == publisher.room) !=
          true)
      .toList();
}
