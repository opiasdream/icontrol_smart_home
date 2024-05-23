import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/repository/room_repository.dart';

class RoomPicker extends StatelessWidget {
  const RoomPicker({super.key});

  static Future<String?> show(BuildContext context) async => await showDialog(
      context: context, builder: (context) => const RoomPicker());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: kDialogWidth,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: RoomRepository.instance.rooms.length,
          itemBuilder: (context, index) {
            final room = RoomRepository.instance.rooms[index];

            return ListTile(
              leading: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(room.iconPath),
              ),
              title: Text(room.name),
              subtitle: Text('home/${room.id}'),
              onTap: () => Navigator.of(context).pop(room.id),
            );
          },
        ),
      ),
    );
  }
}
