import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(page: DashboardRoute.page, initial: true),
        AutoRoute(page: OrderHistoryRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: OrderListRoute.page),
    AutoRoute(page: OutletListRoute.page),
    AutoRoute(page: PaymentRoute.page),
    AutoRoute(page: SelectOutletRoute.page),
    AutoRoute(page: OrderSetupRoute.page),
    AutoRoute(page: DropTicketRoute.page),
    AutoRoute(page: PaymentDetailRoute.page),
    AutoRoute(page: OrderTrackingRoute.page),
    AutoRoute(page: ActiveOrderRoute.page),
  ];
}
