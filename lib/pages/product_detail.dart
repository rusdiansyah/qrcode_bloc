import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qrcode_bloc/bloc/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../routes/router.dart';

class ProductDetailPage extends StatelessWidget {
  ProductDetailPage(this.id, this.product, {super.key});
  final String id;
  final Product product;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    qtyC.text = product.qty!.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail Page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(data: product.code!),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Product Qty",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(
                    ProductEventEdit(
                      productId: product.productId!,
                      name: nameC.text,
                      qty: int.tryParse(qtyC.text) ?? 0,
                    ),
                  );
            },
            icon: const Icon(Icons.save),
            label: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateCompleteEdit) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("UPDATE SUCCESSFUL"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop();
                }
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.msg),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingEdit ? "LOADING..." : "UPDATE",
                );
              },
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(
                    ProductEventDelete(product.productId!),
                  );
            },
            icon: const Icon(Icons.delete),
            label: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateCompleteDelete) {
                  // context.goNamed(Routes.products);
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data berhasil di Hapus"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.msg),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingDelete ? "LOADING .." : "DELETE",
                );
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(
                    ProductEventGetId(product.code!),
                  );
            },
            icon: const Icon(Icons.delete),
            label: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateCompleteGetId) {
                  // context.goNamed(Routes.products);
                  // context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.toString()),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.msg),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingGetId ? "LOADING .." : "CEK",
                );
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade900,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
