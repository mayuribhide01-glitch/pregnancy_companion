import 'package:flutter/material.dart';

import '../core/routes.dart';
import 'models.dart';

/// Static content mirrored from the Figma screens. Swap these for API calls
/// later — the screens only depend on the model classes.
class MockData {
  MockData._();

  static const userName = 'Ananya';
  static const pregnancyWeek = 1;

  static const tools = <ToolItem>[
    ToolItem('Appointment\nTracker', 'assets/images/tools/appointment_tracker.jpg',
        route: Routes.appointments),
    ToolItem('Water Intake\nTracker', 'assets/images/tools/water_intake.jpg'),
    ToolItem('Medicine\nReminder', 'assets/images/tools/medicine_reminder.jpg',
        route: Routes.medicine),
    ToolItem('Hospital Bag\nChecklist', 'assets/images/tools/hospital_bag.jpg'),
    ToolItem('Baby Kick\nCounter', 'assets/images/tools/baby_kick_counter.jpg'),
    ToolItem('Weight Gain\nTracker', 'assets/images/tools/weight_gain.jpg',
        route: Routes.discover),
    ToolItem('Protein Intake\nTracker', 'assets/images/tools/protein_intake.jpg'),
    ToolItem('Vitamin &\nMineral Intake',
        'assets/images/tools/vitamin_mineral.jpg'),
    ToolItem('Helpful\nResources', 'assets/images/tools/helpful_resources.jpg',
        darkScrim: true),
    ToolItem('Glucose\nTracker', 'assets/images/tools/glucose_tracker.jpg'),
  ];

  static const relaxation = <MediaItem>[
    MediaItem('Gentle Morning Stretch', 'Start your day with calm',
        'assets/images/relax/morning_stretch.jpg'),
    MediaItem('Relaxation Activity — Painting, A Love Letter',
        '15 min · Creative', 'assets/images/relax/painting.jpg'),
    MediaItem('Relaxation — Nature Walk', '20 min · Outdoors',
        'assets/images/relax/nature_walk.jpg'),
    MediaItem('Watercolour for Two', '30 min · Creative',
        'assets/images/relax/watercolour.jpg'),
  ];

