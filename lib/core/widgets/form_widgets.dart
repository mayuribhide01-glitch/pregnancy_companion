import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Bold field label above inputs.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.size = 15, this.bold = false});

  final String text;
  final double size;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: AppText.l(size,
                weight: bold ? FontWeight.w700 : FontWeight.w400,
                color: AppColors.gray700)),
      );
}

/// White rounded text input used across onboarding and forms.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.password = false,
    this.keyboardType,
    this.inputFormatters,
    this.radius = 8,
    this.borderColor = AppColors.gray200,
    this.maxLines = 1,
    this.onChanged,
    this.textInputAction,
    this.autofillHints,
  });

  final TextEditingController? controller;
  final String hint;
  final bool password;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double radius;
  final Color borderColor;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidden = true;

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.password && _hidden,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.password ? 1 : widget.maxLines,
      minLines: widget.password ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      style: AppText.l(16, color: AppColors.gray900),
      cursorColor: AppColors.pink500,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppText.l(16, color: AppColors.gray400),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        enabledBorder: _b(widget.borderColor),
        focusedBorder: _b(AppColors.pink300),
        suffixIconConstraints:
            const BoxConstraints(minWidth: 44, minHeight: 40),
        suffixIcon: widget.password
            ? GestureDetector(
                onTap: () => setState(() => _hidden = !_hidden),
                child: Icon(
                  _hidden
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: AppColors.gray400,
                  size: 22,
                ),
              )
            : null,
      ),
    );
  }
}

/// Tappable field that looks like an input (date / time / select pickers).
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.text,
    required this.hint,
    required this.onTap,
    this.icon,
    this.radius = 8,
    this.borderColor = AppColors.gray200,
  });

  final String? text;
  final String hint;
  final IconData? icon;
  final double radius;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text ?? hint,
                  style: AppText.l(16,
                      color:
                          text == null ? AppColors.gray400 : AppColors.gray900),
                ),
              ),
              if (icon != null) Icon(icon, size: 22, color: AppColors.gray600),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width pink action button (Sign In, Continue, Next…).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bold = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.pink500,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.gray200,
          disabledForegroundColor: AppColors.gray400,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: AppText.l(bold ? 17 : 18,
              weight: bold ? FontWeight.w700 : FontWeight.w400),
        ),
        child: Text(label),
      ),
    );
  }
}

/// "Don't have an account? Register" style line.
class PromptLink extends StatelessWidget {
  const PromptLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: '$prompt ',
          style: AppText.l(16, color: AppColors.gray700),
          children: [
            TextSpan(
              text: action,
              style: AppText.l(16,
                  weight: FontWeight.w700, color: AppColors.pink500),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
}
