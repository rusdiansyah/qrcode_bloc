import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc/bloc/models/product.dart';
import 'package:qrcode_bloc/pages/login.dart';
import 'package:qrcode_bloc/pages/product_add.dart';
import 'package:qrcode_bloc/pages/product_detail.dart';
import 'package:qrcode_bloc/pages/products.dart';
import '../pages/error.dart';
import '../pages/home.dart';
import '../pages/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'package:go_router/go_router.dart';

part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // debugPrint(auth.currentUser as String?);
    // print(auth.currentUser);
    if (auth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.productDetail,
              builder: (context, state) => ProductDetailPage(
                state.pathParameters['productId'].toString(),
                state.extra as Product,
                // state.queryParameters,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'product-add',
          name: Routes.productAdd,
          builder: (context, state) => ProductAddPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/setting',
      name: Routes.setting,
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
