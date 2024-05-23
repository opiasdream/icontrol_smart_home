import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/constants/text_styles.dart';
import 'package:icontrol/models/room.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/ui/widgets/loader.dart';
import 'package:icontrol/ui/widgets/room_popup.dart';
import 'package:icontrol/ui/widgets/sensor_card.dart';
import 'package:icontrol/ui/widgets/sensor_listtile.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                RoomPopup(room: room),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            Row(
              children: [
                Image.asset(room.iconPath, height: 50),
                const SizedBox(width: kDefaultPadding),
                Text(room.name, style: TextStyles.h1)
              ],
            ),
            const SizedBox(height: kSmallPadding),
            Text("home/${room.id}", style: TextStyles.h3),
            const SizedBox(height: kDefaultPadding),
            Row(
              children: [
                Text("Cihazlar", style: TextStyles.h2),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      AddPublisherToRoomDialog.show(context, room.id),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            const Divider(height: 0),
            ListenableBuilder(
              listenable: MQTTRepository.instance,
              builder: (context, widget) {
                final publishers = MQTTRepository.instance.publishers.values
                    .where((e) => e.room == room.id);

                if (publishers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Text("Bu odaya kayıtlı hiçbir cihaz bulunamadı!",
                        textAlign: TextAlign.center),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: publishers.length,
                  itemBuilder: (context, index) {
                    final publisher = publishers.elementAt(index);

                    return SensorCard(publisher: publisher);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddPublisherToRoomDialog extends StatelessWidget {
  const AddPublisherToRoomDialog({super.key, required this.roomId});

  final String roomId;

  static Future<void> show(BuildContext context, String roomID) => showDialog(
      context: context,
      builder: (context) => AddPublisherToRoomDialog(roomId: roomID));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: kDialogWidth,
        // height: kDialogWidth * 1.5,
        child: ListenableBuilder(
          listenable: MQTTRepository.instance,
          builder: (context, widget) {
            final publishers = MQTTRepository.instance.publishers;

            if (publishers.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: publishers.length,
                  itemBuilder: (context, index) {
                    final publisher = publishers.values.elementAt(index);
                    return InkWell(
                        onTap: () {
                          MQTTRepository.instance
                              .changeRoom(roomId, publisher.id);
                          Navigator.pop(context);
                        },
                        child: SensorListTile(publisher: publisher));
                  });
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}
