import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../providers/usuarios_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/services/productos_beneficiado_service.dart';
import '../../utils/colors.dart';

class ProductosBeneficiadoView extends StatefulWidget {
  const ProductosBeneficiadoView({super.key});

  @override
  State<ProductosBeneficiadoView> createState() => _ProductosBeneficiadoViewState();
}

class _ProductosBeneficiadoViewState extends State<ProductosBeneficiadoView> {
  final productoCtrl = TextEditingController();
  final service = ProductosBeneficiadoService();

  List<ProductoBeneficiado> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    isSearching = productoCtrl.text.isNotEmpty;
    List<ProductoBeneficiado> pesadores = [];
    pesadores.addAll(service.productos);
    if (isSearching) {
      pesadores.retainWhere((value) {
        String searchLetter = productoCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = pesadores;
    });
  }

  @override
  void initState() {
    productoCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    productoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextBox(
            controller: productoCtrl,
            placeholder: 'Buscar Producto',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 100,
                child: Text(
                  'CODIGO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text('NOMBRE',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              RefreshButton(onPressed: () => refresh()),
              const SizedBox(width: 30),
              Container(
                alignment: Alignment.topRight,
                child: CreateButton(onPressed: () => create(context)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ProductosBeneficiadoProv>(builder: (_, service, __) {
            final list = service.productos;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final producto = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(producto.productCode)),
                    SizedBox(width: 250, child: Text(producto.nombre)),
                    SizedBox(
                      width: 180,
                      child: Text(
                          'Peso Min: ${producto.pesoMin.toStringAsFixed(2)} kg'),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text(
                          'Peso Max: ${producto.pesoMax.toStringAsFixed(2)} kg'),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text(
                          'Peso Prom: ${producto.promedio.toStringAsFixed(2)} kg'),
                    ),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, producto),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, producto),
                    ),
                  ],
                );
              },
              separatorBuilder: (c, i) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              itemCount: isSearching ? filtro.length : list.length,
            );
          }),
        ),
      ],
    );
  }

  void refresh() async {
    final productosProv = Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getProductos(token).then((value) {
      productosProv.productos = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final productosProv = Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final pesoMinCtrl = TextEditingController();
    final pesoMaxCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Producto',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                placeholder: 'Producto Code',
                controller: codigoCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Nombre',
                controller: nombreCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Peso Min',
                controller: pesoMinCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Peso Max',
                controller: pesoMaxCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final pesador = ProductoBeneficiado(
                createdAt: DateTime.now(),
                createdBy: user,
                productCode: codigoCtrl.text,
                nombre: nombreCtrl.text,
                pesoMin: double.parse(pesoMinCtrl.text),
                pesoMax: double.parse(pesoMaxCtrl.text),
              );
              await service.insertProducto(pesador, token).then((v) async {
                await service.getProductos(token).then((value) {
                  productosProv.productos = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Crear'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void update(BuildContext context, ProductoBeneficiado producto) {
    final productosProv = Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final nombreCtrl = TextEditingController();
    nombreCtrl.text = producto.nombre;
    final pesoMinCtrl = TextEditingController();
    pesoMinCtrl.text = producto.pesoMin.toString();
    final pesoMaxCtrl = TextEditingController();
    pesoMaxCtrl.text = producto.pesoMax.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Producto',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                placeholder: 'Nombre',
                controller: nombreCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Peso Min',
                controller: pesoMinCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Peso Max',
                controller: pesoMaxCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newProducto = producto.copyWith(
                newNombre: nombreCtrl.text,
                newPesoMin: double.tryParse(pesoMinCtrl.text),
                newPesoMax: double.tryParse(pesoMaxCtrl.text),
              );
              await service.updateProducto(newProducto, token).then((v) async {
                await service.getProductos(token).then((value) {
                  productosProv.productos = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Actualizar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void delete(BuildContext context, ProductoBeneficiado producto) {
    final productosProv = Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Producto',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar al producto ${producto.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteProducto(producto, token).then((v) async {
                await service.getProductos(token).then((value) {
                  productosProv.productos = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Eliminar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
