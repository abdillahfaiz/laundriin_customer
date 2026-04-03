// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:laundriin_customer/features/auth/presentation/pages/login_page.dart'
    as _i4;
import 'package:laundriin_customer/features/auth/presentation/pages/register_page.dart'
    as _i14;
import 'package:laundriin_customer/features/auth/presentation/pages/splash_page.dart'
    as _i16;
import 'package:laundriin_customer/features/dashboard/presentation/pages/dashboard_page.dart'
    as _i2;
import 'package:laundriin_customer/features/main_nav/presentation/pages/main_page.dart'
    as _i5;
import 'package:laundriin_customer/features/order/domain/entities/order.dart'
    as _i19;
import 'package:laundriin_customer/features/order/presentation/pages/active_order_page.dart'
    as _i1;
import 'package:laundriin_customer/features/order/presentation/pages/drop_ticket_page.dart'
    as _i3;
import 'package:laundriin_customer/features/order/presentation/pages/order_history_page.dart'
    as _i6;
import 'package:laundriin_customer/features/order/presentation/pages/order_list_page.dart'
    as _i7;
import 'package:laundriin_customer/features/order/presentation/pages/order_setup_page.dart'
    as _i8;
import 'package:laundriin_customer/features/order/presentation/pages/order_tracking_page.dart'
    as _i9;
import 'package:laundriin_customer/features/order/presentation/pages/select_outlet_page.dart'
    as _i15;
import 'package:laundriin_customer/features/outlet/presentation/pages/outlet_list_page.dart'
    as _i10;
import 'package:laundriin_customer/features/payment/presentation/pages/payment_detail_page.dart'
    as _i11;
import 'package:laundriin_customer/features/payment/presentation/pages/payment_page.dart'
    as _i12;
import 'package:laundriin_customer/features/profile/presentation/pages/profile_page.dart'
    as _i13;

/// generated route for
/// [_i1.ActiveOrderPage]
class ActiveOrderRoute extends _i17.PageRouteInfo<void> {
  const ActiveOrderRoute({List<_i17.PageRouteInfo>? children})
    : super(ActiveOrderRoute.name, initialChildren: children);

  static const String name = 'ActiveOrderRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActiveOrderPage();
    },
  );
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i17.PageRouteInfo<void> {
  const DashboardRoute({List<_i17.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardPage();
    },
  );
}

/// generated route for
/// [_i3.DropTicketPage]
class DropTicketRoute extends _i17.PageRouteInfo<DropTicketRouteArgs> {
  DropTicketRoute({
    _i18.Key? key,
    required String transactionId,
    required String qrCode,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         DropTicketRoute.name,
         args: DropTicketRouteArgs(
           key: key,
           transactionId: transactionId,
           qrCode: qrCode,
         ),
         initialChildren: children,
       );

  static const String name = 'DropTicketRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DropTicketRouteArgs>();
      return _i3.DropTicketPage(
        key: args.key,
        transactionId: args.transactionId,
        qrCode: args.qrCode,
      );
    },
  );
}

class DropTicketRouteArgs {
  const DropTicketRouteArgs({
    this.key,
    required this.transactionId,
    required this.qrCode,
  });

  final _i18.Key? key;

  final String transactionId;

  final String qrCode;

  @override
  String toString() {
    return 'DropTicketRouteArgs{key: $key, transactionId: $transactionId, qrCode: $qrCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DropTicketRouteArgs) return false;
    return key == other.key &&
        transactionId == other.transactionId &&
        qrCode == other.qrCode;
  }

  @override
  int get hashCode => key.hashCode ^ transactionId.hashCode ^ qrCode.hashCode;
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.MainPage]
class MainRoute extends _i17.PageRouteInfo<void> {
  const MainRoute({List<_i17.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainPage();
    },
  );
}

/// generated route for
/// [_i6.OrderHistoryPage]
class OrderHistoryRoute extends _i17.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i17.PageRouteInfo>? children})
    : super(OrderHistoryRoute.name, initialChildren: children);

  static const String name = 'OrderHistoryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.OrderHistoryPage();
    },
  );
}

/// generated route for
/// [_i7.OrderListPage]
class OrderListRoute extends _i17.PageRouteInfo<void> {
  const OrderListRoute({List<_i17.PageRouteInfo>? children})
    : super(OrderListRoute.name, initialChildren: children);

  static const String name = 'OrderListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.OrderListPage();
    },
  );
}

