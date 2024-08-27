import 'package:app_desktop/src/models/vehiculo.dart';
import 'package:app_desktop/src/presentation/providers/vehiculos_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '../../../models/ordenes_vivo.dart';
import '/src/models/pesador.dart';
import '../../../models/producto_vivo.dart';
import '/src/models/zona.dart';

import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';

import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';
import '../../providers/ordenes_modelo_vivo_provider.dart';

import '../../../services/ordenes_modelo_vivo_service.dart';

class CreateOrdenModeloBeneficiado extends StatefulWidget {
  const CreateOrdenModeloBeneficiado({super.key});

  @override
  State<CreateOrdenModeloBeneficiado> createState() => _CreateOrdenModeloBeneficiadoState();
}

class _CreateOrdenModeloBeneficiadoState extends State<CreateOrdenModeloBeneficiado> {
  final ordenServ = OrdenesModeloVivosService();

  Zona? zona;
  final zonaCtrl = TextEditingController();
  Pesador? pesador;
  final pesadorCtrl = TextEditingController();
  Camal? camal;
  final camalCtrl = TextEditingController();
  Cliente? cliente;
  final clienteCtrl = TextEditingController();
  ProductoVivo? producto;
  final productoCtrl = TextEditingController();
  Vehiculo? vehiculo;
  final placaCtrl = TextEditingController();
  final avesCtrl = TextEditingController();
  final jabasCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final peladoCtrl = TextEditingController();

  ValueNotifier<int> totalAves = ValueNotifier(0);

  void clearControllers() {
    producto = null;
    vehiculo = null;
    productoCtrl.clear();
    placaCtrl.clear();
    avesCtrl.clear();
    jabasCtrl.clear();
    precioCtrl.clear();
    peladoCtrl.clear();
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
    final globalWidth = size.width <= 1366 ? 960.0 : 1050.0;
    return Container(
      width: globalWidth,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crear Nueva Orden de Entrega',
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
                      'Zona',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<ZonasProv>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<Zona>(
                          controller: zonaCtrl,
                          items: service.zonas
                              .map((e) => AutoSuggestBoxItem<Zona>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => zona = item.value);
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
                      'Pesador',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<PesadoresProv>(
                      builder: (_, service, __) {
                        final list = zona != null
                            ? service.pesadores
                                .where((e) => e.zonaCode == zona!.zonaCode)
                            : service.pesadores;
                        return AutoSuggestBox<Pesador>(
                          controller: pesadorCtrl,
                          items: list
                              .map((e) => AutoSuggestBoxItem<Pesador>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => pesador = item.value);
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
                      'Camal',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<CamalesProv>(
                      builder: (_, service, __) {
                        final list = zona != null
                            ? service.camales
                                .where((e) => e.zonaCode == zona!.zonaCode)
                            : service.camales;
                        return AutoSuggestBox<Camal>(
                          controller: camalCtrl,
                          items: list
                              .map((e) => AutoSuggestBoxItem<Camal>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => camal = item.value);
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
                      'Cliente',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<ClientesProv>(
                      builder: (_, service, __) {
                        final list = zona != null
                            ? service.clientes
                                .where((e) => e.zonaCode == zona!.zonaCode)
                            : service.clientes;
                        return AutoSuggestBox<Cliente>(
                          controller: clienteCtrl,
                          items: list
                              .map((e) => AutoSuggestBoxItem<Cliente>(
                                    value: e,
                                    label: e.nombre,
                                    child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) {
                            setState(() => cliente = item.value);
                          },
                        );
                      },
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
          Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Producto',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<ProductosVivoProv>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<ProductoVivo>(
                          controller: productoCtrl,
                          items: service.productos
                              .map((e) => AutoSuggestBoxItem<ProductoVivo>(
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
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Placa',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<VehiculosProvider>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<Vehiculo>(
                          controller: placaCtrl,
                          items: service.vehiculos
                              .map((e) => AutoSuggestBoxItem<Vehiculo>(
                                    value: e,
                                    label: e.placa,
                                    child: Text(e.placa, overflow: TextOverflow.ellipsis)
                                  ))
                              .toList(),
                          onSelected: (item) async {
                            setState(() => vehiculo = item.value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Precio', controller: precioCtrl, width: 80),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Pelado', controller: peladoCtrl, width: 80),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Ave x Jaba', controller: avesCtrl, width: 80),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Nro Jabas', controller: jabasCtrl, width: 80),
              const SizedBox(width: 25),
              SizedBox(
                width: 100,
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
            ],
          ),
        ],
      ),
    );
  }

  void crearDialog() async {
    if (zona == null ||
        pesador == null ||
        camal == null ||
        cliente == null ||
        producto == null ||
        precioCtrl.text.isEmpty ||
        placaCtrl.text.isEmpty ||
        jabasCtrl.text.isEmpty ||
        avesCtrl.text.isEmpty) {
      CustomDialog.messageDialog(
        context,
        'Error al crear',
        const Text('No se ingresaron todos los datos necesarios'),
      );
      return;
    }

    final observacionCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear nueva Orden',
          style: TextStyle(fontSize: 16),
        ),
        content: TextBox(
          controller: observacionCtrl,
          placeholder: 'Observacion',
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await crearOrden(DateTime.now(), observacionCtrl.text).then((value) {
                if (value) Navigator.pop(context);
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
      ),
    );
  }

  Future<bool> crearOrden(DateTime? fecha, String observacion) async {
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final ordenProv = Provider.of<OrdenesModeloVivoProv>(context, listen: false);
    final now = DateTime.now();
    try {
      final orden = OrdenVivo(
        createdAt: fecha ?? now,
        createdBy: userProv.usuario.nombre,
        zonaCode: zona!.zonaCode,
        pesadorId: pesador!.id!,
        pesadorNombre: pesador!.nombre,
        camalId: camal!.id!,
        camalNombre: camal!.nombre,
        clienteId: cliente!.id!,
        clienteNombre: cliente!.nombre,
        clienteCelular: cliente!.celular.toString(),
        clienteEstadoCta: cliente!.estadoCta!,
        productoId: producto!.id!,
        productoNombre: producto!.nombre,
        productoPesoMax: producto!.pesoMax,
        productoPesoMin: producto!.pesoMin,
        precio: double.parse(precioCtrl.text),
        cantAves: totalAves.value,
        cantJabas: int.parse(jabasCtrl.text),
        observacion: observacion,
        placa: placaCtrl.text
      );
      await ordenServ.insertOrden(orden, userProv.token);
      await ordenServ.getOrdenes(userProv.token).then((value) {
        ordenProv.ordenes = value;
      });
      clearControllers();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
