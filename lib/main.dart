// ignore_for_file: prefer_const_constructors

import 'package:edu_ready/pages/absensi/absensi_page.dart';
import 'package:edu_ready/pages/akademik/akademik_page.dart';
import 'package:edu_ready/pages/batasmateri/batas_materi_page.dart';
import 'package:edu_ready/pages/informasi/informasi_page.dart';
import 'package:edu_ready/pages/onelogin/splash_page.dart';
import 'package:edu_ready/pages/pembayaran/pembayaran_page.dart';
import 'package:edu_ready/pages/saldo/top_up_page.dart';
import 'package:edu_ready/pages/welcome/home_page.dart';
import 'package:edu_ready/pages/saldo/history_saldo_page.dart';
import 'package:edu_ready/providers/absensi_provider.dart';
import 'package:edu_ready/providers/akademik_provider.dart';
import 'package:edu_ready/providers/dashboard_provider.dart';
import 'package:edu_ready/providers/first_login_provider.dart';
import 'package:edu_ready/providers/history_saldo_provider.dart';
import 'package:edu_ready/providers/informasi_provider.dart';
import 'package:edu_ready/providers/list_domain_provider.dart';
import 'package:edu_ready/providers/materi_provider.dart';
import 'package:edu_ready/providers/pembayaran_provider.dart';
import 'package:edu_ready/providers/redirect_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirstLoginProvider()),
        ChangeNotifierProvider(create: (context) => ListDomainProvider()),
        ChangeNotifierProvider(create: (context) => RedirectProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => HistorySaldoProvider()),
        ChangeNotifierProvider(create: (context) => AbsensiProvider()),
        ChangeNotifierProvider(create: (context) => MateriProvider()),
        ChangeNotifierProvider(create: (context) => InformasiProvider()),
        ChangeNotifierProvider(create: (context) => AkademikProvider()),
        ChangeNotifierProvider(create: (context) => PembayaranProvider()),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF6600),
            secondary: Color(0xFFFFCC80),
            onPrimary: Color(0xFF263238),
          ),
          textTheme: TextTheme(
            bodyText2: GoogleFonts.montserrat(),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Color(0xFFEF5350),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            prefixIconColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39434D), width: 1.5),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        routes: {
          HomePage.pageRoute: (context) => HomePage(),
          HistorySaldo.pageRoute: (context) => HistorySaldo(),
          AbsensiPage.pageRoute: (context) => AbsensiPage(),
          MateriPage.pageRoute: (context) => MateriPage(),
          InformasiPage.pageRoute: (context) => InformasiPage(),
          AkademikPage.pageRoute: (context) => AkademikPage(),
          TopUpPage.pageRoute: (context) => TopUpPage(),
          PembayaranPage.pageRoute: (context) => PembayaranPage(),
        },
      ),
    );
  }
}
