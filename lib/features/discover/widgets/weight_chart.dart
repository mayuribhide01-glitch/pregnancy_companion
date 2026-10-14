import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Pregnancy weight-gain chart: ideal range band (purple), current-week
/// marker (pink dashed) and logged weights (pink ringed dots).
class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required this.startKg,
    required this.entries,
    this.useLbs = false,
  });

  final double startKg;
  final List<(double, double)> entries;
  final bool useLbs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 169,
      decoration: BoxDecoration(
        color: AppColors.pink50,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 8),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 38),
              _legend(dashed: true, color: AppColors.pink500, label: 'Ideal range'),
              const SizedBox(width: 12),
              _legend(color: AppColors.purpleLight, label: 'Actual'),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _WeightChartPainter(
                startKg: startKg,
                entries: entries,
                factor: useLbs ? 2.20462 : 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend({
    required Color color,
    required String label,
    bool dashed = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 2,
          child: dashed
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      3, (_) => Container(width: 3, height: 1.4, color: color)),
                )
              : ColoredBox(color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppText.l(8.5, color: AppColors.gray400)),
      ],
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.startKg,
    required this.entries,
    required this.factor,
  });

  final double startKg;
  final List<(double, double)> entries;
  final double factor;

  static const _maxWeek = 40.0;
  static const _leftAxis = 26.0;
  static const _bottomAxis = 16.0;

  // Ideal gain for a normal-BMI start weight (kg): slow 1st trimester,
  // then steady weekly gain.
  double _low(double w) => w <= 13 ? 0.5 * w / 13 : 0.5 + (w - 13) * 0.27;
  double _high(double w) => w <= 13 ? 2.0 * w / 13 : 2.0 + (w - 13) * 0.33;

  @override
  void paint(Canvas canvas, Size size) {
    final minY = startKg - 1;
    final maxY = startKg + 11;
    final plot = Rect.fromLTRB(
        _leftAxis, 4, size.width, size.height - _bottomAxis);

    Offset pt(double week, double kg) => Offset(
          plot.left + plot.width * (week / _maxWeek),
          plot.bottom - plot.height * ((kg - minY) / (maxY - minY)),
        );

    final labelStyle = AppText.l(9, color: AppColors.gray400);
    final grid = Paint()
      ..color = AppColors.gray200
      ..strokeWidth = 0.8;

    // Horizontal grid + Y labels (every 2 kg from the start weight).
    for (var i = 0; i <= 5; i++) {
      final kg = startKg + i * 2;
      final y = pt(0, kg).dy;
      _dashedLine(canvas, Offset(plot.left, y), Offset(plot.right, y), grid);
      _text(canvas, (kg * factor).round().toString(), labelStyle,
          Offset(plot.left - 8, y), alignRight: true);
    }

    // X labels.
    const weeks = [0, 8, 16, 24, 32, 40];
    for (final w in weeks) {
      final x = pt(w.toDouble(), minY).dx;
      _text(canvas, w == 0 ? '0' : 'W$w', labelStyle,
          Offset(x, plot.bottom + 9), center: true);
    }

    // Ideal range band.
    final band = Path()..moveTo(pt(0, startKg).dx, pt(0, startKg + _high(0)).dy);
    for (var w = 0.0; w <= _maxWeek; w += 1) {
      band.lineTo(pt(w, 0).dx, pt(w, startKg + _high(w)).dy);
    }
    for (var w = _maxWeek; w >= 0; w -= 1) {
      band.lineTo(pt(w, 0).dx, pt(w, startKg + _low(w)).dy);
    }
    band.close();
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(plot.left, 0, plot.right, plot.bottom));
    canvas.drawPath(
      band,
      Paint()
        ..shader = ui.Gradient.linear(
          plot.topCenter,
          plot.bottomCenter,
          [const Color(0x2EA855F7), const Color(0x0AA855F7)],
        ),
    );
    canvas.restore();

    if (entries.isEmpty) return;

    // Current-week marker.
    final current = entries.last.$1;
    _dashedLine(
      canvas,
      Offset(pt(current, 0).dx, plot.top),
      Offset(pt(current, 0).dx, plot.bottom),
      Paint()
        ..color = AppColors.hotPink
        ..strokeWidth = 1,
    );

    // Actual line + dots.
    final line = Path();
    for (var i = 0; i < entries.length; i++) {
      final p = pt(entries[i].$1, entries[i].$2);
      if (i == 0) {
        line.moveTo(p.dx, p.dy);
      } else {
        line.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.purpleLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final fill = Paint()..color = Colors.white;
    final ring = Paint()
      ..color = AppColors.pink500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final e in entries) {
      final p = pt(e.$1, e.$2);
      canvas.drawCircle(p, 4.5, fill);
      canvas.drawCircle(p, 4.5, ring);
    }
  }

  void _dashedLine(Canvas c, Offset a, Offset b, Paint p) {
    const dash = 3.0, gap = 3.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    for (var d = 0.0; d < total; d += dash + gap) {
      final end = (d + dash).clamp(0, total).toDouble();
      c.drawLine(a + dir * d, a + dir * end, p);
    }
  }

  void _text(Canvas c, String s, TextStyle style, Offset at,
      {bool alignRight = false, bool center = false}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = alignRight
        ? at.dx - tp.width
        : center
            ? at.dx - tp.width / 2
            : at.dx;
    tp.paint(c, Offset(dx, at.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter old) =>
      old.entries != entries || old.factor != factor || old.startKg != startKg;
}
