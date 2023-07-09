import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrcode_bloc/routes/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Add Product";
              icon = Icons.post_add_rounded;
              onTap = () {
                context.goNamed(Routes.productAdd);
                // debugPrint(Routes.productAdd);
              };
              break;
            case 1:
              title = "List Product";
              icon = Icons.list_alt_outlined;
              onTap = () {
                return context.goNamed(Routes.products);
              };
              break;
            case 2:
              title = "QR Code";
              icon = Icons.qr_code;
              onTap = () async {
                String code = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                final snackBar = SnackBar(
                  content: Text('QRCode ${code}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                context.read<ProductBloc>().add(ProductEventGetId(code));

                // return context.goNamed(
                //   Routes.productDetail,
                //   pathParameters: {
                //     "productId": product.productId!,
                //   },
                //   // queryParameters: {
                //   //   "product": product,
                //   //   // "code": product.code!,
                //   //   // "name": product.name!,
                //   //   // "qty": product.qty!,
                //   // },
                //   extra: product,
                // );
              };
              break;
            case 3:
              title = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () {
                context.read<ProductBloc>().add(ProductEventExportPdf());
              };
              break;
          }

          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 0 || index == 1)
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        icon,
                        size: 50,
                      ),
                    ),
                  if (index == 2)
                    BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        if (state is ProductStateCompleteGetId) {
                          // context.goNamed(
                          //   Routes.productDetail,
                          //   pathParameters: {
                          //     "productId": state['data'].productId!,
                          //   },
                          //   extra: state["data"],
                          // );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.toString()),
                              // duration: const Duration(seconds: 2),
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
                        if (state is ProductStateLoadingGetId) {
                          return const CircularProgressIndicator();
                        } else {
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              icon,
                              size: 50,
                            ),
                          );
                        }
                      },
                    ),
                  if (index == 3)
                    BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        if (state is ProductStateLoadingExport) {
                          return const CircularProgressIndicator();
                        } else {
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              icon,
                              size: 50,
                            ),
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(
                AuthEventLogout(),
              );
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
