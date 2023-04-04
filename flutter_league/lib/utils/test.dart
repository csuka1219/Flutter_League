import 'dart:collection';

double highestPossiblePlayrate(
    Map<String, Map<String, double>> championPositions) {
  Map<String, double> maxes = {
    "TOP": 0.0,
    "JUNGLE": 0.0,
    "MIDDLE": 0.0,
    "BOTTOM": 0.0,
    "UTILITY": 0.0
  };
  championPositions.forEach((champion, rates) {
    rates.forEach((position, rate) {
      if (rate > maxes[position]!) {
        maxes[position] = rate;
      }
    });
  });
  return maxes.values.reduce((a, b) => a + b) / maxes.length;
}

double calculateMetric(Map<String, Map<String, double>> championPositions,
    Map<String, int> championsByPosition) {
  return championsByPosition.entries
          .map((entry) =>
              championPositions[entry.value.toString()]![entry.key] ?? 0.0)
          .reduce((a, b) => a + b) /
      championsByPosition.length;
}

double calculateConfidence(double bestMetric, double secondBestMetric) {
  double confidence = (bestMetric - secondBestMetric) / bestMetric * 100;
  return confidence;
}

List<dynamic> getPositions(
    Map<String, Map<String, double>> championPositions, List<int> composition,
    {int? top, int? jungle, int? middle, int? bottom, int? utility}) {
// Check the types in composition and the other input types
  if (composition.any((element) => element is! int)) {
    throw ArgumentError('The composition must be a list of champion IDs.');
  }
  if ([top, jungle, middle, bottom, utility]
      .any((element) => element != null && element is! int)) {
    throw ArgumentError('The composition must be a list of champion IDs.');
  }

  if (top != null &&
      jungle != null &&
      middle != null &&
      bottom != null &&
      utility != null) {
    throw ArgumentError('The composition was predefined by the kwargs.');
  }

// Set the initial guess to be the champion in the composition, order doesn't matter
  Map<String, int> bestPositions = {
    "TOP": composition[0],
    "JUNGLE": composition[1],
    "MIDDLE": composition[2],
    "BOTTOM": composition[3],
    "UTILITY": composition[4]
  };
  double bestMetric = calculateMetric(championPositions, bestPositions);
  double secondBestMetric = double.negativeInfinity;
  Map<String, int>? secondBestPositions;

// Figure out which champions and positions we need to fill
  List<int> knownChampions = [
    if (top != null) top,
    if (jungle != null) jungle,
    if (middle != null) middle,
    if (bottom != null) bottom,
    if (utility != null) utility
  ];
  List<int> unknownChampions = composition
      .where((champion) => !knownChampions.contains(champion))
      .toList();
  List<String> unknownPositions =
      ["TOP", "JUNGLE", "MIDDLE", "BOTTOM", "UTILITY"].where((position) {
    switch (position) {
      case "TOP":
        return top == null;
      case "JUNGLE":
        return jungle == null;
      case "MIDDLE":
        return middle == null;
      case "BOTTOM":
        return bottom == null;
      case "UTILITY":
        return utility == null;
      default:
        return true;
    }
  }).toList();

  Map<String, int> testComposition = {
    "TOP": top ?? unknownChampions[0],
    "JUNGLE": jungle ?? unknownChampions[0],
    "MIDDLE": middle ?? unknownChampions[1],
    "BOTTOM": bottom ?? unknownChampions[2],
    "UTILITY": utility ?? unknownChampions[3]
  };

// Try all possible combinations of unknown champions in unknown positions
  for (int i = 0; i < unknownChampions.length; i++) {
    for (int j = 0; j < unknownPositions.length; j++) {
      try {
        testComposition[unknownPositions[j]] = unknownChampions[j];
      } on RangeError catch (_) {
        testComposition[unknownPositions[j]] = unknownChampions[0];
      }
    }
    //for (int j = 0; j < unknownPositions.length; j++) {
    Map<String, int> tempPositions = Map.from(testComposition);
    //tempPositions[unknownPositions[j]] = unknownChampions[i];
    double metric = calculateMetric(championPositions, tempPositions);
    if (metric > bestMetric) {
      secondBestMetric = bestMetric;
      secondBestPositions = Map.from(bestPositions);
      bestMetric = metric;
      bestPositions = Map.from(tempPositions);
    } else if (metric > secondBestMetric) {
      secondBestMetric = metric;
      secondBestPositions = Map.from(tempPositions);
    }
    //}
  }

  // List<List<int>> permutations =
  //     _permutations(unknownChampions, unknownPositions.length);
  // for (List<int> champs in permutations) {
  //   Map<String, int> testComposition = Map<String, int>.from(bestPositions);
  //   for (int i = 0; i < unknownPositions.length; i++) {
  //     testComposition[unknownPositions[i]] = champs[i];
  //   }

  //   double metric = calculateMetric(championPositions, testComposition);
  //   if (metric > bestMetric) {
  //     secondBestMetric = bestMetric;
  //     secondBestPositions = Map<String, int>.from(bestPositions);
  //     bestMetric = metric;
  //     bestPositions = Map<String, int>.from(testComposition);
  //   }

  //   if (bestMetric > metric && metric > secondBestMetric) {
  //     secondBestMetric = metric;
  //     secondBestPositions = Map<String, int>.from(testComposition);
  //   }
  // }

// If we didn't find a better composition, just return the original one
  if (secondBestPositions == null) {
    return bestPositions.values.toList();
  }

// Calculate the confidence level and return the two best compositions
  double confidence = calculateConfidence(bestMetric, secondBestMetric);
  return [
    bestPositions.values.toList(),
    secondBestPositions.values.toList(),
    confidence
  ];
}

// Helper function to generate permutations of a list of integers
List<List<int>> _permutations(List<int> list, int length) {
  if (length == 0) {
    return [[]];
  }
  List<List<int>> result = [];
  for (int i = 0; i < list.length; i++) {
    int element = list[i];
    List<int> remaining = List<int>.from(list);
    remaining.remove(element);
    List<List<int>> permutations = _permutations(remaining, length - 1);
    for (List<int> perm in permutations) {
      result.add([element, ...perm]);
    }
  }
  return result;
}
