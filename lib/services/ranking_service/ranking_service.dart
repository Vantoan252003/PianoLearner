import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api/api_endpoint.dart';
import '../../auth/auth_process/token_storage.dart';
import '../../models/ranking_model.dart';

class RankingService {
  /// Lấy danh sách bảng xếp hạng
  Future<List<RankingModel>> getRanking() async {
    try {
      String? token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.ranking}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return RankingModel.fromJsonList(data);
      } else {
        throw Exception('Failed to load ranking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading ranking: $e');
    }
  }

  /// Lấy thứ hạng của user hiện tại
  Future<RankingModel?> getMyRanking() async {
    try {
      final rankings = await getRanking();
      // Giả sử userId của user hiện tại được lưu trong TokenStorage
      // Hoặc có thể thêm endpoint riêng để lấy thông tin user hiện tại
      return rankings.isNotEmpty ? rankings.first : null;
    } catch (e) {
      throw Exception('Error loading my ranking: $e');
    }
  }

  /// Lấy top N người chơi
  Future<List<RankingModel>> getTopPlayers({int limit = 10}) async {
    try {
      final rankings = await getRanking();
      return rankings.take(limit).toList();
    } catch (e) {
      throw Exception('Error loading top players: $e');
    }
  }
}
