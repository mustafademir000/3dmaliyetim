import 'package:flutter_test/flutter_test.dart';
import 'package:maliyet3d/main.dart';

void main() {
  testWidgets('App renders correctly test', (WidgetTester tester) async {
    await tester.pumpWidget(const Maliyet3dApp());
    await tester.pumpAndSettle();

    expect(find.text('3D Maliyetim'), findsOneWidget);
    expect(find.text('Hesapla'), findsOneWidget);
    expect(find.text('Ön Ayarlar'), findsOneWidget);
    expect(find.text('Kaydedilenler'), findsOneWidget);
  });
}
