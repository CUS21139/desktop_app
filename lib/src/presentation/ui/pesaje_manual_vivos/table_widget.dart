import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// import '/src/models/camal_jaba.dart';
import '../../../models/venta_vivo.dart';

import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/clientes_provider.dart';
import '../../providers/ordenes_vivo_provider.dart';
import '/src/presentation/providers/pesaje_manual_provider.dart';
import '/src/presentation/providers/pesajes_list_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '../../providers/ventas_vivo_provider.dart';
import '/src/presentation/utils/colors.dart';
import '/src/presentation/utils/text_style.dart';

import '/src/services/clientes_service.dart';
// import '/src/services/camal_jabas_service.dart';
import '../../../services/ordenes_vivo_service.dart';
import '../../../services/ventas_vivo_service.dart';

class TablePesajeManual extends StatefulWidget {
  const TablePesajeManual({super.key, required this.height});
  final double height;

  @override
  State<TablePesajeManual> createState() => _TablePesajeManualState();
}

class _TablePesajeManualState extends State<TablePesajeManual> {
  final observacionesCtrl = TextEditingController();

  double precio = 0;
  String producto = '';
  double min = 0;
  double max = 0;

  @override
  void initState() {
    final orden = Provider.of<OrdenesVivoProv>(context, listen: false).orden;
    precio = orden.precio;
    producto = orden.productoNombre;
    min = orden.productoPesoMin;
    max = orden.productoPesoMax;
    observacionesCtrl.text = orden.observacion ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 920,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: widget.height,
              width: 920,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Consumer<PesajesProv>(builder: (_, service, __) {
                  return HorizontalDataTable(
                    itemCount: service.pesajes.length,
                    headerWidgets: const [
                      CellTitle(text: '', width: 0),
                      CellTitle(text: '', width: 80),
                      CellTitle(text: 'Producto'),
                      CellTitle(text: 'Promedio', width: 80),
                      CellTitle(text: 'Peso Bruto'),
                      CellTitle(text: 'Nro Aves'),
                      CellTitle(text: 'Nro Jabas'),
                      CellTitle(text: 'Peso Tara', width: 80),
                      CellTitle(text: 'Peso Neto', width: 80),
                      CellTitle(text: 'Precio', width: 80),
                      CellTitle(text: 'Importe Total', width: 120),
                    ],
                    isFixedHeader: true,
                    footerWidgets: [
                      const CellTitle(text: '', width: 0),
                      const CellTitle(text: '', width: 80),
                      const CellTitle(text: ''),
                      CellTitle(
                          text: service.totalPromedio.toStringAsFixed(2),
                          width: 80),
                      CellTitle(text: service.totalBruto.toStringAsFixed(2)),
                      CellTitle(text: service.totalAves.toString()),
                      CellTitle(text: service.totalJabas.toString()),
                      CellTitle(
                          text: service.totalTara.toStringAsFixed(2),
                          width: 80),
                      CellTitle(
                          text: service.totalNeto.toStringAsFixed(2),
                          width: 80),
                      const CellTitle(text: '-', width: 80),
                      CellTitle(
                          text: 'S/ ${service.totalImporte.toStringAsFixed(2)}',
                          width: 120)
                    ],
                    isFixedFooter: true,
                    leftHandSideColumnWidth: 0,
                    leftHandSideColBackgroundColor:
                        Colors.white.withOpacity(0.8),
                    leftSideItemBuilder: (c, i) => const SizedBox(),
                    rightHandSideColumnWidth: 920,
                    rightHandSideColBackgroundColor:
                        Colors.white.withOpacity(0.8),
                    rightSideItemBuilder: (c, i) {
                      final pesaje = service.pesajes[i];
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => service.deletePesaje(pesaje),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              height: 35,
                              width: 80,
                              child: const Icon(
                                FluentIcons.delete,
                                color: redColor,
                                size: 17,
                              ),
                            ),
                          ),
                          CellItem(text: producto),
                          Container(
                            height: 35,
                            width: 80,
                            decoration: BoxDecoration(
                              color: pesaje.inRange(min, max) ? null : redColor,
                              border: const Border(
                                right: BorderSide(color: Colors.black),
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${pesaje.promedio.toStringAsFixed(2)} kg',
                                style: pesaje.inRange(min, max)
                                    ? cellDataDBStyle
                                    : cellDataDBErrorStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          CellItem(
                              text: '${pesaje.bruto.toStringAsFixed(2)} kg'),
                          CellItem(text: pesaje.nroAves.toString()),
                          CellItem(text: pesaje.nroJabas.toString()),
                          CellItem(
                              text: '${pesaje.tara.toStringAsFixed(2)} kg',
                              width: 80),
                          CellItem(
                              text: '${pesaje.neto.toStringAsFixed(2)} kg',
                              width: 80),
                          CellItem(
                              text: 'S/ ${precio.toStringAsFixed(2)}',
                              width: 80),
                          CellItem(
                              text: 'S/ ${pesaje.importe.toStringAsFixed(2)}',
                              width: 120),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextBox(
                controller: observacionesCtrl,
                title: 'Observaciones',
                width: 700,
              ),
              FluentTheme(
                data: FluentThemeData(accentColor: Colors.red),
                child: FilledButton(
                  onPressed: finalizarPesaje,
                  child: const Text('Finalizar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void finalizarPesaje() async {
    final indexProv = Provider.of<PesajeManualProv>(context, listen: false);
    final ordenProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final pesajeProv = Provider.of<PesajesProv>(context, listen: false);
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    // final camalJabaServ = CamalesJabasService();
    final ordenServ = OrdenesVivoService();
    final ventaServ = VentasVivoService();

    final orden = ordenProv.orden;
    final now = DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      CustomDialog.loadingDialog(context);
      final venta = VentaVivo(
        createdAt: now,
        createdBy: userProv.usuario.nombre,
        ordenDate: orden.createdAt,
        ordenId: orden.id!,
        zonaCode: orden.zonaCode,
        camalId: orden.camalId,
        camalNombre: orden.camalNombre,
        pesadorId: orden.pesadorId,
        pesadorNombre: orden.pesadorNombre,
        clienteId: orden.clienteId,
        clienteNombre: orden.clienteNombre,
        clienteCelular: orden.clienteCelular,
        clienteEstadoCta: orden.clienteEstadoCta,
        productoId: orden.productoId,
        productoNombre: orden.productoNombre,
        precio: orden.precio,
        pesajes: pesajeProv.pesajes,
        totalJabas: pesajeProv.totalJabas,
        totalBruto: pesajeProv.totalBruto,
        totalTara: pesajeProv.totalTara,
        totalNeto: pesajeProv.totalNeto,
        totalAves: pesajeProv.totalAves,
        totalPromedio: pesajeProv.totalPromedio,
        totalImporte: pesajeProv.totalImporte,
        observacion: observacionesCtrl.text,
        placa: orden.placa,
      );
      // final registro = CamalJaba(
      //   createdAt: now,
      //   operationDate: orden.createdAt,
      //   pesadorId: venta.pesadorId,
      //   pesadorNombre: venta.pesadorNombre,
      //   camalId: venta.camalId,
      //   camalNombre: venta.camalNombre,
      //   cantidad: venta.totalJabas,
      //   recogido: false,
      // );
      await ventaServ.insertVenta(venta, userProv.token).then((value) async {
        if (value) {
          // await camalJabaServ.insertRegistro(registro, userProv.token).then((value) async {
          //   if (!value['ok']) {
          //     final r = CamalJaba.fromJson(value['camal_jaba']);
          //     final newCant = r.cantidad + registro.cantidad;
          //     await camalJabaServ.updateRegistro(r.copyWith(newCant: newCant), userProv.token);
          //   }
          // }).catchError((e) {
          //   throw Exception(['registro jabas', e.toString()]);
          // });
          await ordenServ
              .getOrdenes(userProv.token, ini, fin)
              .then((value) async {
            ordenProv.ordenes = value;
          });
          await ClientesService().getClientes(userProv.token).then((value) {
            clienteProv.clientes = value;
          });
          await ventaServ
              .getVentas(userProv.token, ini, fin)
              .then((value) async {
            indexProv.pesajeManual = false;
            pesajeProv.clearList();
            ventaProv.setVentas(value, false);
            ventaProv.ventasResumen = value;
            Navigator.pop(context);
          });
        }
      });
    } catch (e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    }
  }
}
