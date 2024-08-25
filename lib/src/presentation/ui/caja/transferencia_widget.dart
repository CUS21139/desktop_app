import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/banco.dart';
import '/src/models/caja_mov.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/services/bancos_service.dart';
import '/src/services/caja_mov_service.dart';
import '/src/utils/date_formats.dart';

class TransferenciaWidget extends StatefulWidget {
  const TransferenciaWidget({super.key});

  @override
  State<TransferenciaWidget> createState() => _TransferenciaWidgetState();
}

class _TransferenciaWidgetState extends State<TransferenciaWidget> {
  Banco? bancoDesde;
  final bancoDesdeCtrl = TextEditingController();
  Banco? bancoHacia;
  final bancoHaciaCtrl = TextEditingController();

  final montoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900,
      padding: const EdgeInsets.all(10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Banco Desde',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Consumer<BancosProv>(
                  builder: (_, service, __) {
                    return AutoSuggestBox<Banco>(
                      controller: bancoDesdeCtrl,
                      items: service.bancos
                          .map((e) => AutoSuggestBoxItem<Banco>(
                                value: e,
                                label: e.nombre,
                                child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                              ))
                          .toList(),
                      onSelected: (item) {
                        setState(() => bancoDesde = item.value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Banco Hacia',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Consumer<BancosProv>(
                  builder: (_, service, __) {
                    return AutoSuggestBox<Banco>(
                      controller: bancoHaciaCtrl,
                      items: service.bancos
                          .map((e) => AutoSuggestBoxItem<Banco>(
                                value: e,
                                label: e.nombre,
                                child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                              ))
                          .toList(),
                      onSelected: (item) {
                        setState(() => bancoHacia = item.value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          CustomTextBox(controller: montoCtrl, title: 'Monto S/'),
          const Spacer(),
          FilledButton(
            onPressed: () => transferir(context),
            child: const Text('Transferir'),
          ),
        ],
      ),
    );
  }

  Future<void> transferir(BuildContext context) async {
    final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final cajaServ = CajaService();
    final bancoProv = Provider.of<BancosProv>(context, listen: false);
    final bancoServ = BancosService();
    try {
      if (bancoDesde!.saldo! < double.parse(montoCtrl.text)) {
        CustomDialog.errorDialog(
            context, 'El saldo del banco es menor al monto');
      } else {
        CustomDialog.loadingDialog(context);
        final now = DateTime.now();
        final mov = CajaMov(
          fecha: date.format(now),
          hora: time.format(now),
          createdBy: usuarioProv.usuario.nombre,
          movType: 'TR',
          bancoId: bancoDesde!.id!,
          bancoNombre: bancoDesde!.nombre,
          bancoEstadoCta: bancoDesde!.estadoCta!,
          entityType: 'BN',
          entityId: bancoHacia!.id!,
          entityNombre: bancoHacia!.nombre,
          entityEstadoCta: bancoHacia!.estadoCta!,
          descripcion: 'Transferencia',
          ingreso: 0,
          egreso: double.parse(montoCtrl.text),
        );
        await cajaServ
            .insertTransferencia(usuarioProv.token, mov)
            .then((value) {
          cajaProv.caja = value['caja'];
          cajaProv.cajaMov = value['movs'];
        });
        await bancoServ.getBancos(usuarioProv.token).then((value) {
          bancoProv.bancos = value;
          Navigator.pop(context);
        });
      }
      bancoDesde = null;
      bancoDesdeCtrl.clear();
      bancoHacia = null;
      bancoHaciaCtrl.clear();
      montoCtrl.clear();
    } catch (e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    }
  }
}
