/*
 * File Created: 2022-06-06 16:15:45
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-06 19:10:04
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:math';

import 'package:flutter/material.dart';

class WaveIndicatorPainter extends CustomPainter {
  WaveIndicatorPainter({
    required this.repaint,
    required this.progressAnimation,
    required this.backgroundColor,
    required this.borderRadius,
    required this.waveWidth,
    required this.waveBackgroundColor,
    required this.waveStep,
    required this.waveColor,
  }) : super(repaint: Listenable.merge([repaint, progressAnimation]));

  final Animation<double> repaint;
  final Animation<double> progressAnimation;
  final Color backgroundColor;
  final double? borderRadius;
  final double waveWidth;
  final Color waveBackgroundColor;
  final double waveStep;
  final Color waveColor;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // 剪裁画布
    if (borderRadius != null && borderRadius! > 0) {
      canvas.clipRRect(RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(borderRadius!)));
    } else {
      canvas.clipRect(Offset.zero & size);
    }

    _drawWaves(canvas, size);

    // 把背景盖在波纹上
    _drawBG(canvas, size);
  }

  void _drawBG(Canvas canvas, Size size) {
    final progress = progressAnimation.value;
    final left = size.width * progress;
    _paint
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    final rect = Offset(left, 0) & Size(size.width - left, size.height);
    canvas.drawRect(rect, _paint);
  }

  void _drawWaves(Canvas canvas, Size size) {
    canvas.save();
    // final progress = progressAnimation.value;
    // final width = size.width * progress;
    _paint
      ..color = waveBackgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, _paint);
    canvas.clipRect(Offset.zero & size);

    const angle = 20;
    _paint
      ..color = waveColor
      ..style = PaintingStyle.fill;
    final count = (size.width / (waveStep + waveWidth)).ceil();

    final height = size.height * 2.0;

    final realWidth = (waveWidth + waveStep) * count;
    final offset = -realWidth * repaint.value;
    canvas.translate(offset, 0);

    for (int i = 0; i < count * 2; i++) {
      var dx = (waveWidth + waveStep) * i;

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
  bool shouldRepaint(covariant WaveIndicatorPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.repaint != repaint ||
      oldDelegate.progressAnimation != progressAnimation ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.waveWidth != waveWidth ||
      oldDelegate.waveStep != waveStep ||
      oldDelegate.waveBackgroundColor != waveBackgroundColor ||
      oldDelegate.waveColor != waveColor;
}
