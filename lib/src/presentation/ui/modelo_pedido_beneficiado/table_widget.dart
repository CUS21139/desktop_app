// ignore_for_file: use_build_context_synchronously

import 'package:app_desktop/src/models/producto_beneficiado.dart';
import 'package:app_desktop/src/presentation/providers/ordenes_modelo_beneficiado_provider.dart';
import 'package:app_desktop/src/presentation/providers/productos_beneficiado_provider.dart';
import 'package:app_desktop/src/services/ordenes_modelo_beneficiado_service.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/utils/colors.dart';

import '/src/utils/date_formats.dart';

class TableOrdenesModeloBeneficiado extends StatefulWidget {
  const TableOrdenesModeloBeneficiado({super.key, required this.height});
  final double height;

  @override
  State<TableOrdenesModeloBeneficiado> createState() => _TableOrdenesModeloBeneficiadoState();
}

class _TableOrdenesModeloBeneficiadoState extends State<TableOrdenesModeloBeneficiado> {
  final ordenServ = OrdenesModeloBeneficiadoService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 960.0 : 1000.0;
    return Column(
      children: [
        SizedBox(
          width: globalWidth,
          child: Consumer<OrdenesModeloBeneficiadoProv>(builder: (_, service, __) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RefreshButton(onPressed: () => refresh(context)),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Edit Aves',
                  color: Colors.blue.dark,
                  iconData: FluentIcons.edit,
                  onPressed: () => editAves(),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Edit Precio',
                  color: Colors.green.dark,
                  iconData: FluentIcons.edit,
                  onPressed: () => editPrecio(),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Descontar',
                  color: Colors.orange.darkest,
                  iconData: FluentIcons.edit,
                  onPressed: () => descontarPrecio(),
                ),
                const Spacer(),
                CustomButton(
                  title: 'Editar',
                  color: greenColor,
                  iconData: FluentIcons.edit,
                  onPressed: service.existeOrden ? () => update(context) : null,
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Borrar Seleccion',
                  color: redColor,
                  iconData: FluentIcons.delete,
                  onPressed: service.selectCount > 0
                      ? () => deleteSeleccion(context)
                      : null,
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: widget.height,
            width: globalWidth,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Consumer<OrdenesModeloBeneficiadoProv>(builder: (_, service, __) {
                final lista = service.ordenes;
                return HorizontalDataTable(
                  isFixedHeader: true,
                  rightHandSideColBackgroundColor:
                      Colors.white.withOpacity(0.8),
                  leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
                  headerWidgets: [
                    const CellTitle(text: '', width: 0),
                    const CellTitle(text: 'Selec', width: 60),
                    const CellTitle(text: 'Fecha'),
                    const CellTitle(text: 'Zona'),
                    const CellTitle(text: 'Pesador'),
                    const CellTitle(text: 'Producto', width: 120),
                    const CellTitle(text: 'Camal'),
                    const CellTitle(text: 'Cliente', width: 120),
                    CellTitle(
                        text: 'Aves', width: size.width <= 1366 ? 80 : 100),
                    CellTitle(
                        text: 'Jabas', width: size.width <= 1366 ? 80 : 100),
                    const CellTitle(text: 'Precio'),
                    const CellTitle(text: 'Pelado'),
                    const CellTitle(text: 'Observacion', width: 150),
                  ],
                  isFixedFooter: true,
                  footerWidgets: [
                    const CellTitle(text: '', width: 0),
                    const CellTitle(text: '', width: 60),
                    const CellTitle(text: ''),
                    const CellTitle(text: ''),
                    const CellTitle(text: ''),
                    const CellTitle(text: '', width: 120),
                    const CellTitle(text: ''),
                    const CellTitle(text: '', width: 120),
                    CellTitle(
                        text: service.sumNroAves.toStringAsFixed(0),
                        width: size.width <= 1366 ? 80 : 100),
                    CellTitle(
                        text: service.sumNroJabas.toStringAsFixed(0),
                        width: size.width <= 1366 ? 80 : 100),
                    const CellTitle(text: '-'),
                    const CellTitle(text: '-'),
                    const CellTitle(text: '-', width: 150),
                  ],
                  itemCount: lista.length,
                  leftHandSideColumnWidth: 0,
                  leftSideItemBuilder: (c, i) => const SizedBox(),
                  rightHandSideColumnWidth: 1230,
                  rightSideItemBuilder: (c, i) {
                    final orden = lista[i];
                    return GestureDetector(
                      onTap: () {
                        if (service.existeOrden) {
                          if (service.orden == orden) {
                            service.ordenInitState();
                          } else {
                            service.orden = orden;
                          }
                        } else {
                          service.orden = orden;
                        }
                      },
                      child: Container(
                        color: service.existeOrden && orden == service.orden
                            ? Colors.blue.withOpacity(0.3)
                            : null,
                        child: Row(
                          children: [
                            Container(
                              height: 35,
                              width: 60,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  left: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    orden.isSelected
                                        ? FluentIcons.checkbox_fill
                                        : FluentIcons.checkbox,
                                    color: redColor,
                                  ),
                                  onPressed: () =>
                                      service.actualizarSeleccion(i),
                                ),
                              ),
                            ),
                            CellItem(text: date.format(orden.createdAt)),
                            CellItem(text: orden.zonaCode),
                            CellItem(text: orden.pesadorNombre),
                            CellItem(text: orden.productoNombre, width: 120),
                            CellItem(text: orden.camalNombre),
                            CellItem(text: orden.clienteNombre, width: 120),
                            CellItem(
                                text: orden.cantAves.toString(),
                                width: size.width <= 1366 ? 80 : 100),
                            CellItem(
                                text: orden.cantJabas.toString(),
                                width: size.width <= 1366 ? 80 : 100),
                            CellItem(text: orden.precio.toStringAsFixed(2)),
                            CellItem(text: orden.precio.toStringAsFixed(2)),
                            CellItem(text: orden.observacion ?? '', width: 150),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void refresh(BuildContext context) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    CustomDialog.loadingDialog(context);
    await ordenServ.getOrdenes(token).then((value) {
      ordenProv.ordenes = value;
      ordenProv.ordenInitState();
      Navigator.pop(context);
    }).catchError((e) {
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void update(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenesProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    Camal? uCamal;
    final uCamalCtrl = TextEditingController();
    Cliente? uCliente;
    final uClienteCtrl = TextEditingController();
    ProductoBeneficiado? uProducto;
    final uProductoCtrl = TextEditingController();

    final avesCtrl = TextEditingController();
    final jabasCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final uObservacionCtrl = TextEditingController();

    final orden = ordenesProv.orden;
    uCamalCtrl.text = orden.camalNombre;
    uClienteCtrl.text = orden.clienteNombre;
    uProductoCtrl.text = orden.productoNombre;
    jabasCtrl.text = orden.cantJabas.toString();
    avesCtrl.text = (orden.cantAves / orden.cantJabas).toStringAsFixed(0);
    precioCtrl.text = (orden.precio).toStringAsFixed(2);
    uObservacionCtrl.text = orden.observacion ?? '';

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Orden',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Camal', style: TextStyle(fontWeight: FontWeight.w500)),
            Consumer<CamalesProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<Camal>(
                  controller: uCamalCtrl,
                  placeholder: 'Camal',
                  items: service.camales
                      .map((e) => AutoSuggestBoxItem<Camal>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => uCamal = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            const Text('Cliente',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Consumer<ClientesProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<Cliente>(
                  controller: uClienteCtrl,
                  placeholder: 'Cliente',
                  items: service.clientes
                      .map((e) => AutoSuggestBoxItem<Cliente>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => uCliente = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            const Text('Producto',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: uProductoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => uProducto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: avesCtrl,
              title: 'Aves x Jaba',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: jabasCtrl,
              title: 'Cant Jabas',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: precioCtrl,
              title: 'Precio (S/)',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: uObservacionCtrl,
              title: 'Observacion',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);

              final jabas = int.parse(jabasCtrl.text);
              final aves = int.parse(avesCtrl.text) * jabas;
              final precio = double.parse(precioCtrl.text);
              
              CustomDialog.loadingDialog(context);   
              final newOrden = orden.copyWith(
                  newCamal: uCamal,
                  newCliente: uCliente,
                  newProducto: uProducto,
                  newCantJabas: jabas,
                  newCantAves: aves,
                  newPrecio: precio,
                  newObservacion: uObservacionCtrl.text);
              await ordenServ.updateOrden(newOrden, token).then((value) async {
                if (value) {
                  await ordenServ.getOrdenes(token).then((value) {
                    ordenesProv.ordenes = value;
                    ordenesProv.ordenInitState();
                    Navigator.pop(context);
                  });
                }
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void deleteSeleccion(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text('Eliminar Ordenes', style: TextStyle(fontSize: 16)),
        content: Text('Se eliminarán ${ordenProv.selectCount} ordenes'),
        actions: [
          FilledButton(
            child: const Text('Eliminar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                CustomDialog.loadingDialog(context);
                for (var orden in ordenProv.ordenes) {
                  if (orden.isSelected) {
                    await ordenServ.deleteOrden(orden, token);
                  }
                }
                await ordenServ.getOrdenes(token).then((value) {
                  ordenProv.ordenes = value;
                  ordenProv.ordenInitState();
                  Navigator.pop(context);
                });
              } catch (e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void editPrecio() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    ProductoBeneficiado? producto;
    final productoCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Editar Precio',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: productoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => producto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: precioCtrl,
              title: 'Precio (S/)',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);
              if (producto == null) {
                CustomDialog.errorDialog(context, 'Elija un producto');
              } else {
                try {
                  final precio = double.parse(precioCtrl.text);
                  CustomDialog.loadingDialog(context);
                  for (var orden in ordenProv.ordenes) {
                    if (orden.productoId == producto!.id) {
                      final newOrden = orden.copyWith(newPrecio: precio);
                      await ordenServ.updateOrden(newOrden, token);
                    }
                  }
                  ordenServ.getOrdenes(token).then((value) {
                    ordenProv.ordenes = value;
                    ordenProv.ordenInitState();
                    Navigator.pop(context);
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void editAves() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    ProductoBeneficiado? producto;
    final productoCtrl = TextEditingController();
    final avesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Editar Cant Aves',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: productoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => producto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: avesCtrl,
              title: 'Cant Aves',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);
              if (producto == null) {
                CustomDialog.errorDialog(context, 'Elija un producto');
              } else {
                try {
                  final aves = int.parse(avesCtrl.text);
                  CustomDialog.loadingDialog(context);
                  for (var orden in ordenProv.ordenes) {
                    final newCant = aves * orden.cantJabas;
                    if (orden.productoId == producto!.id) {
                      final newOrden = orden.copyWith(newCantAves: newCant);
                      await ordenServ.updateOrden(newOrden, token);
                    }
                  }
                  ordenServ.getOrdenes(token).then((value) {
                    ordenProv.ordenes = value;
                    ordenProv.ordenInitState();
                    Navigator.pop(context);
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void descontarPrecio() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    final precioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Descontar Precio',
          style: TextStyle(fontSize: 16),
        ),
        content: CustomTextBox(
          controller: precioCtrl,
          title: 'Descontar (S/)',
          width: 400,
        ),
        actions: [
          FilledButton(
            child: const Text('Confirmar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final descuento = double.parse(precioCtrl.text);
                CustomDialog.loadingDialog(context);
                for (var orden in ordenProv.ordenes) {
                  final newPrecio = descuento + orden.precio;
                  final newOrden = orden.copyWith(newPrecio: newPrecio);
                  await ordenServ.updateOrden(newOrden, token);
                }
                ordenServ.getOrdenes(token).then((value) {
                  ordenProv.ordenes = value;
                  ordenProv.ordenInitState();
                  Navigator.pop(context);
                });
              } catch (e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
