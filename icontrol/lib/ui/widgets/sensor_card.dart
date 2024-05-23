import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/enums/sensor_icons.dart';
import 'package:icontrol/common/extension/sensor_data_extension.dart';
import 'package:icontrol/common/extension/sensor_icons_extension.dart';
import 'package:icontrol/data/temp_sensor_data.dart';
import 'package:icontrol/models/publisher.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/ui/widgets/sensor_popup.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.publisher});

  final PublisherData publisher;

  @override
  Widget build(BuildContext context) {
    final sensor = sensorData[publisher.id];

    return Card(
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: kSmallPadding),
            title: Text(sensor != null ? sensor.name : publisher.id),
            subtitle: Text(publisher.topic),
            trailing: PublisherPopup(publisherId: publisher.id),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Image.asset(
                sensor?.iconPath ?? SensorIcons.sensor_4.path,
                colorBlendMode:
                    publisher.status.isInactive ? BlendMode.srcIn : null,
                color:
                    publisher.status.isInactive ? Colors.grey.shade800 : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconButton(onPressed: null, icon: Icon(null)),
              Text(publisher.data),
              IconButton(
                onPressed: () => MQTTRepository.instance
                    .changeStatus(publisher.id, publisher.status.opposite),
                icon: Icon(
                  Icons.power_settings_new,
                  color: publisher.status.isActive ? Colors.red : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSmallPadding)
        ],
      ),
    );
  }
}
