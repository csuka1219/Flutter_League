# Flutter_League

This Flutter app is a League of Legends companion app that allows users to search for and save their favorite summoners, view their stats and match history, and check the currently ongoing game.

## Pages

- Home page: The Home page is the first screen users see when they open the app. It displays information about the summoners that the user has saved as favorites. At here you can select League of Legends server and search for summoners.
- Match history page: Match History Page is a Flutter page that displays a summoner's match history. It shows the summoner's rank, match history data and provides the user with the option to load more matches
- Match info page: The Match Info page displays the details of a specific match, including the result, player stats, and team compositions.
- Match details page: The Match Details page displays information about kills, gold, damage dealt, damage taken, wards, and CS in a TabView format. 
- Live game page: The Live Game page displays information about a currently ongoing League of Legends game, including player information and match details. Is uses the DartLeagueRoleIdentify algorithm, available on GitHub at https://github.com/csuka1219/DartLeagueRoleIdentify, to identify the role for each player in the game.

## Getting Started

To run the app, you need to do the following steps:

1. Clone the repository to your local machine.
2. Open the project in your IDE of choice (e.g., Android Studio, VS Code).
3. Create a Riot API key and add it to the lib/utils/constants.dart file. You can get a key by following the instructions [here](https://developer.riotgames.com/docs/portal).
4. Run the app in the emulator or on a physical device.

## Dependencies

The app uses the following dependencies:

- provider: A state management library that allows easy sharing of data between widgets.
- flutter_svg: A library for rendering SVG images in Flutter.
- http: A library for making HTTP requests to an API.
- intl: A library for formatting dates and numbers.
- tuple: A library for creating and manipulating tuples.
- shared_preferences: A library for persisting key-value data on the device.

## Screenshots

Here are some screenshots of the app:

![Home page](flutter_league/screenshots/home.png)
![Home page](flutter_league/screenshots/home2.png)
![Match history page](flutter_league/screenshots/match_history.png)
![Match info page](flutter_league/screenshots/match_info.png)
![Match details page](flutter_league/screenshots/match_details.png)
![Live game page](flutter_league/screenshots/live_game.png)

## License

This project is licensed under the MIT License. Feel free to use it for your own purposes.
