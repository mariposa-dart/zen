import 'package:html_builder/html_builder.dart';
import 'src/factory.dart';
import 'src/query.dart' as q;

/// Call this with a CSS selector to create an element on-the-fly.
final Zen zen = new _Zen();

abstract class Zen {
  /// Finds all children of a given node matching the given CSS [selectors].
  static Iterable<Node> querySelectorAll(Node node, String selectors,
      {bool recursive: true}) {
    return q.querySelectorAll(node, selectors, recursive);
  }

  /// Finds the first child of a given node matching the given CSS [selectors].
  static Node querySelector(Node node, String selectors,
      {bool recursive: true}) {
    var results =
        querySelectorAll(node, selectors, recursive: recursive != false);
    return results.isNotEmpty ? results.first : null;
  }

  Node call(String selectors, [Iterable<Node> children = const []]);
}

class _Zen implements Zen {
  final Map<String, ElementFactory> _cache = {};

  _Zen();

  @override
  Node call(String selectors, [Iterable<Node> children = const []]) {
    var $factory = _cache.putIfAbsent(selectors, () => buildFactory(selectors));
    return $factory(children);
  }

  ElementFactory buildFactory(String selectors) {}
}
