part of 'product_bloc.dart';

abstract class ProductState {}

class ProductStateInitial extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateLoadingExport extends ProductState {}

class ProductStateLoadingGetId extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateCompleteExport extends ProductState {}

class ProductStateCompleteGetId extends ProductState {}

class ProductStateError extends ProductState {
  ProductStateError(this.msg);
  final String msg;
}
