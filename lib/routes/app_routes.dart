part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const PRODUCTS = _Paths.PRODUCTS;
  static const TRANSACTIONS = _Paths.TRANSACTIONS;
  static const CUSTOMERS = _Paths.CUSTOMERS;
  static const LOGIN = _Paths.LOGIN;
  static const HISTORY = _Paths.HISTORY;
  static const REPORT = _Paths.REPORT;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const PRODUCTS = '/products';
  static const TRANSACTIONS = '/transactions';
  static const CUSTOMERS = '/customers';
  static const LOGIN = '/login';
  static const HISTORY = '/history';
  static const REPORT = '/report';
}
