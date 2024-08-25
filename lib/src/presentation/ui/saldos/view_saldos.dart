import 'package:fluent_ui/fluent_ui.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/services/bancos_service.dart';
import '/src/services/excel_service.dart';
import '/src/services/proveedores_service.dart';
import 'package:provider/provider.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/ui/saldos/saldo_widget.dart';
import '/src/presentation/ui/saldos/total_diario_widget.dart';
import '/src/presentation/utils/colors.dart';

import '/src/services/clientes_service.dart';

class SaldosView extends StatelessWidget {
  const SaldosView({super.key});

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TotalDiarioWidget(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<ClientesProv>(builder: (_, service, __) {
                final deudores =
                    service.clientes.where((e) => e.saldo! > 1).toList();
                return SaldosWidget(
                  title: 'Clientes con Deuda',
                  excelTitle: 'Saldos Clientes',
                  lista: deudores,
                  color: redColor,
                  export: () async => await ExcelService().exportarSaldoClientes(lista: deudores),
                  onRefresh: () async {
                    CustomDialog.loadingDialog(context);
                    await ClientesService()
                        .getClientes(token)
                        .then((value) {
                      service.clientes = value;
                      Navigator.pop(context);
                    }).catchError((e) {
                      Navigator.pop(context);
                      CustomDialog.errorDialog(context, e.toString());
                    });
                  },
                );
              }),
              Consumer<BancosProv>(builder: (_, service, __) {
                return SaldosWidget(
                  title: 'Saldos Bancos',
                  excelTitle: 'Saldos Bancos',
                  lista: service.bancos,
                  color: greenColor,
                  export: () async => await ExcelService().exportarSaldo(lista: service.bancos),
                  onRefresh: () async {
                    CustomDialog.loadingDialog(context);
                    await BancosService().getBancos(token).then((value) {
                      service.bancos = value;
                      Navigator.pop(context);
                    }).catchError((e) {
                      Navigator.pop(context);
                      CustomDialog.errorDialog(context, e.toString());
                    });
                  },
                );
              }),
              Consumer<ProveedoresProv>(builder: (_, service, __) {
                return SaldosWidget(
                  title: 'Saldos Proveedores',
                  excelTitle: 'Saldos Proveedores',
                  lista: service.proveedores,
                  color: blueColor,
                  export: () async => await ExcelService().exportarSaldo(lista: service.proveedores),
                  onRefresh: () async {
                    CustomDialog.loadingDialog(context);
                    await ProveedoresService()
                        .getProveedores(token)
                        .then((value) {
                      service.proveedores = value;
                      Navigator.pop(context);
                    }).catchError((e) {
                      Navigator.pop(context);
                      CustomDialog.errorDialog(context, e.toString());
                    });
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
