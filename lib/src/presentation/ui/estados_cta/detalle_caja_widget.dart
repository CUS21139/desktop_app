import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/caja_mov.dart';
import '/src/presentation/components/table_cell.dart';

class TableDetalleEstadoCajaMov extends StatelessWidget {
  const TableDetalleEstadoCajaMov({super.key, required this.cajaMov});
  final List<CajaMov> cajaMov;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 140,
      width: 860,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ScrollConfiguration(
          behavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: HorizontalDataTable(
            isFixedHeader: true,
            rightHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
            headerWidgets: [
              const CellTitle(text: '', width: 0),
              const CellTitle(text: 'Hora'),
              const CellTitle(text: 'Doc ID', width: 120),
              const CellTitle(text: 'Banco', width: 120),
              const CellTitle(text: 'Entidad', width: 120),
              CellTitle(
                text: 'Descripcion',
                width: size.width <= 1366 ? 170 : 200,
              ),
              const CellTitle(text: 'Ingreso S/'),
              const CellTitle(text: 'Egreso S/'),
            ],
            isFixedFooter: true,
            footerWidgets: [
              const CellTitle(text: '', width: 0),
              const CellTitle(text: ''),
              const CellTitle(text: '', width: 120),
              const CellTitle(text: '', width: 120),
              const CellTitle(text: '', width: 120),
              CellTitle(
                text: '',
                width: size.width <= 1366 ? 170 : 200,
              ),
              const CellTitle(text: ''),
              const CellTitle(text: ''),
            ],
            itemCount: cajaMov.length,
            leftHandSideColumnWidth: 0,
            leftSideItemBuilder: (c, i) => const SizedBox(),
            rightHandSideColumnWidth: 860,
            rightSideItemBuilder: (c, i) {
              final movimiento = cajaMov[i];
              return Row(
                children: [
                  CellItem(text: movimiento.hora),
                  CellItem(text: movimiento.docId!, width: 120),
                  CellItem(text: movimiento.bancoNombre, width: 120),
                  CellItem(text: movimiento.entityNombre, width: 120),
                  CellItem(
                    text: movimiento.descripcion,
                    width: size.width <= 1366 ? 170 : 200,
                  ),
                  CellItem(
                      text: movimiento.ingreso == 0
                          ? '-'
                          : 'S/ ${movimiento.ingreso.toStringAsFixed(2)}'),
                  CellItem(
                      text: movimiento.egreso == 0
                          ? '-'
                          : 'S/ ${movimiento.egreso.toStringAsFixed(2)}'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
