import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/app.dart';
import 'package:absen_kuy/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('Aplikasi dibuka dengan halaman Splash', (tester) async {
    await tester.pumpWidget(const AbsenKuyApp());
    expect(find.byType(SplashPage), findsOneWidget);
  });
}
