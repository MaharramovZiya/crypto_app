import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/crypto_provider.dart';
import '../../../../core/constants/app_colors.dart';
import 'holdings_item.dart';

class HoldingsSection extends StatelessWidget {
  const HoldingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Holdings header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Holdings',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // See All action
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.balanceTextLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Holdings list with real data
        Consumer<CryptoProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.cryptoCoins.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (provider.error != null && provider.cryptoCoins.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              );
            }

            // Show first 12 coins
            final coinsToShow = provider.cryptoCoins.take(12).toList();

            if (coinsToShow.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'No holdings available',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: coinsToShow.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return HoldingsItem(cryptoCoin: coinsToShow[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

