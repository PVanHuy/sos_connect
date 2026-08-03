import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/firebase_options.dart';
import 'package:sos_connect/resourese/service/app_service.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/app_theme_util.dart';
import 'package:sos_connect/theme/base_theme_data.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/shared_key.dart';
import 'package:sos_connect/widget/reponsive/size_config.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppService.initAppService();
  await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v2);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig.instance.init(
          constraints: constraints,
          screenHeight: constraints.maxHeight,
          screenWidth: constraints.maxWidth,
        );

        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final token = LocalStorage.getString(SharedKey.token);

  @override
  void dispose() {
    themeUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        locale: LocalizationService.language.locale,
        supportedLocales: LocalizationService.supportedLanguage.map((e) => e.locale).toList(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        fallbackLocale: LocalizationService.fallbackLanguage.locale,
        translations: LocalizationService(),
        theme: ThemeData(
          primarySwatch: MaterialColor(appTheme.appColor.toInt32, <int, Color>{
            50: appTheme.appColor,
            100: appTheme.appColor,
            200: appTheme.appColor,
            300: appTheme.appColor,
            400: appTheme.appColor,
            500: appTheme.appColor,
            600: appTheme.appColor,
            700: appTheme.appColor,
            800: appTheme.appColor,
            900: appTheme.appColor,
          }),
          scaffoldBackgroundColor: appTheme.whiteColor,
        ),
        initialRoute: Routes.SPLASH,
        getPages: AppPages.pages,
        builder: EasyLoading.init(),
      ),
    );
  }
}
