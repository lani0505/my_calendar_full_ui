import 'package:flutter_test/flutter_test.dart';
import 'package:my_calendar_full/main.dart';

void main() {
  testWidgets('My Calendar starts', (tester) async {
    await tester.pumpWidget(const MyCalendarApp());
    expect(find.text('My Calendar'), findsOneWidget);
  });
}
