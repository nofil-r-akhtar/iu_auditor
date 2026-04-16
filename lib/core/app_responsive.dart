/// ─────────────────────────────────────────────────────────────
/// APP RESPONSIVE UTILITY
/// ─────────────────────────────────────────────────────────────
/// Single source of truth for breakpoints across the whole app.
///
/// Usage inside a widget:
///   LayoutBuilder(builder: (context, constraints) {
///     final r = AppResponsive(constraints.maxWidth);
///     if (r.isMobile) ...
///   })
///
/// Or use the static helpers with MediaQuery if you're inside
/// a build that already has context:
///   AppResponsive.of(context).isTablet
/// ─────────────────────────────────────────────────────────────
class AppResponsive {
  final double width;

  const AppResponsive(this.width);

  factory AppResponsive.of(dynamic context) {
    // works with both BuildContext (via MediaQuery) and raw double
    throw UnimplementedError(
      'Use AppResponsive(constraints.maxWidth) inside LayoutBuilder',
    );
  }

  // ── Breakpoints ──────────────────────────────────────────────
  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  bool get isMobile => width < mobileMax;
  bool get isTablet => width >= mobileMax && width < tabletMax;
  bool get isDesktop => width >= tabletMax;

  // ── Layout helpers ───────────────────────────────────────────

  /// Sidebar: hidden on mobile (use drawer), icon-only on tablet, full on desktop
  bool get showFullSidebar => isDesktop;
  bool get showIconSidebar => isTablet;
  bool get hideSidebar => isMobile;

  /// Dashboard: stack vertically on mobile/tablet, side-by-side on desktop
  bool get stackDashboard => !isDesktop;

  /// Audits table: card view on mobile, full table on tablet+
  bool get useTableView => !isMobile;

  /// Audit form: hide left panel on mobile
  bool get showAuditLeftPanel => !isMobile;

  // ── Value selectors ──────────────────────────────────────────
  /// Returns one of three values based on current breakpoint
  T when<T>({required T mobile, required T tablet, required T desktop}) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }

  /// Returns a value for mobile, or a fallback for tablet/desktop
  T mobileOr<T>({required T mobile, required T other}) {
    return isMobile ? mobile : other;
  }
}
