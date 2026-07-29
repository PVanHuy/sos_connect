import 'package:get/get.dart';
import 'package:sos_connect/utils/dialog_utils.dart';

void showNetWorkErrorDialog() {
  DialogUtils.showErrorDialog('connection_to_api_server_failed'.tr);
}
