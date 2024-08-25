import 'package:fluent_ui/fluent_ui.dart';

import '../utils/colors.dart';

class CustomDialog {
  /// [Dialog] para indicar que un proceso esta cargando.
  static Future<void> loadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (c) => const ContentDialog(
        title: Center(
          child: Text('Cargando...', style: TextStyle(fontSize: 16)),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 250, child: ProgressBar()),
          ],
        ),
      ),
    );
  }

  /// [Dialog] para mostrar un mensaje personalizado
  static Future<void> messageDialog(
      BuildContext context, String title, Widget content) async {
    await showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: Center(
          child: Text(title, style: const TextStyle(fontSize: 16)),
        ),
        content: SizedBox(width: 300, child: content),
        actions: [
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// [Dialog] para mostrar una alerta sobre el proceso que se necesita ejecutar.
  static Future<void> alertMessageDialog(
      BuildContext context, String content, void Function() onAcepted) async {
    await showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Center(
          child: Icon(FluentIcons.error, color: redColor, size: 40),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              const SizedBox(height: 10),
              const Text('Presione Aceptar para continuar.'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: onAcepted,
            child: const Text('Aceptar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Future<void> autogenerarDialog(BuildContext context,
      Map<String, double> map, void Function() onAcepted) async {
    await showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Center(
          child: Icon(FluentIcons.error, color: redColor, size: 40),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'No se crearán algunas ordenes debido a que existen algunos clientes con deuda o no tiene suficiente saldo a favor'),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                width: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: map.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      title: Text(map.keys.elementAt(i)),
                      trailing: Text('S/ ${map.values.elementAt(i).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text('Presione Aceptar para generar el resto de ordenes.'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: onAcepted,
            child: const Text('Aceptar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// [Dialog] para mostrar el error que ocurrió en el proceso.
  static Future<void> errorDialog(BuildContext context, String error) async {
    await showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.error, color: redColor, size: 40),
            SizedBox(width: 15),
            Text(
              'Ocurrio un error inesperado',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Descripción del error:'),
            const SizedBox(height: 10),
            Text(
              error,
              overflow: TextOverflow.ellipsis,
              maxLines: 20,
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
