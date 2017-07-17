import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
import 'package:html_builder/html_builder.dart';

typedef bool NodeMatcher(Node node);

Iterable<Node> querySelectorAll(Node node, String selectors, bool recursive) {
  var matcher = _compileQuery(parseSelectorGroup(selectors));

  if (!recursive)
    return node.children.where(matcher);
  else {
    Iterable<Node> crawl(Node root) {
      return root.children.fold<List<Node>>([], (o, n) {
        if (matcher(n)) o.add(n);
        return o..addAll(crawl(n));
      });
    }

    return crawl(node);
  }
}

NodeMatcher _compileQuery(SelectorGroup selectors) {
  var matchers = selectors.selectors.map<NodeMatcher>(_compileSelector);
  return (Node node) => matchers.every((m) => m(node));
}

NodeMatcher _compileSelector(Selector selector) {
  var matchers =
      selector.simpleSelectorSequences.map<NodeMatcher>(_compileSequence);
  return (Node node) => matchers.every((m) => m(node));
}

NodeMatcher _compileSequence(SimpleSelectorSequence sequence) {
  // TODO: Combinators

  if (sequence.isCombinatorNone) {
    return _compileSimpleSelector(sequence.simpleSelector);
  }
}

NodeMatcher _compileSimpleSelector(SimpleSelector simple) {
  if (simple is PseudoClassSelector || simple is PseudoElementSelector)
    throw new UnsupportedError(
        'Pseudo-elements and pseudo-classes are not supported.');
  else if (simple is AttributeSelector) {
    if (simple.value == null)
      return (Node node) => node.attributes.containsKey(simple.name);
    else
      return (Node node) => node.attributes[simple.name] == simple.value;
  } else if (simple is ElementSelector) {
    return (Node node) => node.tagName == simple.name;
  } else if (simple is IdSelector) {
    return (Node node) => node.attributes['id'] == simple.name;
  }  else if (simple is ClassSelector) {
    return (Node node) {
      if (!node.attributes.containsKey('class')) return false;

      var clazz = node.attributes['class'];
      if (clazz is String || clazz is List)
        return clazz.contains(simple.name);
      else if (clazz is Map)
        return clazz.containsKey(simple.name);
      else
        throw new UnsupportedError('Cannot search class attribute $clazz.');
    };
  } else if (simple is NegationSelector) {
    var matcher = _compileSimpleSelector(simple.negationArg);
    return (Node node) => !matcher(node);
  } else throw new UnsupportedError('Unsupported CSS selector: ${simple.runtimeType}');
}
