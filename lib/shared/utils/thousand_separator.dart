import 'package:intl/intl.dart';

String thousandSeparator(value) {
  final formatter = NumberFormat('#,###');

  return formatter.format(int.parse(value.replaceAll(',', '')));
}
