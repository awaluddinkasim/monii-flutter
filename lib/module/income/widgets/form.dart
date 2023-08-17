import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/income.dart';
import 'package:monii/shared/utils/dio.dart';
import 'package:monii/shared/utils/thousand_separator.dart';

class FormWidget extends ConsumerStatefulWidget {
  final DateFormat dateFormat;
  const FormWidget({super.key, required this.dateFormat});

  @override
  ConsumerState<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends ConsumerState<FormWidget> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _sumber = TextEditingController();
  final TextEditingController _jumlah = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();

  DateTime _tanggalPemasukan = DateTime.now();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tanggal.text = widget.dateFormat.format(_tanggalPemasukan);
  }

  void _input(token) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final navigator = Navigator.of(context);
      Map data = {
        "sumber": _sumber.text,
        "jumlah": _jumlah.text,
        "tanggal": _tanggalPemasukan.toString(),
      };

      try {
        Response response = await dio(token: token).post("/income/store", data: data);
        if (response.statusCode == 200) {
          ref.read(incomeProvider.notifier).updateList(
                newData: response.data['incomes']['data'],
                lastPage: response.data['incomes']['last_page'],
              );
          ref.read(incomeProvider.notifier).setMessage(response.data['message']);
        }
      } on DioException catch (e) {
        ref.read(incomeProvider.notifier).setMessage(e.response!.data['message']);
      } finally {
        navigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = ref.watch(authProvider).token;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Form Pemasukan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _sumber,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Sumber",
                  prefixIcon: Icon(Icons.abc),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == "" || value == null) {
                    return "Harap diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _jumlah,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Jumlah Pemasukan",
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                validator: (value) {
                  if (value == "" || value == null) {
                    return "Harap diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _tanggal,
                readOnly: true,
                onTap: () {
                  _datePicker(context);
                },
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Tanggal Pemasukan",
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == "" || value == null) {
                    return "Harap diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton.tonal(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    context.loaderOverlay.show();
                    _input(token);
                  }
                },
                child: const Text("Input"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _datePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    _tanggalPemasukan = date;
    setState(() {
      _tanggal.text = widget.dateFormat.format(date);
    });
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isNotEmpty) {
      String newText = thousandSeparator(newValue.text);
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
