// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps

import 'package:crypto_app/ui/base/base_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/injector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/crypto_coin.dart';
import '../../../domain/usecases/get_crypto_coin_by_id.dart';
import '../../../domain/usecases/get_crypto_coins.dart';
import '../../providers/crypto_provider.dart';
import '../../widgets/trading_chart_widget.dart';

class TradingView extends StatefulWidget {
  const TradingView({super.key});

  @override
  State<TradingView> createState() => _TradingViewState();
}

class _TradingViewState extends State<TradingView> {
  // Top 6 most important coins by market cap
  final List<String> _tabs = ['BTC', 'ETH', 'BNB', 'SOL', 'XRP', 'DOGE'];
  String _selectedTab = 'BTC';
  final TextEditingController _priceController = TextEditingController(text: '0.031');
  final TextEditingController _amountController = TextEditingController(text: '345');
  CryptoCoin? _fallbackCoin; // Store coin if loaded directly from API
  bool _isLoadingFallback = false;

  @override
  void initState() {
    super.initState();
    // Load more coins for trading (need at least 250 to include all tabs)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTradingCoins();
    });
  }

  Future<void> _loadTradingCoins() async {
    if (!mounted) return;
    
    final provider = context.read<CryptoProvider>();
    // Check if we already have enough coins
    if (provider.cryptoCoins.length >= 25) {
      return;
    }
    
    // Load more coins to ensure all trading tabs have data
    // Load in batches until we have at least 30 coins (max 3 batches to avoid infinite loop)
    int attempts = 0;
    while (provider.cryptoCoins.length < 30 && provider.hasMoreData && attempts < 3) {
      if (!mounted) return;
      await provider.loadCryptoCoins(refresh: provider.cryptoCoins.isEmpty);
      attempts++;
      if (provider.cryptoCoins.length >= 30) break;
      
      // Small delay to prevent rapid requests
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  CryptoCoin? _getSelectedCoin() {
    if (!mounted) return null;
    
    try {
      final provider = context.read<CryptoProvider>();
      
      // First try by symbol (more reliable)
      try {
        return provider.cryptoCoins.firstWhere(
          (coin) => coin.symbol.toUpperCase() == _selectedTab.toUpperCase(),
        );
      } catch (e) {
        // If not found by symbol, try by ID
        final symbolMap = {
          'BTC': 'bitcoin',
          'ETH': 'ethereum',
          'BNB': 'binancecoin',
          'SOL': 'solana',
          'XRP': 'ripple',
          'DOGE': 'dogecoin',
        };
        
        final coinId = symbolMap[_selectedTab];
        if (coinId != null) {
          try {
            return provider.cryptoCoins.firstWhere(
              (coin) => coin.id.toLowerCase() == coinId.toLowerCase(),
            );
          } catch (e) {
            // Not found in provider, return fallback if available
            return _fallbackCoin?.symbol.toUpperCase() == _selectedTab.toUpperCase() 
                ? _fallbackCoin 
                : null;
          }
        }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadCoinFromAPI(String tab) async {
    if (_isLoadingFallback || !mounted) return;

    final symbolMap = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'BNB': 'binancecoin',
      'SOL': 'solana',
      'XRP': 'ripple',
      'DOGE': 'dogecoin',
    };

    final coinId = symbolMap[tab];
    if (coinId == null) return;

    setState(() {
      _isLoadingFallback = true;
    });

    try {
      final getCryptoCoinById = GetCryptoCoinById(injector.get());
      
      // Also try to get sparkline from markets endpoint (first 100 coins)
      final getCryptoCoins = GetCryptoCoins(injector.get());
      final marketsResult = await getCryptoCoins(
        GetCryptoCoinsParams(
          page: 1,
          perPage: 100,
          order: 'market_cap_desc',
        ),
      );

      marketsResult.fold(
        (failure) async {
          // If markets fails, try direct coin endpoint
          final result = await getCryptoCoinById(GetCryptoCoinByIdParams(id: coinId));
          result.fold(
            (failure) {
              if (mounted) {
                setState(() {
                  _isLoadingFallback = false;
                });
              }
            },
            (coin) {
              if (mounted) {
                setState(() {
                  _fallbackCoin = coin;
                  _isLoadingFallback = false;
                });
              }
            },
          );
        },
        (coins) {
          // Try to find coin in markets list (has sparkline)
          try {
            final coinWithSparkline = coins.firstWhere(
              (coin) => coin.id.toLowerCase() == coinId.toLowerCase() || 
                       coin.symbol.toUpperCase() == tab.toUpperCase(),
            );
            if (mounted) {
              setState(() {
                _fallbackCoin = coinWithSparkline;
                _isLoadingFallback = false;
              });
            }
          } catch (e) {
            // Not in markets, load from detail endpoint
            getCryptoCoinById(GetCryptoCoinByIdParams(id: coinId)).then((result) {
              result.fold(
                (failure) {
                  if (mounted) {
                    setState(() {
                      _isLoadingFallback = false;
                    });
                  }
                },
                (coin) {
                  if (mounted) {
                    setState(() {
                      _fallbackCoin = coin;
                      _isLoadingFallback = false;
                    });
                  }
                },
              );
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFallback = false;
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

  List<String> _generateDates(List<double> prices) {
    final now = DateTime.now();
    final dates = <String>[];
    for (int i = prices.length - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: prices.length - 1 - i));
      final dayName = _getDayName(date.weekday);
      dates.add('$dayName ${date.day}');
    }
    return dates;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  void _setPercentage(double percentage) {
    final coin = _getSelectedCoin();
    if (coin != null) {
      final totalAmount = coin.currentPrice * 2.05; // Mock total balance
      final amount = (totalAmount * percentage / 100).toStringAsFixed(0);
      setState(() {
        _amountController.text = amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Trading',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings action
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.iconPrimary,
            ),
          ),
        ],
      ),
      body: Consumer<CryptoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.cryptoCoins.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          final selectedCoin = _getSelectedCoin();
          if (selectedCoin == null) {
            // Try to load from API if not already loading
            if (!_isLoadingFallback) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadCoinFromAPI(_selectedTab);
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoadingFallback)
                    const CircularProgressIndicator(
                      color: AppColors.primary,
                    )
                  else
                  const Icon(
                      Icons.search_off,
                    size: 64,
                      color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLoadingFallback 
                        ? 'Loading $_selectedTab...'
                        : '${_selectedTab} coin not found',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  if (!_isLoadingFallback) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Loading from API...',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                        _loadCoinFromAPI(_selectedTab);
                    },
                      child: const Text('Retry Loading'),
                  ),
                  ],
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Tab Navigation
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final tab = _tabs[index];
                      final isSelected = tab == _selectedTab;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = tab;
                          });
                          // If coin not found, try to load from API
                          final coin = _getSelectedCoin();
                          if (coin == null) {
                            _loadCoinFromAPI(tab);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Coin Info Section
                Row(
                  children: [
                    // Coin Icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        selectedCoin.image,
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.currency_bitcoin,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Coin Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCoin.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                  Text(
                            selectedCoin.symbol.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price and Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatPrice(selectedCoin.currentPrice),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                  Text(
                          '2.05 ${selectedCoin.symbol.toUpperCase()}',
                    style: const TextStyle(
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
                if (selectedCoin.sparkline7d != null && selectedCoin.sparkline7d!.isNotEmpty)
                  TradingChartWidget(
                    prices: selectedCoin.sparkline7d!,
                    dates: _generateDates(selectedCoin.sparkline7d!),
                    height: 300,
                  )
                else
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No chart data available',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // Buy/Sell Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Buy action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const BaseText(
                          'Buy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Sell action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                      color: AppColors.textSecondary,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sell',
                          style: TextStyle(
                      fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Price Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'At Price | USD',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _priceController,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.031',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),

                const SizedBox(height: 16),

                // Amount Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '345 USD',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildPercentageButton('25%', 0.25),
                          const SizedBox(width: 4),
                          _buildPercentageButton('50%', 0.50),
                          const SizedBox(width: 4),
                          _buildPercentageButton('100%', 1.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPercentageButton(String label, double percentage) {
    return GestureDetector(
      onTap: () => _setPercentage(percentage * 100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
