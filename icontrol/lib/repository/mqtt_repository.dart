import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icontrol/models/publisher.dart';
import 'package:icontrol/repository/room_repository.dart';
import 'package:icontrol/services/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTTRepository extends ChangeNotifier {
  MQTTRepository._();

  static final MQTTRepository instance = MQTTRepository._();

  Map<String, PublisherData> publishers = {};

  static final _service = IMQTTService.instance;

  void init() {
    _service.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // topic
      final List<String> topic = c![0].topic.split('/');

      // topic: home/<room_id>/<sensor_id> or home/<sensor_id>

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

  void changeRoom(String roomID, String sensorID) {
    final topic =
        roomID.isNotEmpty ? "home/$roomID/$sensorID" : "home/$sensorID";
    _service.changeTopic(topic, sensorID);
  }

  void changeStatus(String sensorID, SensorStatus status) {
    _service.changeStatus(sensorID, status.name);
  }

  List<PublisherData> getUncategorizedPublishers() {
    return publishers.values
        .where((publisher) =>
            RoomRepository.instance.rooms
                .any((room) => room.id == publisher.room) !=
            true)
        .toList();
  }
}
