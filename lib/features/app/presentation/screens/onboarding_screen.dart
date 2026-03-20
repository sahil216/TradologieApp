import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(const _DemoApp());

class _DemoApp extends StatelessWidget {
  const _DemoApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const OnboardingScreen(),
      );
}

// ─────────────────────────────────────────────
//  COLOURS
// ─────────────────────────────────────────────
class _C {
  // Brand orange (Pages-inspired warm amber)
  static const orange = Color(0xFFF5A623);
  static const orangeDark = Color(0xFFE8922A);
  static const orangeDeep = Color(0xFFD4841A);

  // Dark card surface (Pages dark-grey)
  static const cardSurface = Color(0xFF1C1C1E);
  static const cardBorder = Color(0x1AFFFFFF); // 10 % white

  // Sheet
  static const sheetBg = Color(0xEB1C1C1E); // 92 % opaque dark

  // Text on dark
  static const textWhite = Color(0xFFFFFFFF);
  static const textSub = Color(0x73FFFFFF); // 45 % white

  // Tag tints
  static const agroTag = Color(0x2E4ADE80);
  static const agroTagTxt = Color(0xFF4ADE80);
  static const fmcgTag = Color(0x2EF5A623);
  static const fmcgTagTxt = Color(0xFFF5A623);
}

// ─────────────────────────────────────────────
//  OPTION MODEL
// ─────────────────────────────────────────────
class _Option {
  final String id, emoji, title, subtitle, tag;
  final Color tagBg, tagFg;
  final List<Color> iconGradient;
  const _Option({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagBg,
    required this.tagFg,
    required this.iconGradient,
  });
}

