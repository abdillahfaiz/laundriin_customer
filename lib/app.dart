import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/order/presentation/cubit/order_cubit.dart';
import 'features/outlet/presentation/cubit/outlet_cubit.dart';
import 'features/payment/presentation/cubit/payment_cubit.dart';

/// Root widget aplikasi Laundriin Customer.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider<OutletCubit>(create: (_) => di.sl<OutletCubit>()),
        BlocProvider<OrderCubit>(create: (_) => di.sl<OrderCubit>()),
        BlocProvider<PaymentCubit>(create: (_) => di.sl<PaymentCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Laundriin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: di.sl<AppRouter>().config(),
      ),
    );
  }
}
