part of 'navbar_cubit.dart';

@immutable
abstract class NavbarState {
  const NavbarState();
}

class NavbarEventsState extends NavbarState {
  const NavbarEventsState();
}

class NavbarNewsState extends NavbarState {
  const NavbarNewsState();
}

class NavbarSettingsState extends NavbarState {
  const NavbarSettingsState();
}
