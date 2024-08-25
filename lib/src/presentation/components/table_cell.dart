import 'package:fluent_ui/fluent_ui.dart';

import '../utils/colors.dart';
import '../utils/text_style.dart';

class CellItem extends StatelessWidget {
  const CellItem({
    super.key,
    required this.text,
    this.heigth = 35,
    this.width = 100,
    this.backgroundColor,
    this.textColor,
  });
  final String text;
  final double heigth;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heigth,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          right: BorderSide(color: Colors.black, width: 0.5),
          left: BorderSide(color: Colors.black, width: 0.5),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: cellDataDBStyle.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CellDeleteButton extends StatelessWidget {
  const CellDeleteButton({
    super.key,
    required this.colorIcon,
    this.height = 35,
    this.width = 60,
    required this.onPressed,
  });
  final Color colorIcon;
  final double height;
  final double width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: IconButton(
        icon: Icon(FluentIcons.delete, color: colorIcon),
        onPressed: onPressed,
      ),
    );
  }
}

class CellTitle extends StatelessWidget {
  const CellTitle({
    super.key,
    required this.text,
    this.heigth = 35,
    this.width = 100,
  });
  final String text;
  final double heigth;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heigth,
      width: width,
      decoration: const BoxDecoration(
        color: darkBlueColor,
        border: Border(
          right: BorderSide(color: Colors.black),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: titleTableStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
