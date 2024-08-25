import 'package:fluent_ui/fluent_ui.dart';
import '../utils/colors.dart';

/// Botón personalizado.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.color,
    required this.iconData,
  });
  final void Function()? onPressed;
  final String title;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            iconData,
            color: onPressed != null ? color : ligthGreyColor,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: onPressed != null ? color : ligthGreyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.color,
    required this.iconData,
  });
  final void Function()? onPressed;
  final String title;
  final AccentColor color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        accentColor: color,
      ),
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(iconData),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
