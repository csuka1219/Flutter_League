// This function calculates the highest possible playrate across all positions.
// It takes a map of champion positions and their playrates as input.
double highestPossiblePlayrate(
    Map<String, Map<String, double>> championPositions) {
  // Create a map of maximum playrates for each position.
  Map<String, double> maxes = {
    "TOP": 0.0,
    "JUNGLE": 0.0,
    "MIDDLE": 0.0,
    "BOTTOM": 0.0,
    "UTILITY": 0.0
  };

  // Loop through each champion and their playrates for each position.
  championPositions.forEach((champion, rates) {
    rates.forEach((position, rate) {
      // If the playrate for this champion in this position is greater than the current maximum,
      // update the maximum for this position.
      if (rate > maxes[position]!) {
        maxes[position] = rate;
      }
    });
  });

  // Calculate the average of the maximum playrates for all positions.
  return maxes.values.reduce((a, b) => a + b) / maxes.length;
}

// Calculates a metric for a given set of champions by position, based on their positions' values
double calculateMetric(Map<String, Map<String, double>> championPositions,
    Map<String, int> championsByPosition) {
  // For each champion in its respective position, retrieve the corresponding value
  // If a champion doesn't have a corresponding value, use 0.0 as a default value
  // Calculate the sum of all values
  // Divide the sum by the number of champions in the composition to get the average metric
  return championsByPosition.entries
          .map((entry) =>
              championPositions[entry.value.toString()]![entry.key] ?? 0.0)
          .reduce((a, b) => a + b) /
      championsByPosition.length;
}

// Calculates the confidence level for a given set of metrics
double calculateConfidence(double bestMetric, double secondBestMetric) {
  // Calculate the difference between the best and second best metrics
  // Normalize the difference based on the best metric
  // Multiply by 100 to get the confidence level as a percentage
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
  for (var champs in permutations(unknownChampions, unknownPositions.length)) {
    for (int j = 0; j < unknownPositions.length; j++) {
      testComposition[unknownPositions[j]] = champs[j];
    }

    // Calculate the metric for the current composition
    Map<String, int> tempPositions = Map.from(testComposition);
    double metric = calculateMetric(championPositions, tempPositions);

    // Update the best and second-best compositions if necessary
    if (metric > bestMetric) {
      secondBestMetric = bestMetric;
      secondBestPositions = Map.from(bestPositions);
      bestMetric = metric;
      bestPositions = Map.from(tempPositions);
    } else if (metric > secondBestMetric) {
      secondBestMetric = metric;
      secondBestPositions = Map.from(tempPositions);
    }
  }

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

// This function generates all permutations of a given length from a list of items.
// It uses a recursive approach to generate the permutations.
// The function is a generator, so it yields each permutation as it is generated.
Iterable<List<T>> permutations<T>(List<T> items, int length) sync* {
  // If the desired length is 0, yield an empty list and return.
  if (length == 0) {
    yield <T>[];
    return;
  }

  // Loop over the items in the input list.
  for (int i = 0; i < items.length; i++) {
    // Select the current item.
    T current = items[i];

    // Create a new list of remaining items by removing the current item from the input list.
    List<T> remaining = List<T>.from(items)..removeAt(i);

    // Generate all permutations of length length-1 from the remaining items.
    for (List<T> permutation in permutations(remaining, length - 1)) {
      // Yield a new list consisting of the current item followed by the permutation.
      yield [current, ...permutation];
    }
  }
}
