import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = event.email;
        final password = event.password;

        if (password.length < 6) {
          emit(AuthFailure('Password cannot be les than 6 characters'));
          return;
        }
        await Future.delayed(Duration(seconds: 1), () {
          return emit(AuthSuccess(uid: '$email-$password'));
        });
      } catch (e) {
        return emit(
          AuthFailure(
            e.toString(),
          ),
        );
      }
    });
    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(Duration(seconds: 1), () {
          return emit(AuthInitial());
        });
      } catch (e) {
        emit(
          AuthFailure(
            e.toString(),
          ),
        );
      }
    });
  }
}

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final String uid;
  AuthSuccess({required this.uid});
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

final class AuthLoading extends AuthState {}
