import 'package:flutter/material.dart';

class SlideAction<T> {
  final IconData icon;
  final Color color;
  final void Function(T item) onPressed;

  SlideAction({
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}

class SlideCard<T> extends StatefulWidget {
  final T item;
  final Widget child;
  final List<SlideAction<T>>? leftOptions;
  final List<SlideAction<T>>? rightOptions;
  final BorderRadius? borderRadius;

  const SlideCard({
    super.key,
    required this.item,
    required this.child,
    this.leftOptions,
    this.rightOptions,
    this.borderRadius,
  });

  @override
  State<SlideCard<T>> createState() => _SlideCardState<T>();
}

class _SlideCardState<T> extends State<SlideCard<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  static const double _actionWidth = 70.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final double maxLeft = (widget.leftOptions?.length ?? 0) * _actionWidth;
    final double maxRight = -(widget.rightOptions?.length ?? 0) * _actionWidth;

    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(maxRight, maxLeft);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final double maxLeft = (widget.leftOptions?.length ?? 0) * _actionWidth;
    final double maxRight = -(widget.rightOptions?.length ?? 0) * _actionWidth;
    final double threshold = _actionWidth * 0.5;

    if (_dragExtent > threshold && widget.leftOptions != null) {
      _snapTo(maxLeft);
    } else if (_dragExtent < -threshold && widget.rightOptions != null) {
      _snapTo(maxRight);
    } else {
      _snapTo(0);
    }
  }

  void _snapTo(double target) {
    final Animation<double> localAnimation = Tween<double>(
      begin: _dragExtent,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    localAnimation.addListener(() {
      setState(() {
        _dragExtent = localAnimation.value;
      });
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          // Actions
          Positioned.fill(
            child: Row(
              children: [
                if (widget.leftOptions != null)
                  ...widget.leftOptions!.map((action) => _buildAction(action)),
                const Spacer(),
                if (widget.rightOptions != null)
                  ...widget.rightOptions!.map((action) => _buildAction(action)),
              ],
            ),
          ),
          // Content
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Transform.translate(
              offset: Offset(_dragExtent, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(SlideAction<T> action) {
    return GestureDetector(
      onTap: () {
        _snapTo(0);
        action.onPressed(widget.item);
      },
      child: Container(
        width: _actionWidth,
        color: action.color,
        child: Center(child: Icon(action.icon, color: Colors.white)),
      ),
    );
  }
}
