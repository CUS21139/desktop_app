import 'package:fluent_ui/fluent_ui.dart';

/// Botón personalizado para la función crear.
class CreateButton extends StatelessWidget {
  const CreateButton({
    super.key,
    required this.onPressed,
    this.title = 'Crear Nuevo',
  });
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        children: [
          const Icon(FluentIcons.add, color: Colors.white),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