  static const webinars = <WebinarItem>[
    WebinarItem('Pain Relief', 'Pregnancy Pain Relief Workshop',
        'Dr. Sarah Mills · 45 mins',
        [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFFA855F7)]),
    WebinarItem('Wellness', 'Strong Care During Pregnancy',
        'Dr. Priya Nair · 30 mins',
        [Color(0xFF0EA5E9), Color(0xFF6366F1), Color(0xFFA855F7)]),
    WebinarItem('Nutrition', 'Nutrition for Two', 'Maya Chen, RD · 25 mins',
        [Color(0xFFF43F8E), Color(0xFFC026D3), Color(0xFF7C3AED)]),
  ];

  static const stories = <MediaItem>[
    MediaItem('A Beautiful Beginning', '',
        'assets/images/stories/beautiful_beginning.jpg'),
    MediaItem('Our Tiny Miracle', '', 'assets/images/stories/tiny_miracle.jpg'),
    MediaItem('Pure Joy', '', 'assets/images/stories/pure_joy.jpg'),
    MediaItem('First Embrace', '', 'assets/images/stories/first_embrace.jpg'),
  ];

  static const moods = <Mood>[
    Mood('Disgust', 'assets/images/moods/disgust.png', Color(0xFFCCEAB9)),
    Mood('Calm', 'assets/images/moods/calm.png', Color(0xFFD1FAE5)),
    Mood('Nervous', 'assets/images/moods/nervous.png', Color(0xFFE8D5F5)),
    Mood('Sad', 'assets/images/moods/sad.png', Color(0xFFCFFAFE)),
    Mood('Fear', 'assets/images/moods/fear.png', Color(0xFFFEE2E2)),
    Mood('Happy', 'assets/images/moods/happy.png', Color(0xFFFEFFD9)),
    Mood('Grateful', 'assets/images/moods/grateful.png', Color(0xFFFEF9C3)),
    Mood('Motivated', 'assets/images/moods/motivated.png', Color(0xFFDCFCE7)),
  ];

  static const activities = <ActivityCategory>[
    ActivityCategory(
        'Physical Wellness', 0, 1, 'assets/images/home/physical_wellness.jpg'),
    ActivityCategory('Emotional Well-being', 0, 1,
        'assets/images/home/emotional_wellbeing.jpg'),
    ActivityCategory('Spiritual Practices', 0, 2,
        'assets/images/home/spiritual_practices.jpg'),
    ActivityCategory(
        'Cognitive Ability', 0, 2, 'assets/images/home/cognitive_ability.jpg'),
  ];

  static const lessons = <LessonItem>[
    LessonItem('🌸', 'Holistic Pregnancy Journey', 2,
        [Color(0xFFE8D5F5), Color(0xFFC084FC)]),
    LessonItem('🌺', 'Rewriting the Story', 5,
        [Color(0xFFFCE7F3), Color(0xFFF472B6)]),
    LessonItem('🌼', 'The Holistic Connection', 2,
        [Color(0xFFDBEAFE), Color(0xFF93C5FD)]),
    LessonItem('🌷', 'Living It Daily', 2,
        [Color(0xFFFCE7F3), Color(0xFFF9A8D4)]),
  ];

  static List<Appointment> appointments() => [
        Appointment(
          id: 'a1',
          provider: 'Dr. Sarah Mills',
          specialty: 'OB-GYN',
          date: DateTime(2026, 8, 10),
          time: const TimeOfDay(hour: 10, minute: 0),
          location: 'City Maternity Clinic',
          status: AppointmentStatus.upcoming,
          notes: 'Routine check-up',
        ),
        Appointment(
          id: 'a2',
          provider: 'Dr. Priya Nair',
          specialty: 'Ultrasound',
          date: DateTime(2026, 8, 18),
          time: const TimeOfDay(hour: 14, minute: 30),
          location: 'Radiology Centre, Block B',
          status: AppointmentStatus.upcoming,
          notes: '20-week anatomy scan',
        ),
        Appointment(
          id: 'a3',
          provider: 'Lab – Bloom Path',
          specialty: 'Blood Test',
          date: DateTime(2026, 7, 22),
          time: const TimeOfDay(hour: 8, minute: 0),
          location: 'PathCare Lab, Main St',
          status: AppointmentStatus.completed,
          notes: 'Iron & glucose panel',
        ),
      ];

  static List<Medicine> medicines() => [
        Medicine(
          id: 'm1',
          name: 'Gynac Medicines',
          dose: '1 mg',
          form: 'Tablet',
          times: const [TimeOfDay(hour: 8, minute: 0)],
          frequency: '1×/day',
          color: const Color(0xFF10B981),
          since: DateTime(2026, 8, 3),
          notes: 'Take with food',
        ),
        Medicine(
          id: 'm2',
          name: 'Iron Supplement',
          dose: '325 mg',
          form: 'Tablet',
          times: const [
            TimeOfDay(hour: 8, minute: 0),
            TimeOfDay(hour: 20, minute: 0),
          ],
          frequency: '2×/day',
          color: const Color(0xFFD51065),
          since: DateTime(2026, 8, 3),
        ),
      ];

  static List<CommunityPost> posts() => [
        CommunityPost(
            initials: 'BP',
            author: 'Babita Pathak',
            timeAgo: '2w ago',
            text: 'I am having coughing now, what should I do?',
            likes: 0,
            comments: 0,
            accent: const Color(0xFF7C3AED)),
        CommunityPost(
            initials: 'AG',
            author: 'Amy Guerra',
            timeAgo: '5d ago',
            text: 'What actually helped with back pain during pregnancy?',
            likes: 5,
            comments: 7,
            accent: const Color(0xFF0EA5E9)),
        CommunityPost(
            initials: 'MD',
            author: 'Morgen Dennis',
            timeAgo: '3d ago',
            text:
                "Tips for sleeping in the third trimester? I can't seem to get comfortable at all 😩",
            likes: 7,
            comments: 7,
            accent: const Color(0xFF10B981)),
        CommunityPost(
            initials: 'AR',
            author: 'Arju',
            timeAgo: '2m ago',
            text:
                "Anyone else feeling anxious about labor even though it's months away?",
            likes: 4,
            comments: 7,
            accent: const Color(0xFFF59E0B)),
        CommunityPost(
            initials: 'PS',
            author: 'Priya Sharma',
            timeAgo: '1h ago',
            text:
                'Just hit 20 weeks! 🎉 Any must-do things for the second half?',
            likes: 12,
            comments: 3,
            accent: const Color(0xFFEC4899)),
        CommunityPost(
            initials: 'SR',
            author: 'Sunita Rao',
            timeAgo: '30m ago',
            text:
                'My doctor recommended iron supplements but they upset my stomach. Any tips?',
            likes: 2,
            comments: 4,
            accent: const Color(0xFF6366F1)),
      ];
}
