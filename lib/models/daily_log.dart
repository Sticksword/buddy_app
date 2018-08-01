// example usage - Post.fromJson(responseJson);
// see more - https://flutter.io/cookbook/networking/authenticated-requests/
class DailyLog {
  final int userId;
  final String text;
  final double sentimentScore;
  final double sentimentMagnitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyLog({this.userId, this.text, this.sentimentScore, this.sentimentMagnitude, this.createdAt, this.updatedAt});

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    print('called fromJson');
    return DailyLog(
      userId: json['user_id'],
      text: json['text'],
      sentimentScore: json['sentiment_score'],
      sentimentMagnitude: json['sentiment_magnitude'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']
    );
  }
}