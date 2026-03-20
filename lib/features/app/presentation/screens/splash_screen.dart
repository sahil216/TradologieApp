import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/get_device_id.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/routes/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../injection_container.dart';

// ─────────────────────────────────────────────
//  COLOURS
// ─────────────────────────────────────────────
class _C {
  static const bgDeep = Color(0xFF0A1A0A);
  static const green = Color(0xFF4ACD4A);
  static const greenDark = Color(0xFF2D8A2D);
  static const greenDeep = Color(0xFF1A5C1A);
  static const amber = Color(0xFFF5C842);
  static const amberDark = Color(0xFFE8972A);
  static const red = Color(0xFFE84C2A);
  static const blue = Color(0xFF42A8D4);
  static const cardBg = Color(0xD10A1A0A);
  static const cardBorder = Color(0x474ACD4A);
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbit1;
  late final AnimationController _orbit2;
  late final AnimationController _orbit3;
  late final AnimationController _globeCtrl;
  late final AnimationController _cardCtrl;
  late final AnimationController _progCtrl;
  late final AnimationController _topCtrl;
  late final List<AnimationController> _floatCtrls;

  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _iconScale;
  late final Animation<double> _progVal;
  late final Animation<double> _topFade;
  late final List<Animation<double>> _floatAnim;

  final _agroItems = ['🌾', '🌽', '🍅', '🫘', '🌿', '🌱'];
  final _rand = math.Random(42);
  late final List<Offset> _iconPos;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    _orbit1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
    _orbit2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 14))
          ..repeat();
    _orbit3 =
        AnimationController(vsync: this, duration: const Duration(seconds: 22))
          ..repeat();
    _globeCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();

    _cardCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _cardFade = CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _cardSlide = Tween<Offset>(begin: const Offset(0, .15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _cardCtrl,
            curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic)));
    _iconScale = Tween<double>(begin: .4, end: 1.0).animate(CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.2, 0.75, curve: Curves.elasticOut)));

    _progCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800));
    _progVal = CurvedAnimation(parent: _progCtrl, curve: Curves.easeInOut);

    _iconPos = List.generate(
        6,
        (_) => Offset(
              _rand.nextDouble() * .82 + .06,
              _rand.nextDouble() * .48 + .06,
            ));
    _floatCtrls = List.generate(
        6,
        (i) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 3500 + i * 400)));
    _floatAnim = _floatCtrls
        .map((c) => Tween<double>(begin: 0, end: -10)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)))
        .toList();
    for (var i = 0; i < 6; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _floatCtrls[i].repeat(reverse: true);
      });
    }

    _topCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _topFade = CurvedAnimation(parent: _topCtrl, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _cardCtrl.forward();
        _topCtrl.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _progCtrl.forward();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Constants().checkAndroidVersion();
      if (Constants.deviceID == '') {
        Constants.deviceID = await DeviceIdService.getDeviceId();
      }
    });
    _startDelay(context);
  }

  @override
  void dispose() {
    _orbit1.dispose();
    _orbit2.dispose();
    _orbit3.dispose();
    _globeCtrl.dispose();
    _cardCtrl.dispose();
    _progCtrl.dispose();
    _topCtrl.dispose();
    for (final c in _floatCtrls) c.dispose();
    super.dispose();
  }

  Future<void> _nameUpdate() async {
    final s = SecureStorageService();
    Constants.name = Constants.isFmcg == true
        ? await s.read(AppStrings.fmcgName) ?? ''
        : Constants.isBuyer == true
            ? await s.read(AppStrings.customerName) ?? ''
            : await s.read(AppStrings.vendorName) ?? '';
  }

  Future<void> _goNext(BuildContext ctx) async {
    await _nameUpdate();
    if (!ctx.mounted) return;
    if (Constants.isLogin) {
      sl<NavigationService>().pushNamedAndRemoveUntil(
          Constants.isFmcg == true || Constants.isBuyer == true
              ? Routes.fmcgMainScreen
              : Routes.mainRoute);
    } else {
      sl<NavigationService>().pushNamedAndRemoveUntil(Routes.onboardingRoute);
    }
  }

  void _startDelay(BuildContext ctx) {
    Future.delayed(const Duration(milliseconds: 12000), () {
      if (!ctx.mounted) return;
      _goNext(ctx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _C.bgDeep,
      extendBodyBehindAppBar: true,
      body: BlocListener<AppCubit, AppState>(
        listener: (_, __) {},
        child: Stack(
          children: [
            // Lottie / gradient

            // Star field
            const Positioned.fill(child: _StarField()),

            // Orbit system — centred in top 65% of screen
            Positioned(
              top: size.height * .06,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 340,
                  height: 340,
                  child: _OrbitSystem(
                    orbit1: _orbit1,
                    orbit2: _orbit2,
                    orbit3: _orbit3,
                    globe: _globeCtrl,
                  ),
                ),
              ),
            ),

            // Floating agri icons
            ...List.generate(6, (i) {
              final p = _iconPos[i];
              return Positioned(
                left: p.dx * size.width,
                top: p.dy * size.height * .68,
                child: AnimatedBuilder(
                  animation: _floatAnim[i],
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _floatAnim[i].value),
                    child: Opacity(
                        opacity: .72,
                        child: Text(_agroItems[i],
                            style: const TextStyle(fontSize: 22))),
                  ),
                ),
              );
            }),

            // Top category label
            Positioned(
              top: MediaQuery.of(context).padding.top + 14,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _topFade,
                child: const Text(
                  'Agriculture  ·  Trade  ·  Technology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0x7F4ACD4A),
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ),

            // Logo card pinned to bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: _buildCard(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() => Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _C.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 40,
                offset: const Offset(0, -8)),
            BoxShadow(
                color: _C.green.withOpacity(.06),
                blurRadius: 60,
                spreadRadius: -10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_C.greenDark, _C.greenDeep],
                      ),
                      border: Border.all(
                          color: _C.green.withOpacity(.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: _C.green.withOpacity(.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: CustomPaint(painter: _GlobePainter()),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -.5,
                            height: 1.0),
                        children: [
                          TextSpan(text: 'tradologie'),
                          TextSpan(
                              text: '.', style: TextStyle(color: _C.green)),
                          TextSpan(text: 'com'),
                        ],
                      )),
                      const SizedBox(height: 3),
                      Text('TRADE THROUGH TECHNOLOGY',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _C.green.withOpacity(.55),
                              letterSpacing: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Connecting Agro Markets & FMCG Brands',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(.38),
                    letterSpacing: .2)),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _progVal,
              builder: (_, __) => Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: _progVal.value * .92,
                      minHeight: 3,
                      backgroundColor: Colors.white.withOpacity(.1),
                      valueColor: const AlwaysStoppedAnimation(_C.green),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Loading...',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _C.green.withOpacity(.45),
                          letterSpacing: .8)),
                ],
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
//  ORBIT SYSTEM
// ─────────────────────────────────────────────
class _OrbitSystem extends StatelessWidget {
  final AnimationController orbit1, orbit2, orbit3, globe;
  const _OrbitSystem(
      {required this.orbit1,
      required this.orbit2,
      required this.orbit3,
      required this.globe});

