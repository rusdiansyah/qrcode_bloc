part of 'product_bloc.dart';

abstract class ProductEvent {}

class ProductEventAdd extends ProductEvent {
  ProductEventAdd({required this.code, required this.name, required this.qty});
  final String code;
  final String name;
  final int qty;
}

class ProductEventEdit extends ProductEvent {
  ProductEventEdit(
      {required this.productId, required this.name, required this.qty});
  final String productId;
  final String name;
  final int qty;
}

class ProductEventDelete extends ProductEvent {
  ProductEventDelete(this.productId);
  final String productId;
}

class ProductEventGetId extends ProductEvent {
  ProductEventGetId(this.code);
  final String code;
}

class ProductEventExportPdf extends ProductEvent {}
