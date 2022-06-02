/*
 * File Created: 2022-06-02 14:24:09
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-02 18:16:49
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:math';

import 'package:flutter/material.dart';

class WaveLinearProgressIndicator extends ProgressIndicator {
  const WaveLinearProgressIndicator({
    Key? key,
    required double value,
    Color? backgroundColor = const Color(0xFFECF4F2),
    Color? color,
    this.borderRadius,
    this.waveWidth = 10,
    this.waveColor = const Color(0x21FFFFFF),
    this.waveBackgroundColor = const Color(0xFF71E4D6),
    this.waveStep = 8,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          color: color,
        );

  final double? borderRadius;
  final double waveWidth;
  final Color waveBackgroundColor;
  final double waveStep;
  final Color waveColor;

  @override
  State<StatefulWidget> createState() => _WaveLinearProgressIndicatorState();
}

class _WaveLinearProgressIndicatorState
    extends State<WaveLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color get _backgroundColor {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        Theme.of(context).colorScheme.background;
    return trackColor;
  }

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: 19,
      ),
      child: CustomPaint(
        painter: _WaveIndicatorPainter(
          repaint: _controller,
          backgroundColor: _backgroundColor,
          borderRadius: widget.borderRadius,
          waveWidth: widget.waveWidth,
          waveBackgroundColor: widget.waveBackgroundColor,
          waveStep: widget.waveStep,
          waveColor: widget.waveColor,
        ),
      ),
    );
  }
}

class _WaveIndicatorPainter extends CustomPainter {
  _WaveIndicatorPainter({
    required this.repaint,
    required this.backgroundColor,
    required this.borderRadius,
    required this.waveWidth,
    required this.waveBackgroundColor,
    required this.waveStep,
    required this.waveColor,
  }) : super(repaint: repaint);

  final Animation<double> repaint;
  final Color backgroundColor;
  final double? borderRadius;
  final double waveWidth;
  final Color waveBackgroundColor;
  final double waveStep;
  final Color waveColor;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, _paint);

    _drawWaves(canvas, size);
  }

  void _drawWaves(Canvas canvas, Size size) {
    final progress = 0.5;
    final width = size.width * progress;
    _paint
      ..color = waveBackgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & Size(width, size.height), _paint);
    canvas.clipRect(Offset.zero & Size(width, size.height));

    const angle = 20;
    _paint
      ..color = waveColor
      ..style = PaintingStyle.fill;
    final count = (width / (waveStep + waveWidth)).ceil();

    final height = size.height * 1.5;
    // canvas.translate(width, 0);
    canvas.translate(-width * repaint.value, 0);
    canvas.save();
    canvas.translate(0, 0);
    for (int i = 0; i < count; i++) {
      var dx = (waveWidth + waveStep) * i;
      // dx *= repaint.value;
      canvas.save();
      canvas.translate(dx + waveWidth / 2, 0);
      canvas.rotate(angle * pi / 180);

      canvas.drawRect(
          Offset(0, -(height - size.height) / 2) & Size(waveWidth, height),
          _paint);
      canvas.restore();
    }
    canvas.restore();

    canvas.translate(width, 0);
    for (int i = 0; i < count; i++) {
      var dx = (waveWidth + waveStep) * i;
      // dx *= repaint.value;
      canvas.save();
      canvas.translate(dx + waveWidth / 2, 0);
      canvas.rotate(angle * pi / 180);

      canvas.drawRect(
          Offset(0, -(height - size.height) / 2) & Size(waveWidth, height),
          _paint);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WaveIndicatorPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor;
}
