import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/enums/room_icons.dart';
import 'package:icontrol/common/extension/room_icons_extension.dart';

class RoomIconPicker extends StatelessWidget {
  const RoomIconPicker({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog(
        context: context, builder: (context) => const RoomIconPicker());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: kDialogWidth,
        height: kDialogWidth * 1.5,
        child: ListView.builder(
          itemCount: RoomIcons.values.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Card(
              child: ListTile(
                onTap: () =>
                    Navigator.of(context).pop(RoomIcons.values[index].path),
                leading: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(RoomIcons.values[index].path),
                ),
                title: Text(RoomIcons.values[index].title),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
