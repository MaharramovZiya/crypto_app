import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/injector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/crypto_coin.dart';
import '../../../domain/usecases/get_crypto_coin_by_id.dart';
import '../../../domain/usecases/get_crypto_coins.dart';
import '../../providers/crypto_provider.dart';
import '../../widgets/mini_chart_widget.dart';

class DetailView extends StatefulWidget {
  final String cryptoId;

  const DetailView({
    super.key,
    required this.cryptoId,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  CryptoCoin? _cryptoCoin;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCryptoCoin();
  }

  Future<void> _loadCryptoCoin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // First try to get from provider (has sparkline)
      final provider = Provider.of<CryptoProvider>(context, listen: false);
      final coinFromProvider = provider.cryptoCoins.firstWhere(
        (coin) => coin.id == widget.cryptoId,
        orElse: () => throw Exception('Not found'),
      );

      // If found in provider, use it (has sparkline)
      setState(() {
        _cryptoCoin = coinFromProvider;
        _isLoading = false;
      });
    } catch (e) {
      // If not in provider, fetch from API
      try {
        final getCryptoCoinById = GetCryptoCoinById(
          injector.get(),
        );
        
        final result = await getCryptoCoinById(
          GetCryptoCoinByIdParams(id: widget.cryptoId),
        );

        result.fold(
          (failure) {
            setState(() {
              _error = failure.toString();
              _isLoading = false;
            });
          },
          (cryptoCoin) async {
            // Try to get sparkline from markets endpoint
            try {
              final getCryptoCoins = GetCryptoCoins(injector.get());
              final marketsResult = await getCryptoCoins(
                GetCryptoCoinsParams(
                  page: 1,
                  perPage: 250,
                  order: 'market_cap_desc',
                ),
              );

              marketsResult.fold(
                (failure) {
                  // Use coin without sparkline
                  setState(() {
                    _cryptoCoin = cryptoCoin;
                    _isLoading = false;
                  });
                },
                (coins) {
                  // Find coin in markets list and get sparkline
                  final coinWithSparkline = coins.firstWhere(
                    (coin) => coin.id == widget.cryptoId,
                    orElse: () => cryptoCoin,
                  );
                  
                  setState(() {
                    _cryptoCoin = coinWithSparkline;
                    _isLoading = false;
                  });
                },
              );
            } catch (e) {
              // Use coin without sparkline
              setState(() {
                _cryptoCoin = cryptoCoin;
                _isLoading = false;
              });
            }
          },
        );
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(2)}K';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else {
      return '\$${price.toStringAsFixed(6)}';
    }
  }

  String _formatLargeNumber(double number) {
    if (number >= 1000000000000) {
      return '\$${(number / 1000000000000).toStringAsFixed(2)}T';
    } else if (number >= 1000000000) {
      return '\$${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '\$${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '\$${(number / 1000).toStringAsFixed(2)}K';
    }
    return '\$${number.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCryptoCoin,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_cryptoCoin == null) {
      return const Center(
        child: Text(
          'Coin not found',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final coin = _cryptoCoin!;
    final isPositive = coin.priceChangePercentage24h >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and name
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  coin.image,
                  width: 64,
                  height: 64,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.currency_bitcoin,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Current price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Price',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(coin.currentPrice),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? AppColors.secondary : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? AppColors.secondary : AppColors.error,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatPrice(coin.priceChange24h.abs()),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Chart
          if (coin.sparkline7d != null && coin.sparkline7d!.isNotEmpty)
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: MiniChartWidget(
                prices: coin.sparkline7d!,
                width: double.infinity,
                height: 200,
                isPositive: isPositive,
              ),
            ),

          const SizedBox(height: 32),

          // Stats
          const Text(
            'Statistics',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Market Cap
          _buildStatCard(
            'Market Cap',
            _formatLargeNumber(coin.marketCap),
            'Rank #${coin.marketCapRank}',
          ),

          const SizedBox(height: 12),

          // 24h High/Low
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '24h High',
                  _formatPrice(coin.high24h),
                  null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '24h Low',
                  _formatPrice(coin.low24h),
                  null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Volume
          _buildStatCard(
            'Total Volume',
            _formatLargeNumber(coin.totalVolume),
            null,
          ),

          const SizedBox(height: 12),

          // ATH/ATL
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'All Time High',
                  _formatPrice(coin.ath),
                  '${coin.athChangePercentage.toStringAsFixed(2)}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'All Time Low',
                  _formatPrice(coin.atl),
                  '${coin.atlChangePercentage.toStringAsFixed(2)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String? subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

