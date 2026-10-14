import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  static const specialties = [
    'OB-GYN',
    'Ultrasound',
    'Blood Test',
    'Nutritionist',
    'Physiotherapy',
    'Other',
  ];

  final _provider = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String? _specialty;
  AppointmentStatus _status = AppointmentStatus.upcoming;

  bool get _canSubmit =>
      _provider.text.trim().isNotEmpty && _date != null && _time != null;

  @override
  void initState() {
    super.initState();
    _provider.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _provider.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    AppStateScope.of(context).addAppointment(Appointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      provider: _provider.text.trim(),
      specialty: _specialty ?? 'Other',
      date: _date!,
      time: _time!,
      location: _location.text.trim().isEmpty ? '—' : _location.text.trim(),
      status: _status,
      notes: _notes.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PageHeader(title: 'Appointment Tracker'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                const _Label('Doctor / Provider Name'),
                _Input(controller: _provider, hint: 'e.g. Dr. Sarah Mills'),
                const _Label('Date'),
                _PickerField(
                  text: _date == null ? null : Fmt.dateField(_date!),
                  hint: 'DD - MM - YYYY',
                  icon: Icons.calendar_today_outlined,
                  radius: 6,
                  borderColor: AppColors.gray300,
                  onTap: _pickDate,
                ),
                const _Label('Time'),
                _PickerField(
                  text: _time == null ? null : Fmt.time(_time!),
                  hint: '',
                  onTap: _pickTime,
                ),
                const _Label('Location / Hospital'),
                _Input(controller: _location, hint: 'e.g. City Maternity Clinic'),
                const _Label('Specialty / Type'),
                _Dropdown(
                  value: _specialty,
                  items: specialties,
                  onChanged: (v) => setState(() => _specialty = v),
                ),
                const _Label('Status'),
                Row(
                  children: [
                    for (final s in AppointmentStatus.values) ...[
                      Expanded(
                        child: _StatusButton(
                          label: s.label,
                          active: s == _status,
                          onTap: () => setState(() => _status = s),
                        ),
                      ),
                      if (s != AppointmentStatus.values.last)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),
                const _Label('Notes (optional)'),
                _Input(
                  controller: _notes,
                  hint: 'Add any notes or reminders...',
                  maxLines: 3,
                  fontSize: 14,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: _canSubmit ? _submit : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pink500,
                      disabledBackgroundColor: AppColors.gray200,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: AppColors.gray400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      textStyle: AppText.l(18),
                    ),
                    child: const Text('Add Appointment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Text(text,
            style: AppText.l(13,
                weight: FontWeight.w700, color: AppColors.gray700)),
      );
}

OutlineInputBorder _border(Color c, double r) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(r),
      borderSide: BorderSide(color: c),
    );

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.fontSize = 16,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: maxLines,
      style: AppText.l(fontSize, color: AppColors.gray700),
      cursorColor: AppColors.pink500,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.l(fontSize, color: const Color(0x80111827)),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        enabledBorder: _border(AppColors.gray200, 10),
        focusedBorder: _border(AppColors.pink300, 10),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.text,
    required this.hint,
    required this.onTap,
    this.icon,
    this.radius = 10,
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
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text ?? hint,
                style: AppText.l(16,
                    color: text == null
                        ? const Color(0x80111827)
                        : AppColors.gray700),
              ),
            ),
            if (icon != null) Icon(icon, size: 20, color: AppColors.gray500),
          ],
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 15, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.gray900, size: 26),
          hint: Text('Select specialty...',
              style: AppText.l(14, color: AppColors.gray900)),
          style: AppText.l(14, color: AppColors.gray900),
          items: [
            for (final s in items) DropdownMenuItem(value: s, child: Text(s)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
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
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.pink600 : AppColors.lavenderChip,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: AppText.l(12,
                weight: FontWeight.w700,
                color: active ? Colors.white : AppColors.gray500)),
      ),
    );
  }
}
