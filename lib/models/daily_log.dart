// example usage - Post.fromJson(responseJson);
// see more - https://flutter.io/cookbook/networking/authenticated-requests/
class DailyLog {
  int userId;
  String text;
  double sentimentScore;
  double sentimentMagnitude;
  DateTime createdAt;

  DailyLog({this.userId, this.text, this.sentimentScore, this.sentimentMagnitude, this.createdAt});

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      userId: int.parse(json['id']),
      text: json['attributes']['text'],
      sentimentScore: double.parse(json['attributes']['sentiment-score']),
      sentimentMagnitude: double.parse(json['attributes']['sentiment-magnitude']),
      createdAt: DateTime.parse(json['attributes']['created-at'])
    );
  }
}