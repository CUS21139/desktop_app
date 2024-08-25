import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/utils/text_style.dart';
import '/src/services/caja_mov_service.dart';
import '/src/utils/date_formats.dart';

class FiltrosCaja extends StatefulWidget {
  const FiltrosCaja({super.key});

  @override
  State<FiltrosCaja> createState() => _FiltrosCajaState();
}

class _FiltrosCajaState extends State<FiltrosCaja> {
  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  bool hoy = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtrar por fecha', style: subtitleDataDBStyle),
          const SizedBox(height: 15),
          TextBox(
            placeholder: 'Fecha',
            controller: fechaCtrl,
            readOnly: true,
            onTap: () async {
              fecha = await CustomDatePicker.showPicker(context);
              if (fecha != null) fechaCtrl.text = date.format(fecha!);
            },
          ),
          const SizedBox(height: 15),
          Center(
            child: FilledButton(
              onPressed: () {
                buscarCaja(fecha);
                if (fecha != null) {
                  setState(() => hoy = false);
                }
              },
              child: const Text('Buscar'),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Checkbox(
              content: const Text('Caja de Hoy'),
              checked: hoy,
              onChanged: (v) {
                if (v!) {
                  setState(() {
                    hoy = v;
                    fecha = null;
                    fechaCtrl.clear();
                  });
                  buscarCaja(DateTime.now());
                }
              },
            ),
          ),
          const SizedBox(height: 40),
          const Text('Saldos Bancos', style: subtitleDataDBStyle),
          const SizedBox(height: 15),
          Expanded(
            child: Consumer<BancosProv>(builder: (_, service, __) {
              final banco = service.bancos;
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (c, i) => ListTile(
                  title: Text(banco[i].nombre),
                  trailing: Text('S/ ${banco[i].saldo!.toStringAsFixed(2)}'),
                ),
                itemCount: banco.length,
              );
            }),
          ),
        ],
      ),
    );
  }

  void buscarCaja(DateTime? date) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final cajaServ = CajaService();

    if (date == null) {
      CustomDialog.errorDialog(context, 'Seleccione una fecha');
    } else {
      CustomDialog.loadingDialog(context);
      await cajaServ.getCaja(token, date).then((value) {
        cajaProv.caja = value['caja'];
        cajaProv.cajaMov = value['movs'];
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }
}
