import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/hoy_ayer_ben_widget.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';

import '/src/presentation/providers/ayer_hoy_ben_provider.dart';
import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';
import '/src/presentation/utils/text_style.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/models/pesador.dart';
import '/src/models/zona.dart';

import '/src/services/filtro_beneficiado_service.dart';
import '/src/services/ordenes_beneficiado_service.dart';
import '/src/utils/date_formats.dart';

class FiltrosProgramacionBeneficiado extends StatefulWidget {
  const FiltrosProgramacionBeneficiado({super.key});

  @override
  State<FiltrosProgramacionBeneficiado> createState() => _FiltrosProgramacionBeneficiadoState();
}

class _FiltrosProgramacionBeneficiadoState extends State<FiltrosProgramacionBeneficiado> {
  final filtroServ = FiltroBeneficiadoService();
  final ordenService = OrdenesBeneficiadoService();

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  Zona? zona;
  final zonaCtrl = TextEditingController();
  Pesador? pesador;
  final pesadorCtrl = TextEditingController();
  Cliente? cliente;
  final clienteCtrl = TextEditingController();
  Camal? camal;
  final camalCtrl = TextEditingController();
  ProductoBeneficiado? producto;
  final productoCtrl = TextEditingController();

  void cleanFiltrosControllers() {
    fecha = null;
    fechaCtrl.clear();
    zona = null;
    zonaCtrl.clear();
    pesador = null;
    pesadorCtrl.clear();
    cliente = null;
    clienteCtrl.clear();
    camal = null;
    camalCtrl.clear();
    producto = null;
    productoCtrl.clear();
  }