  Widget _ring(double s) => Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.07), width: 1)));

  Widget _planet(double s, List<Color> colors, Color glow) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors),
          boxShadow: [BoxShadow(color: glow, blurRadius: 12, spreadRadius: -2)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      _ring(140), _ring(220), _ring(310),

      // Globe
      AnimatedBuilder(
        animation: globe,
        builder: (_, __) => Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A5C1A), Color(0xFF2D8A2D), Color(0xFF0D2B0D)],
            ),
            border: Border.all(color: _C.green.withOpacity(.3), width: 2),
            boxShadow: [
              BoxShadow(
                  color: _C.green.withOpacity(.35),
                  blurRadius: 24,
                  spreadRadius: -4),
              BoxShadow(
                  color: _C.green.withOpacity(.12),
                  blurRadius: 60,
                  spreadRadius: -8),
            ],
          ),
          child:
              ClipOval(child: CustomPaint(painter: _EarthPainter(globe.value))),
        ),
      ),

      _Orbiter(
          ctrl: orbit1,
          radius: 70,
          startAngle: 0,
          child:
              _planet(22, [_C.amber, _C.amberDark], _C.amber.withOpacity(.6))),
      _Orbiter(
          ctrl: orbit2,
          radius: 110,
          startAngle: math.pi / 4,
          child: _planet(
              28, [_C.red, const Color(0xFFC03010)], _C.red.withOpacity(.55))),
      _Orbiter(
          ctrl: orbit3,
          radius: 155,
          startAngle: 2 * math.pi / 3,
          child:
              _planet(18, [_C.green, _C.greenDark], _C.green.withOpacity(.5))),
      _Orbiter(
          ctrl: orbit3,
          radius: 155,
          startAngle: 300 * math.pi / 180,
          child: _planet(
              14, [_C.blue, const Color(0xFF1A6B9A)], _C.blue.withOpacity(.5))),
    ]);
  }
}

