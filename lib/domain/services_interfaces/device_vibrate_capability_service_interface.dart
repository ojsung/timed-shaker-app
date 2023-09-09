abstract class DeviceVibrateCapabilityServiceInterface {
  Future<bool> canVibrate();
  Future<bool> hasAmplitudeControl();
  Future<bool> hasDurationControl();
}
