import 'dart:convert';

class SupporterEntity {
  final String name;
  final double amount;
  final String currency;
  final bool masterSupporter;
  const SupporterEntity({
    required this.name,
    required this.amount,
    required this.currency,
    required this.masterSupporter,
  });

  factory SupporterEntity.fromMap(Map<String, dynamic> map) {
    final rawAmount = map['amount'];
    return SupporterEntity(
      name: map['name']?.toString() ?? '',
      amount: rawAmount is num ? rawAmount.toDouble() : 0.0,
      currency: map['currency']?.toString() ?? '',
      masterSupporter: map['master_supporter'] ?? false,
    );
  }

  static List<SupporterEntity> listFromDynamic(dynamic source) {
    final rawList = _normalizeToList(source);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(SupporterEntity.fromMap)
        .where((entity) => entity.name.isNotEmpty)
        .toList();
  }

  static List<dynamic> _normalizeToList(dynamic source) {
    if (source is List) {
      return source;
    }
    if (source is Iterable) {
      return source.toList();
    }
    if (source is String && source.isNotEmpty) {
      try {
        final decoded = jsonDecode(source);
        if (decoded is List) {
          return decoded;
        }
      } catch (_) {
        return const [];
      }
    }
    return const [];
  }

  String get formattedAmount {
    return '${currency.toUpperCase()} ${amount.toStringAsFixed(2)}';
  }
}
