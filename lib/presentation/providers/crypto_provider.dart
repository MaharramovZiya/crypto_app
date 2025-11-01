import 'package:flutter/foundation.dart';

import '../../domain/entities/crypto_coin.dart';
import '../../domain/usecases/get_crypto_coins.dart';

class CryptoProvider extends ChangeNotifier {
  final GetCryptoCoins _getCryptoCoins;

  CryptoProvider({
    required GetCryptoCoins getCryptoCoins,
  }) : _getCryptoCoins = getCryptoCoins;

  // State
  List<CryptoCoin> _cryptoCoins = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMoreData = true;

  // Getters
  List<CryptoCoin> get cryptoCoins => _cryptoCoins;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreData => _hasMoreData;

  // Methods
  Future<void> loadCryptoCoins({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _cryptoCoins.clear();
      _hasMoreData = true;
    }

    if (!_hasMoreData) return;

    _setLoading(true);
    _clearError();

    try {
      final result = await _getCryptoCoins(
        GetCryptoCoinsParams(
          page: _currentPage,
          perPage: 12,
          order: 'market_cap_desc',
        ),
      );

      result.fold(
        (failure) {
          _setError(failure.toString());
        },
        (cryptoCoins) {
          if (refresh) {
            _cryptoCoins = cryptoCoins;
          } else {
            _cryptoCoins.addAll(cryptoCoins);
          }
          
          if (cryptoCoins.length < 12) {
            _hasMoreData = false;
          } else {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshCryptoCoins() async {
    await loadCryptoCoins(refresh: true);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

}
