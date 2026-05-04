import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbController1;
  late final AnimationController _orbController2;
  late final AnimationController _pulseController;
  late final AnimationController _ringController;
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _orbController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
    _orbController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _orbController1.dispose();
    _orbController2.dispose();
    _pulseController.dispose();
    _ringController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14142A),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _orbController1,
          _orbController2,
          _pulseController,
          _ringController,
          _dotsController,
        ]),
        builder: (context, _) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;

    // Icon anchored at 42% screen height
    final iconSize = (size.width * 0.36).clamp(120.0, 180.0);
    final logoCenterY = size.height * 0.42;
    final logoCenterX = size.width / 2;

    // Ring
    final ringRadius = iconSize * 0.74;

    // Orb drift (ease-in-out applied manually)
    final t1 = _easeInOut(_orbController1.value);
    final t2 = _easeInOut(_orbController2.value);
    final orb1Dx = 80.0 * t1 / 1080 * size.width;
    final orb1Dy = -40.0 * t1 / 1920 * size.height;
    final orb2Dx = 60.0 * t2 / 1080 * size.width;
    final orb2Dy = 50.0 * t2 / 1920 * size.height;

    // Pulse
    final tp = _easeInOut(_pulseController.value);
    final pulseScale = 1.0 + 0.08 * tp;
    final pulseOpacity = (0.55 + 0.40 * tp).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.38, 0.76, 1.0],
              colors: [
                Color(0xFF14142A),
                Color(0xFF1A1A2E),
                Color(0xFF2A2752),
                Color(0xFF3B3B98),
              ],
            ),
          ),
        ),

        // Orb 1 — purple, drifts from upper-left
        Positioned(
          left: -size.width * 0.185 + orb1Dx,
          top: size.height * 0.10 + orb1Dy,
          child: _Orb(
            diameter: size.width * 0.65,
            color: const Color(0xFF8E44AD),
            opacity: 0.55,
          ),
        ),

        // Orb 2 — blue, bottom-right
        Positioned(
          right: -size.width * 0.24 - orb2Dx,
          bottom: size.height * 0.05 + orb2Dy,
          child: _Orb(
            diameter: size.width * 0.74,
            color: const Color(0xFF3B3B98),
            opacity: 0.55,
          ),
        ),

        // Pulsing radial glow behind logo
        Positioned(
          left: logoCenterX - size.width * 0.51 * pulseScale,
          top: logoCenterY - size.width * 0.51 * pulseScale,
          child: Opacity(
            opacity: pulseOpacity,
            child: Transform.scale(
              scale: pulseScale,
              child: _Glow(diameter: size.width * 1.02),
            ),
          ),
        ),

        // Three expanding concentric rings
        ..._buildRings(logoCenterX, logoCenterY, ringRadius),

        // Logo + brand text
        Positioned(
          top: logoCenterY - iconSize / 2,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Center(child: _SpeakingClubIcon(size: iconSize)),
              SizedBox(height: iconSize * 0.25),
              const Text(
                'Speaking Club',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      color: Color(0x59000000),
                      offset: Offset(0, 4),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _subtitleWord('Practice'),
                  _subtitleDot(),
                  _subtitleWord('Connect'),
                  _subtitleDot(),
                  _subtitleWord('Improve'),
                ],
              ),
            ],
          ),
        ),

        // Bouncing loading dots
        Positioned(
          left: 0,
          right: 0,
          bottom: size.height * 0.083,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final delay = i * 0.125; // 0.2s / 1.6s
              final progress = (_dotsController.value + delay) % 1.0;
              final sine = math.sin(progress * math.pi);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Transform.translate(
                  offset: Offset(0, -6 * sine),
                  child: Opacity(
                    opacity: (0.25 + 0.75 * sine).clamp(0.0, 1.0),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Footer wordmark
        Positioned(
          left: 0,
          right: 0,
          bottom: size.height * 0.036,
          child: const Text(
            'SPEAKING CLUB · v1.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0x73FFFFFF),
              fontSize: 11,
              letterSpacing: 4,
              fontFamily: 'monospace',
            ),
          ),
        ),

        // Safe-area top guard (keeps status bar readable)
        Positioned(
          top: 0, left: 0, right: 0,
          height: topPad,
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }

  List<Widget> _buildRings(double cx, double cy, double radius) {
    return List.generate(3, (i) {
      final delay = i * (1.3 / 4.0);
      final progress = (_ringController.value + delay) % 1.0;
      final scale = 1.0 + 1.4 * progress; // 1.0 → 2.4
      final opacity = (0.7 * (1.0 - progress)).clamp(0.0, 1.0);
      return Positioned(
        left: cx - radius,
        top: cy - radius,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  static double _easeInOut(double t) =>
      t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;

  static Widget _subtitleWord(String text) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFFCDB8FF),
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
        ),
      );

  static Widget _subtitleDot() => Container(
        width: 4,
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFCDB8FF).withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
      );
}

// ── Orb (drifting blurred glow) ──────────────────────────────────────────────

class _Orb extends StatelessWidget {
  final double diameter;
  final Color color;
  final double opacity;

  const _Orb({
    required this.diameter,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
          stops: const [0.0, 0.65],
        ),
      ),
    );
  }
}

