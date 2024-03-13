abstract class ThemeChange {}

class ThemeEvent extends ThemeChange {
  final bool isDark;
  ThemeEvent({required this.isDark});
}