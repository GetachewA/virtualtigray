import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:virtual_tigray/main.dart';
import 'package:virtual_tigray/providers/auth_provider.dart';
import 'package:virtual_tigray/providers/theme_provider.dart';

void main() {
  testWidgets('shows the splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await dotenv.load();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(false)),
        ],
        child: const VirtualTigrayApp(),
      ),
    );

    expect(find.text('Virtual Tigray'), findsOneWidget);
    expect(find.text('Discover, Connect, Grow'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to connect with the community'), findsOneWidget);
  });
}
