import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/status_bar_strip.dart';
import 'widgets/auth_hero.dart';

/// Verification Code (iPhone 17 – 9). Any 4–6 digit code is accepted in this
/// prototype.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  int _seconds = 48;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 48);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _seconds--);
      if (_seconds <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _verify() {
    if (_code.text.trim().length < 4) {
      showSnack(context, 'Enter the code we sent you');
      return;
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.shell, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: StatusBarStrip(
        color: authBackground,
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHero(showBack: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 34, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Verification Code',
                      style: AppText.l(24,
                          weight: FontWeight.w700, color: AppColors.gray900)),
                  const SizedBox(height: 18),
                  const FieldLabel('Please enter your verification code'),
                  AppTextField(
                    controller: _code,
                    hint: 'Enter code',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Verify', onPressed: _verify),
                  const SizedBox(height: 20),
                  Center(
                    child: _seconds > 0
                        ? Text('Resend code in $_seconds secs',
                            style: AppText.l(16, color: AppColors.gray700))
                        : GestureDetector(
                            onTap: () {
                              _startTimer();
                              showSnack(context, 'A new code has been sent');
                            },
                            child: Text('Resend code',
                                style: AppText.l(16,
                                    weight: FontWeight.w700,
                                    color: AppColors.pink500)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
