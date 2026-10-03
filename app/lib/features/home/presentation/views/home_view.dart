import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/products/products_cubit.dart';
import 'package:stylebox/generated/l10n.dart';
import 'package:stylebox/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductsCubit(getIt<ProductRepo>())
            ..loadProducts(restaurantLimit: KHomeResturantLimit),
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context)!.homeViewTitle)),
        body: const HomeViewBody(),
      ),
    );
  }
}
