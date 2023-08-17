import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/constants.dart';
import 'package:monii/model/user.dart';
import 'package:monii/shared/utils/dio.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String token;
  final User? user;
  final String errorMessage;

  AuthState({
    required this.status,
    required this.token,
    this.user,
    required this.errorMessage,
  });
}

const storage = AppConstats.storage;

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(status: AuthStatus.loading, token: "", errorMessage: ""));

  Future<void> login({required Map creds}) async {
    setErrorMessage("");
    try {
      Response response = await dio().post("/login", data: creds);
      if (response.statusCode == 200) {
        Map data = response.data;
        state = AuthState(
          status: AuthStatus.authenticated,
          token: data['token'],
          user: User.fromJson(data['user']),
          errorMessage: "",
        );
        await storage.write(key: 'auth-token', value: state.token);
      }
    } on DioException catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        token: "",
        errorMessage: "${e.response!.data['message']}",
      );
    }
  }

  void setErrorMessage(String msg) {
    state = AuthState(status: state.status, token: "", errorMessage: msg);
  }

  Future<void> getUserData() async {
    String? token = await storage.read(key: "auth-token");
    try {
      Response response = await dio(token: token).get("/user");
      if (response.statusCode == 200) {
        state = AuthState(
          status: AuthStatus.authenticated,
          token: token!,
          user: User.fromJson(response.data['user']),
          errorMessage: state.errorMessage,
        );
      }
    } catch (_) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        token: "",
        errorMessage: "",
      );
      await storage.delete(key: 'auth-token');
    }
  }

  void updateUser(data) {
    state = AuthState(
      status: state.status,
      token: state.token,
      user: User.fromJson(data),
      errorMessage: state.errorMessage,
    );
  }

  Future<void> logout() async {
    try {
      Response response = await dio(token: state.token).get("/logout");
      if (response.statusCode == 200) {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          token: "",
          user: null,
          errorMessage: "",
        );
      }
      await storage.delete(key: 'auth-token');
    } on DioException catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        token: "",
        errorMessage: "${e.response!.data['message']}",
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