// ── Radial glow behind logo ───────────────────────────────────────────────────

class _Glow extends StatelessWidget {
  final double diameter;
  const _Glow({required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0x59BA87FF), // 35% white-purple
            Color(0x2E8E44AD), // 18%
            Color(0x003B3B98), // transparent
          ],
          stops: [0.0, 0.35, 0.65],
        ),
      ),
    );
  }
}

// ── Speaking Club Icon (CustomPainter) ────────────────────────────────────────

class _SpeakingClubIcon extends StatelessWidget {
  final double size;
  const _SpeakingClubIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    final radius = size * 112 / 512;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E44AD).withValues(alpha: 0.45),
            offset: Offset(0, size * 40 / 360),
            blurRadius: size * 80 / 360,
            spreadRadius: -size * 24 / 360,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            offset: Offset(0, size * 16 / 360),
            blurRadius: size * 32 / 360,
            spreadRadius: -size * 16 / 360,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CustomPaint(
          size: Size(size, size),
          painter: const _IconPainter(),
        ),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  const _IconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 512;
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgRRect = RRect.fromRectAndRadius(bounds, Radius.circular(112 * s));

    // Background gradient
    canvas.drawRRect(
      bgRRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B3B98), Color(0xFF8E44AD)],
        ).createShader(bounds),
    );

    // Radial glow overlay
    canvas.drawRRect(
      bgRRect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.4, -0.5), // cx=0.3, cy=0.25 in SVG space
          radius: 0.7,
          colors: [Color(0x38FFFFFF), Color(0x00FFFFFF)],
        ).createShader(bounds),
    );

    // Sheen overlay (top-down highlight)
    canvas.drawRRect(
      bgRRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.55],
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(bounds),
    );

    // Back bubble shadow
    final backPath = _backBubble(s);
    canvas.save();
    canvas.translate(0, 3 * s);
    canvas.drawPath(
      backPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * s),
    );
    canvas.restore();

    // Back bubble fill
    canvas.drawPath(
      backPath,
      Paint()..color = Colors.white.withValues(alpha: 0.38),
    );

    // Front bubble shadow
    final frontPath = _frontBubble(s);
    canvas.save();
    canvas.translate(0, 6 * s);
    canvas.drawPath(
      frontPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 * s),
    );
    canvas.restore();

    // Front bubble fill
    canvas.drawPath(frontPath, Paint()..color = Colors.white);

    // Sound bars — gradient matching background
    final barShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3B3B98), Color(0xFF8E44AD)],
    ).createShader(bounds);

    const bars = [
      (219.0, 294.0, 14.0, 28.0),
      (251.0, 278.0, 14.0, 60.0),
      (283.0, 260.0, 14.0, 96.0),
      (315.0, 278.0, 14.0, 60.0),
      (347.0, 294.0, 14.0, 28.0),
      (379.0, 278.0, 14.0, 60.0),
    ];

    final barPaint = Paint()..shader = barShader;
    for (final (x, y, w, h) in bars) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x * s, y * s, w * s, h * s),
          Radius.circular(7 * s),
        ),
        barPaint,
      );
    }
  }

  // M 120 109 H 272 Q 316 109 316 153 V 243 Q 316 287 272 287
  // H 232 L 212 325 L 192 287 H 120 Q 76 287 76 243 V 153 Q 76 109 120 109 Z
  Path _backBubble(double s) => Path()
    ..moveTo(120 * s, 109 * s)
    ..lineTo(272 * s, 109 * s)
    ..quadraticBezierTo(316 * s, 109 * s, 316 * s, 153 * s)
    ..lineTo(316 * s, 243 * s)
    ..quadraticBezierTo(316 * s, 287 * s, 272 * s, 287 * s)
    ..lineTo(232 * s, 287 * s)
    ..lineTo(212 * s, 325 * s)
    ..lineTo(192 * s, 287 * s)
    ..lineTo(120 * s, 287 * s)
    ..quadraticBezierTo(76 * s, 287 * s, 76 * s, 243 * s)
    ..lineTo(76 * s, 153 * s)
    ..quadraticBezierTo(76 * s, 109 * s, 120 * s, 109 * s)
    ..close();

  // M 222 216 H 402 Q 446 216 446 260 V 356 Q 446 400 402 400
  // H 332 L 312 438 L 292 400 H 222 Q 178 400 178 356 V 260 Q 178 216 222 216 Z
  Path _frontBubble(double s) => Path()
    ..moveTo(222 * s, 216 * s)
    ..lineTo(402 * s, 216 * s)
    ..quadraticBezierTo(446 * s, 216 * s, 446 * s, 260 * s)
    ..lineTo(446 * s, 356 * s)
    ..quadraticBezierTo(446 * s, 400 * s, 402 * s, 400 * s)
    ..lineTo(332 * s, 400 * s)
    ..lineTo(312 * s, 438 * s)
    ..lineTo(292 * s, 400 * s)
    ..lineTo(222 * s, 400 * s)
    ..quadraticBezierTo(178 * s, 400 * s, 178 * s, 356 * s)
    ..lineTo(178 * s, 260 * s)
    ..quadraticBezierTo(178 * s, 216 * s, 222 * s, 216 * s)
    ..close();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
