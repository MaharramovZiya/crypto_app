import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../core/constants/app_colors.dart';

class MiniChartWidget extends StatelessWidget {
  final List<double> prices;
  final double width;
  final double height;
  final bool isPositive;

  const MiniChartWidget({
    super.key,
    required this.prices,
    this.width = 60,
    this.height = 30,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return CustomPaint(
      size: Size(width, height),
      painter: _WaveChartPainter(
        prices: prices,
        isPositive: isPositive,
      ),
    );
  }
}

class _WaveChartPainter extends CustomPainter {
  final List<double> prices;
  final bool isPositive;

  _WaveChartPainter({
    required this.prices,
    required this.isPositive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Determine color based on price change
    paint.color = isPositive ? Colors.green : Colors.red;

    final path = Path();

    // Find min and max for scaling
    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final range = maxPrice - minPrice;

    if (range == 0) {
      // If all prices are the same, draw a straight line
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
    } else {
      // Draw wave
      final stepX = size.width / (prices.length - 1);
      
      for (int i = 0; i < prices.length; i++) {
        final x = i * stepX;
        final normalizedPrice = (prices[i] - minPrice) / range;
        final y = size.height - (normalizedPrice * size.height);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveChartPainter oldDelegate) {
    return oldDelegate.prices != prices || oldDelegate.isPositive != isPositive;
  }
}

