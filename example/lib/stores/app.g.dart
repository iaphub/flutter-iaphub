// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isLoggedAtom =
      Atom(name: '_AppStore.isLogged', context: context);

  @override
  bool get isLogged {
    _$isLoggedAtom.reportRead();
    return super.isLogged;
  }

  @override
  set isLogged(bool value) {
    _$isLoggedAtom.reportWrite(value, super.isLogged, () {
      super.isLogged = value;
    });
  }

  late final _$alertAtom = Atom(name: '_AppStore.alert', context: context);

  @override
  String? get alert {
    _$alertAtom.reportRead();
    return super.alert;
  }

  @override
  set alert(String? value) {
    _$alertAtom.reportWrite(value, super.alert, () {
      super.alert = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_AppStore.login', context: context);

  @override
  Future login(String? userId) {
    return _$loginAsyncAction.run(() => super.login(userId));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  dynamic logout() {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.logout');
    try {
      return super.logout();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic openAlert(String content) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.openAlert');
    try {
      return super.openAlert(content);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic closeAlert() {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.closeAlert');
    try {
      return super.closeAlert();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLogged: ${isLogged},
alert: ${alert}
    ''';
  }
}
