import 'package:flutter/material.dart';

/// Loading Widget với style thống nhất
class AppLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoading({
    Key? key,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? Colors.white,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

/// Empty State Widget
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const AppEmptyState({
    Key? key,
    required this.icon,
    required this.message,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.3),
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error State Widget
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade300,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'Xem tất cả',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}

/// Glass Container Widget (Glassmorphism effect)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors!,
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade900,
                  Colors.black,
                ],
              ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Badge Widget
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Stat Item Widget
class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const StatItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

/// Icon Badge (số notification trên icon)
class IconBadge extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;
  final Color iconColor;
  final Color badgeColor;
  final double iconSize;

  const IconBadge({
    Key? key,
    required this.icon,
    this.badgeCount,
    this.iconColor = Colors.white,
    this.badgeColor = Colors.red,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount! > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer Loading Effect (skeleton loader)
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.shade800,
                Colors.grey.shade700,
                Colors.grey.shade800,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
