import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:analysis_app/localizations/free_localizations.dart';
import 'package:analysis_app/localizations/localizations.dart';
import 'package:analysis_app/root/root_page.dart';
import 'package:analysis_app/routes/application.dart';
import 'package:analysis_app/routes/routes.dart';
import 'package:analysis_app/tools/config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(TJAnalysis());

class TJAnalysis extends StatelessWidget {
  TJAnalysis() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  final ThemeData light = ThemeData(
        primaryColor:AppColor.theme,
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        tabBarTheme: TabBarTheme(labelColor: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        return TjLocalizations.of(context).appName;
      },
      theme: light,
      home: Builder(
        builder: (context) {
          return FreeLocalizations(
            child: RootPage(),
          );
        },
      ),
      onGenerateRoute: Application.router.generator,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        TjLocalizationsDelegate.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    );
  }
}
