import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'design/routes.dart';
import 'design/tokens.dart';
import 'state/app_state.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/license_screen.dart';
import 'design/kbreak.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  registerFontLicense();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: WidgetsApp(
        title: '가정간호노트',
        color: T.nurse,
        debugShowCheckedModeBanner: false,
        pageRouteBuilder: <R>(RouteSettings settings, WidgetBuilder builder) =>
            fadeRoute<R>(Builder(builder: builder), settings),
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    if (s.loading) return Container(color: T.w);
    if (s.loadError != null) return _LoadFail(message: s.loadError!);
    return s.disclaimerAcked ? const HomeScreen() : const IntroScreen();
  }
}

class _LoadFail extends StatelessWidget {
  final String message;
  const _LoadFail({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: T.w,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(T.pad),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const KText('콘텐츠를 읽지 못했습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: T.ff,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: T.g900)),
        const SizedBox(height: 10),
        KText('assets/content.json 을 확인해 주세요.\n$message',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: T.ff, fontSize: 13, height: 1.6, color: T.g500)),
      ]),
    );
  }
}
