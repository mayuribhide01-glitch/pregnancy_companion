import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/photo_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../shell/main_shell.dart';
import 'widgets/weight_chart.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool _lbs = false;

  String _fmt(double kg) =>
      _lbs ? '${(kg * 2.20462).toStringAsFixed(1)} lbs' : '${kg.toStringAsFixed(1)} kg';

  Future<void> _updateWeight(AppState state) async {
    final kg = await showDialog<double>(
      context: context,
      builder: (_) => _WeightDialog(initialKg: state.currentWeightKg),
    );
    if (kg != null && kg > 20 && kg < 250) state.updateWeight(kg);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final increased = state.currentWeightKg - state.initialWeightKg;

    return Column(
      children: [
        PageHeader(
          title: 'Discover',
          onBack: () => MainShell.goTo(context, MainShell.home),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                16, 16, 16, MainShell.contentBottomInset),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Ideal Pregnancy Weight Gain',
                        style: AppText.l(18,
                            weight: FontWeight.w900, color: AppColors.gray900)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Body Weight Track',
                              style: AppText.l(14,
                                  weight: FontWeight.w700,
                                  color: AppColors.gray600)),
                        ),
                        _UnitToggle(
                          lbs: _lbs,
                          onChanged: (v) => setState(() => _lbs = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    WeightChart(
                      startKg: state.initialWeightKg,
                      entries: state.weightLog,
                      useLbs: _lbs,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _Stat(
                                _fmt(state.initialWeightKg), 'Initial Weight')),
                        const SizedBox(width: 8),
                        Expanded(child: _Stat(_fmt(increased), 'Increased Weight')),
                        const SizedBox(width: 8),
                        Expanded(
                            child:
                                _Stat(_fmt(state.idealWeightKg), 'Ideal Weight')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: () => _updateWeight(state),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.pink500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    textStyle: AppText.l(18),
                  ),
                  child: const Text('Update Weight'),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Positive Birth Stories',
                onAll: () {},
                style: AppText.l(16,
                    weight: FontWeight.w900, color: AppColors.gray900),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: MockData.stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final s = MockData.stories[i];
                    return PhotoCard(
                      image: s.image,
                      width: 150,
                      height: 110,
                      onTap: () {},
                      scrim: const [Color(0x001E053C), Color(0xB31E053C)],
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(s.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.l(11,
                                  weight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeightDialog extends StatefulWidget {
  const _WeightDialog({required this.initialKg});

  final double initialKg;

  @override
  State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> {
  late final _controller =
      TextEditingController(text: widget.initialKg.toStringAsFixed(1));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => Navigator.pop(context, double.tryParse(_controller.text));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Update weight', style: AppText.l(18, weight: FontWeight.w700)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        onSubmitted: (_) => _save(),
        decoration: const InputDecoration(suffixText: 'kg'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.pink500),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.lbs, required this.onChanged});

  final bool lbs;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget opt(String label, bool active, bool value) => GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 41,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.pink500 : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(label,
                style: AppText.l(12,
                    weight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.gray500)),
          ),
        );
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          opt('lbs', lbs, true),
          const SizedBox(width: 5),
          opt('kg', !lbs, false),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.statBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(value,
                style: AppText.l(14,
                    weight: FontWeight.w900, color: AppColors.pink500)),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppText.l(10, color: AppColors.gray500)),
        ],
      ),
    );
  }
}
