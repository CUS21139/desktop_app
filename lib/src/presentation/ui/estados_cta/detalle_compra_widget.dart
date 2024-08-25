import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../models/compra_vivo.dart';
import '/src/presentation/components/table_cell.dart';
import '/src/utils/date_formats.dart';

class TableDetalleEstadoCompra extends StatelessWidget {
  const TableDetalleEstadoCompra({super.key, required this.compra});
  final CompraVivo compra;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final globalWidth = width <= 1366 ? 960.0 : 1000.0;
    return Container(
      height: 105,
      width: globalWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: HorizontalDataTable(
            isFixedHeader: true,
            rightHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            headerWidgets: [
              const CellTitle(text: '', width: 0),
              const CellTitle(text: 'Doc ID', width: 120),
              CellTitle(text: 'Fecha', width: width <= 1366 ? 80 : 100),
              const CellTitle(text: 'Proveedor', width: 140),
              const CellTitle(text: 'Producto', width: 140),
              const CellTitle(text: 'Nro Aves', width: 80),
              const CellTitle(text: 'Nro Jabas', width: 80),
              CellTitle(text: 'Precio', width: width <= 1366 ? 80 : 100),
              const CellTitle(text: 'Peso Total'),
              const CellTitle(text: 'Importe Total', width: 140),
            ],
            isFixedFooter: true,
            footerWidgets: [
              const CellTitle(text: '', width: 0),
              const CellTitle(text: '', width: 120),
              CellTitle(text: '', width: width <= 1366 ? 80 : 100),
              const CellTitle(text: '', width: 140),
              const CellTitle(
                text: '',
                width: 140,
              ),
              CellTitle(text: compra.cantAves.toString(), width: 80),
              CellTitle(text: compra.cantJabas.toString(), width: 80),
              CellTitle(text: '-', width: width <= 1366 ? 80 : 100),
              CellTitle(text: '${compra.pesoTotal.toStringAsFixed(2)} kg'),
              CellTitle(
                  text: 'S/ ${compra.importeTotal.toStringAsFixed(2)}',
                  width: 140),
            ],
            itemCount: 1,
            leftHandSideColumnWidth: 0,
            leftSideItemBuilder: (c, i) => const SizedBox(),
            rightHandSideColumnWidth: globalWidth,
            rightSideItemBuilder: (c, i) {
              return Row(
                children: [
                  CellItem(text: compra.docId!, width: 120),
                  CellItem(
                      text: date.format(compra.createdAt),
                      width: width <= 1366 ? 80 : 100),
                  CellItem(text: compra.proveedorNombre, width: 140),
                  CellItem(text: compra.productoNombre, width: 140),
                  CellItem(
                    text: compra.cantAves.toStringAsFixed(0),
                    width: 80,
                  ),
                  CellItem(
                    text: compra.cantJabas.toStringAsFixed(0),
                    width: 80,
                  ),
                  CellItem(
                      text: 'S/ ${compra.precio.toStringAsFixed(2)}',
                      width: width <= 1366 ? 80 : 100),
                  CellItem(text: '${compra.pesoTotal.toStringAsFixed(2)} kg'),
                  CellItem(
                    text: 'S/ ${compra.importeTotal.toStringAsFixed(2)}',
                    width: 140,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
