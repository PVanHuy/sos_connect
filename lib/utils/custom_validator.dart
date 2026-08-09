import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sos_connect/model/phone_code_model.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class CustomValidator {
  static final RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp cccdRegex = RegExp(r'^\d{12}$');

  static final RegExp passwordRegex = RegExp(
    r'^(?!.*[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯưĂâđêôơư])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[#?!@$%^&*-])\S{8,}$',
  );

  static String validateName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'name'.tr});
    }
    if (fullName.trim().length < AppConstants.minNameLength || fullName.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'name'.tr.toLowerCase()});
    }
    return '';
  }

  static String validateFullName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'full_name'.tr});
    }
    if (fullName.trim().length < AppConstants.minNameLength || fullName.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'full_name'.tr.toLowerCase()});
    }
    return '';
  }

  static String validateCCCD(String cccd, {bool isRequired = true}) {
    if (cccd.trim().isEmpty) {
      return isRequired ? 'field_is_required'.trParams({'field': 'cccd'.tr}) : '';
    }

    if (cccd.isNotEmpty && !cccdRegex.hasMatch(cccd.trim())) {
      return 'field_is_invalid'.trParams({'field': 'cccd'.tr});
    }

    return '';
  }

  static String validateFirstName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'first_name'.tr});
    }
    if (fullName.trim().length < AppConstants.minNameLength || fullName.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'first_name'.tr.toLowerCase()});
    }
    return '';
  }

  static String validateLastName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'last_name'.tr});
    }
    if (fullName.trim().length < AppConstants.minNameLength || fullName.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'last_name'.tr.toLowerCase()});
    }
    return '';
  }

  static String validateStoreCode(String code) {
    if (code.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'store_code'.tr});
    }
    if (code.trim().length < AppConstants.minNameLength || code.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'store_code'.tr.toLowerCase()});
    }
    return '';
  }

  static String validateUserName(String userName) {
    if (userName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'user_name'.tr});
    }
    if (userName.trim().length < AppConstants.minNameLength) {
      return 'field_must_be_at_least_min_characters'.trParams({
        'field': 'user_name'.tr,
        'min': AppConstants.minNameLength.toString(),
      });
    }
    if (userName.trim().length > AppConstants.maxNameLength) {
      return 'field_is_invalid'.trParams({'field': 'user_name'.tr});
    }
    return '';
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return 'field_is_required'.trParams({'field': 'password'.tr});
    } else if (!passwordRegex.hasMatch(password)) {
      return 'validate_password'.tr;
    }
    return '';
  }

  static String validateEmail(String? email, {bool isRequired = true}) {
    if (email == null || email.trim().isEmpty) {
      return isRequired ? 'field_is_required'.trParams({'field': 'email'.tr}) : '';
    }
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email.trim()) ? '' : 'field_is_invalid'.trParams({'field': 'email'.tr});
  }

  static String validateAddress(String address) {
    if (address.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'address'.tr});
    }
    if (address.trim().length < AppConstants.minAddressLength ||
        address.trim().length > AppConstants.maxAddressLength) {
      return 'enter_full_field'.trParams({'field': 'address'.tr.toLowerCase()});
    }
    return '';
  }

  static PhoneValid isPhoneValid(String number) {
    String phone = number;
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      phone = '+${phoneNumber.countryCode}${phoneNumber.nsn}';

      final regex = RegExp(r'^\+84[35789]\d{8}$');
      final isValid = regex.hasMatch(phone);

      return PhoneValid(isValid: isValid, phone: phone);
    } catch (e, a) {
      loggerHelper.error('Phone number validation error', error: e, stackTrace: a);
      return PhoneValid(isValid: false, phone: phone);
    }
  }

  static String validatePhone(String phone, {bool isRequired = true}) {
    if (isRequired && phone.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'phone_number'.tr});
    }

    if (phone.isNotEmpty) {
      final number = phone.replaceFirst(RegExp(r'^\+84'), '0').replaceFirst(RegExp(r'^0'), '');
      final phoneValid = isPhoneValid(PhoneCodeModel().getCodeAsString() + number);

      if (!phoneValid.isValid && phone.isNotEmpty) {
        return 'field_is_invalid'.trParams({'field': 'phone_number'.tr});
      }
      return '';
    }
    return '';
  }

  static String validateRequiredField(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': fieldName});
    }
    return '';
  }

  static String validateRequiredAndMinLength(String value, String fieldName, {int minLength = 3}) {
    if (value.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': fieldName});
    }
    if (value.trim().length < minLength) {
      return 'field_must_be_at_least_min_characters'.trParams({'field': fieldName, 'min': minLength.toString()});
    }
    return '';
  }

  static String validateUrlField(String url, {String fieldName = '', bool isRequired = false}) {
    if (url.trim().isEmpty) {
      if (isRequired) {
        return 'field_is_required'.trParams({'field': fieldName});
      }
      return '';
    }

    final uri = Uri.tryParse(url.trim());

    if (uri == null || !uri.isAbsolute || uri.host.isEmpty || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'field_is_invalid'.trParams({'field': fieldName});
    }

    return '';
  }
}

class PhoneValid {
  bool isValid;
  String phone;

  PhoneValid({required this.isValid, required this.phone});
}
