import 'package:flutter/material.dart';

void montrerDialogChargement(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Empêche la fermeture de la boîte de dialogue en appuyant à l'extérieur
    builder: (context) {
      return const Center(
        child: AnimatedGraduationHat(),
      );
    },
  );
}

void cacherDialogChargement(BuildContext context) {
  Navigator.of(context).pop();
}

class AnimatedGraduationHat extends StatefulWidget {
  const AnimatedGraduationHat({Key? key}) : super(key: key);

  @override
  _AnimatedGraduationHatState createState() => _AnimatedGraduationHatState();
}

class _AnimatedGraduationHatState extends State<AnimatedGraduationHat> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _tasselAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _tasselAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: const Size(150, 150),
            painter: GraduationHatPainter(_tasselAnimation.value),
          ),
        );
      },
    );
  }
}

class GraduationHatPainter extends CustomPainter {
  final double tasselProgress;

  GraduationHatPainter(this.tasselProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final hatPaint = Paint()
      ..color = Color(0xFFFF7643)
      ..style = PaintingStyle.fill;

    final tasselPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw the hat
    final hatPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(0, size.height * 0.3)
      ..close();
    canvas.drawPath(hatPath, hatPaint);

    // Draw the base of the hat
    final basePath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.4)
      ..lineTo(size.width * 0.3, size.height * 0.4)
      ..close();
    canvas.drawPath(basePath, hatPaint);

    // Draw the tassel
    final tasselStartX = size.width * 0.5;
    final tasselStartY = size.height * 0.4;
    final tasselEndX = tasselStartX + 30 * tasselProgress;
    final tasselEndY = tasselStartY + 60 * tasselProgress;
    
    canvas.drawLine(
      Offset(tasselStartX, tasselStartY),
      Offset(tasselEndX, tasselEndY),
      tasselPaint,
    );
    canvas.drawCircle(
      Offset(tasselEndX, tasselEndY),
      5,
      tasselPaint..style = PaintingStyle.fill,
    );

    // Draw the top button of the hat
    final buttonRadius = size.width * 0.05;
    final buttonCenter = Offset(size.width * 0.5, size.height * 0.3);
    canvas.drawCircle(buttonCenter, buttonRadius, hatPaint);
  }

  @override
  bool shouldRepaint(covariant GraduationHatPainter oldDelegate) {
    return oldDelegate.tasselProgress != tasselProgress;
  }
}
