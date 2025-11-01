import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/injector.dart';
import '../domain/usecases/get_crypto_coins.dart';
import '../presentation/providers/crypto_provider.dart';

class ProviderScope extends StatelessWidget {
  final Widget child;

  const ProviderScope({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Crypto Provider
        ChangeNotifierProvider(
          create: (_) => CryptoProvider(
            getCryptoCoins: injector<GetCryptoCoins>(),
          ),
        ),
        
        // Add more providers here as needed
        // ChangeNotifierProvider(create: (_) => AnotherProvider()),
      ],
      child: child,
    );
  }
}