/// generated route for
/// [_i8.OrderSetupPage]
class OrderSetupRoute extends _i17.PageRouteInfo<OrderSetupRouteArgs> {
  OrderSetupRoute({
    _i18.Key? key,
    required String outletId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         OrderSetupRoute.name,
         args: OrderSetupRouteArgs(key: key, outletId: outletId),
         initialChildren: children,
       );

  static const String name = 'OrderSetupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSetupRouteArgs>();
      return _i8.OrderSetupPage(key: args.key, outletId: args.outletId);
    },
  );
}

class OrderSetupRouteArgs {
  const OrderSetupRouteArgs({this.key, required this.outletId});

  final _i18.Key? key;

  final String outletId;

  @override
  String toString() {
    return 'OrderSetupRouteArgs{key: $key, outletId: $outletId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderSetupRouteArgs) return false;
    return key == other.key && outletId == other.outletId;
  }

  @override
  int get hashCode => key.hashCode ^ outletId.hashCode;
}

/// generated route for
/// [_i9.OrderTrackingPage]
class OrderTrackingRoute extends _i17.PageRouteInfo<OrderTrackingRouteArgs> {
  OrderTrackingRoute({
    _i18.Key? key,
    required String orderId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         OrderTrackingRoute.name,
         args: OrderTrackingRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'OrderTrackingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderTrackingRouteArgs>();
      return _i9.OrderTrackingPage(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderTrackingRouteArgs {
  const OrderTrackingRouteArgs({this.key, required this.orderId});

  final _i18.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderTrackingRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderTrackingRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [_i10.OutletListPage]
class OutletListRoute extends _i17.PageRouteInfo<void> {
  const OutletListRoute({List<_i17.PageRouteInfo>? children})
    : super(OutletListRoute.name, initialChildren: children);

  static const String name = 'OutletListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.OutletListPage();
    },
  );
}

/// generated route for
/// [_i11.PaymentDetailPage]
class PaymentDetailRoute extends _i17.PageRouteInfo<PaymentDetailRouteArgs> {
  PaymentDetailRoute({
    _i18.Key? key,
    required String orderId,
    required String paymentId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         PaymentDetailRoute.name,
         args: PaymentDetailRouteArgs(
           key: key,
           orderId: orderId,
           paymentId: paymentId,
         ),
         initialChildren: children,
       );

  static const String name = 'PaymentDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentDetailRouteArgs>();
      return _i11.PaymentDetailPage(
        key: args.key,
        orderId: args.orderId,
        paymentId: args.paymentId,
      );
    },
  );
}

class PaymentDetailRouteArgs {
  const PaymentDetailRouteArgs({
    this.key,
    required this.orderId,
    required this.paymentId,
  });

  final _i18.Key? key;

  final String orderId;

  final String paymentId;

  @override
  String toString() {
    return 'PaymentDetailRouteArgs{key: $key, orderId: $orderId, paymentId: $paymentId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PaymentDetailRouteArgs) return false;
    return key == other.key &&
        orderId == other.orderId &&
        paymentId == other.paymentId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode ^ paymentId.hashCode;
}

/// generated route for
/// [_i12.PaymentPage]
class PaymentRoute extends _i17.PageRouteInfo<PaymentRouteArgs> {
  PaymentRoute({
    _i18.Key? key,
    required _i19.Order order,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         PaymentRoute.name,
         args: PaymentRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'PaymentRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentRouteArgs>();
      return _i12.PaymentPage(key: args.key, order: args.order);
    },
  );
}

class PaymentRouteArgs {
  const PaymentRouteArgs({this.key, required this.order});

  final _i18.Key? key;

  final _i19.Order order;

  @override
  String toString() {
    return 'PaymentRouteArgs{key: $key, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PaymentRouteArgs) return false;
    return key == other.key && order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ order.hashCode;
}

/// generated route for
/// [_i13.ProfilePage]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfilePage();
    },
  );
}

/// generated route for
/// [_i14.RegisterPage]
class RegisterRoute extends _i17.PageRouteInfo<void> {
  const RegisterRoute({List<_i17.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.RegisterPage();
    },
  );
}

/// generated route for
/// [_i15.SelectOutletPage]
class SelectOutletRoute extends _i17.PageRouteInfo<void> {
  const SelectOutletRoute({List<_i17.PageRouteInfo>? children})
    : super(SelectOutletRoute.name, initialChildren: children);

  static const String name = 'SelectOutletRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.SelectOutletPage();
    },
  );
}

/// generated route for
/// [_i16.SplashPage]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.SplashPage();
    },
  );
}
