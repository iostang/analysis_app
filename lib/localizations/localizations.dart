import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class TjLocalizations {

  final Locale locale;

  TjLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'logout': 'Logout',
      'login_success': 'Login Success',
      "app_name": "Analysis",
      "change_language": "Change Language",
      "input_account": "Enter account",
      "input_pwd": "Enter the password",
      "please_enter": "Please enter",
      "order_title": "Order",
    },
    'zh': {
      'login': '登录',
      'logout': '退出登录',
      'login_success': '登录成功',
      "app_name": "Analysis",
      "change_language": "切换语言",
      "input_account": "输入账号",
      "input_pwd": "输入密码",
      "please_enter": "请输入",
      "order_title": "订单",
    }
  };

  get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  get loginSuccess {
    return _localizedValues[locale.languageCode]['login_success'];
  }

  get appName {
    return _localizedValues[locale.languageCode]['app_name'];
  }
  
  get changeLanguage {
    return _localizedValues[locale.languageCode]['change_language'];
  }

  get inputAccount {
    return _localizedValues[locale.languageCode]['input_account'];
  }

  get inputPwd {
    return _localizedValues[locale.languageCode]['input_pwd'];
  }

  get pleaseEnter {
    return _localizedValues[locale.languageCode]['please_enter'];
  }
  
  get orderTitle {
    return _localizedValues[locale.languageCode]['order_title'];
  }


  static TjLocalizations of(BuildContext context){
    return Localizations.of(context, TjLocalizations);
  }
}

class TjLocalizationsDelegate extends LocalizationsDelegate<TjLocalizations>{

  const TjLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en','zh'].contains(locale.languageCode);
  }

  @override
  Future<TjLocalizations> load(Locale locale) {
    return new SynchronousFuture<TjLocalizations>(new TjLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<TjLocalizations> old) {
    return false;
  }

  static TjLocalizationsDelegate delegate = const TjLocalizationsDelegate();
}