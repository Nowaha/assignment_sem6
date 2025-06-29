import 'dart:math';

import 'package:latlong2/latlong.dart';

class Generate {
  static final rand = Random();

  static const _words = [
    "banana",
    "tree",
    "flutter",
    "sky",
    "apple",
    "run",
    "cat",
    "moon",
    "ocean",
    "bright",
    "calm",
    "swift",
    "cloud",
    "happy",
    "fire",
    "dream",
    "volcano",
    "river",
    "mountain",
    "forest",
    "star",
    "light",
    "wind",
    "peace",
    "i",
    "a",
    "the",
    "and",
    "to",
    "is",
  ];

  static const _names = [
    "Alice",
    "Bob",
    "Charlie",
    "Diana",
    "Ethan",
    "Fiona",
    "George",
    "Hannah",
    "Ian",
    "Jasmine",
    "Kevin",
    "Liam",
    "Mia",
    "Nora",
    "Oliver",
    "Paula",
    "Quinn",
    "Ryan",
    "Sophie",
    "Tom",
  ];

  static const _lastNames = [
    "Smith",
    "Johnson",
    "Williams",
    "Jones",
    "Brown",
    "Davis",
    "Miller",
    "Wilson",
    "Moore",
    "Taylor",
    "Anderson",
    "Thomas",
    "Jackson",
    "White",
    "Harris",
  ];

  static String username({String? first, String? last}) {
    first ??= firstName().toLowerCase();
    last ??= lastName().toLowerCase();
    return "$first.$last${rand.nextInt(1000)}";
  }

  static String firstName() => _names[rand.nextInt(_names.length)];
  static String lastName() => _lastNames[rand.nextInt(_lastNames.length)];
  static String word() => _words[rand.nextInt(_words.length)];
  static String sentence(int wordCount) {
    final sentence =
        "${List.generate(wordCount, (_) => _words[rand.nextInt(_words.length)]).join(" ")}.";
    return sentence.substring(0, 1).toUpperCase() + sentence.substring(1);
  }

  static String paragraph(int sentenceCount) => List.generate(
    sentenceCount,
    (_) => sentence(rand.nextInt(5) + 5),
  ).join(" ");

  static LatLng location() => LatLng(
    41.8719 + rand.nextDouble() * 0.5 - 0.05,
    12.5674 + rand.nextDouble() * 0.5 - 0.05,
  );
}
