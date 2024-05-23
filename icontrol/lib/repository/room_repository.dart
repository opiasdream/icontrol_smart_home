import 'package:flutter/material.dart';
import 'package:icontrol/common/enums/room_icons.dart';
import 'package:icontrol/common/extension/room_icons_extension.dart';
import 'package:icontrol/models/room.dart';

class RoomRepository extends ChangeNotifier {
  static final RoomRepository _instance = RoomRepository._internal();
  static RoomRepository get instance => _instance;
  RoomRepository._internal();

  List<Room> rooms = [
    Room(
      id: 'salon',
      name: RoomIcons.livingroom.title,
      iconPath: RoomIcons.livingroom.path,
    ),
    Room(
      id: 'bebekodasi',
      name: RoomIcons.babyroom.title,
      iconPath: RoomIcons.babyroom.path,
    ),
  ];

  void addRoom(Room room) {
    rooms.add(room);
    notifyListeners();
  }

  void remove(String id) {
    rooms.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
