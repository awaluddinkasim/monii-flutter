import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConstats {
  AppConstats._();

  static const storage = FlutterSecureStorage();

  // static const baseUrl = "http://10.0.2.2:8000";
  static const baseUrl = "https://monii.egols.my.id";

  static const currencySymbols = {
    'IDR': 'Rp. ',
    'JPY': '¥',
    'USD': '\$',
  };
}
