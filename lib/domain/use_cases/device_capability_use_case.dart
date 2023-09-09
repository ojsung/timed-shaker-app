import 'package:timed_shaker/domain/entities/device_vibrate_capability_entity.dart';
import 'package:timed_shaker/domain/services_interfaces/device_vibrate_capability_service_interface.dart';

class DeviceCapabilityUseCase {
  const DeviceCapabilityUseCase(this.deviceVibrateCapabilityService);
  final DeviceVibrateCapabilityServiceInterface deviceVibrateCapabilityService;
  Future<DeviceVibrateCapabilityEntity> checkSystemVibrationCapability() async {
    final [canVibrate, hasAmplitudeControls, hasDurationControls] = await Future.wait([
      deviceVibrateCapabilityService.canVibrate(),
      deviceVibrateCapabilityService.hasAmplitudeControl(),
      deviceVibrateCapabilityService.hasDurationControl(),
    ]);
    return DeviceVibrateCapabilityEntity(
      canVibrate: canVibrate,
      hasAmplitudeControls: hasAmplitudeControls,
      hasDurationControl: hasDurationControls,
    );
  }
}
