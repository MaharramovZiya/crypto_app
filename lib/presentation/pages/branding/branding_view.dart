import 'package:crypto_app/core/constants/app_colors.dart';
import 'package:crypto_app/presentation/pages/branding/components/branding_app_bar.dart';
import 'package:crypto_app/presentation/pages/branding/components/balance_card.dart';
import 'package:crypto_app/presentation/pages/branding/components/holdings_section.dart';
import 'package:crypto_app/presentation/providers/crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandingView extends StatefulWidget {
  const BrandingView({super.key});

  @override
  State<BrandingView> createState() => _BrandingViewState();
}

class _BrandingViewState extends State<BrandingView> {
  @override
  void initState() {
    super.initState();
    // Load crypto coins when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoProvider>().loadCryptoCoins(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BrandingAppBar(),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card
                    const BalanceCard(),
                    
                    const SizedBox(height: 32),
                    
                    // Holdings Section
                    const HoldingsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*

 Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'CryptX',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<BrandingBloc>().add(RefreshCryptoCoins());
            },
            icon: const Icon(
              Icons.refresh,
              color: AppColors.iconPrimary,
            ),
          ),
        ],
      ),
      body: BlocBuilder<BrandingBloc, BrandingState>(
        builder: (context, state) {
          if (state is BrandingLoading && state.cryptoCoins.isEmpty) {
            return const LoadingWidget();
          }

          if (state is BrandingError && state.cryptoCoins.isEmpty) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<BrandingBloc>().add(RefreshCryptoCoins()),
            );
          }

          if (state is BrandingLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BrandingBloc>().add(RefreshCryptoCoins());
              },
              color: AppColors.progressIndicator,
              backgroundColor: AppColors.background,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.cryptoCoins.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.cryptoCoins.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.progressIndicator),
                        ),
                      ),
                    );
                  }

                  final cryptoCoin = state.cryptoCoins[index];
                  return CryptoCoinCard(
                    cryptoCoin: cryptoCoin,
                    onTap: () {
                      // Navigate to detail page
                      context.go('/crypto-detail/${cryptoCoin.id}');
                    },
                  );
                },
              ),
            );
          }

          return const LoadingWidget();
        },
      ),
    );
*/