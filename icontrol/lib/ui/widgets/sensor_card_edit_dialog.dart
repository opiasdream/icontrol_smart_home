import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/common/constants/dimens.dart';
import 'package:icontrol/common/enums/sensor_icons.dart';
import 'package:icontrol/common/extension/sensor_icons_extension.dart';
import 'package:icontrol/data/temp_sensor_data.dart';
import 'package:icontrol/models/sensor.dart';

class SensorCardEditDialog extends StatefulWidget {
  const SensorCardEditDialog({super.key, required this.sensorID});

  final String sensorID;

  static Future<void> show(BuildContext context, String sensorID) async {
    await showDialog(
        context: context,
        builder: (context) => SensorCardEditDialog(sensorID: sensorID));
  }

  @override
  State<SensorCardEditDialog> createState() => _SensorCardEditDialogState();
}

class _SensorCardEditDialogState extends State<SensorCardEditDialog> {
  late Sensor? sensor;

  final controller = TextEditingController();

  final iconPath = ValueNotifier<String>(SensorIcons.sensor_4.path);

  @override
  void initState() {
    super.initState();

    sensor = sensorData[widget.sensorID];

    if (sensor != null) {
      controller.text = sensor!.name;
      iconPath.value = sensorData[widget.sensorID]!.iconPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: kDialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            roomIconPicker(),
            const SizedBox(height: kDefaultPadding),
            sensorNameInput(),
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
              radius: 50,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.08),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(iconPath.value),
              ),
            ),
            onTap: () async {
              final path = await SensorIconPicker.show(context);

              if (path != null) iconPath.value = path;
            },
          );
        });
  }

  Widget sensorNameInput() {
    return TextField(
      autofocus: true,
      controller: controller,
      inputFormatters: [LengthLimitingTextInputFormatter(40)],
      decoration: const InputDecoration(
        filled: true,
        label: Text("Sensor Adı"),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
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
        sensorData[widget.sensorID] = Sensor(
          publisherID: widget.sensorID,
          name: controller.text,
          iconPath: iconPath.value,
        );

        Navigator.of(context).pop();
      },
      child: const Text("Kaydet"),
    );
  }
}

class SensorIconPicker extends StatelessWidget {
  const SensorIconPicker({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog(
        context: context, builder: (context) => const SensorIconPicker());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: kDialogWidth,
        height: kDialogWidth,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
            itemCount: SensorIcons.values.length,
            itemBuilder: (context, index) => Card(
                    child: InkWell(
                  onTap: () => Navigator.pop(
                      context, SensorIcons.values.elementAt(index).path),
                  child: Padding(
                    padding: const EdgeInsets.all(kSmallPadding),
                    child:
                        Image.asset(SensorIcons.values.elementAt(index).path),
                  ),
                ))),
      ),
    );
  }
}
