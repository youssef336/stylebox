import 'package:get_it/get_it.dart';
import 'package:stylebox/core/repos/ordres_repo/orders_repo.dart';
import 'package:stylebox/core/repos/ordres_repo/orders_repo_impl.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'package:stylebox/core/repos/product_repo/product_repo_impl.dart';
import 'package:stylebox/core/services/database_servies.dart';
import 'package:stylebox/core/services/firebase_auth_services.dart';
import 'package:stylebox/core/services/firestore_services.dart';
import 'package:stylebox/features/auth/data/repos/auth_repo_implemtation.dart';
import 'package:stylebox/features/auth/domains/repos/auth_repo.dart';
import 'package:stylebox/features/home/data/repos/product_reviews_repo_impl.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<FirebaseAuthServices>(
    () => FirebaseAuthServices(),
  );
  getIt.registerLazySingleton<DatabaseServies>(() => FirestoreServices());
  getIt.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(getIt<DatabaseServies>()),
  );
  getIt.registerLazySingleton<ProductReviewsRepo>(
    () => ProductReviewsRepoImpl(
      firestore: (getIt<DatabaseServies>() as FirestoreServices).firestore,
    ),
  );
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImpl(databaseServies: getIt<DatabaseServies>()),
  );
  // getIt.registerLazySingleton<NotificationRepo>(
  //   () => NotificationRepoImpl(getIt<DatabaseServies>()),
  // );
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImplemtation(
      databaseServies: getIt<DatabaseServies>(),
      firebaseAuthServices: getIt<FirebaseAuthServices>(),
    ),
  );
}
