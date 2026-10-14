import 'package:flutter/material.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

extension AppointmentStatusX on AppointmentStatus {
  String get label => switch (this) {
        AppointmentStatus.upcoming => 'Upcoming',
        AppointmentStatus.completed => 'Completed',
        AppointmentStatus.cancelled => 'Cancelled',
      };
}

class Appointment {
  Appointment({
    required this.id,
    required this.provider,
    required this.specialty,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    this.notes = '',
  });

  final String id;
  final String provider;
  final String specialty;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final AppointmentStatus status;
  final String notes;
}

class CommunityPost {
  CommunityPost({
    required this.initials,
    required this.author,
    required this.timeAgo,
    required this.text,
    required this.likes,
    required this.comments,
    required this.accent,
    this.liked = false,
  });

  final String initials;
  final String author;
  final String timeAgo;
  final String text;
  int likes;
  final int comments;
  final Color accent;
  bool liked;
}

class ToolItem {
  const ToolItem(this.title, this.image, {this.route, this.darkScrim = false});
  final String title;
  final String image;
  final String? route;
  final bool darkScrim;
}

class MediaItem {
  const MediaItem(this.title, this.subtitle, this.image);
  final String title;
  final String subtitle;
  final String image;
}

class WebinarItem {
  const WebinarItem(this.tag, this.title, this.meta, this.gradient);
  final String tag;
  final String title;
  final String meta;
  final List<Color> gradient;
}

class Mood {
  const Mood(this.label, this.asset, this.background);
  final String label;
  final String asset;
  final Color background;
}

class ActivityCategory {
  const ActivityCategory(this.title, this.done, this.total, this.image);
  final String title;
  final int done;
  final int total;
  final String image;
}

enum PremiumPlan { monthly, annual, lifetime }

extension PremiumPlanX on PremiumPlan {
  String get label => switch (this) {
        PremiumPlan.monthly => 'Monthly',
        PremiumPlan.annual => 'Annual',
        PremiumPlan.lifetime => 'Lifetime',
      };

  /// Amount charged after the trial (or once, for lifetime).
  double get charge => switch (this) {
        PremiumPlan.monthly => 4.99,
        PremiumPlan.annual => 35.99,
        PremiumPlan.lifetime => 79.99,
      };

  bool get hasTrial => this != PremiumPlan.lifetime;

  String get summary => switch (this) {
        PremiumPlan.monthly => 'Monthly plan - \$4.99/month',
        PremiumPlan.annual => 'Annual plan - \$35.99/year',
        PremiumPlan.lifetime => 'Lifetime - \$79.99 one-time',
      };
}

class Medicine {
  Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.form,
    required this.times,
    required this.frequency,
    required this.color,
    required this.since,
    this.notes = '',
  });

  final String id;
  final String name;

  /// e.g. "325 mg"
  final String dose;
  final String form;
  final List<TimeOfDay> times;

  /// e.g. "1×/day"
  final String frequency;
  final Color color;
  final DateTime since;
  final String notes;
}

class LessonItem {
  const LessonItem(this.emoji, this.title, this.minutes, this.gradient);
  final String emoji;
  final String title;
  final int minutes;
  final List<Color> gradient;
}
