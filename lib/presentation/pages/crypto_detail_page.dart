import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import 'detail/detail_view.dart';

class CryptoDetailPage extends StatelessWidget {
  final String cryptoId;

  const CryptoDetailPage({
    super.key,
    required this.cryptoId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Crypto Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconPrimary,
          ),
        ),
      ),
      body: DetailView(cryptoId: cryptoId),
    );
  }
}
