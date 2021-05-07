import 'dart:math';

import 'package:flutter/material.dart';

class ColumnItem extends StatefulWidget {
  final int count;
  final int current;

  ColumnItem({
    required this.count,
    required this.current,
    Key? key,
  }) : super(key: key);

  @override
  _ColumnItemState createState() => _ColumnItemState();
}

class _ColumnItemState extends State<ColumnItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _offsetY;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ColumnItem oldWidget) {
    if (oldWidget.current != widget.current) {
      _offsetY = Tween<double>(
        begin: -oldWidget.current * 50,
        end: -widget.current * 50,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.250,
            0.750,
            curve: Curves.ease,
          ),
        ),
      );
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bg = Container(
      height: widget.count * 50,
      width: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Color(0xFF9D9D9D),
            Color(0xFF5E5E5E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(-4, -4),
          ),
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(4, 4),
          ),
        ],
      ),
    );

    final numbers = Container(
      height: widget.count * 50,
      width: 50,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: Iterable<int>.generate(widget.count)
            .map((e) => _num(e, e == widget.current))
            .toList(),
      ),
    );

    final selected = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final sinValue = sin(pi * _controller.value);
            final scale = 1 + -.25 * sinValue;
            final opacity = 1 + -1 * sinValue;
            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(
                    0,
                    _offsetY?.value ?? -widget.current * 50,
                  ),
                  child: bg,
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: selected,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    0,
                    _offsetY?.value ?? -widget.current * 50,
                  ),
                  child: numbers,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _num(int number, bool selected) {
    return Container(
      height: 50,
      width: 50,
      child: Center(
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            color: selected ? Colors.white : Color(0xFFe1e1e1),
            fontSize: selected ? 26 : 16,
            fontFamily: 'Carre',
          ),
          duration: const Duration(milliseconds: 250),
          child: Text(
            '$number',
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  SineCurve();

  @override
  double transformInternal(double t) {
    var val = sin(pi * t);
    return val;
  }
}
