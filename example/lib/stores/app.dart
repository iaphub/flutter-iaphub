import 'package:mobx/mobx.dart';
import 'index.dart';

part 'app.g.dart';

class AppStore extends _AppStore with _$AppStore {}

abstract class _AppStore with Store {
  
  @observable
  bool isLogged = false;

  @observable
  String? alert;

  _AppStore() {
    start();
  }

  start() async {
    await iapStore.init();
  }

  @action
  login(String? userId) async {
    if (userId != null) {
      iapStore.login(userId);
    }
    await iapStore.refreshProducts();
    isLogged = true;
  }

  @action
  logout() {
    iapStore.logout();
    isLogged = false;
  }

  @action
  openAlert(String content) {
    alert = content;
  }

  @action
  closeAlert() {
    alert = null;
  }

}