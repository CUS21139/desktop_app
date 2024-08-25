import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/utils/colors.dart';
import '/src/services/saldo_service.dart';
import '/src/utils/date_formats.dart';

class TotalDiarioWidget extends StatefulWidget {
  const TotalDiarioWidget({super.key});

  @override
  State<TotalDiarioWidget> createState() => _TotalDiarioWidgetState();
}

class _TotalDiarioWidgetState extends State<TotalDiarioWidget> {
  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  double clientes = 0;
  double bancos = 0;
  double proveedores = 0;
  double saldo = 0;

  @override
  void initState() {
    fecha = DateTime.now();
    fechaCtrl.text = date.format(fecha!);
    clientes =
        Provider.of<ClientesProv>(context, listen: false).totalSaldoDeudores;
    bancos = Provider.of<BancosProv>(context, listen: false).totalSaldo;
    proveedores =
        Provider.of<ProveedoresProv>(context, listen: false).totalSaldo;
    saldo = clientes + bancos - proveedores;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fecha',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextBox(
                  placeholder: 'Fecha',
                  controller: fechaCtrl,
                  readOnly: true,
                  onTap: () async {
                    fecha = await CustomDatePicker.showPicker(context);
                    if (fecha != null) fechaCtrl.text = date.format(fecha!);
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: FilledButton(
                    child: const Text('Buscar'),
                    onPressed: () => getSaldoByDate(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 50),
          TotalWidget(
            title: 'Clientes',
            monto: clientes,
            color: redColor,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(FluentIcons.add, size: 10),
          ),
          TotalWidget(
            title: 'Bancos',
            monto: bancos,
            color: greenColor,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(FluentIcons.remove, size: 10),
          ),
          TotalWidget(
            title: 'Proveedores',
            monto: proveedores,
            color: blueColor,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(FluentIcons.calculator_equal_to, size: 10),
          ),
          TotalWidget(
            title: 'Saldo Total',
            monto: saldo,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  void getSaldoByDate() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    if (date.format(fecha!) == date.format(DateTime.now())) {
      setState(() {
        clientes = Provider.of<ClientesProv>(context, listen: false)
            .totalSaldoDeudores;
        bancos = Provider.of<BancosProv>(context, listen: false).totalSaldo;
        proveedores =
            Provider.of<ProveedoresProv>(context, listen: false).totalSaldo;
        saldo = clientes + bancos - proveedores;
      });
    } else {
      CustomDialog.loadingDialog(context);
      await SaldosService().getSaldo(token, fecha!).then((value) {
        Navigator.pop(context);
        setState(() {
          clientes = value.clientes;
          bancos = value.bancos;
          proveedores = value.proveedores;
          saldo = clientes + bancos - proveedores;
        });
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }
}

class TotalWidget extends StatelessWidget {
  const TotalWidget({
    super.key,
    required this.title,
    required this.monto,
    required this.color,
  });
  final String title;
  final double monto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30,
            alignment: Alignment.center,
            color: color.withOpacity(0.1),
            child: Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text('S/ ${monto.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