const _options = [
  _Option(
    id: 'agro_sell',
    emoji: '📦',
    title: 'Agro Seller',
    subtitle: 'List & sell agricultural commodities to verified buyers',
    tag: 'Agro',
    tagBg: _C.agroTag,
    tagFg: _C.agroTagTxt,
    iconGradient: [Color(0xFF4ADE80), Color(0xFF16A34A)],
  ),
  _Option(
    id: 'agro_buy',
    emoji: '🛍️',
    title: 'Agro Buyer',
    subtitle: 'Source & purchase quality commodities at best prices',
    tag: 'Agro',
    tagBg: _C.agroTag,
    tagFg: _C.agroTagTxt,
    iconGradient: [Color(0xFF60A5FA), Color(0xFF2563EB)],
  ),
  _Option(
    id: 'fmcg_brand',
    emoji: '🏷️',
    title: 'Register Brand',
    subtitle: 'List your FMCG brand & connect with nationwide distributors',
    tag: 'FMCG',
    tagBg: _C.fmcgTag,
    tagFg: _C.fmcgTagTxt,
    iconGradient: [Color(0xFFC084FC), Color(0xFF9333EA)],
  ),
  _Option(
    id: 'fmcg_dist',
    emoji: '🚚',
    title: 'Distributorship',
    subtitle: 'Apply to distribute top FMCG brands in your region',
    tag: 'FMCG',
    tagBg: _C.fmcgTag,
    tagFg: _C.fmcgTagTxt,
    iconGradient: [Color(0xFF34D399), Color(0xFF059669)],
  ),
];

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── dark hero card ───────────────────────────
  late final AnimationController _cardCtrl;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  // ── icon inside card ─────────────────────────
  late final Animation<double> _iconScale;

  // ── hero text / buttons ──────────────────────
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  // ── bottom sheet ─────────────────────────────
  late final AnimationController _sheetCtrl;
  late final Animation<Offset> _sheetSlide;

  // ── staggered cards ──────────────────────────
  late final List<AnimationController> _optCtrls;
  late final List<Animation<Offset>> _optSlides;
  late final List<Animation<double>> _optFades;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // hero card drop
    _cardCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 680))
      ..forward();
    _cardFade = CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut));
    _cardScale = Tween<double>(begin: .88, end: 1.0).animate(CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.0, 0.65, curve: _Springs.gentle)));
    _cardSlide = Tween<Offset>(begin: const Offset(0, -.15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _cardCtrl,
            curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic)));

    // icon pop (delayed slightly inside card)
    _iconScale = Tween<double>(begin: .5, end: 1.0).animate(CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.1, 0.6, curve: _Springs.bouncy)));

    // hero text
    _heroFade = CurvedAnimation(
        parent: _cardCtrl,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut));
    _heroSlide = Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _cardCtrl,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic)));

    // sheet slides up from fully below
    _sheetCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 660))
      ..forward();
    _sheetSlide = Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _sheetCtrl,
            curve: const Interval(0.1, 1.0, curve: Curves.easeOutQuint)));

    // staggered option cards
    _optCtrls = List.generate(
        4,
        (_) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 420)));
    _optSlides = _optCtrls
        .map((c) => Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)))
        .toList();
    _optFades = _optCtrls
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    for (var i = 0; i < 4; i++) {
      Future.delayed(Duration(milliseconds: 380 + i * 70), () {
        if (mounted) _optCtrls[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _sheetCtrl.dispose();
    for (final c in _optCtrls) c.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.orange,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── warm Lottie / gradient background ────
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/background.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
              // Fallback gradient if Lottie file isn't loaded yet
              errorBuilder: (_, __, ___) => const _WarmGradient(),
            ),
          ),
          // tint so dark card pops
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x22000000),
                  ],
                ),
              ),
            ),
          ),

          // ── content ───────────────────────────────
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenH = MediaQuery.of(context).size.height;
                final cardH = screenH * 0.30; // card = 30% (top)
                // sheet gets 70% via Expanded
                return Column(
                  children: [
                    // hero card — fixed at 30% screen height
                    SizedBox(
                      height: cardH,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                        child: FadeTransition(
                          opacity: _cardFade,
                          child: SlideTransition(
                            position: _cardSlide,
                            child: ScaleTransition(
                              scale: _cardScale,
                              child: _buildHeroCard(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // sheet fills 70% of screen
                    Expanded(
                      child: SlideTransition(
                        position: _sheetSlide,
                        child: _buildSheet(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── DARK HERO CARD ────────────────────────────
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: double.infinity, // fills the 70% SizedBox
      decoration: BoxDecoration(
        color: _C.cardSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _C.cardBorder, width: .5),
        boxShadow: const [
          BoxShadow(
              color: Color(0x60000000), blurRadius: 48, offset: Offset(0, 16)),
          BoxShadow(
              color: Color(0x30000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          // subtle inner glow at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    _C.orange.withOpacity(.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // app icon
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_C.orange, _C.orangeDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: _C.orange.withOpacity(.45),
                            blurRadius: 22,
                            offset: const Offset(0, 8)),
                        BoxShadow(
                            color: _C.orange.withOpacity(.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(height: 10),

                // big title
                FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: const Text(
                      'Tradologie',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: _C.textWhite,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // primary CTA
                FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: _HeroCTAButton(
                      label: 'Get Started',
                      icon: Icons.arrow_forward_rounded,
                      onTap: () {
                        // scrolls down to sheet — handled automatically
                        // since sheet is always visible below
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // secondary link
                FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Choose a Role ↓',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: _C.orange,
                          letterSpacing: -.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── DARK BOTTOM SHEET ─────────────────────────
  Widget _buildSheet(BuildContext context) {
    const sheetRadius = BorderRadius.vertical(top: Radius.circular(28));
    return ClipRRect(
      borderRadius: sheetRadius,
      child: Stack(
        children: [
          // dark glass base
          Container(
            decoration: BoxDecoration(
              color: _C.sheetBg,
              borderRadius: sheetRadius,
              border:
                  Border.all(color: Colors.white.withOpacity(.10), width: .5),
            ),
            child: Column(
              children: [
                // pill
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // header row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('CHOOSE YOUR ROLE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: Color(0x66FFFFFF))),
                      Text('Tap to continue →',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _C.orange.withOpacity(.85))),
                    ],
                  ),
                ),

                // scrollable option cards
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                    child: Column(
                      children: List.generate(4, (i) {
                        final opt = _options[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SlideTransition(
                            position: _optSlides[i],
                            child: FadeTransition(
                              opacity: _optFades[i],
                              child: _DarkOptionCard(
                                option: opt,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  // TODO: navigate based on opt.id
                                  // switch (opt.id) {
                                  //   case 'agro_sell':
                                  //   case 'agro_buy':
                                  //     Navigator.pushNamed(context, Routes.sendOtpScreen);
                                  //     break;
                                  //   case 'fmcg_brand':
                                  //   case 'fmcg_dist':
                                  //     Navigator.pushNamed(context, Routes.fmcgSignIn);
                                  //     break;
                                  // }
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // top rim highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                gradient: LinearGradient(colors: [
                  Colors.white.withOpacity(0),
                  Colors.white.withOpacity(.18),
                  Colors.white.withOpacity(0),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WARM GRADIENT FALLBACK  (if Lottie not found)
// ─────────────────────────────────────────────
class _WarmGradient extends StatelessWidget {
  const _WarmGradient();
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.4),
            radius: 1.4,
            colors: [
              Color(0xFFFFD280),
              Color(0xFFF5A623),
              Color(0xFFD4841A),
              Color(0xFFB86B10),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      );
}

// ─────────────────────────────────────────────
//  HERO CTA BUTTON  (orange, inside dark card)
// ─────────────────────────────────────────────
class _HeroCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _HeroCTAButton(
      {required this.label, required this.icon, required this.onTap});
  @override
  State<_HeroCTAButton> createState() => _HeroCTAButtonState();
}

class _HeroCTAButtonState extends State<_HeroCTAButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _p;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _p = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _s = Tween<double>(begin: 1.0, end: .972).animate(_p);
  }

  @override
  void dispose() {
    _p.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _s,
        child: GestureDetector(
          onTapDown: (_) => _p.forward(),
          onTapUp: (_) {
            _p.reverse();
            widget.onTap();
          },
          onTapCancel: () => _p.reverse(),
          child: Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [_C.orange, _C.orangeDark],
              ),
              boxShadow: [
                BoxShadow(
                    color: _C.orange.withOpacity(.45),
                    blurRadius: 16,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -.2)),
                const SizedBox(width: 8),
                Icon(widget.icon, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
//  DARK OPTION CARD  (direct-navigate, no selection state)
// ─────────────────────────────────────────────
class _DarkOptionCard extends StatefulWidget {
  final _Option option;
  final VoidCallback onTap;
  const _DarkOptionCard({required this.option, required this.onTap});
  @override
  State<_DarkOptionCard> createState() => _DarkOptionCardState();
}

class _DarkOptionCardState extends State<_DarkOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _pressScale = Tween<double>(begin: 1.0, end: .964)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opt = widget.option;
    return ScaleTransition(
      scale: _pressScale,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withOpacity(.06),
            border: Border.all(color: Colors.white.withOpacity(.10), width: .5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // icon tile
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: opt.iconGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: opt.iconGradient.last.withOpacity(.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Center(
                      child: Text(opt.emoji,
                          style: const TextStyle(fontSize: 21))),
                ),
                const SizedBox(width: 13),

                // text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(opt.title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: _C.textWhite,
                                  height: 1.2)),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: opt.tagBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(opt.tag,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: opt.tagFg,
                                    letterSpacing: .3)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(opt.subtitle,
                          style: const TextStyle(
                              fontSize: 11.5, color: _C.textSub, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // chevron → replaces check ring
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.white.withOpacity(.35)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  SPRING CURVE
//  Mimics iOS spring physics — overshoots then
//  settles. Equivalent to SwiftUI's .spring()
// ─────────────────────────────────────────────
class _SpringCurve extends Curve {
  const _SpringCurve({
    this.mass = 1.0,
    this.stiffness = 180.0,
    this.damping = 22.0,
  });

  final double mass;
  final double stiffness;
  final double damping;

  @override
  double transformInternal(double t) {
    final w0 = math.sqrt(stiffness / mass); // natural frequency
    final zeta = damping / (2 * math.sqrt(stiffness * mass)); // damping ratio

    if (zeta < 1.0) {
      // ── under-damped (bouncy) ───────────────
      final wd = w0 * math.sqrt(1.0 - zeta * zeta); // damped frequency
      final A = 1.0;
      final phi = math.atan2(zeta * w0, wd); // phase offset
      return 1.0 -
          A *
              math.exp(-zeta * w0 * t) *
              math.cos(wd * t - phi) /
              math.cos(-phi);
    } else if (zeta == 1.0) {
      // ── critically damped ───────────────────
      return 1.0 - math.exp(-w0 * t) * (1.0 + w0 * t);
    } else {
      // ── over-damped ─────────────────────────
      final r1 = -w0 * (zeta - math.sqrt(zeta * zeta - 1.0));
      final r2 = -w0 * (zeta + math.sqrt(zeta * zeta - 1.0));
      final c2 = (1.0 - r1) / (r2 - r1);
      final c1 = 1.0 - c2;
      return 1.0 - (c1 * math.exp(r1 * t) + c2 * math.exp(r2 * t));
    }
  }
}

// Pre-built named spring presets matching common iOS feel
class _Springs {
  _Springs._();

  /// Default iOS spring — gentle overshoot
  static const gentle = _SpringCurve(
    mass: 1.0,
    stiffness: 180.0,
    damping: 22.0,
  );

  /// Snappy spring — faster settle, small overshoot
  static const snappy = _SpringCurve(
    mass: 1.0,
    stiffness: 280.0,
    damping: 28.0,
  );

  /// Bouncy spring — more pronounced overshoot
  static const bouncy = _SpringCurve(
    mass: 1.0,
    stiffness: 160.0,
    damping: 14.0,
  );

  /// Stiff spring — almost no overshoot, quick
  static const stiff = _SpringCurve(
    mass: 1.0,
    stiffness: 400.0,
    damping: 40.0,
  );

  /// Soft spring — slow settle, dreamy feel
  static const soft = _SpringCurve(
    mass: 1.2,
    stiffness: 120.0,
    damping: 18.0,
  );
}
