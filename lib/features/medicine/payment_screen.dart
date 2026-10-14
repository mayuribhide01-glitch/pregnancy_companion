import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import 'paywall_screen.dart';

enum _Method { card, paypal, wallet }

/// Payment (iPhone 17 – 20 / 21 / 22): order summary + Card / PayPal / Pay.
///
/// PROTOTYPE ONLY — nothing entered here is stored or sent anywhere. Wire a
/// real payment SDK (Stripe, Razorpay, Play Billing…) before release.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _Method _method = _Method.card;
  final _number = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _number.addListener(() => setState(() {}));
    _expiry.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_number, _expiry, _cvv, _name]) {
      c.dispose();
    }
    super.dispose();
  }

  PremiumPlan get _plan =>
      ModalRoute.of(context)?.settings.arguments as PremiumPlan? ??
      PremiumPlan.monthly;

  void _pay() {
    if (_method == _Method.card) {
      final digits = _number.text.replaceAll(' ', '');
      if (digits.length < 12 ||
          _expiry.text.length < 5 ||
          _cvv.text.length < 3 ||
          _name.text.trim().isEmpty) {
        showSnack(context, 'Please complete the card details');
        return;
      }
    }
    AppStateScope.of(context).activatePremium(_plan);
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.medSuccess,
      ModalRoute.withName(Routes.shell),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    final price = '\$${plan.charge.toStringAsFixed(2)}';
    final dueToday = plan.hasTrial ? '\$0.00' : price;
    return Scaffold(
      backgroundColor: medBackground,
      body: Column(
        children: [
          const PageHeader(title: 'Payment', uppercase: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 24),
              children: [
                Text(plan.summary,
                    textAlign: TextAlign.center,
                    style: AppText.l(15, color: AppColors.gray700)),
                const SizedBox(height: 20),
                _Card(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORDER SUMMARY',
                          style: AppText.l(13,
                              weight: FontWeight.w700,
                              color: AppColors.gray900,
                              letterSpacing: 0.8)),
                      const SizedBox(height: 12),
                      _row('Medicine Reminder – ${plan.label}', price,
                          AppText.l(15, color: AppColors.gray700),
                          AppText.l(15,
                              weight: FontWeight.w700,
                              color: AppColors.pink500)),
                      if (plan.hasTrial) ...[
                        const SizedBox(height: 8),
                        _row(
                            '🎉 7-day free trial',
                            '-$price',
                            AppText.l(14, color: const Color(0xFF10B981)),
                            AppText.l(14, color: const Color(0xFF10B981))),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Color(0xFFF1E8EE)),
                      ),
                      _row(
                          'Due today',
                          dueToday,
                          AppText.l(15,
                              weight: FontWeight.w700,
                              color: AppColors.gray900),
                          AppText.l(18,
                              weight: FontWeight.w900,
                              color: AppColors.pink500)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final m in _Method.values) ...[
                      Expanded(
                        child: _MethodTab(
                          label: switch (m) {
                            _Method.card => '💳 Card',
                            _Method.paypal => 'PayPal',
                            _Method.wallet => '🍎 Pay',
                          },
                          active: m == _method,
                          onTap: () => setState(() => _method = m),
                        ),
                      ),
                      if (m != _Method.wallet) const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: switch (_method) {
                    _Method.card => _cardForm(),
                    _Method.paypal => const _InfoBox(
                        key: ValueKey('pp'),
                        text:
                            'You will be redirected to PayPal to complete payment.'),
                    _Method.wallet => const _InfoBox(
                        key: ValueKey('wallet'),
                        text: 'Use Face ID or Touch ID to complete payment.'),
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 15, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Text('256-bit SSL encryption · PCI DSS compliant',
                        style: AppText.l(12, color: AppColors.gray600)),
                  ],
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  bold: true,
                  label: plan.hasTrial
                      ? 'Start Free Trial — \$0.00 Today'
                      : 'Pay $price',
                  onPressed: _pay,
                ),
                const SizedBox(height: 10),
                Text('Prototype: no payment is processed',
                    textAlign: TextAlign.center,
                    style: AppText.l(11, color: AppColors.gray400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String r, TextStyle ls, TextStyle rs) => Row(
        children: [
          Expanded(child: Text(l, style: ls)),
          Text(r, style: rs),
        ],
      );

  Widget _cardForm() {
    final digits = _number.text.replaceAll(' ', '');
    final masked = digits.isEmpty
        ? '••••  ••••  ••••  ••••'
        : (digits.padRight(16, '•'))
            .replaceAllMapped(RegExp(r'.{4}'), (m) => '${m[0]}  ')
            .trim();
    return _Card(
      key: const ValueKey('card'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card preview
          Container(
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA9CBEF), Color(0xFF3B8EDE)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x1FFFFFFF),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CARD NUMBER',
                                style: AppText.l(10,
                                    color: const Color(0xB3FFFFFF),
                                    letterSpacing: 0.6)),
                            const SizedBox(height: 4),
                            Text(masked,
                                style: AppText.l(15,
                                    weight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1)),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('EXPIRES',
                              style: AppText.l(10,
                                  color: const Color(0xB3FFFFFF))),
                          Text(_expiry.text.isEmpty ? 'MM/YY' : _expiry.text,
                              style: AppText.l(14, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const FieldLabel('Card Number', size: 14, bold: true),
          AppTextField(
            controller: _number,
            hint: '0000 0000 0000 0000',
            radius: 10,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _GroupFormatter(4, ' '),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Expiry', size: 14, bold: true),
                    AppTextField(
                      controller: _expiry,
                      hint: 'MM/YY',
                      radius: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _GroupFormatter(2, '/'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('CVV', size: 14, bold: true),
                    AppTextField(
                      controller: _cvv,
                      hint: '•••',
                      radius: 10,
                      password: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const FieldLabel('Name on Card', size: 14, bold: true),
          AppTextField(controller: _name, hint: 'Full name', radius: 10),
        ],
      ),
    );
  }
}

/// Inserts [separator] after every [size] characters (card number, expiry).
class _GroupFormatter extends TextInputFormatter {
  _GroupFormatter(this.size, this.separator);

  final int size;
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(separator, '');
    final buf = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && i % size == 0) buf.write(separator);
      buf.write(raw[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF5E4EE)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0FD51065), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
      child: Text(text,
          textAlign: TextAlign.center,
          style: AppText.l(15, color: AppColors.gray500, height: 1.5)),
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.pink500 : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: AppText.l(13,
                weight: FontWeight.w700,
                color: active ? Colors.white : AppColors.gray600)),
      ),
    );
  }
}
