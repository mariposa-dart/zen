# zen
Build `html_builder` nodes by writing CSS selectors.
Also includes `querySelector` functionality for `html_builder`
AST's.

Using the `z` function, you can cleanly create
complex, nested HTML trees.

# Example

```dart
import 'package:html_builder/elements.dart';
import 'package:html_builder/html_builder.dart';
import 'package:zen/zen.dart';

Node semanticUiForm() {
  return z('form.ui.form', [
    z('.ui.left.icon.input', [
      z('i.chat.icon'),
      z('input[type="text"][placeholder="Say something..."]'),
    ]),
    z('button.ui.submit.button', [
      text('Submit'),
    ]),
  ]);
}

void main() {
  var tree = semanticUiForm();
  print(new StringRenderer().render(tree));
  print(Zen.querySelectorAll(tree, '.ui'));
}
```