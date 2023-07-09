import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../bloc/bloc.dart';
import '../bloc/models/product.dart';
import '../routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
        ),
        body: StreamBuilder<QuerySnapshot<Product>>(
            stream: productB.streamProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                  child: Text("tidak ada data / tidak dapat mengambil data"),
                );
              }
              List<Product> allProducts = [];

              for (var element in snapshot.data!.docs) {
                allProducts.add(element.data());
              }

              if (allProducts.isEmpty) {
                return const Center(
                  child: Text("Tidak Ada Data"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: allProducts.length,
                itemBuilder: (context, index) {
                  Product product = allProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                          Routes.productDetail,
                          pathParameters: {
                            "productId": product.productId!,
                          },
                          // queryParameters: {
                          //   "product": product,
                          //   // "code": product.code!,
                          //   // "name": product.name!,
                          //   // "qty": product.qty!,
                          // },
                          extra: product,
                        );
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.code!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(product.name!),
                                  const SizedBox(height: 5),
                                  Text("Qty : ${product.qty}"),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: QrImageView(
                                data: product.code!,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
