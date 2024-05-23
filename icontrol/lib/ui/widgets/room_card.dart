import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/models/room.dart';
import 'package:icontrol/ui/screens/room_scren.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => RoomScreen(room: room))),
      child: Card(
        elevation: .9,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(room.iconPath),
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: kDefaultPadding),
              title: Text(room.name),
            ),
          ],
        ),
      ),
    );
  }
}
