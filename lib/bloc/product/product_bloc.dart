import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/product.dart';
import 'package:open_file/open_file.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAdd>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());
        var hasil = await firestore.collection("products").add({
          "code": event.code,
          "name": event.name,
          "qty": event.qty,
        });
        await firestore.collection("products").doc(hasil.id).update({
          "productId": hasil.id,
        });
        emit(ProductStateCompleteAdd());
      } on FirebaseAuthException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambah product"));
      }
    });
    on<ProductEventEdit>((event, emit) async {
      try {
        emit(ProductStateLoadingEdit());

        await firestore.collection("products").doc(event.productId).update({
          "name": event.name,
          "qty": event.qty,
        });

        emit(ProductStateCompleteEdit());
      } on FirebaseAuthException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambah product"));
      }
    });
    on<ProductEventDelete>((event, emit) async {
      try {
        emit(ProductStateLoadingDelete());

        await firestore.collection("products").doc(event.productId).delete();

        emit(ProductStateCompleteDelete());
      } on FirebaseAuthException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menghapus product"));
      }
    });
    on<ProductEventExportPdf>((event, emit) async {
      try {
        emit(ProductStateLoadingExport());

        var querySnap = await firestore
            .collection("products")
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<Product> allProducts = [];

        for (var element in querySnap.docs) {
          Product product = element.data();
          allProducts.add(product);
        }

        final pdf = pw.Document();

        var data =
            await rootBundle.load("assets/fonts/opensans/OpenSans-Regular.ttf");
        var myFont = pw.Font.ttf(data);
        // var myStyle = pw.TextStyle(font: myFont);
        var headStyle = pw.TextStyle(
          font: myFont,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          // background: PdfColor.fromHex("#e3dede"),
        );

        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pw.TableRow> allData = List.generate(
              allProducts.length,
              (index) {
                Product product = allProducts[index];
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "${index}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        product.code!,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        product.name!,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        product.qty.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#0f0f0f"),
                        barcode: pw.Barcode.qrCode(),
                        data: product.code!,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                );
              },
            );
            return [
              pw.Center(
                child: pw.Text(
                  "PRODUCT CATALOG",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: myFont,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(
                  // color: PdfColor(17, 18, 17),
                  width: 2,
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "No",
                          textAlign: pw.TextAlign.center,
                          style: headStyle,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "Code",
                          textAlign: pw.TextAlign.center,
                          style: headStyle,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "Product Name",
                          textAlign: pw.TextAlign.center,
                          style: headStyle,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "QTY",
                          textAlign: pw.TextAlign.center,
                          style: headStyle,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "QR Code",
                          textAlign: pw.TextAlign.center,
                          style: headStyle,
                        ),
                      ),
                    ],
                  ),
                  ...allData,
                ],
              ),
            ];
          },
        ));

        Uint8List bytes = await pdf.save();
        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/myProduct.pdf");
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);

        // print(file.path);

        emit(ProductStateCompleteExport());
      } on FirebaseAuthException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError("Tidak dapat export product"));
      }
    });
    on<ProductEventGetId>((event, emit) async {
      try {
        emit(ProductStateLoadingGetId());

        final result =
            await firestore.collection("products").doc(event.code).get();

        print("Test");
        // print(result);
        // result.fold(
        //   (error) => {ProductStateError(message: error)},
        //   (data) => {ProductStateCompleteGetId(data: data)},
        // );

        // await firestore
        //     .collection("products")
        //     .doc(event.code)
        //     .withConverter<Product>(
        //       fromFirestore: (snapshot, _) =>
        //           Product.fromJson(snapshot.data()!),
        //       toFirestore: (product, _) => product.toJson(),
        //     )
        //     .get();

        // List<Product> lP = [];

        // for (var element in querySnap.docs) {
        //   Product row = element.data();
        //   lp.add(row);
        // }

        // print("isi produk : ${querySnap}");

        // if (product.data() == null) {
        //   throw "error";
        //   // emit(ProductStateError("Product ID tidak ditemukan"));
        // }

        emit(ProductStateCompleteGetId());
      } on FirebaseAuthException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError("Tidak dapat mendapatkan ID product"));
      }
    });
  }
}
