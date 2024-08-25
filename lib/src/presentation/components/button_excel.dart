import 'package:fluent_ui/fluent_ui.dart';

/// Botón personalizado para la función exportar excel.
class ExcelButton extends StatelessWidget {
  const ExcelButton({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
        accentColor: Colors.green,
      ),
      child: FilledButton(
        onPressed: onPressed,
        child: const Row(
          children: [
            Icon(
              FluentIcons.excel_document,
              color: Colors.white,
            ),
            SizedBox(width: 15),
            Text(
              'Excel',
              style: TextStyle(
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
