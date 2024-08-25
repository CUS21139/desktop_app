import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';


import '/src/models/compra_beneficiado.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/models/proveedor.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';

import '/src/presentation/providers/compras_beneficiado_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/compras_beneficiado_service.dart';
import '/src/services/proveedores_service.dart';

import '/src/utils/date_formats.dart';

class CreateCompraBeneficiados extends StatefulWidget {
  const CreateCompraBeneficiados({super.key});

  @override
  State<CreateCompraBeneficiados> createState() => _CreateCompraBeneficiadosState();
}

class _CreateCompraBeneficiadosState extends State<CreateCompraBeneficiados> {
  final compraServ = ComprasBeneficiadoService();

  ProductoBeneficiado? producto;
  final productoCtrl = TextEditingController();
  Proveedor? proveedor;
  final proveedorCtrl = TextEditingController();
  final avesCtrl = TextEditingController();
  final jabasCtrl = TextEditingController();
  final precioCtrl = TextEditingController();

  ValueNotifier<int> totalAves = ValueNotifier(0);

  void clearControllers() {
    producto = null;
    productoCtrl.clear();
    proveedor = null;
    proveedorCtrl.clear();
    avesCtrl.clear();
    jabasCtrl.clear();
    precioCtrl.clear();
  }

  void calcularTotalAves() {
    if (avesCtrl.text.isEmpty) totalAves.value = 0;
    if (jabasCtrl.text.isEmpty) totalAves.value = 0;
    final aves = int.tryParse(avesCtrl.text);
    final jabas = int.tryParse(jabasCtrl.text);
    if (aves != null && jabas != null) {
      totalAves.value = aves * jabas;
    }
  }

  @override
  void initState() {
    avesCtrl.addListener(() => calcularTotalAves());
    jabasCtrl.addListener(() => calcularTotalAves());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width <= 1366 ? 960 : 1050,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crear Nueva Compra',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proveedor',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<ProveedoresProv>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<Proveedor>(
                          controller: proveedorCtrl,
                          items: service.proveedores
                              .map((e) => AutoSuggestBoxItem<Proveedor>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => proveedor = item.value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Producto',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<ProductosBeneficiadoProv>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<ProductoBeneficiado>(
                          controller: productoCtrl,
                          items: service.productos
                              .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => producto = item.value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Precio', controller: precioCtrl, width: 100),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Ave x Jaba', controller: avesCtrl, width: 100),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Nro Jabas', controller: jabasCtrl, width: 100),
              const SizedBox(width: 25),
              SizedBox(
                width: size.width * 0.04,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'T.Aves',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: ValueListenableBuilder(
                          valueListenable: totalAves,
                          builder: (_, value, __) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: crearDialog,
                child: const Text('Agregar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void crearDialog() async {
    if (proveedor == null ||
        producto == null ||
        precioCtrl.text.isEmpty ||
        jabasCtrl.text.isEmpty ||
        avesCtrl.text.isEmpty) {
      CustomDialog.messageDialog(
        context,
        'Error al crear',
        const Text('No se ingresaron todos los datos necesarios'),
      );
      return;
    }

    DateTime? newFecha;
    final fechaCtrl = TextEditingController();
    showDialog(
        context: context,
        builder: (c) => ContentDialog(
              key: const Key('crearCompra'),
              title: const Text(
                'Crear nueva Compra',
                style: TextStyle(fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Seleccione una fecha si desea asignar una distinta a la actual',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextBox(
                    placeholder: 'Fecha',
                    controller: fechaCtrl,
                    readOnly: true,
                    onTap: () async {
                      newFecha = await CustomDatePicker.showPicker(context);
                      if (newFecha != null) {
                        fechaCtrl.text = date.format(newFecha!);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    CustomDialog.loadingDialog(context);
                    await crearCompra(fecha: newFecha).then((value) {
                      if (value) {
                        Navigator.pop(context);
                        clearControllers();
                      }
                    }).catchError((e) {
                      Navigator.pop(context);
                      CustomDialog.errorDialog(context, e.toString());
                    });
                  },
                  child: const Text('Crear'),
                ),
                Button(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ));
  }

  Future<bool> crearCompra({DateTime? fecha}) async {
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final compraProv = Provider.of<ComprasBeneficiadoProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final now = DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      final pesoTotal = producto!.promedio * totalAves.value;
      final importeTotal = pesoTotal * double.parse(precioCtrl.text);

      final compra = CompraBeneficiado(
        createdAt: fecha ?? now,
        createdBy: userProv.usuario.nombre,
        productoId: producto!.id!,
        productoNombre: producto!.nombre,
        proveedorId: proveedor!.id!,
        proveedorNombre: proveedor!.nombre,
        proveedorEstadoCta: proveedor!.estadoCta!,
        precio: double.parse(precioCtrl.text),
        pesoTotal: pesoTotal,
        cantAves: totalAves.value,
        cantJabas: int.parse(jabasCtrl.text),
        importeTotal: importeTotal,
      );
      await compraServ.insertCompra(compra, userProv.token);
      await ProveedoresService().getProveedores(userProv.token).then((value) {
        proveedorProv.proveedores = value;
      });
      await compraServ.getCompras(userProv.token, ini, fin).then((value) {
        compraProv.compras = value;
        compraProv.comprasResumen = value;
      });
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
