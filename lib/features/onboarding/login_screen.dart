import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/form_widgets.dart';
import '../../data/app_state.dart';
import '../../core/widgets/status_bar_strip.dart';
import 'widgets/auth_hero.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    final email = _email.text.trim();
    if (!email.contains('@') || _password.text.isEmpty) {
      showSnack(context, 'Enter your email address and password');
      return;
    }
    AppStateScope.of(context).saveProfile(email: email);
    Navigator.of(context).pushNamed(Routes.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: StatusBarStrip(
        color: authBackground,
        child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 38, 16, 32),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Login',
                        style: AppText.l(24,
                            weight: FontWeight.w700,
                            color: AppColors.gray900)),
                    const SizedBox(height: 22),
                    const FieldLabel('Email Address'),
                    AppTextField(
                      controller: _email,
                      hint: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: 22),
                    const FieldLabel('Enter Password'),
                    AppTextField(
                      controller: _password,
                      hint: 'Password',
                      password: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(label: 'Sign In', onPressed: _signIn),
                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () => showSnack(
                            context, 'Password reset link sent (demo)'),
                        child: Text('Forget password?',
                            style: AppText.l(17,
                                weight: FontWeight.w700,
                                color: AppColors.pink500)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PromptLink(
                      prompt: 'Don’t have an account?',
                      action: 'Register',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.intention),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
