import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/pesaje.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '../../providers/ordenes_vivo_provider.dart';
import '/src/presentation/providers/pesajes_list_provider.dart';
import '/src/presentation/utils/round_number.dart';

class DatosPesajeWidget extends StatefulWidget {
  const DatosPesajeWidget({super.key});

  @override
  State<DatosPesajeWidget> createState() => _DatosPesajeWidgetState();
}

class _DatosPesajeWidgetState extends State<DatosPesajeWidget> {
  final zonaCtrl = TextEditingController();
  final clienteCtrl = TextEditingController();
  final camalCtrl = TextEditingController();
  final productoCtrl = TextEditingController();
  final nroJabasCtrl = TextEditingController();
  final pesoJabaCtrl = TextEditingController();
  final pesoBrutoCtrl = TextEditingController();
  final nroAvesCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  
  @override
  void initState() {
    final orden = Provider.of<OrdenesVivoProv>(context, listen: false).orden;
    zonaCtrl.text = orden.zonaCode;
    clienteCtrl.text = orden.clienteNombre;
    camalCtrl.text = orden.camalNombre;
    productoCtrl.text = orden.productoNombre;
    precioCtrl.text = orden.precio.toStringAsFixed(2);
    super.initState();
  }

  void clearControllers() {
    pesoBrutoCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.2,
      child: Column(
        children: [
          CustomTextBox(
            controller: zonaCtrl,
            title: 'Zona',
            readOnly: true,
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: camalCtrl,
            title: 'Camal',
            readOnly: true,
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: clienteCtrl,
            title: 'Cliente',
            readOnly: true,
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: productoCtrl,
            title: 'Producto',
            readOnly: true,
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: pesoJabaCtrl,
            title: 'Peso por Jaba',
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: nroJabasCtrl,
            title: 'Nro Jabas',
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: nroAvesCtrl,
            title: 'Nro Aves por Jaba',
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: precioCtrl,
            title: 'Precio por kg',
            readOnly: true,
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            controller: pesoBrutoCtrl,
            title: 'Peso Bruto',
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: guradarPeso,
            child: const Text('Pesar'),
          ),
        ],
      ),
    );
  }

  void guradarPeso() {
    final ordenProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final pesajeServ = Provider.of<PesajesProv>(context, listen: false);
    try {
      final precio = double.parse(precioCtrl.text);
      final nroJabas = int.parse(nroJabasCtrl.text);
      final pesoJaba = roundNumber(double.parse(pesoJabaCtrl.text));
      final bruto = roundNumber(double.parse(pesoBrutoCtrl.text));
      final tara = roundNumber(nroJabas * pesoJaba);
      final neto = roundNumber(bruto - tara);
      final cantAves = int.parse(nroAvesCtrl.text) * nroJabas;
      final promedio = roundNumber(neto / cantAves);
      final pesaje = Pesaje(
        createdAt: DateTime.now(),
        nroJabas: nroJabas,
        pesoJaba: pesoJaba,
        bruto: bruto,
        tara: tara,
        neto: neto,
        nroAves: cantAves,
        promedio: promedio.isNaN ? 0 : promedio,
        importe: precio * neto,
      );
      if ((pesajeServ.totalAves + cantAves) > ordenProv.orden.cantAves) {
        const message =
            'El cantidad de aves será mayor que el de la orden. ¿Desea guardar el pesaje?';
        CustomDialog.alertMessageDialog(context, message, () {
          Navigator.pop(context);
          pesajeServ.addPesaje(pesaje);
          clearControllers();
        });
      } else {
        pesajeServ.addPesaje(pesaje);
        clearControllers();
      }
    } catch (e) {
      CustomDialog.errorDialog(context, e.toString());
    }
  }

}
