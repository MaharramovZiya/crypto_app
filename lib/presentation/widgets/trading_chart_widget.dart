// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../core/constants/app_colors.dart';

class TradingChartWidget extends StatelessWidget {
  final List<double> prices;
  final List<String> dates;
  final double width;
  final double height;

  const TradingChartWidget({
    super.key,
    required this.prices,
    required this.dates,
    this.width = double.infinity,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 40, right: 16, top: 16, bottom: 40),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        size: Size(width - 56, height - 56),
        painter: _TradingChartPainter(
          prices: prices,
          dates: dates,
        ),
      ),
    );
  }
}

class _TradingChartPainter extends CustomPainter {
  final List<double> prices;
  final List<String> dates;

  _TradingChartPainter({
    required this.prices,
    required this.dates,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    // Find min and max for scaling
    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final range = maxPrice - minPrice;

    // Chart area (excluding axes)
    final chartWidth = size.width;
    final chartHeight = size.height - 40; // Space for X-axis labels
    final chartTop = 0.0;
    final chartLeft = 0.0;

    // Draw Y-axis labels (price scale)
    final yAxisCount = 6;
    final textStyle = const TextStyle(
      color: AppColors.textSecondary,
      fontSize: 10,
    );

    for (int i = 0; i < yAxisCount; i++) {
      final ratio = i / (yAxisCount - 1);
      final price = maxPrice - (range * ratio);
      final y = chartTop + (chartHeight * ratio);

      // Format price
      String priceLabel;
      if (price >= 1000) {
        priceLabel = '${(price / 1000).toStringAsFixed(0)}k';
      } else {
        priceLabel = price.toStringAsFixed(0);
      }

      // Draw price label
      final textSpan = TextSpan(
        text: priceLabel,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 8, y - textPainter.height / 2),
      );
    }

    // Draw X-axis labels (dates)
    if (dates.isNotEmpty) {
      final xStep = chartWidth / (dates.length - 1);
      for (int i = 0; i < dates.length; i++) {
        if (i % math.max(1, (dates.length / 7).floor()) == 0 || i == dates.length - 1) {
          final x = chartLeft + (i * xStep);
          final date = dates[i];

          final textSpan = TextSpan(
            text: date,
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(x - textPainter.width / 2, chartHeight + 8),
          );
        }
      }
    }

    // Draw chart line and area
    if (range > 0) {
      final path = Path();
      final areaPath = Path();
      final stepX = chartWidth / (prices.length - 1);

      for (int i = 0; i < prices.length; i++) {
        final x = chartLeft + (i * stepX);
        final normalizedPrice = (prices[i] - minPrice) / range;
        final y = chartTop + chartHeight - (normalizedPrice * chartHeight);

        if (i == 0) {
          path.moveTo(x, y);
          areaPath.moveTo(x, y);
        } else {
          path.lineTo(x, y);
          areaPath.lineTo(x, y);
        }
      }

      // Close area path
      areaPath.lineTo(chartLeft + chartWidth, chartTop + chartHeight);
      areaPath.lineTo(chartLeft, chartTop + chartHeight);
      areaPath.close();

      // Draw gradient area
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.3),
          AppColors.primary.withOpacity(0.0),
        ],
      );

      final rect = Rect.fromLTWH(chartLeft, chartTop, chartWidth, chartHeight);
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(areaPath, paint);

      // Draw line
      final linePaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(_TradingChartPainter oldDelegate) {
    return oldDelegate.prices != prices || oldDelegate.dates != dates;
  }
}

