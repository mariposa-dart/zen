import 'package:html_builder/elements.dart';
import 'package:html_builder/html_builder.dart';
import 'package:test/test.dart';
import 'package:zen/zen.dart';

final StringRenderer renderer =
    new StringRenderer(pretty: false, doctype: null);

main() {
  group('single', () {
    test('attribute selector', () {
      var $dom = ul(c: [
        li(c: [img(src: 'foo')])
      ]);
      print(renderer.render($dom));

      var $img = Zen.querySelector($dom, '[src]');
      print(renderer.render($img));

      expect(Zen.querySelector($dom, '[src="foo"]'), $img);
      expect(Zen.querySelector($dom, '[src="bar"]'), isNull);
    });

    test('class selector', () {
      var $dom = div(c: [
        p(className: ['green', 'eggs', 'and', 'ham'])
      ]);

      var $ham = Zen.querySelector($dom, '.ham');
      expect($ham, isNotNull);
      expect($ham.tagName, 'p');
    });

    test('element selector', () {
      var $dom = ul(
          c: new List<Node>.generate(
              5, (i) => li(c: [text('Item #${i + 1}')])));
      print(renderer.render($dom));

      var $li = Zen.querySelectorAll($dom, 'li');
      print($li.map(renderer.render).toList());

      expect($li, hasLength(5));
      expect(
          $li,
          everyElement(
              predicate((Node node) => node.tagName == 'li', 'is a <li>')));
    });

    test('negation selector', () {
      var $dom = div(c: [
        p(className: ['green', 'eggs', 'and', 'ham'])
      ]);

      var $ham = Zen.querySelector($dom, ':not(.steak)');
      expect($ham, isNotNull);
      expect($ham.tagName, 'p');
    });
  });

  group('multiple', () {
    test('class and id', () {
      var $dom = div(c: [
        p(id: 'seuss', className: ['green', 'eggs', 'and', 'ham'])
      ]);

      var $ham = Zen.querySelector($dom, '.green#seuss');
      expect($ham, isNotNull);
      print(renderer.render($ham));

      expect(Zen.querySelector($dom, '.green:not(#seuss)'), isNull);
      expect(Zen.querySelector($dom, '#seuss:not(.green)'), isNull);
      expect(Zen.querySelector($dom, '.green#not-seuss'), isNull);
    });
  });
}
