import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'models.dart';

/// Single in-memory store for the prototype. Exposed to the widget tree via
/// [AppStateScope] so any screen can read/update without extra packages.
/// Swap for Provider/Riverpod/Bloc when you wire a backend.
class AppState extends ChangeNotifier {
  final List<Appointment> _appointments = MockData.appointments();
  final List<CommunityPost> _posts = MockData.posts();
  final List<Medicine> _medicines = MockData.medicines();

  // ---- Profile (filled during onboarding) ----
  String userName = MockData.userName;
  String email = '';
  String country = '';
  DateTime? lastPeriod;
  String? intention;
  String? referralSource;
  Set<String> features = {'affirmation', 'yoga', 'tools'};

  void saveProfile({
    String? name,
    String? email,
    String? country,
    DateTime? lastPeriod,
    double? weightKg,
  }) {
    if (name != null && name.trim().isNotEmpty) userName = name.trim();
    if (email != null) this.email = email.trim();
    if (country != null) this.country = country;
    if (lastPeriod != null) this.lastPeriod = lastPeriod;
    if (weightKg != null) {
      initialWeightKg = weightKg;
      _weightLog
        ..clear()
        ..add((0, weightKg));
    }
    notifyListeners();
  }

  /// Weeks since last period (min 1), used on Home.
  int get pregnancyWeek {
    final lp = lastPeriod;
    if (lp == null) return MockData.pregnancyWeek;
    final w = DateTime.now().difference(lp).inDays ~/ 7;
    return w.clamp(1, 42);
  }

  /// Due date = last period + 280 days (Naegele's rule).
  DateTime? get dueDate => lastPeriod?.add(const Duration(days: 280));

  // ---- Medicine reminder (premium) ----
  PremiumPlan? plan;
  bool get isPremium => plan != null;

  void activatePremium(PremiumPlan p) {
    plan = p;
    notifyListeners();
  }

  List<Medicine> get medicines => List.unmodifiable(_medicines);

  void addMedicine(Medicine m) {
    _medicines.insert(0, m);
    notifyListeners();
  }

  void removeMedicine(String id) {
    _medicines.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  double initialWeightKg = 70.0;
  final double idealWeightKg = 70.5;

  /// (pregnancy week, kg) entries plotted on the Discover chart.
  final List<(double, double)> _weightLog = [
    (0, 70.0),
    (0.5, 70.0),
    (1, 70.1),
    (1.5, 70.2),
  ];
  List<(double, double)> get weightLog => List.unmodifiable(_weightLog);
  double get currentWeightKg => _weightLog.last.$2;
  double get currentWeek => _weightLog.last.$1;

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<CommunityPost> get posts => List.unmodifiable(_posts);

  List<Appointment> appointmentsFor(AppointmentStatus? status) => status == null
      ? appointments
      : _appointments.where((a) => a.status == status).toList();

  void addAppointment(Appointment a) {
    _appointments.insert(0, a);
    notifyListeners();
  }

  void removeAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void addPost(String text) {
    _posts.insert(
      0,
      CommunityPost(
        initials: 'ME',
        author: 'You',
        timeAgo: 'now',
        text: text,
        likes: 0,
        comments: 0,
        accent: const Color(0xFFEF2A7F),
      ),
    );
    notifyListeners();
  }

  void toggleLike(CommunityPost post) {
    post.liked = !post.liked;
    post.likes += post.liked ? 1 : -1;
    notifyListeners();
  }

  void updateWeight(double kg) {
    _weightLog.add((_weightLog.last.$1 + 0.5, kg));
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
