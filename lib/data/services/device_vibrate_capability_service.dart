import 'package:vibration/vibration.dart';

import 'package:timed_shaker/domain/services_interfaces/device_vibrate_capability_service_interface.dart';

class DeviceVibrateCapabilityService implements DeviceVibrateCapabilityServiceInterface {
  const DeviceVibrateCapabilityService();
  @override
  Future<bool> canVibrate() async => (await Vibration.hasVibrator()) ?? false;
  @override
  Future<bool> hasAmplitudeControl() async => (await Vibration.hasAmplitudeControl()) ?? false;
  @override
  Future<bool> hasDurationControl() async => (await Vibration.hasCustomVibrationsSupport()) ?? false;
}
