import 'package:sos_connect/utils/logger_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteLauncherUtil {
  RouteLauncherUtil._();

  static Future<void> openPhoneCall(String phoneNumber) async {
    final phone = phoneNumber.trim();
    if (phone.isEmpty) return;

    final phoneUri = Uri.parse('tel:$phone');
    try {
      final launched = await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        loggerHelper.error('Could not launch phone call: $phoneUri');
      }
    } catch (e) {
      loggerHelper.error('Error launching phone call: $e');
    }
  }

  static Future<void> openGoogleMapByAddress(String address) async {
    final queryAddress = address.trim();
    if (queryAddress.isEmpty) return;

    final query = Uri.encodeComponent(queryAddress);
    final mapUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    final geoUri = Uri.parse('geo:0,0?q=$query');

    try {
      // Prefer Google Maps web/app deep link, fallback to geo intent.
      final launched = await launchUrl(mapUri, mode: LaunchMode.externalApplication);
      if (launched) return;

      final launchedGeo = await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      if (!launchedGeo) {
        loggerHelper.error('Could not launch Google Maps: $mapUri');
      }
    } catch (e) {
      try {
        await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } catch (geoError) {
        loggerHelper.error('Error launching Google Maps: $e / $geoError');
      }
    }
  }
}
