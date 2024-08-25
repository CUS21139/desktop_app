import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../models/venta_vivo.dart';
import '/src/presentation/components/table_cell.dart';
import '/src/utils/date_formats.dart';

class TableDetalleEstadoVenta extends StatelessWidget {
  const TableDetalleEstadoVenta({super.key, required this.venta});
  final VentaVivo venta;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 920,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: HorizontalDataTable(
            itemCount: venta.pesajes.length,
            headerWidgets: const [
              SizedBox(),
              CellTitle(text: 'Nro ', width: 80),
              CellTitle(text: 'Hora', width: 80),
              CellTitle(text: 'Producto', width: 140),
              CellTitle(text: 'Jabas', width: 60),
              CellTitle(text: 'Peso Tara', width: 80),
              CellTitle(text: 'Peso Bruto'),
              CellTitle(text: 'Nro Aves'),
              CellTitle(text: 'Promedio', width: 80),
              CellTitle(text: 'Peso Neto', width: 80),
              CellTitle(text: 'Importe Total', width: 120),
              CellTitle(text: 'Comentarios', width: 150),
            ],
            isFixedHeader: true,
            footerWidgets: [
              const SizedBox(),
              const CellTitle(text: '', width: 80),
              const CellTitle(text: '', width: 80),
              const CellTitle(text: '', width: 140),
              CellTitle(text: (venta.totalJabas).toString(), width: 60),
              CellTitle(text: (venta.totalTara).toStringAsFixed(2), width: 80),
              CellTitle(text: (venta.totalBruto).toStringAsFixed(2)),
              CellTitle(text: (venta.totalAves).toString()),
              CellTitle(
                  text: (venta.totalPromedio).toStringAsFixed(2), width: 80),
              CellTitle(text: (venta.totalNeto).toStringAsFixed(2), width: 80),
              CellTitle(
                  text: (venta.totalImporte).toStringAsFixed(2), width: 120),
              const CellTitle(text: '', width: 150),
            ],
            isFixedFooter: true,
            leftHandSideColumnWidth: 0,
            leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            leftSideItemBuilder: (c, i) => const SizedBox(),
            rightHandSideColumnWidth: 1070,
            rightHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            rightSideItemBuilder: (c, i) {
              final pesaje = venta.pesajes[i];
              return Row(
                children: [
                  CellItem(text: venta.id!.toString(), width: 80),
                  CellItem(text: time.format(pesaje.createdAt), width: 80),
                  CellItem(text: venta.productoNombre, width: 140),
                  CellItem(text: pesaje.nroJabas.toString(), width: 60),
                  CellItem(
                      text: '${pesaje.tara.toStringAsFixed(2)} kg', width: 80),
                  CellItem(text: '${pesaje.bruto.toStringAsFixed(2)} kg'),
                  CellItem(text: pesaje.nroAves.toString()),
                  CellItem(
                      text: '${pesaje.promedio.toStringAsFixed(2)} kg',
                      width: 80),
                  CellItem(
                      text: '${pesaje.neto.toStringAsFixed(2)} kg', width: 80),
                  CellItem(
                      text: 'S/ ${pesaje.importe.toStringAsFixed(2)}',
                      width: 120),
                  CellItem(text: pesaje.observacion ?? '', width: 150),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
