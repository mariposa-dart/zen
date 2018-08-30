import 'package:test/test.dart';
import 'package:zen/zen.dart';

void main() {
  test('defaults to div', () {
    expect(z('.foo').tagName, 'div');
  });
  test('custom tag name', () {
    expect(z('li').tagName, 'li');
  });

  test('single class', () {
    expect(z('.bar').attributes['class'], ['bar']);
  });

  test('multiple classes', () {
    expect(z('.bar.baz.quux').attributes['class'], ['bar', 'baz', 'quux']);
  });

  test('string attribute', () {
    expect(z('[foo="bar"]').attributes['foo'], 'bar');
  });

  test('boolean attribute', () {
    expect(z('[foo]').attributes['foo'], true);
  });

  test('custom tag, attributes, and class', () {
    var node = z('li.open.closed[foo="bar"][baz="quux"]');
    print(node.attributes);
    expect(node.tagName, 'li');
    expect(node.attributes['class'], ['open', 'closed']);
    expect(node.attributes['foo'], 'bar');
    expect(node.attributes['baz'], 'quux');
  });
}
