import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IMQTTService {
  IMQTTService._();

  static IMQTTService instance = IMQTTService._();

  static const _server = "localhost";

  static final _client = MqttServerClient.withPort(_server, '', 1883);

  MqttServerClient get client => _client;

  static const topic = 'home/#';

  Future<void> init() async {
    client.setProtocolV311();
    client.keepAlivePeriod = 5;
    client.disconnectOnNoResponsePeriod = 10;
    client.autoReconnect = true;
    client.onAutoReconnect = onAutoReconnect;
    client.onAutoReconnected = onAutoReconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic('willtopic')
        .withWillMessage('Will Message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception {
      client.disconnect();
      exit(-1);
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client Connected');
    } else {
      print('ERROR client connection failed: ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void getPublishers() {
    client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void changeStatus(String sensorID, String status) {
    final reTopic = "re/$sensorID";

    final builder = MqttClientPayloadBuilder();

    builder.addString('change status:$status');

    client.subscribe(reTopic, MqttQos.exactlyOnce);

    client.publishMessage(reTopic, MqttQos.exactlyOnce, builder.payload!);

    client.unsubscribe(reTopic);
  }

  void changeTopic(String topic, String sensorID) {
    final reTopic = "re/$sensorID";

    final builder = MqttClientPayloadBuilder();

    builder.addString('change topic:$topic');

    client.subscribe(reTopic, MqttQos.exactlyOnce);

    client.publishMessage(reTopic, MqttQos.exactlyOnce, builder.payload!);

    client.unsubscribe(reTopic);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  /// The pre auto re connect callback
  void onAutoReconnect() {
    print('onAutoReconnect client callbackt');
  }

  /// The post auto re connect callback
  void onAutoReconnected() {
    print(
        'onAutoReconnected client callback - Client auto reconnection sequence has completed');
  }

  /// The successful connect callback
  void onConnected() {
    print('Client connection was successful');
  }

  /// Pong callback
  void pong() {
    print(
        'Ping response client callback invoked - you may want to stop your ping responses here');
  }
}
