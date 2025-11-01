import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/crypto_coin.dart';

part 'crypto_coin_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CryptoCoinModel extends CryptoCoin {
  const CryptoCoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.priceChange24h,
    required super.priceChangePercentage24h,
    required super.marketCapChange24h,
    required super.marketCapChangePercentage24h,
    required super.totalVolume,
    required super.high24h,
    required super.low24h,
    required super.ath,
    required super.athChangePercentage,
    required super.athDate,
    required super.atl,
    required super.atlChangePercentage,
    required super.atlDate,
    required super.lastUpdated,
    super.sparkline7d,
  });

  factory CryptoCoinModel.fromJson(Map<String, dynamic> json) {
    return CryptoCoinModel(
      id: json['id'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChange24h: (json['market_cap_change_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChangePercentage24h: (json['market_cap_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] as num?)?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] as num?)?.toDouble() ?? 0.0,
      ath: (json['ath'] as num?)?.toDouble() ?? 0.0,
      athChangePercentage: (json['ath_change_percentage'] as num?)?.toDouble() ?? 0.0,
      athDate: DateTime.tryParse(json['ath_date'] as String? ?? '') ?? DateTime.now(),
      atl: (json['atl'] as num?)?.toDouble() ?? 0.0,
      atlChangePercentage: (json['atl_change_percentage'] as num?)?.toDouble() ?? 0.0,
      atlDate: DateTime.tryParse(json['atl_date'] as String? ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(json['last_updated'] as String? ?? '') ?? DateTime.now(),
      sparkline7d: json['sparkline_in_7d'] != null && json['sparkline_in_7d']['price'] != null
          ? (json['sparkline_in_7d']['price'] as List)
              .map((e) => (e as num).toDouble())
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$CryptoCoinModelToJson(this);
}
