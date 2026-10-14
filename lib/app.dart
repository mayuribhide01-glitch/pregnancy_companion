import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/routes.dart';
import 'core/theme/app_theme.dart';
import 'data/app_state.dart';
import 'features/appointments/add_appointment_screen.dart';
import 'features/appointments/appointment_tracker_screen.dart';
import 'features/medicine/add_medicine_screen.dart';
import 'features/medicine/medicine_list_screen.dart';
import 'features/medicine/payment_screen.dart';
import 'features/medicine/paywall_screen.dart';
import 'features/medicine/premium_success_screen.dart';
import 'features/onboarding/features_screen.dart';
import 'features/onboarding/intention_screen.dart';
import 'features/onboarding/login_screen.dart';
import 'features/onboarding/otp_screen.dart';
import 'features/onboarding/register_screens.dart';
import 'features/onboarding/source_screen.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/shell/main_shell.dart';

class PregnancyCompanionApp extends StatefulWidget {
  const PregnancyCompanionApp({super.key, this.initialRoute = Routes.splash});

  /// Tests start at [Routes.shell] to skip onboarding.
  final String initialRoute;

  @override
  State<PregnancyCompanionApp> createState() => _PregnancyCompanionAppState();
}

class _PregnancyCompanionAppState extends State<PregnancyCompanionApp> {
  final _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _state,
      child: MaterialApp(
        title: 'Pregnancy Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: widget.initialRoute,
        // Start on exactly one route (Flutter would otherwise also stack '/'
        // underneath deep initial routes like '/home').
        onGenerateInitialRoutes: (name) => [
          MaterialPageRoute<void>(
            settings: RouteSettings(name: name),
            builder: _routes[name] ?? _routes[Routes.splash]!,
          ),
        ],
        routes: _routes,
        // Keeps the phone-sized layout centred when run on web/desktop.
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: appSystemUiStyle,
          child: _StatusBarSpace(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  static final Map<String, WidgetBuilder> _routes = {
    // Onboarding
    Routes.splash: (_) => const SplashScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.otp: (_) => const OtpScreen(),
    Routes.intention: (_) => const IntentionScreen(),
    Routes.source: (_) => const SourceScreen(),
    Routes.features: (_) => const FeaturesScreen(),
    Routes.dueDate: (_) => const DueDateScreen(),
    Routes.details: (_) => const DetailsScreen(),
    Routes.country: (_) => const CountryScreen(),
    // Main app
    Routes.shell: (_) => const MainShell(),
    Routes.appointments: (_) => const AppointmentTrackerScreen(),
    Routes.addAppointment: (_) => const AddAppointmentScreen(),
    // Medical reminder
    Routes.medPaywall: (_) => const PaywallScreen(),
    Routes.medPayment: (_) => const PaymentScreen(),
    Routes.medSuccess: (_) => const PremiumSuccessScreen(),
    Routes.medList: (_) => const MedicineListScreen(),
    Routes.medAdd: (_) => const AddMedicineScreen(),
  };
}

/// Guarantees a status-bar gap at the top of every screen — at least
/// [minTop] (the 48 px status bar from the Figma frames), or the phone's real
/// status-bar height if that is taller. Screens read it via
/// `MediaQuery.paddingOf(context).top`, `SafeArea` and `StatusBarStrip`.
class _StatusBarSpace extends StatelessWidget {
  const _StatusBarSpace({required this.child});

  final Widget child;
  static const minTop = 48.0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final top = math.max(mq.padding.top, minTop);
    return MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(top: top),
        viewPadding:
            mq.viewPadding.copyWith(top: math.max(mq.viewPadding.top, top)),
      ),
      child: ColoredBox(
        color: const Color(0xFFF4F1F6),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            // Keep everything above the Android gesture / nav bar.
            child: ColoredBox(
              color: Colors.white,
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
f5