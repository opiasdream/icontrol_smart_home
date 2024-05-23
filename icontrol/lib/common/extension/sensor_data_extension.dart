import 'package:icontrol/models/publisher.dart';

extension SensorDataExtension on SensorStatus {
  bool get isActive => this == SensorStatus.active;
  bool get isInactive => this == SensorStatus.inactive;

  SensorStatus get opposite =>
      isActive ? SensorStatus.inactive : SensorStatus.active;
}
