import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_state.g.dart';

class NavigationState {
  String currentRoute;
  bool visible;
  bool isSmall;
  NavigationState({
    this.currentRoute = '/',
    this.visible = true,
    this.isSmall = false,
  });
}

const invisibleList = ['/edit'];

@Riverpod(keepAlive: true)
class BottomNavigationState extends _$BottomNavigationState {
  @override
  NavigationState build() => NavigationState();

  void setRoute(String route) {
    if (invisibleList.contains(route)) {
      hide();
    } else {
      show();
    }
    state = NavigationState(
      currentRoute: route,
      visible: state.visible,
      isSmall: state.isSmall,
    );
  }

  void show() {
    state = NavigationState(
      currentRoute: state.currentRoute,
      visible: true,
      isSmall: state.isSmall,
    );
  }

  void hide() {
    state = NavigationState(
      currentRoute: state.currentRoute,
      visible: false,
      isSmall: state.isSmall,
    );
  }

  void collapse() {
    state = NavigationState(
      currentRoute: state.currentRoute,
      visible: state.visible,
      isSmall: true,
    );
  }

  void expand() {
    state = NavigationState(
      currentRoute: state.currentRoute,
      visible: state.visible,
      isSmall: false,
    );
  }
}
