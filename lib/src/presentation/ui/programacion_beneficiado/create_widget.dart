import 'package:fluent_ui/fluent_ui.dart';
import '/src/services/clientes_service.dart';
import 'package:provider/provider.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/ordenes_beneficiado.dart';
import '/src/models/pesador.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/models/vehiculo.dart';
import '/src/models/zona.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';

import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '/src/presentation/providers/pesaje_manual_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/vehiculos_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import '/src/services/ordenes_beneficiado_service.dart';
import '/src/utils/date_formats.dart';

class CreateOrdenBeneficiado extends StatefulWidget {
  const CreateOrdenBeneficiado({super.key});

  @override
  State<CreateOrdenBeneficiado> createState() => _CreateOrdenBeneficiadoState();
}

class _CreateOrdenBeneficiadoState extends State<CreateOrdenBeneficiado> {
  final ordenServ = OrdenesBeneficiadoService();

  Zona? zona;
  final zonaCtrl = TextEditingController();
  Pesador? pesador;
  final pesadorCtrl = TextEditingController();
  Camal? camal;
  final camalCtrl = TextEditingController();
  Cliente? cliente;
  final clienteCtrl = TextEditingController();
  ProductoBeneficiado? producto;
  final productoCtrl = TextEditingController();
  Vehiculo? vehiculo;
  final placaCtrl = TextEditingController();
  final avesCtrl = TextEditingController();
  final jabasCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final precioPeladoCtrl = TextEditingController();

  ValueNotifier<int> totalAves = ValueNotifier(0);

  void clearControllers() {
    vehiculo == null;
    producto = null;
    productoCtrl.clear();
    avesCtrl.clear();
    jabasCtrl.clear();
    precioCtrl.clear();
    precioPeladoCtrl.clear();
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
      padding: EdgeInsets.all(size.width <= 1366 ? 5 : 10),
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
                                  child: Text(e.nombre,
                                      overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onSelected: (item) {
                            setState(() => zona = item.value);
                          },
                          onChanged: (text, changeReason) {
                            if(text.isEmpty){
                              pesadorCtrl.clear();
                              camalCtrl.clear();
                              clienteCtrl.clear();
                            }
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
                                  child: Text(e.nombre,
                                      overflow: TextOverflow.ellipsis)))
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
                                  child: Text(e.nombre,
                                      overflow: TextOverflow.ellipsis)))
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
                                  child: Text(e.nombre,
                                      overflow: TextOverflow.ellipsis)))
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
                    Consumer<ProductosBeneficiadoProv>(
                      builder: (_, service, __) {
                        return AutoSuggestBox<ProductoBeneficiado>(
                          controller: productoCtrl,
                          items: service.productos
                              .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                                  value: e,
                                  label: e.nombre,
                                  child: Text(e.nombre,
                                      overflow: TextOverflow.ellipsis)))
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
                width: 100,
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
                                  child: Text(e.placa,
                                      overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onSelected: (item) {
                            //TODO: validar capacidad
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
                  title: 'Precio', controller: precioCtrl, width: 100),
              const SizedBox(width: 15),
              CustomTextBox(
                  title: 'Pelado', controller: precioPeladoCtrl, width: 100),
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
              Consumer<PesajeManualProv>(builder: (_, service, __) {
                final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context);
                return FilledButton(
                  onPressed: ordenProv.existeOrden
                      ? () {
                          service.pesajeManual = true;
                        }
                      : null,
                  child: const Text('Pesaje Manual'),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void crearDialog() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    if (zona == null ||
        pesador == null ||
        camal == null ||
        cliente == null ||
        producto == null ||
        vehiculo == null ||
        precioCtrl.text.isEmpty ||
        precioPeladoCtrl.text.isEmpty ||
        jabasCtrl.text.isEmpty ||
        avesCtrl.text.isEmpty) {
      CustomDialog.messageDialog(
        context,
        'Error al crear',
        const Text('No se ingresaron todos los datos necesarios'),
      );
      return;
    }

    await ClientesService().getCliente(token, cliente!.id!).then((value) {
      if (!value.inRangeMax) {
        CustomDialog.errorDialog(
          context,
          'No se puede crear la Orden, el cliente ${value.nombre} tiene una deuda de S/ ${value.saldo!.toStringAsFixed(2)}',
        );
        return;
      }

      if (!value.inRangeMin) {
        CustomDialog.errorDialog(
          context,
          'No se puede crear la Orden, el cliente ${value.nombre} debe tener al menos S/ ${value.saldoMinimo!.toStringAsFixed(2)} como saldo.',
        );
        return;
      }
      DateTime? newFecha;
      final fechaCtrl = TextEditingController();
      final observacionCtrl = TextEditingController();
      showDialog(
        context: context,
        builder: (c) => ContentDialog(
          title: const Text(
            'Crear nueva Orden',
            style: TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                controller: observacionCtrl,
                placeholder: 'Observacion',
              ),
              const SizedBox(height: 10),
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
                  if (newFecha != null) fechaCtrl.text = date.format(newFecha!);
                },
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                CustomDialog.loadingDialog(context);
                await crearOrden(newFecha, observacionCtrl.text).then((value) {
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
    });
  }

  Future<bool> crearOrden(DateTime? fecha, String observacion) async {
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final now = DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      final orden = OrdenBeneficiado(
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
        precioPelado: double.parse(precioPeladoCtrl.text),
        cantAves: totalAves.value,
        cantJabas: int.parse(jabasCtrl.text),
        observacion: observacion,
        placa: placaCtrl.text,
      );
      await ordenServ.insertOrden(orden, userProv.token);
      await ordenServ.getOrdenes(userProv.token, ini, fin).then((value) {
        ordenProv.ordenes = value;
        ordenProv.ordenesResumen = value;
      });
      clearControllers();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
