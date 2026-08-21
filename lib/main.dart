import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/constants/theme.dart';
import 'features/auth/buyer_approval_view.dart';
import 'features/auth/buyer_login_view.dart';
import 'features/buyer_main_navigation.dart';
import 'state/buyer_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const AisleyBuyerApp(),
    ),
  );
}

class AisleyBuyerApp extends StatefulWidget {
  const AisleyBuyerApp({super.key});

  @override
  State<AisleyBuyerApp> createState() => _AisleyBuyerAppState();
}

class _AisleyBuyerAppState extends State<AisleyBuyerApp> {
  late final BuyerState _buyerState;

  @override
  void initState() {
    super.initState();
    _buyerState = BuyerState();
  }

  @override
  void dispose() {
    _buyerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BuyerStateProvider(
      notifier: _buyerState,
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    final state = BuyerStateProvider.of(context);

    return MaterialApp(
      title: 'Aisley — Philippine Luxury Marketplace',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AisleyTheme.lightTheme,
      darkTheme: AisleyTheme.darkTheme,
      themeMode: state.themeMode,
      home: _buildCurrentScreen(state.authState),
    );
  }

  Widget _buildCurrentScreen(AuthState authState) {
    switch (authState) {
      case AuthState.unauthenticated:
        return const BuyerLoginView();
      case AuthState.pendingApproval:
        return const BuyerApprovalView();
      case AuthState.approved:
        return const BuyerMainNavigation();
    }
  }
}
