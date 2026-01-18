import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

final bottomNavIndexProvider = StateProvider<int>((ref) => 1);
