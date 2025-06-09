import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareSearchResults({
    required bool isHotels,
    required List<Map<String, dynamic>> items,
    required String searchQuery,
  }) async {
    if (items.isEmpty) {
      await Share.share('No ${isHotels ? 'hotels' : 'events'} found for "$searchQuery"');
      return;
    }

    final StringBuffer shareText = StringBuffer()
      ..writeln(isHotels ? '🏨 Hotels Results' : '🎟️ Events Results')
      ..writeln('Search: "$searchQuery"')
      ..writeln('----------------------------');

    for (final item in items) {
      shareText.writeln();
      
      if (isHotels) {
        shareText
          ..writeln('🔹 ${item['name'] ?? 'Unnamed Hotel'}')
          ..writeln('📍 ${item['location'] ?? 'Location not specified'}')
          ..writeln('💰 ${item['price']?.toStringAsFixed(2) ?? 'N/A'} ₪')
          ..writeln('⭐ ${item['rating'] ?? 'Not rated'}');
      } else {
        shareText
          ..writeln('🔹 ${item['name'] ?? 'Unnamed Event'}')
          ..writeln('📍 ${item['location'] ?? 'Location not specified'}')
          ..writeln('💰 ${item['price']?.toStringAsFixed(2) ?? 'N/A'} ₪')
          ..writeln('📅 ${item['date'] ?? 'Date not specified'}');
      }
    }

    shareText.writeln('\nFound ${items.length} ${isHotels ? 'hotels' : 'events'}');
    await Share.share(shareText.toString());
  }
}