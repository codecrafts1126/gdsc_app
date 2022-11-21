import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  int _page = 0;
  NavbarCubit() : super(const NavbarEventsState());

  Future<void> switchNavbarPage(int navbarPageIndex) async {
    if (navbarPageIndex == _page) return;
    if (navbarPageIndex == 0) {
      emit(const NavbarEventsState());
    } else if (navbarPageIndex == 1) {
      emit(const NavbarNewsState());
    } else if (navbarPageIndex == 2) {
      emit(const NavbarSettingsState());
    }
    _page = navbarPageIndex;
  }
}
