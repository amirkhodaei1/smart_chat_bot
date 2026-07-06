import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_chat_bot/views/chat_view.dart';

void main() {
  testWidgets('Chat screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: ChatView(), // اصلاح نام کلاس
      ),
    );

    expect(find.text('هوشمند چت'), findsOneWidget);
  });
}