

import 'package:flutter_test/flutter_test.dart';
import 'package:sloth_day/utils/widget_utils.dart';

void main() {

  test('Test removeDecimalZeroFormat', () {
    expect("12.5", removeDecimalZeroFormat(12.50));
    expect("12", removeDecimalZeroFormat(12.0));
    expect("1000", removeDecimalZeroFormat(1000));
  });
}