import 'package:icontrol/common/enums/room_icons.dart';

extension RoomIconsExtension on RoomIcons {
  String get path => "assets/icons/rooms/$name.png";

  String get title {
    switch (this) {
      case RoomIcons.babyroom:
        return "Bebek Odası";
      case RoomIcons.bathroom:
        return "Banyo";
      case RoomIcons.bedroom:
        return "Yatak Odası";
      case RoomIcons.corridor:
        return "Koridor";
      case RoomIcons.garage:
        return "Garaj";
      case RoomIcons.garden:
        return "Bahçe";
      case RoomIcons.kitchen:
        return "Mutfak";
      case RoomIcons.livingroom:
        return "Salon";
      case RoomIcons.office:
        return "Ofis";
    }
  }
}