  Future<void> verConfirmadas() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ayerHoyProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    final now = ayerHoyProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await ordenService.getOrdenes(token, ini, fin).then((value) {
      final list = ordenProv.ordenes;
      list.removeWhere((element) => element.confirm == 0);
      ordenProv.ordenes = list;
      ordenProv.ordenesResumen = list;
      ordenProv.ordenInitState();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void refresh() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ayerHoyProv = Provider.of<AyerHoyBenProv>(context, listen: false);
    final now = ayerHoyProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await ordenService.getOrdenes(token, ini, fin).then((value) {
      ordenProv.ordenes = value;
      ordenProv.ordenesResumen = value;
      ordenProv.ordenInitState();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.15,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HoyAyerBeneficiadoWidget(),
          Consumer<AyerHoyBenProv>(builder: (_, service, __) {
            return Checkbox(
              content: const Text('Ver Confirmadas'),
              checked: service.confirmadas,
              onChanged: (v) {
                service.confirmadas = v!;
                if (v) {
                  verConfirmadas();
                } else {
                  refresh();
                }
              },
            );
          }),
          const SizedBox(height: 20),
          const Text('Filtros de Busqueda', style: subtitleDataDBStyle),
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
          Consumer<ZonasProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Zona>(
                controller: zonaCtrl,
                placeholder: 'Zona',
                items: service.zonas
                    .map((e) => AutoSuggestBoxItem<Zona>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => zona = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<PesadoresProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Pesador>(
                controller: pesadorCtrl,
                placeholder: 'Pesador',
                items: service.pesadores
                    .map((e) => AutoSuggestBoxItem<Pesador>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => pesador = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<ClientesProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Cliente>(
                controller: clienteCtrl,
                placeholder: 'Cliente',
                items: service.clientes
                    .map((e) => AutoSuggestBoxItem<Cliente>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => cliente = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<CamalesProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Camal>(
                controller: camalCtrl,
                placeholder: 'Camal',
                items: service.camales
                    .map((e) => AutoSuggestBoxItem<Camal>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => camal = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<ProductosBeneficiadoProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<ProductoBeneficiado>(
                controller: productoCtrl,
                placeholder: 'Producto',
                items: service.productos
                    .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => producto = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 50),
          Center(
            child: FilledButton(
              onPressed: filtrar,
              child: const Text('Filtrar'),
            ),
          ),
          const SizedBox(height: 20),
          // Center(
          //   child: FilledButton(
          //     onPressed: jabasByProduct,
          //     child: const Text('Jabas por Pesador'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> filtrar() async {
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);
    DateTime date;
    if (fecha != null) {
      date = fecha!;
      fechaProv.ayer = false;
      fechaProv.hoy = false;
    } else if (fechaProv.ayer) {
      date = DateTime.now().subtract(const Duration(days: 1));
    } else {
      date = DateTime.now();
    }

    CustomDialog.loadingDialog(context);
    await filtroServ
        .filtrarOrdenes(
      context,
      date,
      camal: camal,
      cliente: cliente,
      pesador: pesador,
      producto: producto,
      zona: zona,
    )
        .then((value) {
      cleanFiltrosControllers();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  // void jabasByProduct() {
  //   Pesador? pesadorJ;
  //   TextEditingController pesadorJCtrl = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (c) => ContentDialog(
  //       title: const Text('Ver Jabas por Pesador'),
  //       content: Consumer<PesadoresProv>(
  //         builder: (_, service, __) {
  //           return SizedBox(
  //             height: 50,
  //             child: AutoSuggestBox<Pesador>(
  //               controller: pesadorJCtrl,
  //               placeholder: 'Pesador',
  //               items: service.pesadores
  //                   .map((e) => AutoSuggestBoxItem<Pesador>(
  //                       value: e,
  //                       label: e.nombre,
  //                       child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
  //                   .toList(),
  //               onSelected: (item) {
  //                 setState(() => pesadorJ = item.value);
  //               },
  //             ),
  //           );
  //         },
  //       ),
  //       actions: [
  //         FilledButton(
  //           onPressed: () {
  //             if (pesadorJ != null) {
  //               Navigator.pop(context);
  //               showJabasByProducto(pesadorJ!, context);
  //             }
  //           },
  //           child: const Text('Ver'),
  //         ),
  //         Button(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cerrar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// void showJabasByProducto(Pesador pesador, BuildContext context) {
//   final ordenes = Provider.of<OrdenesBeneficiadoProv>(context, listen: false)
//       .ordenes
//       .where((orden) => orden.pesadorId == pesador.id!);

//   Map<String, Map<String, int>> map = {};

//   int totalJabas = 0;

//   for (var orden in ordenes) {
//     totalJabas += orden.cantJabas;
//     if (!map.containsKey(orden.productoNombre)) {
//       map.putIfAbsent(
//           orden.productoNombre,
//           () => {
//                 'totalJabas': orden.cantJabas,
//                 'totalAves': orden.cantAves,
//                 'aves': orden.avesByJaba,
//               });
//     } else {
//       map.update(
//           orden.productoNombre,
//           (value) => {
//                 'totalJabas': value['totalJabas']! + orden.cantJabas,
//                 'totalAves': value['totalAves']! + orden.cantAves,
//                 'aves': value['aves']!,
//               });
//     }
//   }

//   showDialog(
//     context: context,
//     builder: (c) => ContentDialog(
//       title: Text('${pesador.nombre.toUpperCase()} - Total Jabas: $totalJabas'),
//       content: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.6,
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: ListView.separated(
//           shrinkWrap: true,
//           itemCount: map.length,
//           separatorBuilder: (c, i) => const SizedBox(height: 8),
//           itemBuilder: (c, i) {
//             final producto = map.keys.elementAt(i);
//             final cantJabas = map.values.elementAt(i)['totalJabas'];
//             final cantAves = map.values.elementAt(i)['totalAves'];
//             final aves = map.values.elementAt(i)['aves'];
//             return ListTile(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//                 side: const BorderSide(color: Colors.grey),
//               ),
//               title: Text(producto),
//               subtitle: Text(
//                 'Total Aves: $cantAves',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               trailing: Text(
//                 '$cantJabas por $aves',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       actions: [
//         Button(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cerrar'),
//         ),
//       ],
//     ),
//   );
// }
