import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/strings.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/constants/text_styles.dart';
import 'package:icontrol/repository/mqtt_repository.dart';
import 'package:icontrol/repository/room_repository.dart';
import 'package:icontrol/ui/widgets/room_card.dart';
import 'package:icontrol/ui/widgets/room_dialog.dart';
import 'package:icontrol/ui/widgets/sensor_listtile.dart';

part 'home_screen_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Text(appName, style: TextStyles.appName),
            const SizedBox(height: kDefaultPadding),
            buildRoomListWidget(),
            const SizedBox(height: kDefaultPadding),
            uncategorizedPublishersWidget(),
          ],
        ),
      )),
    );
  }

  ListenableBuilder buildRoomListWidget() {
    return ListenableBuilder(
      listenable: RoomRepository.instance,
      builder: (context, widget) {
        final rooms = RoomRepository.instance.rooms;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Odalar", style: TextStyles.h2),
                IconButton(
                    onPressed: () => RoomDialog.show(context),
                    icon: const Icon(Icons.add))
              ],
            ),
            const Divider(height: 0),
            const SizedBox(height: kDefaultPadding),
            Builder(
              builder: (context) {
                if (rooms.isEmpty) {
                  return const SizedBox(
                    height: kDialogWidth / 4,
                    child: Text("Kayıtlı içbir oda yok!"),
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) =>
                        RoomCard(room: rooms.elementAt(index)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget uncategorizedPublishersWidget() {
    return ListenableBuilder(
      listenable: MQTTRepository.instance,
      builder: (context, widget) {
        final publishers = MQTTRepository.instance.getUncategorizedPublishers();

        if (publishers.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kategorize Edilmemiş Cihazlar", style: TextStyles.h2),
              const SizedBox(height: kSmallPadding),
              const Text("home/#"),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: publishers.length,
                itemBuilder: (context, index) =>
                    SensorListTile(publisher: publishers.elementAt(index)),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
