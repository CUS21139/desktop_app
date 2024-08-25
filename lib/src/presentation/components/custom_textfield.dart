import 'package:fluent_ui/fluent_ui.dart';
import '../utils/colors.dart';

/// [TextField] personalizado con un ancho por defecto de 200.
class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    Key? key,
    required this.controller,
    required this.title,
    this.width = 200,
    this.focusNode,
    this.onTap,
    this.maxLength,
    this.readOnly = false,
    this.obscure = false
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final double width;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final int? maxLength;
  final bool readOnly;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 30,
          width: width,
          child: TextBox(
            focusNode: focusNode,
            controller: controller,
            cursorColor: darkBlueColor,
            obscureText: obscure,
            style: const TextStyle(fontSize: 14),
            maxLength: maxLength,
            readOnly: readOnly,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
