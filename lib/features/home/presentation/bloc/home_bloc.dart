import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:himtika_mobile_information/features/auth/domain/entities/user.dart';
import 'package:himtika_mobile_information/features/roles/domain/entities/role.dart';
import 'package:himtika_mobile_information/features/home/domain/entities/home_banner.dart';
import 'package:himtika_mobile_information/features/home/domain/entities/division.dart';
import 'package:himtika_mobile_information/features/auth/domain/usecases/get_current_user.dart';
import 'package:himtika_mobile_information/features/home/domain/usecases/get_home_content.dart';
import 'package:himtika_mobile_information/features/roles/domain/usecases/get_my_roles.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentUser _getCurrentUser;
  final GetMyRoles _getMyRoles;
  final GetHomeContent _getHomeContent;

  HomeBloc({
    required GetCurrentUser getCurrentUser,
    required GetMyRoles getMyRoles,
    required GetHomeContent getHomeContent,
  })  : _getCurrentUser = getCurrentUser,
        _getMyRoles = getMyRoles,
        _getHomeContent = getHomeContent,
        super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    if (state.currentUser == null) {
      emit(state.copyWith(isLoading: true));
    }

    User? user;
    try {
      user = await _getCurrentUser();
    } catch (_) {}

    List<Role> roles = [];
    try {
      roles = await _getMyRoles();
    } catch (_) {}

    List<HomeBanner> banners = [];
    List<Division> divisions = [];
    try {
      final content = await _getHomeContent();
      banners = content.$1;
      divisions = content.$2;
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }

    final isPengurus = roles.any((role) => role.groupName == 'Pengurus');

    emit(state.copyWith(
      isLoading: false,
      currentUser: user,
      isPengurus: isPengurus,
      banners: banners,
      divisions: divisions,
      currentUserRoles: roles,
    ));
  }
}