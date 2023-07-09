import 'package:flutter/material.dart';
import 'package:qrcode_bloc/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // context.go('/products/${index + 1}');
              context.goNamed(
                Routes.productDetail,
                pathParameters: {
                  'productId': '${index + 1}',
                },
                queryParameters: {
                  'id': '${index + 1}',
                  'title': 'Product ${index + 1}',
                  'description': 'Description: ${index + 1} ',
                },
              );
            },
            leading: CircleAvatar(
              child: Text("${index + 1}"),
            ),
            title: Text("PRODUK KE ${index + 1}"),
            subtitle: Text("Description: ${index + 1}"),
          );
        },
      ),
    );
  }
}
