import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import 'paywall_screen.dart';

/// Add medicine form (iPhone 17 – 25).
class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  static const colors = [
    Color(0xFF7C3AED),
    Color(0xFFD51065),
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];
  static const units = ['mg', 'mcg', 'g', 'ml', 'IU'];
  static const forms = [
    'Tablet',
    'Capsule',
    'Liquid',
    'Injection',
    'Patch',
    'Drops'
  ];
  static const frequencies = [
    'Once daily',
    'Twice daily',
    '3x daily',
    'Weekly',
    'As needed',
  ];

  final _name = TextEditingController();
  final _dose = TextEditingController();
  final _notes = TextEditingController();
  Color _color = colors.first;
  DateTime _start = DateTime.now();
  String _unit = 'mg';
  String _form = 'Tablet';
  String _frequency = 'Once daily';
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  /// Spread doses through the day from the first reminder time.
  List<TimeOfDay> _times() {
    final first = _time ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay plus(int h) =>
        TimeOfDay(hour: (first.hour + h) % 24, minute: first.minute);
    return switch (_frequency) {
      'Twice daily' => [first, plus(12)],
      '3x daily' => [first, plus(6), plus(12)],
      _ => [first],
    };
  }

  String get _freqLabel => switch (_frequency) {
        'Twice daily' => '2×/day',
        '3x daily' => '3×/day',
        'Weekly' => '1×/week',
        'As needed' => 'As needed',
        _ => '1×/day',
      };

  void _save() {
    final dose = _dose.text.trim().isEmpty ? '1' : _dose.text.trim();
    AppStateScope.of(context).addMedicine(Medicine(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      dose: '$dose $_unit',
      form: _form,
      times: _times(),
      frequency: _freqLabel,
      color: _color,
      since: _start,
      notes: _notes.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: medBackground,
      body: Column(
        children: [
          const PageHeader(
            title: 'Medicine Reminders',
            uppercase: false,
            gradient: PageHeader.premiumGradient,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              children: [
                _label('Pill Color'),
                Row(
                  children: [
                    for (final c in colors)
                      GestureDetector(
                        onTap: () => setState(() => _color = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 10),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c == _color
                                  ? AppColors.gray900
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                _label('Medication Name'),
                AppTextField(
                    controller: _name, hint: 'e.g. Prenatal Vitamins',
                    radius: 10),
                _label('Start Date'),
                PickerField(
                  text: Fmt.date(_start),
                  hint: '',
                  icon: Icons.calendar_today_outlined,
                  radius: 10,
                  onTap: _pickDate,
                ),
                _label('Dosage'),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _dose,
                        hint: 'e.g. 500',
                        radius: 10,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 84,
                      height: 46,
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _unit,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: AppColors.gray900),
                          style: AppText.l(15, color: AppColors.gray900),
                          items: [
                            for (final u in units)
                              DropdownMenuItem(value: u, child: Text(u)),
                          ],
                          onChanged: (v) => setState(() => _unit = v ?? 'mg'),
                        ),
                      ),
                    ),
                  ],
                ),
                _label('Form'),
                _Chips(
                  options: forms,
                  value: _form,
                  onChanged: (v) => setState(() => _form = v),
                ),
                _label('Frequency'),
                _Chips(
                  options: frequencies,
                  value: _frequency,
                  onChanged: (v) => setState(() => _frequency = v),
                ),
                _label('Reminder Time'),
                PickerField(
                  text: _time == null ? null : _times().map(Fmt.time).join(', '),
                  hint: 'Select time',
                  icon: Icons.access_time_rounded,
                  radius: 10,
                  onTap: _pickTime,
                ),
                _label('Notes (optional)'),
                AppTextField(
                    controller: _notes,
                    hint: 'e.g. Take with food',
                    radius: 10,
                    maxLines: 2),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Save Reminder',
                  bold: true,
                  onPressed: _name.text.trim().isEmpty ? null : _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Text(t,
            style: AppText.l(15,
                weight: FontWeight.w700, color: AppColors.gray900)),
      );
}

class _Chips extends StatelessWidget {
  const _Chips({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final o in options)
          GestureDetector(
            onTap: () => onChanged(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: o == value ? AppColors.pink500 : Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(o,
                  style: AppText.l(14,
                      weight: FontWeight.w700,
                      color: o == value ? Colors.white : AppColors.gray600)),
            ),
          ),
      ],
    );
  }
}
