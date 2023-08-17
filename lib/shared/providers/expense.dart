import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/shared/utils/dio.dart';

class ExpenseState {
  List expenses = [];
  String message = "";

  ExpenseState({required this.expenses, required this.message});
}

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  ExpenseNotifier() : super(ExpenseState(expenses: [], message: ""));

  bool _isLoading = true;
  bool isLastPage = true;
  int _currentPage = 1;

  bool get isLoading => _isLoading;

  Future<void> fetchData(token) async {
    _isLoading = true;
    try {
      final response = await dio(token: token).get("/expense");
      if (response.statusCode == 200) {
        final expenses = response.data['expenses'];
        _currentPage = 1;
        isLastPage = expenses['current_page'] == expenses['last_page'];
        state = ExpenseState(
          expenses: expenses['data'],
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
    state = ExpenseState(
      expenses: newData,
      message: "",
    );

    _currentPage = 1;
    _isLoading = false;
    isLastPage = _currentPage == lastPage;
  }

  Future<void> loadMore(token) async {
    try {
      final response = await dio(token: token).get("/expense?page=${_currentPage + 1}");
      if (response.statusCode == 200) {
        final expenses = response.data['expenses'];
        isLastPage = expenses['current_page'] == expenses['last_page'];
        _currentPage++;
        state = ExpenseState(
          expenses: [...state.expenses, ...expenses['data']],
          message: "",
        );
      }
    } on DioException catch (e) {
      setMessage(e.response!.data['message']);
    }
  }

  void removeData(Map data) {
    state = ExpenseState(
      expenses: state.expenses.where((element) => element['id'] != data['id']).toList(),
      message: "",
    );
  }

  void setMessage(String message) {
    state = ExpenseState(expenses: state.expenses, message: message);
  }

  void resetState() {
    _isLoading = true;
    isLastPage = true;
    _currentPage = 1;

    state = ExpenseState(expenses: [], message: "");
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>(
  (ref) => ExpenseNotifier(),
);
