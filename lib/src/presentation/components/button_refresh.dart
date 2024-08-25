import 'package:fluent_ui/fluent_ui.dart';

/// Botón personalizado para la función refresh.
class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, required this.onPressed, this.text = 'Refresh'});
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        accentColor: Colors.teal,
      ),
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          children: [
            const Icon(
              FluentIcons.refresh,
              color: Colors.white,
            ),
            SizedBox(width: text.isEmpty ? 0 : 15),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
