enum OtpType { signUp, forgetPassword }

class OtpParameter {
  final String phoneNumber;
  final OtpType type;

  OtpParameter({required this.phoneNumber, required this.type});
}
