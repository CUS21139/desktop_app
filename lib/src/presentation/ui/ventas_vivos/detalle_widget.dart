import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/presentation/components/table_cell.dart';
import '../../providers/ventas_vivo_provider.dart';
import '/src/utils/date_formats.dart';

class TableDetalleVivo extends StatelessWidget {
  const TableDetalleVivo({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: height,
        width: 850,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Consumer<VentasVivoProv>(builder: (_, service, __) {
            final exist = service.existeVenta;
            return HorizontalDataTable(
              itemCount: exist ? service.venta.pesajes.length : 0,
              headerWidgets: const [
                SizedBox(),
                CellTitle(text: 'Hora', width: 80),
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
                CellTitle(text: (exist ? service.venta.totalJabas : 0).toString(), width: 60),
                CellTitle(text: (exist ? service.venta.totalTara : 0).toStringAsFixed(2), width: 80),
                CellTitle(text: (exist ? service.venta.totalBruto : 0).toStringAsFixed(2)),
                CellTitle(text: (exist ? service.venta.totalAves : 0).toString()),
                CellTitle(text: (exist ? service.venta.totalPromedio : 0).toStringAsFixed(2), width: 80),
                CellTitle(text: (exist ? service.venta.totalNeto : 0).toStringAsFixed(2), width: 80),
                CellTitle(text: (exist ? service.venta.totalImporte : 0).toStringAsFixed(2), width: 120),
                const CellTitle(text: '', width: 150),
              ],
              isFixedFooter: true,
              leftHandSideColumnWidth: 0,
              leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
              leftSideItemBuilder: (c, i) => const SizedBox(),
              rightHandSideColumnWidth: 850,
              rightHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
              rightSideItemBuilder: (c, i) {
                final pesaje = service.venta.pesajes[i];
                return Row(
                  children: [
                    CellItem(text: time.format(pesaje.createdAt), width: 80),
                    CellItem(text: pesaje.nroJabas.toString(), width: 60),
                    CellItem(
                        text: '${pesaje.tara.toStringAsFixed(2)} kg',
                        width: 80),
                    CellItem(text: '${pesaje.bruto.toStringAsFixed(2)} kg'),
                    CellItem(text: pesaje.nroAves.toString()),
                    CellItem(
                        text: '${pesaje.promedio.toStringAsFixed(2)} kg',
                        width: 80),
                    CellItem(
                        text: '${pesaje.neto.toStringAsFixed(2)} kg',
                        width: 80),
                    CellItem(
                        text: 'S/ ${pesaje.importe.toStringAsFixed(2)}',
                        width: 120),
                    CellItem(text: pesaje.observacion ?? '', width: 150),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}