import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Auth ──
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/update_fcm_token.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
// ── Order ──
import '../../features/order/data/datasources/order_remote_datasource.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/create_order.dart';
import '../../features/order/domain/usecases/get_active_orders.dart';
import '../../features/order/domain/usecases/get_order_detail.dart';
import '../../features/order/domain/usecases/get_order_history.dart';
import '../../features/order/domain/usecases/get_user_orders.dart';
import '../../features/order/presentation/cubit/order_cubit.dart';
// ── Outlet ──
import '../../features/outlet/data/datasources/outlet_remote_datasource.dart';
import '../../features/outlet/data/repositories/outlet_repository_impl.dart';
import '../../features/outlet/domain/repositories/outlet_repository.dart';
import '../../features/outlet/domain/usecases/check_coverage_area.dart';
import '../../features/outlet/domain/usecases/get_durasi_per_item.dart';
import '../../features/outlet/domain/usecases/get_jenis_by_item.dart';
import '../../features/outlet/domain/usecases/get_nearby_outlets.dart';
import '../../features/outlet/domain/usecases/get_outlet_durasi.dart';
import '../../features/outlet/domain/usecases/get_outlet_items.dart';
import '../../features/outlet/domain/usecases/get_outlet_layanan.dart';
import '../../features/outlet/domain/usecases/get_outlet_parfum.dart';
import '../../features/outlet/presentation/cubit/outlet_cubit.dart';
// ── Payment ──
import '../../features/payment/data/datasources/payment_remote_datasource.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/check_payment_status.dart';
import '../../features/payment/domain/usecases/create_payment.dart';
import '../../features/payment/domain/usecases/get_payment_detail.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../routes/app_router.dart';

/// Service Locator (GetIt) instance.
final sl = GetIt.instance;

/// Inisialisasi semua dependency.
///
/// Dipanggil sekali saat aplikasi pertama kali dibuka.
Future<void> init() async {
  // ──────────────────────────────────────────────────────
  // External Dependencies
  // ──────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // ──────────────────────────────────────────────────────
  // Core
  // ──────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  sl.registerLazySingleton(() => ApiClient(dio: sl(), sharedPreferences: sl()));

  // Custom router
  sl.registerLazySingleton(() => AppRouter());

  // ──────────────────────────────────────────────────────
  // Auth Feature
  // ──────────────────────────────────────────────────────

  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      updateFcmTokenUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => UpdateFcmToken(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ──────────────────────────────────────────────────────
  // Outlet Feature
  // ──────────────────────────────────────────────────────

  // Cubit
  sl.registerFactory(
    () => OutletCubit(
      getNearbyOutletsUseCase: sl(),
      checkCoverageAreaUseCase: sl(),
      getOutletLayananPerKgUseCase: sl(),
      getOutletDurasiPerKgUseCase: sl(),
      getOutletParfumUseCase: sl(),
      getOutletItemsPerItemUseCase: sl(),
      getJenisByItemUseCase: sl(),
      getDurasiPerItemUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNearbyOutlets(sl()));
  sl.registerLazySingleton(() => CheckCoverageArea(sl()));
  sl.registerLazySingleton(() => GetOutletLayananPerKg(sl()));
  sl.registerLazySingleton(() => GetOutletDurasiPerKg(sl()));
  sl.registerLazySingleton(() => GetOutletParfum(sl()));
  sl.registerLazySingleton(() => GetOutletItemsPerItem(sl()));
  sl.registerLazySingleton(() => GetJenisByItem(sl()));
  sl.registerLazySingleton(() => GetDurasiPerItem(sl()));

  // Repository
  sl.registerLazySingleton<OutletRepository>(
    () => OutletRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<OutletRemoteDataSource>(
    () => OutletRemoteDataSourceImpl(dio: sl()),
  );

  // ──────────────────────────────────────────────────────
  // Order Feature
  // ──────────────────────────────────────────────────────

  // Cubit
  sl.registerFactory(
    () => OrderCubit(
      createOrderUseCase: sl(),
      getUserOrdersUseCase: sl(),
      getActiveOrdersUseCase: sl(),
      getOrderDetailUseCase: sl(),
      getOrderHistoryUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateOrder(sl()));
  sl.registerLazySingleton(() => GetUserOrders(sl()));
  sl.registerLazySingleton(() => GetActiveOrders(sl()));
  sl.registerLazySingleton(() => GetOrderDetail(sl()));
  sl.registerLazySingleton(() => GetOrderHistory(sl()));

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(dio: sl()),
  );

  // ──────────────────────────────────────────────────────
  // Payment Feature
  // ──────────────────────────────────────────────────────

  // Cubit
  sl.registerFactory(
    () => PaymentCubit(
      createPaymentUseCase: sl(),
      getPaymentDetailUseCase: sl(),
      checkPaymentStatusUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreatePayment(sl()));
  sl.registerLazySingleton(() => GetPaymentDetail(sl()));
  sl.registerLazySingleton(() => CheckPaymentStatus(sl()));

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl()),
  );
}
