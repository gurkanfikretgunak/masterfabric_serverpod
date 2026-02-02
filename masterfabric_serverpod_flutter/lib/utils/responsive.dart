import 'package:flutter/material.dart';

/// Responsive breakpoints for adaptive layouts
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Extension on BuildContext for responsive utilities
extension ResponsiveContext on BuildContext {
  /// Screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is mobile
  bool get isMobile => screenWidth < Breakpoints.mobile;

  /// Check if device is tablet
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;

  /// Check if device is desktop
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Check if device is large desktop
  bool get isLargeDesktop => screenWidth >= Breakpoints.desktop;

  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    if (isMobile) return const EdgeInsets.all(16);
    if (isTablet) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  /// Get responsive horizontal padding
  double get horizontalPadding {
    if (isMobile) return 16;
    if (isTablet) return 24;
    return 32;
  }

  /// Get responsive card width
  double get cardMaxWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 600;
    return 800;
  }

  /// Get responsive grid columns
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }

  /// Get responsive font scale factor
  double get fontScale {
    if (isMobile) return 1.0;
    if (isTablet) return 1.1;
    return 1.15;
  }
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (context.isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

/// Responsive layout widget with centered content
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 800,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? context.responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Responsive grid with adaptive columns
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.isMobile
        ? (mobileColumns ?? 1)
        : context.isTablet
            ? (tabletColumns ?? 2)
            : (desktopColumns ?? 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
