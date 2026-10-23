import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/app.dart';

void main() {
  testWidgets('Aplikasi dapat dijalankan', (tester) async {
    await tester.pumpWidget(const AbsenKuyApp());
    expect(find.text('absenKuy'), findsOneWidget);
  });
}
