import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/enums/room_icons.dart';
import 'package:icontrol/common/extension/room_icons_extension.dart';
import 'package:icontrol/common/helpers/functions.dart';
import 'package:icontrol/models/room.dart';
import 'package:icontrol/repository/room_repository.dart';
import 'package:icontrol/ui/widgets/room_icon_picker.dart';

class RoomDialog extends StatefulWidget {
  const RoomDialog({super.key, this.room});

  final Room? room;

  static Future<void> show(BuildContext context, {Room? room}) async {
    await showDialog(
        context: context, builder: (context) => RoomDialog(room: room));
  }

  @override
  State<RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends State<RoomDialog> {
  bool editMode = false;

  final controller = TextEditingController();

  final iconPath = ValueNotifier<String>(RoomIcons.livingroom.path);

  @override
  void initState() {
    super.initState();

    if (widget.room != null) {
      editMode = true;
      controller.text = widget.room!.name;
      iconPath.value = widget.room!.iconPath;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    iconPath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if room is null, create a new room else edit the room.

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(editMode ? "Oda Düzenle" : "Yeni Oda Ekle"),
          const CloseButton(),
        ],
      ),
      content: SizedBox(
        width: kDialogWidth,
        child: Row(
          children: [
            roomIconPicker(),
            const SizedBox(width: kSmallPadding),
            roomNameInput(),
          ],
        ),
      ),
      actions: [
        cancelButton(context),
        saveButton(context),
      ],
    );
  }

  ValueListenableBuilder<String> roomIconPicker() {
    return ValueListenableBuilder(
        valueListenable: iconPath,
        builder: (context, val, ch) {
          return InkWell(
            child: CircleAvatar(
              radius: 30,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.1),
              child: SizedBox(
                  height: 40, width: 40, child: Image.asset(iconPath.value)),
            ),
            onTap: () async {
              final path = await RoomIconPicker.show(context);

              if (path != null) iconPath.value = path;
            },
          );
        });
  }

  Expanded roomNameInput() {
    return Expanded(
      child: TextField(
        autofocus: true,
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(40)],
        decoration: const InputDecoration(
          filled: true,
          label: Text("Oda Adı"),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("İptal"),
    );
  }

  FilledButton saveButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        var tempRoom =
            Room(id: "", name: controller.text, iconPath: iconPath.value);

        if (editMode) {
          RoomRepository.instance.remove(widget.room!.id);
          tempRoom.id = widget.room!.id;
        } else {
          tempRoom.id = controller.text
              .toLowerCase()
              .replaceAllMapped(RegExp(r'[çğıöü ]'), Functions.trToEng);
        }

        RoomRepository.instance.addRoom(tempRoom);

        Navigator.of(context).pop();
      },
      child: const Text("Kaydet"),
    );
  }
}
