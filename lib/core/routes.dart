/// Named routes. Tab screens (home/tools/discover/community/profile) live in
/// the shell; everything else is pushed on top of it.
class Routes {
  Routes._();

  // Onboarding
  static const splash = '/';
  static const login = '/login';
  static const otp = '/otp';
  static const intention = '/onboarding/intention';
  static const source = '/onboarding/source';
  static const features = '/onboarding/features';
  static const dueDate = '/register/due-date';
  static const details = '/register/details';
  static const country = '/register/country';

  // Main app
  static const shell = '/home';
  static const appointments = '/appointments';
  static const addAppointment = '/appointments/add';

  // Medical reminder (premium)
  static const medPaywall = '/medicine/premium';
  static const medPayment = '/medicine/payment';
  static const medSuccess = '/medicine/success';
  static const medList = '/medicine';
  static const medAdd = '/medicine/add';

  /// Pseudo-route: switches the shell to the Discover tab.
  static const discover = '#discover';

  /// Pseudo-route: opens the reminder list, or the paywall if not premium.
  static const medicine = '#medicine';
}
