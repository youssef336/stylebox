import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_cubit.dart';
import 'package:stylebox_dashboard/features/dashboard/view/widgets/dashboard_view_body.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/cubit/restaurant_cubit.dart';

class DashboardView extends StatelessWidget {
  static const routeName = 'dashboard';

  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(getIt())),
        // Feeds the overview stats and the "Your stores" list.
        BlocProvider(
          create: (_) {
            final cubit = RestaurantCubit(
              fetchRestaurantsUseCase: getIt(),
              addRestaurantUseCase: getIt(),
              updateRestaurantUseCase: getIt(),
              deleteRestaurantUseCase: getIt(),
              uploadImageUseCase: getIt(),
            );
            if (UserSession.instance.isLoggedIn) {
              cubit.fetchRestaurants(UserSession.instance.currentEmail);
            }
            return cubit;
          },
        ),
      ],
      child: const DashboardViewBody(),
    );
  }
}
