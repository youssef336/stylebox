import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import '../../manager/cubits/products/products_cubit.dart';
import 'home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductsCubit(getIt<ProductRepo>())
            ..loadProducts(restaurantLimit: KHomeResturantLimit),
      child: const HomeViewBody(),
    );
  }
}
