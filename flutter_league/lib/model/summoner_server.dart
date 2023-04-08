class SummonerServer {
  final String puuid;
  final String server;

  SummonerServer({required this.puuid, required this.server});

  Map<String, dynamic> toJson() {
    return {
      'puuid': puuid,
      'server': server,
    };
  }

  factory SummonerServer.fromJson(Map<String, dynamic> json) {
    return SummonerServer(
      puuid: json['puuid'],
      server: json['server'],
    );
  }
}
