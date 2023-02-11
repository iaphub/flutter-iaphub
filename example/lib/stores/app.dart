import 'package:mobx/mobx.dart';
import 'index.dart';

part 'app.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  
  @observable
  bool isLogged = false;

  @observable
  String? alert = null;

  _AppStore() {
    this.start();
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
    this.isLogged = true;
  }

  @action
  logout() {
    iapStore.logout();
    this.isLogged = false;
  }

  @action
  openAlert(String content) {
    this.alert = content;
  }

  @action
  closeAlert() {
    this.alert = null;
  }

}