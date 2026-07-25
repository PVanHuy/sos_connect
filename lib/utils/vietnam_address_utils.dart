import 'package:get/get.dart';
import 'package:sos_connect/widget/dialog/show_select_bottom_sheet.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class VietnamAddressUtils {
  VietnamAddressUtils._();

  static List<Province> getProvinces() {
    return VietnamProvinces.getProvinces().cast<Province>();
  }

  static List<Ward> getWards({required int provinceCode}) {
    return VietnamProvinces.getWards(provinceCode: provinceCode).cast<Ward>();
  }

  static Future<Province?> pickProvince({String? title}) {
    return showSelectBottomSheet<Province>(
      title: title ?? 'province_city'.tr,
      items: getProvinces(),
      labelBuilder: (item) => item.name,
    );
  }

  static Future<Ward?> pickWard({required Province province, String? title}) {
    return showSelectBottomSheet<Ward>(
      title: title ?? 'ward'.tr,
      items: getWards(provinceCode: province.code),
      labelBuilder: (item) => item.name,
    );
  }
}
