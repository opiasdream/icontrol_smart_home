import 'package:flutter/material.dart';
import 'package:icontrol/common/enums/sensor_icons.dart';
import 'package:icontrol/common/extension/sensor_data_extension.dart';
import 'package:icontrol/common/extension/sensor_icons_extension.dart';
import 'package:icontrol/data/temp_sensor_data.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/ui/widgets/sensor_popup.dart';

import '../../models/publisher.dart';

class SensorListTile extends StatelessWidget {
  const SensorListTile({super.key, required this.publisher});

  final PublisherData publisher;

  @override
  Widget build(BuildContext context) {
    final sensor = sensorData[publisher.id];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      isThreeLine: true,
      minLeadingWidth: 30,
      leading: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            sensor?.iconPath ?? SensorIcons.sensor_4.path,
            height: 30,
            width: 30,
            colorBlendMode:
                publisher.status.isInactive ? BlendMode.srcIn : null,
            color: publisher.status.isInactive ? Colors.grey.shade800 : null,
          ),
        ),
      ),
      title: Text(sensor?.name ?? publisher.id),
      subtitle: Text('${publisher.topic}\n${publisher.data}'),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () => MQTTRepository.instance
                  .changeStatus(publisher.id, publisher.status.opposite),
              icon: Icon(
                Icons.power_settings_new,
                color: publisher.status.isActive ? Colors.red : null,
              )),
          PublisherPopup(publisherId: publisher.id),
        ],
      ),
    );
  }
}
