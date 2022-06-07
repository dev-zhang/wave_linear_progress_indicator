/*
 * File Created: 2022-06-02 14:24:09
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-07 11:47:47
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:flutter/material.dart';
import 'package:wave_linear_progress_indicator/src/progress_label.dart';

import 'wave_indicator_painter.dart';

class WaveLinearProgressIndicator extends ProgressIndicator {
  const WaveLinearProgressIndicator({
    Key? key,
    required double value,
    Color? backgroundColor = const Color(0xFFECF4F2),
    Color? color,
    this.minHeight,
    this.borderRadius = 18,
    this.waveWidth = 10,
    this.waveColor = const Color(0x21FFFFFF),
    this.waveBackgroundColor = const Color(0xFF71E4D6),
    this.waveStep = 8,
    this.labelDecoration,
    this.enableBounceAnimation = false,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          color: color,
        );

  /// The minimum height of the line used to draw the linear indicator.
  final double? minHeight;

  /// Rounded corners of the progress indicator
  final double? borderRadius;

  /// Width of wave
  final double waveWidth;

  /// Background color of the progress indicator
  final Color waveBackgroundColor;

  /// Spacing from wave to the next wave
  final double waveStep;

  /// Color of the spacing between waves
  final Color waveColor;

  /// Decoration of the progress label widget
  final Decoration? labelDecoration;

  /// Whether to turn on the bouncing animation effect
  final bool enableBounceAnimation;

  @override
  State<StatefulWidget> createState() => _WaveLinearProgressIndicatorState();
}

class _WaveLinearProgressIndicatorState
    extends State<WaveLinearProgressIndicator> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final GlobalKey _progressLabelKey = GlobalKey();

  Decoration get _labelDecoration {
    if (widget.labelDecoration != null) {
      return widget.labelDecoration!;
    }
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF9DF3E9),
          Color(0xFF71E4D6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(13),
    );
  }

  Color get _backgroundColor {
    final Color trackColor = widget.backgroundColor ??
        _indicatorTheme.linearTrackColor ??
        Theme.of(context).colorScheme.background;
    return trackColor;
  }

  double get _minHeight =>
      widget.minHeight ?? _indicatorTheme.linearMinHeight ?? 9;

  double get _progressLabelHeight => _minHeight + 4.5 * 2;

  ProgressIndicatorThemeData get _indicatorTheme =>
      ProgressIndicatorTheme.of(context);

  @override
  void initState() {
    _waveController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    _waveController.repeat();
    _progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _progressAnimation =
        Tween(begin: widget.value).animate(_progressController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WaveLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldValue = oldWidget.value ?? 0;
    final newValue = widget.value ?? 0;
    if (widget.enableBounceAnimation) {
      double bouncingValue = newValue +
          (10 / 100) * ((newValue - oldValue) / (newValue - oldValue).abs());
      bouncingValue = bouncingValue.clamp(0, 1.0).toDouble();
      _progressAnimation = TweenSequence(<TweenSequenceItem<double>>[
        TweenSequenceItem(
          tween: Tween(begin: oldValue, end: bouncingValue)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 3 / 4,
        ),
        TweenSequenceItem(
          tween: Tween(begin: bouncingValue, end: newValue)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 1 / 4,
        ),
      ]).animate(_progressController);
    } else {
      _progressAnimation =
          Tween(begin: oldValue, end: newValue).animate(_progressController);
    }
    _progressController.forward(from: 0);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: _progressLabelHeight,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // print('=======layout===$constraints');
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: _minHeight,
                  minWidth: double.infinity,
                ),
                child: CustomPaint(
                  painter: WaveIndicatorPainter(
                    repaint: _waveController,
                    progressAnimation: _progressAnimation,
                    backgroundColor: _backgroundColor,
                    borderRadius: widget.borderRadius,
                    waveWidth: widget.waveWidth,
                    waveBackgroundColor: widget.waveBackgroundColor,
                    waveStep: widget.waveStep,
                    waveColor: widget.waveColor,
                  ),
                ),
              ),
            ),
            _buildProgressLabel(constraints.biggest),
          ],
        );
      }),
    );
  }

  Widget _buildProgressLabel(Size size) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progressLabelWidth =
            _getChildSize(_progressLabelKey)?.width ?? 62;
        final progress = _progressAnimation.value;
        double left = size.width * progress;
        left = left.clamp(0, size.width - progressLabelWidth);
        return Positioned(
          left: left,
          height: _progressLabelHeight,
          child: ProgressLabel(
            progress: progress,
            key: _progressLabelKey,
            decoration: _labelDecoration,
          ),
        );
      },
    );
  }

  Size? _getChildSize(GlobalKey globalKey) {
    final renderBox =
        globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return null;
    }
    final size = renderBox.size;
    return size;
  }
}
