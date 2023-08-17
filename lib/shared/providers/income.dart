import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/shared/utils/dio.dart';

class IncomeState {
  List incomes = [];
  String message = "";

  IncomeState({required this.incomes, required this.message});
}

class IncomeNotifier extends StateNotifier<IncomeState> {
  IncomeNotifier() : super(IncomeState(incomes: [], message: ""));

  bool _isLoading = true;
  bool isLastPage = true;
  int _currentPage = 1;

  bool get isLoading => _isLoading;

  Future<void> fetchData(token) async {
    _isLoading = true;
    try {
      final response = await dio(token: token).get("/income");
      if (response.statusCode == 200) {
        final incomes = response.data['incomes'];
        _currentPage = 1;
        isLastPage = incomes['current_page'] == incomes['last_page'];
        state = IncomeState(
          incomes: incomes['data'],
          message: "",
        );
      }
    } on DioException catch (e) {
      setMessage(e.response!.data['message']);
    } finally {
      _isLoading = false;
    }
  }

  void updateList({required List newData, required int lastPage}) {
    state = IncomeState(
      incomes: newData,
      message: "",
    );

    _currentPage = 1;
    _isLoading = false;
    isLastPage = _currentPage == lastPage;
  }

  Future<void> loadMore(token) async {
    try {
      final response = await dio(token: token).get("/income?page=${_currentPage + 1}");
      if (response.statusCode == 200) {
        final incomes = response.data['incomes'];
        isLastPage = incomes['current_page'] == incomes['last_page'];
        _currentPage++;
        state = IncomeState(
          incomes: [...state.incomes, ...incomes['data']],
          message: "",
        );
      }
    } on DioException catch (e) {
      setMessage(e.response!.data['message']);
    }
  }

  void removeData(Map data) {
    state = IncomeState(
      incomes: state.incomes.where((element) => element['id'] != data['id']).toList(),
      message: "",
    );
  }

  void setMessage(String message) {
    state = IncomeState(incomes: state.incomes, message: message);
  }

  void resetState() {
    _isLoading = true;
    isLastPage = true;
    _currentPage = 1;

    state = IncomeState(incomes: [], message: "");
  }
}

final incomeProvider = StateNotifierProvider<IncomeNotifier, IncomeState>(
  (ref) => IncomeNotifier(),
);
