import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IMQTTService {
  IMQTTService._();

  static IMQTTService instance = IMQTTService._();

  static final _client = MqttServerClient.withPort('localhost', '', 1883);

  MqttServerClient get client => _client;

  static const topic = 'home/#';

  Future<void> init() async {
    client.setProtocolV311();
    client.keepAlivePeriod = 5;
    client.autoReconnect = true;

    await client.connect();

    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void sendMessage(String sensorID, String msg) {
    final reTopic = "re/$sensorID";

    final builder = MqttClientPayloadBuilder();

    builder.addString(msg);

    client.subscribe(reTopic, MqttQos.exactlyOnce);

    client.publishMessage(reTopic, MqttQos.exactlyOnce, builder.payload!);

    client.unsubscribe(reTopic);
  }
}
