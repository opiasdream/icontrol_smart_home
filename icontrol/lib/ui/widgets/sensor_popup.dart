import 'package:flutter/material.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/ui/widgets/room_picker.dart';
import 'package:icontrol/ui/widgets/sensor_card_edit_dialog.dart';

class PublisherPopup extends StatelessWidget {
  const PublisherPopup({super.key, required this.publisherId});

  final String publisherId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      splashRadius: 24,
      padding: EdgeInsets.zero,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 1,
          child: Text("Düzenle"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Oda Değiştir"),
        ),
      ],
      onSelected: (value) async {
        if (value == 1) {
          SensorCardEditDialog.show(context, publisherId);
        } else if (value == 2) {
          final roomId = await RoomPicker.show(context);
          if (roomId != null) {
            MQTTRepository.instance.changeRoom(publisherId, roomId);
          }
        }
      },
    );
  }
}