// ─────────────────────────────────────────────
//  ORBITER
// ─────────────────────────────────────────────
class _Orbiter extends StatelessWidget {
  final AnimationController ctrl;
  final double radius, startAngle;
  final Widget child;
  const _Orbiter(
      {required this.ctrl,
      required this.radius,
      required this.startAngle,
      required this.child});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) {
          final a = startAngle + ctrl.value * 2 * math.pi;
          return Transform.translate(
            offset: Offset(math.cos(a) * radius, math.sin(a) * radius),
            child: child,
          );
        },
      );
}

// ─────────────────────────────────────────────
//  EARTH PAINTER
// ─────────────────────────────────────────────
class _EarthPainter extends CustomPainter {
  final double t;
  const _EarthPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shift = t * w;
    canvas.drawRect(Offset.zero & size,
        Paint()..color = const Color(0xFF1A3A6B).withOpacity(.5));
    final land = Paint()..color = const Color(0xFF2D8A2D);
    for (final r in [
      Rect.fromLTWH(-shift % w + w * .2, h * .3, w * .25, h * .2),
      Rect.fromLTWH(-shift % w + w * .5, h * .4, w * .18, h * .18),
      Rect.fromLTWH(-shift % w + w * .75, h * .25, w * .2, h * .25),
      Rect.fromLTWH(-shift % w + w * 1.1, h * .35, w * .22, h * .2),
    ]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(5)), land);
    }
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * .3, h * .3), width: w * .3, height: h * .2),
      Paint()..color = Colors.white.withOpacity(.12),
    );
  }

  @override
  bool shouldRepaint(_EarthPainter o) => o.t != t;
}

// ─────────────────────────────────────────────
//  GLOBE ICON PAINTER
// ─────────────────────────────────────────────
class _GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * .38;
    Paint p(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), r, p(_C.green, 1.8));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: r, height: r * 2),
        p(_C.green.withOpacity(.5), 1.2));

    canvas.drawPath(
      Path()
        ..moveTo(cx - r, cy)
        ..cubicTo(
            cx - r * .5, cy - r * .3, cx + r * .5, cy + r * .3, cx + r, cy),
      p(const Color(0xFFA0E060), 1.5),
    );

    final arrow = p(Colors.white, 1.8)..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(cx - r * .3, cy + r * .2)
        ..lineTo(cx, cy - r * .2)
        ..lineTo(cx + r * .3, cy + r * .2),
      arrow,
    );
    canvas.drawLine(Offset(cx, cy - r * .2), Offset(cx, cy + r * .5), arrow);
  }

  @override
  bool shouldRepaint(_GlobePainter _) => false;
}

// ─────────────────────────────────────────────
//  STAR FIELD
// ─────────────────────────────────────────────
class _Star {
  final double x, y, size;
  _Star(math.Random r)
      : x = r.nextDouble(),
        y = r.nextDouble(),
        size = r.nextDouble() * 2.2 + .5;
}

class _StarField extends StatefulWidget {
  const _StarField();
  @override
  State<_StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<_StarField> with TickerProviderStateMixin {
  late final List<_Star> stars;
  late final List<AnimationController> ctrls;
  final r = math.Random(7);

  @override
  void initState() {
    super.initState();
    stars = List.generate(80, (_) => _Star(r));
    ctrls = stars
        .map((s) => AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 1500 + r.nextInt(2000)))
          ..repeat(reverse: true))
        .toList();
  }

  @override
  void dispose() {
    for (final c in ctrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) => Stack(
          children: List.generate(stars.length, (i) {
            final s = stars[i];
            return Positioned(
              left: s.x * constraints.maxWidth,
              top: s.y * constraints.maxHeight,
              child: AnimatedBuilder(
                animation: ctrls[i],
                builder: (_, __) => Opacity(
                  opacity: .15 + ctrls[i].value * .75,
                  child: Transform.scale(
                    scale: 1.0 + ctrls[i].value * .4,
                    child: Container(
                      width: s.size,
                      height: s.size,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
}

// ─────────────────────────────────────────────
//  FALLBACK GRADIENT
// ─────────────────────────────────────────────
class _CosmicGradient extends StatelessWidget {
  const _CosmicGradient();
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.3),
            radius: 1.5,
            colors: [
              Color(0xFF1A3A1A),
              Color(0xFF0D2B0D),
              Color(0xFF0A1A0A),
              Color(0xFF060E06)
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      );
}
