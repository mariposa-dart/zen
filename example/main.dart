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
