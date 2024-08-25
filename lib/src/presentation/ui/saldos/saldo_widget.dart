import 'package:fluent_ui/fluent_ui.dart';

import '/src/presentation/components/button_excel.dart';
import '../../../models/entity.dart';
import '../../../presentation/utils/text_style.dart';

class SaldosWidget extends StatefulWidget {
  const SaldosWidget(
      {super.key,
      required this.title,
      required this.excelTitle,
      required this.lista,
      required this.color,
      required this.onRefresh,
      required this.export});

  final String title;
  final String excelTitle;
  final List<Entity> lista;
  final Color color;
  final void Function ()? onRefresh;
  final void Function () export;

  @override
  State<SaldosWidget> createState() => _SaldosWidgetState();
}

class _SaldosWidgetState extends State<SaldosWidget> {
  final entityCtrl = TextEditingController();

  List<Entity> filtro = [];

  bool isSearching = false;

  double sumaSaldo(List<Entity> estados) {
    double suma = 0;
    for (var e in estados) {
      suma += e.saldo!;
    }
    return suma;
  }

  @override
  void initState() {
    entityCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    entityCtrl.dispose();
    super.dispose();
  }

  void filter() {
    isSearching = entityCtrl.text.isNotEmpty;
    List<Entity> entities = [];
    entities.addAll(widget.lista);
    if (isSearching) {
      entities.retainWhere((entity) {
        String searchLetter = entityCtrl.text.toLowerCase();
        String name = entity.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = entities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double saltoTotal = sumaSaldo(isSearching ? filtro : widget.lista);
    return Container(
      height: size.height * 0.7,
      width: size.width * 0.22,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.color.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: widget.color.withOpacity(0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.color, fontWeight: FontWeight.bold),
                    ),
                    ExcelButton(onPressed: widget.export),
                    FilledButton(
                      onPressed: widget.onRefresh,
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Icon(FluentIcons.refresh),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextBox(
                  placeholder: 'Buscar',
                  controller: entityCtrl,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                final element = isSearching ? filtro[i] : widget.lista[i];
                return ListTile(
                  title: Text(element.nombre),
                  trailing: Text(
                    'S/ ${element.saldo!.toStringAsFixed(2)}',
                    style: subtitleDataDBStyle,
                  ),
                );
              },
              itemCount: isSearching ? filtro.length : widget.lista.length,
            ),
          ),
          Container(
            color: widget.color.withOpacity(0.1),
            child: ListTile(
              title: Text(
                'Saldo Total',
                style:
                    TextStyle(color: widget.color, fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                'S/ ${saltoTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
