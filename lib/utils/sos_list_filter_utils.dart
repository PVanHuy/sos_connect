class SosListFilterUtils {
  static const List<int> radiusKmOptions = [10, 20, 30, 40, 50];
  static const List<String> timeWindowOptions = ['24h', '48h', '72h'];

  static int? toMeters(int? radiusKm) {
    if (radiusKm == null) return null;
    return radiusKm * 1000;
  }
}
