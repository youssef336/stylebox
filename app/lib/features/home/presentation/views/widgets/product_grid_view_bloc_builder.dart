import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stylebox/generated/l10n.dart';
import '../../manager/cubits/products/products_cubit.dart';
import '../../manager/cubits/products/products_state.dart';

class ProductGridViewBlocBuilder extends StatefulWidget {
  const ProductGridViewBlocBuilder({super.key});

  @override
  State<ProductGridViewBlocBuilder> createState() =>
      _ProductGridViewBlocBuilderState();
}

class _ProductGridViewBlocBuilderState
    extends State<ProductGridViewBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final textColor = scheme.onSurface;
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading || state is ProductsInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductsFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              state.failure.message,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          );
        }

        if (state is ProductsSuccess) {
          final products = state.products;
          if (products.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                S.of(context)!.productGridViewPlaceholder,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final title = Directionality.of(context) == TextDirection.rtl
                  ? product.nameAr
                  : product.nameEn;

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(KradiusCard),
                  border: isDark
                      ? Border.all(color: Theme.of(context).dividerColor)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: KprimaryColorDark.withValues(
                        alpha: isDark ? 0 : 0.06,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(KradiusCard - 6),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.checkroom_outlined,
                            size: 36,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'EGP ${product.price}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
