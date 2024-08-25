import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/pesador.dart';
import '/src/models/jabas.dart';

import '/src/presentation/components/button_create.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/table_cell.dart';
import '/src/presentation/providers/jabas_provider.dart';
import '/src/presentation/providers/camales_jabas_prov.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '/src/presentation/utils/colors.dart';

import '/src/services/camal_jabas_service.dart';
import '/src/services/jabas_service.dart';
import '/src/utils/date_formats.dart';

class JabasView extends StatefulWidget {
  const JabasView({super.key});

  @override
  State<JabasView> createState() => _JabasViewState();
}

class _JabasViewState extends State<JabasView> {
  final jabaService = JabasService();

  late List<Pesador> pesadores = [];
  Pesador? pesador;

  late String token;

  final fechaCtrl = TextEditingController();
  DateTime? fecha;

  @override
  void initState() {
    final pesadoresProv = Provider.of<PesadoresProv>(context, listen: false);
    final userProv = Provider.of<UsuariosProv>(context, listen: false);

    pesadores = pesadoresProv.pesadores;
    token = userProv.token;
    final now = DateTime.now();
    final operationDay = DateTime(
      now.year,
      now.month,
      (now.hour < 12) ? (now.day - 1) : now.day,
    );
    fecha = operationDay;
    fechaCtrl.text = date.format(fecha!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const globalWidth = 800.0;

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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
                    const Text(
                      'Pesador',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    AutoSuggestBox(
                      items: pesadores
                          .map((e) => AutoSuggestBoxItem(
                                value: e,
                                label: e.nombre,
                              ))
                          .toList(),
                      onSelected: (v) => pesador = v.value,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: FilledButton(
                        child: const Text('Buscar'),
                        onPressed: () => buscar(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CreateButton(
                      title: 'Añadir Jaba',
                      onPressed: () => addJaba(),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Consumer<JabasProv>(
                        builder: (_, serv, __) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: serv.list.length,
                            itemBuilder: (c, i) => ListTile(
                              leading: IconButton(
                                icon: const Icon(FluentIcons.edit),
                                onPressed: () => editJaba(serv.list[i]),
                              ),
                              title: Text(serv.list[i].color.toUpperCase()),
                              trailing: Text(serv.list[i].cantidad.toString()),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Consumer<JabasProv>(builder: (_, serv, __) {
                      return Column(
                        children: [
                          const Text(
                            'GLOBAL DE JABAS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total JABAS:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${serv.totalJabas}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total RECOGIDAS:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${serv.totalRecogida}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total PENDIENTES:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${serv.totalPendientes}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total ACOPIO:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${serv.totalAcopio}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: globalWidth,
                child: Column(
                  children: [
                    Row(
                      children: [
                        RefreshButton(onPressed: () => buscar()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: size.height * 0.70,
                        width: globalWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 0.5),
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: Consumer<CamalesJabasProv>(
                              builder: (_, service, __) {
                            return HorizontalDataTable(
                              itemCount: service.list.length,
                              headerWidgets: const [
                                CellTitle(text: '', width: 0),
                                CellTitle(text: 'Fecha'),
                                CellTitle(text: 'Hora'),
                                CellTitle(text: 'Camal', width: 150),
                                CellTitle(text: 'Trabajador', width: 150),
                                CellTitle(text: 'Total'),
                                CellTitle(text: 'Recogida'),
                                CellTitle(text: 'Pendiente'),
                              ],
                              footerWidgets: [
                                const CellTitle(text: '', width: 0),
                                const CellTitle(text: ''),
                                const CellTitle(text: ''),
                                const CellTitle(text: '', width: 150),
                                const CellTitle(text: '', width: 150),
                                CellTitle(text: service.totalJabas.toString()),
                                CellTitle(
                                    text: service.totalRecogida.toString()),
                                CellTitle(
                                    text: service.totalPendientes.toString()),
                              ],
                              isFixedHeader: true,
                              isFixedFooter: true,
                              leftHandSideColumnWidth: 0,
                              leftHandSideColBackgroundColor:
                                  Colors.white.withOpacity(0.8),
                              leftSideItemBuilder: (c, i) => const SizedBox(),
                              rightHandSideColumnWidth: globalWidth,
                              rightHandSideColBackgroundColor:
                                  Colors.white.withOpacity(0.8),
                              rightSideItemBuilder: (c, i) {
                                final mov = service.list[i];
                                return Row(
                                  children: [
                                    CellItem(text: date.format(mov.createdAt)),
                                    CellItem(text: time.format(mov.createdAt)),
                                    CellItem(text: mov.camalNombre, width: 150),
                                    CellItem(
                                      text: mov.trabajadorNombre ?? '',
                                      width: 150,
                                    ),
                                    CellItem(text: mov.cantidad.toString()),
                                    CellItem(text: mov.cantRecogida.toString()),
                                    CellItem(
                                      text: mov.quedan.toString(),
                                      backgroundColor:
                                          mov.quedan > 0 ? redColor : null,
                                      textColor:
                                          mov.quedan > 0 ? Colors.white : null,
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> buscar() async {
    final camalJabaProv = Provider.of<CamalesJabasProv>(context, listen: false);
    final jabaProv = Provider.of<JabasProv>(context, listen: false);

    if (pesador == null) {
      CustomDialog.errorDialog(context, 'Elija un pesador');
      return;
    }

    if (fecha == null) {
      CustomDialog.errorDialog(context, 'Elija una fecha');
      return;
    }

    CustomDialog.loadingDialog(context);
    jabaProv.clearListTotales();
    for (var p in pesadores) {
      await CamalesJabasService()
          .getRegistrosPendientes(token, p, fecha!)
          .then((value) {
        if (p.id! == pesador!.id!) {
          camalJabaProv.setList(value);
        }
        jabaProv.addListTotales(value);
      });
    }
    Navigator.pop(context);
  }

  void addJaba() {
    final jabaProv = Provider.of<JabasProv>(context, listen: false);
    final colorCtrl = TextEditingController();
    final cantidadCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text('Agregar Jaba'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              width: 400,
              controller: colorCtrl,
              title: 'Color',
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: cantidadCtrl,
              title: 'Cantidad',
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Agregar'),
            onPressed: () async {
              Navigator.pop(c);
              final cant = int.tryParse(cantidadCtrl.text);
              if (cant == null) {
                CustomDialog.errorDialog(context, 'Ingrese un número válido');
                return;
              }

              CustomDialog.loadingDialog(context);
              final jaba = Jaba(color: colorCtrl.text, cantidad: cant);
              await jabaService.insertJaba(jaba, token);
              await jabaService.getJabas(token).then((value) {
                jabaProv.setList(value);
                Navigator.pop(context);
              });
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(c),
          ),
        ],
      ),
    );
  }

  void editJaba(Jaba jaba) {
    final jabaProv = Provider.of<JabasProv>(context, listen: false);
    final colorCtrl = TextEditingController(text: jaba.color);
    final cantidadCtrl = TextEditingController(text: jaba.cantidad.toString());
    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text('Editar Jabas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              width: 400,
              controller: colorCtrl,
              title: 'Color',
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: cantidadCtrl,
              title: 'Cantidad',
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Agregar'),
            onPressed: () async {
              Navigator.pop(c);
              final cant = int.tryParse(cantidadCtrl.text);
              if (cant == null) {
                CustomDialog.errorDialog(context, 'Ingrese un número válido');
                return;
              }

              CustomDialog.loadingDialog(context);
              final newJaba =
                  jaba.copyWith(newColor: colorCtrl.text, newCantidad: cant);
              await jabaService.updateJaba(newJaba, token);
              await jabaService.getJabas(token).then((value) {
                jabaProv.setList(value);
                Navigator.pop(context);
              });
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(c),
          ),
        ],
      ),
    );
  }
}
