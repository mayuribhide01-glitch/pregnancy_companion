import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/form_widgets.dart';
import '../../data/app_state.dart';
import 'widgets/register_scaffold.dart';

/// Step 1 — Find your delivery date (iPhone 17 – 4).
class DueDateScreen extends StatefulWidget {
  const DueDateScreen({super.key});

  @override
  State<DueDateScreen> createState() => _DueDateScreenState();
}

class _DueDateScreenState extends State<DueDateScreen> {
  DateTime? _date;

  Future<void> _pick() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.subtract(const Duration(days: 28)),
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
      helpText: 'First day of last period',
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final due = _date?.add(const Duration(days: 280));
    return RegisterScaffold(
      step: 1,
      title: 'Find your delivery date',
      subtitle: 'What was the first day of your last\nmenstrual period?',
      children: [
        const FieldLabel('Select Date', size: 16),
        PickerField(
          text: _date == null ? null : Fmt.dateField(_date!),
          hint: 'DD - MM - YYYY',
          icon: Icons.calendar_today_outlined,
          radius: 6,
          borderColor: AppColors.gray300,
          onTap: _pick,
        ),
        if (due != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.pink50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.child_friendly_rounded,
                    color: AppColors.pink500),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Estimated due date: ${Fmt.date(due)}',
                      style: AppText.l(15,
                          weight: FontWeight.w700, color: AppColors.pink600)),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Continue',
          onPressed: _date == null
              ? null
              : () {
                  AppStateScope.of(context).saveProfile(lastPeriod: _date);
                  Navigator.of(context).pushNamed(Routes.details);
                },
        ),
        const SizedBox(height: 22),
        PromptLink(
          prompt: 'Have an account?',
          action: 'Login',
          onTap: () => Navigator.of(context)
              .popUntil(ModalRoute.withName(Routes.login)),
        ),
      ],
    );
  }
}

/// Step 2 — Enter your details (iPhone 17 – 7).
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _weight = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _weight]) {
      c.dispose();
    }
    super.dispose();
  }

  void _continue() {
    if (_name.text.trim().isEmpty ||
        !_email.text.contains('@') ||
        _password.text.length < 6) {
      showSnack(context,
          'Add your name, a valid email and a password (6+ characters)');
      return;
    }
    AppStateScope.of(context).saveProfile(
      name: _name.text,
      email: _email.text,
      weightKg: double.tryParse(_weight.text),
    );
    Navigator.of(context).pushNamed(Routes.country);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: 2,
      title: 'Enter your details',
      subtitle: 'Fill in the information below to\ncreate your account',
      children: [
        const FieldLabel('Full Name', size: 16),
        AppTextField(
            controller: _name, hint: 'Full name', radius: 6,
            borderColor: AppColors.gray300,
            textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        const FieldLabel('Email Address', size: 16),
        AppTextField(
            controller: _email,
            hint: 'Email Address',
            radius: 6,
            borderColor: AppColors.gray300,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        const FieldLabel('Enter Password', size: 16),
        AppTextField(
            controller: _password,
            hint: 'Password',
            password: true,
            radius: 6,
            borderColor: AppColors.gray300),
        const SizedBox(height: 20),
        const FieldLabel('Pregnancy weight in Kg/lbs', size: 16),
        AppTextField(
          controller: _weight,
          hint: 'Enter weight',
          radius: 6,
          borderColor: AppColors.gray300,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
        const SizedBox(height: 30),
        PrimaryButton(label: 'Continue', onPressed: _continue),
      ],
    );
  }
}

/// Step 3 — Country (the frame lists "Country *" / "Select Country").
class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  static const countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'United Arab Emirates',
    'Singapore',
    'Other',
  ];
  String? _country;

  Future<void> _pick() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final c in countries)
              ListTile(
                title: Text(c, style: AppText.l(16)),
                trailing: c == _country
                    ? const Icon(Icons.check_rounded, color: AppColors.pink500)
                    : null,
                onTap: () => Navigator.pop(ctx, c),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _country = picked);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: 3,
      title: 'Where are you based?',
      subtitle: 'We use this to show local guidance\nand care resources',
      children: [
        const FieldLabel('Country *', size: 16),
        PickerField(
          text: _country,
          hint: 'Select Country',
          icon: Icons.keyboard_arrow_down_rounded,
          radius: 6,
          borderColor: AppColors.gray300,
          onTap: _pick,
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          label: 'Create Account',
          onPressed: _country == null
              ? null
              : () {
                  AppStateScope.of(context).saveProfile(country: _country);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.shell, (r) => false);
                },
        ),
      ],
    );
  }
}
