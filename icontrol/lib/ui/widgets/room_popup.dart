import 'package:flutter/material.dart';

import 'package:icontrol/models/room.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/repository/room_repository.dart';
import 'package:icontrol/ui/widgets/room_dialog.dart';

class RoomPopup extends StatelessWidget {
  const RoomPopup({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 1, child: Text("Düzenle")),
        PopupMenuItem(value: 2, child: Text("Sil")),
      ],
      onSelected: (value) {
        if (value == 1) {
          RoomDialog.show(context, room: room);
        } else if (value == 2) {
          RoomRepository.instance.remove(room.id);
          MQTTRepository.instance.publishers.values
              .where((e) => e.room == room.id)
              .forEach((e) => MQTTRepository.instance.changeRoom('', e.id));
          Navigator.pop(context);
        }
      },
    );
  }
}
