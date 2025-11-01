import 'package:flutter/material.dart';

import '../../../../domain/entities/crypto_coin.dart';
import '../../../widgets/mini_chart_widget.dart';
import '../../../../core/constants/app_colors.dart';

class HoldingsItem extends StatelessWidget {
  final CryptoCoin cryptoCoin;

  const HoldingsItem({
    super.key,
    required this.cryptoCoin,
  });

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(2)}K';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else {
      return '\$${price.toStringAsFixed(4)}';
    }
  }

  String _formatAmount(double price, String symbol) {
    // Mock amount calculation - you can adjust this based on your needs
    final mockAmount = (1000 / price).toStringAsFixed(2);
    return '$mockAmount ${symbol.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = cryptoCoin.priceChangePercentage24h >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Coin Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cryptoCoin.image,
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.currency_bitcoin,
                    color: AppColors.primary,
                    size: 24,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Name and code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cryptoCoin.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cryptoCoin.symbol.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Mini chart
          if (cryptoCoin.sparkline7d != null && cryptoCoin.sparkline7d!.isNotEmpty)
            MiniChartWidget(
              prices: cryptoCoin.sparkline7d!,
              width: 60,
              height: 30,
              isPositive: isPositive,
            )
          else
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(width: 16),
          // Value and amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(cryptoCoin.currentPrice),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatAmount(cryptoCoin.currentPrice, cryptoCoin.symbol),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

