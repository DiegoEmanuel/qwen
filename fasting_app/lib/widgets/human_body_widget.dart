import 'package:flutter/material.dart';

class HumanBodyWidget extends StatefulWidget {
  final List<BodySystem> activeSystems;
  final VoidCallback? onSystemTap;
  final BodySystem? selectedSystem;

  const HumanBodyWidget({
    super.key,
    required this.activeSystems,
    this.onSystemTap,
    this.selectedSystem,
  });

  @override
  State<HumanBodyWidget> createState() => _HumanBodyWidgetState();
}

class _HumanBodyWidgetState extends State<HumanBodyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  BodySystem? _hoveredSystem;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getSystemColor(BodySystem system) {
    if (!widget.activeSystems.contains(system)) {
      return Colors.grey.shade700;
    }
    
    if (widget.selectedSystem == system) {
      return Colors.amber.shade400;
    }
    
    if (_hoveredSystem == system) {
      return Colors.lightBlue.shade400;
    }
    
    return Colors.lightBlue.shade700;
  }

  Widget _buildSystemIndicator(
    BodySystem system,
    double left,
    double top,
    double size,
  ) {
    final isActive = widget.activeSystems.contains(system);
    final isSelected = widget.selectedSystem == system;
    final isHovered = _hoveredSystem == system;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          if (widget.onSystemTap != null && isActive) {
            widget.onSystemTap!();
          }
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredSystem = system),
          onExit: (_) => setState(() => _hoveredSystem = null),
          cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getSystemColor(system).withOpacity(isActive ? 0.9 : 0.4),
              border: Border.all(
                color: isActive 
                    ? (isSelected ? Colors.amber : Colors.white) 
                    : Colors.grey,
                width: isSelected ? 3 : (isActive ? 2 : 1),
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _getSystemColor(system).withOpacity(0.6),
                        blurRadius: isSelected ? 20 : 10,
                        spreadRadius: isSelected ? 5 : 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Icon(
                _getSystemIcon(system),
                color: Colors.white,
                size: size * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSystemIcon(BodySystem system) {
    switch (system) {
      case BodySystem.brain:
        return Icons.psychology;
      case BodySystem.liver:
        return Icons.water_drop;
      case BodySystem.muscles:
        return Icons.fitness_center;
      case BodySystem.fat:
        return Icons.local_fire_department;
      case BodySystem.heart:
        return Icons.favorite;
      case BodySystem.cells:
        return Icons.blur_circle;
      case BodySystem.immune:
        return Icons.shield;
      case BodySystem.gut:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        
        return SizedBox(
          width: size,
          height: size * 1.8,
          child: Stack(
            children: [
              // Silhueta do corpo humano
              Center(
                child: CustomPaint(
                  size: Size(size * 0.6, size * 1.6),
                  painter: HumanBodyPainter(
                    activeSystems: widget.activeSystems,
                    selectedSystem: widget.selectedSystem,
                  ),
                ),
              ),
              
              // Indicadores interativos dos sistemas
              ..._buildSystemIndicators(size),
              
              // Animação de pulso para sistemas ativos
              if (widget.activeSystems.isNotEmpty)
                ..._buildPulseAnimations(size),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSystemIndicators(double baseSize) {
    final indicators = <Widget>[];
    final positions = _getSystemPositions(baseSize);
    
    for (var entry in positions.entries) {
      indicators.add(_buildSystemIndicator(
        entry.key,
        entry.value['left']!,
        entry.value['top']!,
        entry.value['size']!,
      ));
    }
    
    return indicators;
  }

  Map<BodySystem, Map<String, double>> _getSystemPositions(double baseSize) {
    final centerX = baseSize * 0.5;
    final centerY = baseSize * 0.9;
    final scale = baseSize / 400;
    
    return {
      BodySystem.brain: {
        'left': centerX - 25 * scale,
        'top': 50 * scale,
        'size': 50 * scale,
      },
      BodySystem.heart: {
        'left': centerX - 45 * scale,
        'top': 280 * scale,
        'size': 45 * scale,
      },
      BodySystem.liver: {
        'left': centerX + 10 * scale,
        'top': 320 * scale,
        'size': 40 * scale,
      },
      BodySystem.gut: {
        'left': centerX - 30 * scale,
        'top': 380 * scale,
        'size': 60 * scale,
      },
      BodySystem.muscles: {
        'left': centerX - 80 * scale,
        'top': 250 * scale,
        'size': 35 * scale,
      },
      BodySystem.fat: {
        'left': centerX + 60 * scale,
        'top': 450 * scale,
        'size': 40 * scale,
      },
      BodySystem.cells: {
        'left': centerX - 20 * scale,
        'top': 500 * scale,
        'size': 35 * scale,
      },
      BodySystem.immune: {
        'left': centerX + 40 * scale,
        'top': 200 * scale,
        'size': 40 * scale,
      },
    };
  }

  List<Widget> _buildPulseAnimations(double baseSize) {
    final pulses = <Widget>[];
    final positions = _getSystemPositions(baseSize);
    
    for (var system in widget.activeSystems) {
      if (positions.containsKey(system)) {
        final pos = positions[system]!;
        pulses.add(
          Positioned(
            left: pos['left']! - 10,
            top: pos['top']! - 10,
            child: FadeTransition(
              opacity: _pulseAnimation,
              child: Container(
                width: pos['size']! + 20,
                height: pos['size']! + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getSystemColor(system).withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    
    return pulses;
  }
}

class HumanBodyPainter extends CustomPainter {
  final List<BodySystem> activeSystems;
  final BodySystem? selectedSystem;

  HumanBodyPainter({
    required this.activeSystems,
    this.selectedSystem,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.shade600;
    
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade800.withOpacity(0.3);

    // Desenhar silhueta do corpo
    _drawBodySilhouette(canvas, size, paint, fillPaint);
    
    // Destacar sistemas ativos
    _highlightActiveSystems(canvas, size);
  }

  void _drawBodySilhouette(Canvas canvas, Size size, Paint paint, Paint fillPaint) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    
    // Cabeça
    path.addOval(Rect.fromCenter(
      center: Offset(w / 2, h * 0.08),
      width: w * 0.25,
      height: h * 0.15,
    ));
    
    // Tronco
    path.moveTo(w * 0.35, h * 0.18);
    path.quadraticBezierTo(
      w * 0.5, h * 0.22,
      w * 0.65, h * 0.18,
    );
    path.lineTo(w * 0.62, h * 0.55);
    path.quadraticBezierTo(
      w * 0.5, h * 0.58,
      w * 0.38, h * 0.55,
    );
    path.close();
    
    // Braços
    path.moveTo(w * 0.35, h * 0.2);
    path.quadraticBezierTo(
      w * 0.15, h * 0.35,
      w * 0.12, h * 0.55,
    );
    path.lineTo(w * 0.18, h * 0.55);
    path.quadraticBezierTo(
      w * 0.22, h * 0.35,
      w * 0.33, h * 0.25,
    );
    
    path.moveTo(w * 0.65, h * 0.2);
    path.quadraticBezierTo(
      w * 0.85, h * 0.35,
      w * 0.88, h * 0.55,
    );
    path.lineTo(w * 0.82, h * 0.55);
    path.quadraticBezierTo(
      w * 0.78, h * 0.35,
      w * 0.67, h * 0.25,
    );
    
    // Pernas
    path.moveTo(w * 0.42, h * 0.55);
    path.lineTo(w * 0.4, h * 0.85);
    path.lineTo(w * 0.45, h * 0.98);
    path.lineTo(w * 0.5, h * 0.98);
    path.lineTo(w * 0.55, h * 0.85);
    path.lineTo(w * 0.58, h * 0.55);
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  void _highlightActiveSystems(Canvas canvas, Size size) {
    // Implementação de destaque visual para sistemas ativos
    for (var system in activeSystems) {
      final highlightPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getSystemColor(system).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      // Desenhar áreas de destaque baseadas no sistema
      final position = _getSystemOffset(system, size);
      if (position != null) {
        canvas.drawCircle(position, 30, highlightPaint);
      }
    }
  }

  Offset? _getSystemOffset(BodySystem system, Size size) {
    final w = size.width;
    final h = size.height;
    
    switch (system) {
      case BodySystem.brain:
        return Offset(w / 2, h * 0.08);
      case BodySystem.heart:
        return Offset(w * 0.45, h * 0.3);
      case BodySystem.liver:
        return Offset(w * 0.55, h * 0.35);
      case BodySystem.gut:
        return Offset(w / 2, h * 0.42);
      case BodySystem.muscles:
        return Offset(w * 0.3, h * 0.4);
      case BodySystem.fat:
        return Offset(w * 0.6, h * 0.6);
      case BodySystem.cells:
        return Offset(w * 0.5, h * 0.7);
      case BodySystem.immune:
        return Offset(w * 0.5, h * 0.25);
    }
  }

  Color _getSystemColor(BodySystem system) {
    switch (system) {
      case BodySystem.brain:
        return Colors.purple;
      case BodySystem.liver:
        return Colors.red;
      case BodySystem.muscles:
        return Colors.orange;
      case BodySystem.fat:
        return Colors.yellow;
      case BodySystem.heart:
        return Colors.redAccent;
      case BodySystem.cells:
        return Colors.blue;
      case BodySystem.immune:
        return Colors.green;
      case BodySystem.gut:
        return Colors.brown;
    }
  }

  @override
  bool shouldRepaint(covariant HumanBodyPainter oldDelegate) {
    return oldDelegate.activeSystems != activeSystems ||
        oldDelegate.selectedSystem != selectedSystem;
  }
}
