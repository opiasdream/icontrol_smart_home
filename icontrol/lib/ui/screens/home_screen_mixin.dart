part of 'home_screen.dart';

mixin HomeScreenMixin on State<HomeScreen> {
  @override
  void initState() {
    MQTTRepository.instance.init();

    super.initState();
  }
}
