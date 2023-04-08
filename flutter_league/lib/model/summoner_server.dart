class SummonerServer {
  final String summonerName;
  final String server;

  SummonerServer({required this.summonerName, required this.server});

  Map<String, dynamic> toJson() {
    return {
      'summonerName': summonerName,
      'server': server,
    };
  }

  factory SummonerServer.fromJson(Map<String, dynamic> json) {
    return SummonerServer(
      summonerName: json['summonerName'],
      server: json['server'],
    );
  }
}
