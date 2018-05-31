import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
import 'package:html_builder/html_builder.dart';
import 'src/factory.dart';
import 'src/query.dart' as q;

/// Call this with a CSS selector to create an element on-the-fly.
final Zen z = new _Zen();

abstract class Zen {
  static const List<String> _selfClosing = const [
    "area",
    "base",
    "br",
    "col",
    "command",
    "embed",
    "hr",
    "img",
    "input",
    "keygen",
    "link",
    "menuitem",
    "meta",
    "param",
    "source",
    "track",
    "wbr",
  ];

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

  ElementFactory buildFactory(String selectors) {
    var selectorGroup = parseSelectorGroup(selectors);
    var simpleSelectors =
        selectorGroup.selectors.fold<List<SimpleSelector>>([], (out, s) {
      for (var seq in s.simpleSelectorSequences) out.add(seq.simpleSelector);
      return out;
    });
    var attrs = <String, dynamic>{};
    String tagName = 'div';

    for (var selector in simpleSelectors) {
      if (selector is PseudoClassSelector || selector is PseudoElementSelector)
        throw new UnsupportedError(
            'Pseudo-elements and pseudo-classes are not supported.');
      else if (selector is AttributeSelector) {
        var attr = selector;
        if (attr.value == null)
          attrs[attr.name] = true;
        else
          attrs[attr.name] = attr.value;
      } else if (selector is ElementSelector) {
        tagName = selector.name;
      } else if (selector is IdSelector) {
        attrs['id'] = selector.name;
      } else if (selector is ClassSelector) {
        var clazz = attrs.putIfAbsent('class', () => []);
        if (clazz is List) clazz.add(selector.name);
      } else if (selector is NegationSelector) {
        throw new UnsupportedError('Negations are not supported.');
      } else
        throw new UnsupportedError(
            'Unsupported CSS selector.\n${selector.span.highlight()}');
    }

    if (Zen._selfClosing.contains(tagName))
      return (children) => new SelfClosingNode(tagName, attrs);
    return (children) => h(tagName, attrs, children);
  }
}
