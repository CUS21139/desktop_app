import 'dart:io';
import 'package:app_desktop/src/models/venta_beneficiado.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_app_file/open_app_file.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '/src/abstracts_entities/orden.dart';
import '/src/models/banco.dart';
import '/src/models/cliente.dart';
import '/src/models/entity.dart';
import '/src/models/estado_cliente_mov.dart';
import '/src/models/proveedor.dart';
import '../models/venta_vivo.dart';
import '/src/presentation/utils/round_number.dart';

class ExcelService {
  Future<void> exportarEstadoCuenta({
    required Cliente cliente,
    required List<EstadoClienteMov> lista,
  }) async {
    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();
      final ayer = DateTime(fecha.year, fecha.month, fecha.day)
          .subtract(const Duration(days: 1));
      final anteayer = DateTime(fecha.year, fecha.month, fecha.day)
          .subtract(const Duration(days: 2));

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile = "reporte-estado-cuenta${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        ByteData data = await rootBundle.load('assets/estado_cta.xlsx');
        var bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        var excel = Excel.decodeBytes(bytes);

        Sheet sheetObject = excel['Hoja1'];

        CellStyle cellStyleContent = CellStyle(
          fontFamily: getFontFamily(FontFamily.Arial),
          fontSize: 14,
          topBorder: Border(borderStyle: BorderStyle.Thin),
          bottomBorder: Border(borderStyle: BorderStyle.Thin),
          rightBorder: Border(borderStyle: BorderStyle.Thin),
          leftBorder: Border(borderStyle: BorderStyle.Thin),
          bold: true,
        );

        final f = DateFormat('dd-MM-yyyy');

        int index = 2;

        //Insertar nombre de la entidad
        var cellNameValue =
            sheetObject.cell(CellIndex.indexByString('B$index'));
        cellNameValue.value = cliente.nombre;
        index++;

        //Insertar fechas de inicio y fin de movimientos
        var cellFechaIniValue =
            sheetObject.cell(CellIndex.indexByString('B$index'));
        cellFechaIniValue.value = f.format(lista.first.docDate);

        //Insertar tabla de movimientos
        index++;
        index++;

        bool findAyer = false;
        bool findAnteayer = false;

        for (var i = 0; i < lista.length; i++) {
          final p = lista[i];

          if (i != lista.length - 1 && i > 0) {
            // NO ES EL ULTIMO EN LA LISTA
            final nextDoc = lista[i + 1];
            final beforDoc = lista[i - 1];

            if (f.format(ayer) == f.format(p.docDate) && !findAyer) {
              // fecha de documento es igual a ayer
              if (p.movType == 'I' && nextDoc.movType == 'V') {
                var cellK =
                    sheetObject.cell(CellIndex.indexByString('K$index'));
                cellK.value = 'SALDO DE AYER';
                cellK.cellStyle = cellStyleContent;
                findAyer = true;
              } else if (p.movType == 'V' && beforDoc.docDate.isBefore(ayer)) {
                var cellK =
                    sheetObject.cell(CellIndex.indexByString('K${index - 1}'));
                cellK.value = 'SALDO DE AYER';
                cellK.cellStyle = cellStyleContent;
                findAyer = true;
              }
            }
            if (f.format(anteayer) == f.format(p.docDate) && !findAnteayer) {
              // fecha de documento es igual a anteayer
              if (p.movType == 'I' && nextDoc.movType == 'V') {
                var cellK =
                    sheetObject.cell(CellIndex.indexByString('K$index'));
                cellK.value = 'SALDO DE ANTEAYER';
                cellK.cellStyle = cellStyleContent;
                findAnteayer = true;
              } else if (p.movType == 'V' &&
                  beforDoc.docDate.isBefore(anteayer)) {
                var cellK =
                    sheetObject.cell(CellIndex.indexByString('K${index - 1}'));
                cellK.value = 'SALDO DE ANTEAYER';
                cellK.cellStyle = cellStyleContent;
                findAnteayer = true;
              }
            }
          }

          var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
          cellA.value = p.docId;
          cellA.cellStyle = cellStyleContent;
          var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
          cellB.value = p.bancoNombre;
          cellB.cellStyle = cellStyleContent;
          var cellC = sheetObject.cell(CellIndex.indexByString('C$index'));
          cellC.value = f.format(p.docDate);
          cellC.cellStyle = cellStyleContent;
          var cellD = sheetObject.cell(CellIndex.indexByString('D$index'));
          cellD.value = p.producto;
          cellD.cellStyle = cellStyleContent;
          var cellE = sheetObject.cell(CellIndex.indexByString('E$index'));
          cellE.value = p.cantAves;
          cellE.cellStyle = cellStyleContent;
          var cellF = sheetObject.cell(CellIndex.indexByString('F$index'));
          cellF.value = roundNumber(p.peso.toDouble());
          cellF.cellStyle = cellStyleContent;
          var cellG = sheetObject.cell(CellIndex.indexByString('G$index'));
          cellG.value = roundNumber(p.precio.toDouble());
          cellG.cellStyle = cellStyleContent;
          var cellH = sheetObject.cell(CellIndex.indexByString('H$index'));
          cellH.value = roundNumber(p.importe.toDouble());
          cellH.cellStyle = cellStyleContent;
          var cellI = sheetObject.cell(CellIndex.indexByString('I$index'));
          cellI.value = roundNumber(p.pago.toDouble());
          cellI.cellStyle = cellStyleContent;
          var cellJ = sheetObject.cell(CellIndex.indexByString('J$index'));
          cellJ.value = roundNumber(p.saldo.toDouble());
          cellJ.cellStyle = cellStyleContent;

          if (i == lista.length - 1) {
            var cellK = sheetObject.cell(CellIndex.indexByString('K$index'));
            cellK.value = 'SALDO FINAL';
            cellK.cellStyle = cellStyleContent;
          }
          index++;
        }

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista se encuentra vacia');
    }
  }

  Future<void> exportarProgamacion({
    required List<Orden> lista,
  }) async {
    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile = "reporte-programacion${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        Excel excel = Excel.createExcel();

        List<String> titles = [
          'Fecha',
          'Zona',
          'Pesador',
          'Producto',
          'Camal',
          'Cliente',
          'Aves',
          'Jabas',
          'Precio',
          'Observación'
        ];

        Sheet sheetObject = excel['Sheet1'];

        CellStyle cellStyle = CellStyle(
          backgroundColorHex: "#21356E",
          fontColorHex: '#FFFFFF',
          fontFamily: getFontFamily(FontFamily.Calibri),
        );

        final f = DateFormat('dd-MM-yyyy');

        int index = 0;

        //Insertar tabla de Ordenes de Entrega
        for (int i = 0; i < titles.length; i++) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: i, rowIndex: index));
          cell.value = titles[i];
          cell.cellStyle = cellStyle;
        }
        index++;
        index++;

        int totalAves = 0;
        int totalJabas = 0;

        for (var orden in lista) {
          var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
          cellA.value = f.format(orden.createdAt);
          var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
          cellB.value = orden.zonaCode;
          var cellC = sheetObject.cell(CellIndex.indexByString('C$index'));
          cellC.value = orden.pesadorNombre;
          var cellD = sheetObject.cell(CellIndex.indexByString('D$index'));
          cellD.value = orden.productoNombre;
          var cellE = sheetObject.cell(CellIndex.indexByString('E$index'));
          cellE.value = orden.camalNombre;
          var cellF = sheetObject.cell(CellIndex.indexByString('F$index'));
          cellF.value = orden.clienteNombre;
          var cellG = sheetObject.cell(CellIndex.indexByString('G$index'));
          cellG.value = orden.cantAves;
          var cellH = sheetObject.cell(CellIndex.indexByString('H$index'));
          cellH.value = orden.cantJabas;
          var cellI = sheetObject.cell(CellIndex.indexByString('I$index'));
          cellI.value = roundNumber(orden.precio.toDouble());
          var cellJ = sheetObject.cell(CellIndex.indexByString('J$index'));
          cellJ.value = orden.observacion;
          index++;

          totalAves += orden.cantAves;
          totalJabas += orden.cantJabas;
        }

        // Insertar Saldo Total
        var cellAves = sheetObject.cell(CellIndex.indexByString('G$index'));
        cellAves.value = totalAves;
        cellAves.cellStyle = cellStyle;
        var cellJabas = sheetObject.cell(CellIndex.indexByString('H$index'));
        cellJabas.value = totalJabas;
        cellJabas.cellStyle = cellStyle;

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista esta vacia');
    }
  }

  Future<void> exportarReporteDelDia({
    required List<VentaVivo> lista,
  }) async {
    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();
      lista.sort((a, b) => a.clienteNombre.compareTo(b.clienteNombre));

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile = "reporte-ventas-${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        ByteData data = await rootBundle.load('assets/reporte_del_dia.xlsx');
        var bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        var excel = Excel.decodeBytes(bytes);

        Sheet sheetObject = excel['Hoja1'];

        CellStyle cellContentStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Arial),
          fontSize: 14,
          bold: true,
        );

        final f = DateFormat('dd-MM-yyyy');

        var dateCell = sheetObject.cell(CellIndex.indexByString('B2'));
        dateCell.value = f.format(lista.first.ordenDate);
        dateCell.cellStyle = cellContentStyle;

        int index = 4;

        for (var venta in lista) {
          sheetObject.updateCell(
              CellIndex.indexByString('A$index'), venta.clienteNombre);
          sheetObject.updateCell(
              CellIndex.indexByString('B$index'), venta.productoNombre);
          sheetObject.updateCell(
              CellIndex.indexByString('C$index'), venta.totalAves);
          sheetObject.updateCell(CellIndex.indexByString('D$index'),
              roundNumber(venta.totalNeto.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('E$index'),
              roundNumber(venta.totalPromedio.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('F$index'),
              roundNumber(venta.precio.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('G$index'),
              roundNumber(venta.totalImporte.toDouble()));
          sheetObject.updateCell(
              CellIndex.indexByString('H$index'), venta.observacion);
          index++;
        }

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista esta vacia');
    }
  }
  
  Future<void> exportarReporteDelDiaBeneficiado({
    required List<VentaBeneficiado> lista,
  }) async {
    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();
      lista.sort((a, b) => a.clienteNombre.compareTo(b.clienteNombre));

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile = "reporte-ventas-ben-${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        ByteData data = await rootBundle.load('assets/reporte_del_dia_b.xlsx');
        var bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        var excel = Excel.decodeBytes(bytes);

        Sheet sheetObject = excel['Hoja1'];

        CellStyle cellContentStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Arial),
          fontSize: 14,
          bold: true,
        );

        final f = DateFormat('dd-MM-yyyy');

        var dateCell = sheetObject.cell(CellIndex.indexByString('B2'));
        dateCell.value = f.format(lista.first.ordenDate);
        dateCell.cellStyle = cellContentStyle;

        int index = 4;

        for (var venta in lista) {
          sheetObject.updateCell(
              CellIndex.indexByString('A$index'), venta.clienteNombre);
          sheetObject.updateCell(
              CellIndex.indexByString('B$index'), venta.productoNombre);
          sheetObject.updateCell(
              CellIndex.indexByString('C$index'), venta.totalAves);
          sheetObject.updateCell(CellIndex.indexByString('D$index'),
              roundNumber(venta.totalNeto.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('E$index'),
              roundNumber(venta.totalPromedio.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('F$index'),
              roundNumber(venta.precioPelado.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('G$index'),
              roundNumber(venta.precio.toDouble()));
          sheetObject.updateCell(CellIndex.indexByString('H$index'),
              roundNumber(venta.totalImporte.toDouble()));
          sheetObject.updateCell(
              CellIndex.indexByString('I$index'), venta.observacion);
          index++;
        }

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista esta vacia');
    }
  }

  Future<void> exportarResumen(Map<String, Map<String, dynamic>> mapa) async {
    final date = DateFormat('ddMMyyyy-hhmmss');
    DateTime fecha = DateTime.now();

    try {
      String directorio = (await getTemporaryDirectory()).absolute.path;
      String nameFile = "reporte-resumen-${date.format(fecha)}.xlsx";
      String pathDescarga = p.join(directorio, nameFile);

      Excel excel = Excel.createExcel();

      Sheet sheetObject = excel['Sheet1'];

      CellStyle greyCellStyle = CellStyle(
        backgroundColorHex: "#454545",
        fontColorHex: '#FFFFFF',
        bold: true,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );
      CellStyle blueCellStyle = CellStyle(
        backgroundColorHex: "#0000FF",
        fontColorHex: '#FFFFFF',
        bold: true,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );
      CellStyle greenCellStyle = CellStyle(
        backgroundColorHex: "#008000",
        fontColorHex: '#FFFFFF',
        bold: true,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );
      CellStyle redCellStyle = CellStyle(
        backgroundColorHex: "#FF0000",
        fontColorHex: '#FFFFFF',
        bold: true,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      int index = 1;

      // Insertar titulos
      var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
      cellA.value = '';
      cellA.cellStyle = greyCellStyle;
      var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
      cellB.value = '';
      cellB.cellStyle = blueCellStyle;
      var cellC = sheetObject.cell(CellIndex.indexByString('C$index'));
      cellC.value = 'Compra';
      cellC.cellStyle = blueCellStyle;
      var cellD = sheetObject.cell(CellIndex.indexByString('D$index'));
      cellD.value = '';
      cellD.cellStyle = blueCellStyle;
      var cellE = sheetObject.cell(CellIndex.indexByString('E$index'));
      cellE.value = '';
      cellE.cellStyle = greenCellStyle;
      var cellF = sheetObject.cell(CellIndex.indexByString('F$index'));
      cellF.value = 'Venta';
      cellF.cellStyle = greenCellStyle;
      var cellG = sheetObject.cell(CellIndex.indexByString('G$index'));
      cellG.value = '';
      cellG.cellStyle = greenCellStyle;
      var cellH = sheetObject.cell(CellIndex.indexByString('H$index'));
      cellH.value = '';
      cellH.cellStyle = redCellStyle;
      var cellI = sheetObject.cell(CellIndex.indexByString('I$index'));
      cellI.value = 'Diferencia';
      cellI.cellStyle = redCellStyle;
      var cellJ = sheetObject.cell(CellIndex.indexByString('J$index'));
      cellJ.value = '';
      cellJ.cellStyle = redCellStyle;

      index++;

      var cellA1 = sheetObject.cell(CellIndex.indexByString('A$index'));
      cellA1.value = 'Productos';
      cellA1.cellStyle = greyCellStyle;
      var cellB1 = sheetObject.cell(CellIndex.indexByString('B$index'));
      cellB1.value = 'Cant';
      cellB1.cellStyle = blueCellStyle;
      var cellC1 = sheetObject.cell(CellIndex.indexByString('C$index'));
      cellC1.value = 'Peso';
      cellC1.cellStyle = blueCellStyle;
      var cellD1 = sheetObject.cell(CellIndex.indexByString('D$index'));
      cellD1.value = 'Importe';
      cellD1.cellStyle = blueCellStyle;
      var cellE1 = sheetObject.cell(CellIndex.indexByString('E$index'));
      cellE1.value = 'Cant';
      cellE1.cellStyle = greenCellStyle;
      var cellF1 = sheetObject.cell(CellIndex.indexByString('F$index'));
      cellF1.value = 'Peso';
      cellF1.cellStyle = greenCellStyle;
      var cellG1 = sheetObject.cell(CellIndex.indexByString('G$index'));
      cellG1.value = 'Importe';
      cellG1.cellStyle = greenCellStyle;
      var cellH1 = sheetObject.cell(CellIndex.indexByString('H$index'));
      cellH1.value = 'Cant';
      cellH1.cellStyle = redCellStyle;
      var cellI1 = sheetObject.cell(CellIndex.indexByString('I$index'));
      cellI1.value = 'Peso';
      cellI1.cellStyle = redCellStyle;
      var cellJ1 = sheetObject.cell(CellIndex.indexByString('J$index'));
      cellJ1.value = 'Importe';
      cellJ1.cellStyle = redCellStyle;

      index++;

      //Insertar tabla de movimientos
      double cCant = 0;
      double cPeso = 0;
      double cImpor = 0;

      double vCant = 0;
      double vPeso = 0;
      double vImpor = 0;

      mapa.forEach((key, value) {
        final producto = key;
        final ventaCant = value['venta']['cantidad'];
        final ventaPeso = value['venta']['peso'];
        final ventaImporte = value['venta']['importe'];
        final compraCant = value['compra']['cantidad'];
        final compraPeso = value['compra']['peso'];
        final compraImporte = value['compra']['importe'];
        final diferenciaCant = (ventaCant ?? 0) - (compraCant ?? 0);
        final diferenciaPeso = (ventaPeso ?? 0) - (compraPeso ?? 0);
        final diferenciaImporte = (ventaImporte ?? 0) - (compraImporte ?? 0);
        var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
        cellA.value = producto;
        var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
        cellB.value = compraCant;
        var cellC = sheetObject.cell(CellIndex.indexByString('C$index'));
        cellC.value = roundNumber(compraPeso.toDouble());
        var cellD = sheetObject.cell(CellIndex.indexByString('D$index'));
        cellD.value = roundNumber(compraImporte.toDouble());
        var cellE = sheetObject.cell(CellIndex.indexByString('E$index'));
        cellE.value = ventaCant;
        var cellF = sheetObject.cell(CellIndex.indexByString('F$index'));
        cellF.value = roundNumber(ventaPeso.toDouble());
        var cellG = sheetObject.cell(CellIndex.indexByString('G$index'));
        cellG.value = roundNumber(ventaImporte.toDouble());
        var cellH = sheetObject.cell(CellIndex.indexByString('H$index'));
        cellH.value = diferenciaCant;
        var cellI = sheetObject.cell(CellIndex.indexByString('I$index'));
        cellI.value = roundNumber(diferenciaPeso.toDouble());
        var cellJ = sheetObject.cell(CellIndex.indexByString('J$index'));
        cellJ.value = roundNumber(diferenciaImporte.toDouble());

        index++;

        cCant += compraCant;
        cPeso += compraPeso;
        cImpor += compraImporte;

        vCant += ventaCant;
        vPeso += ventaPeso;
        vImpor += ventaImporte;
      });

      // Insertar Totales
      var cellcCant = sheetObject.cell(CellIndex.indexByString('B$index'));
      cellcCant.value = cCant;
      cellcCant.cellStyle = blueCellStyle;
      var cellcPeso = sheetObject.cell(CellIndex.indexByString('C$index'));
      cellcPeso.value = roundNumber(cPeso.toDouble());
      cellcPeso.cellStyle = blueCellStyle;
      var cellcImpor = sheetObject.cell(CellIndex.indexByString('D$index'));
      cellcImpor.value = roundNumber(cImpor.toDouble());
      cellcImpor.cellStyle = blueCellStyle;
      var cellvCant = sheetObject.cell(CellIndex.indexByString('E$index'));
      cellvCant.value = vCant;
      cellvCant.cellStyle = greenCellStyle;
      var cellvPeso = sheetObject.cell(CellIndex.indexByString('F$index'));
      cellvPeso.value = roundNumber(vPeso.toDouble());
      cellvPeso.cellStyle = greenCellStyle;
      var cellvImpor = sheetObject.cell(CellIndex.indexByString('G$index'));
      cellvImpor.value = roundNumber(vImpor.toDouble());
      cellvImpor.cellStyle = greenCellStyle;
      var celldCant = sheetObject.cell(CellIndex.indexByString('H$index'));
      celldCant.value = vCant - cCant;
      celldCant.cellStyle = redCellStyle;
      var celldPeso = sheetObject.cell(CellIndex.indexByString('I$index'));
      celldPeso.value = roundNumber((vPeso - cPeso).toDouble());
      celldPeso.cellStyle = redCellStyle;
      var celldImpor = sheetObject.cell(CellIndex.indexByString('J$index'));
      celldImpor.value = roundNumber((vImpor - cImpor).toDouble());
      celldImpor.cellStyle = redCellStyle;

      List<int> bytesExcel = excel.encode()!;

      File newFile = File(p.join(pathDescarga))
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytesExcel);

      await OpenAppFile.open(newFile.path);
    } catch (e) {
      throw Exception('Open Document Exception: $e');
    }
  }

  Future<void> exportarSaldo({required List<Entity> lista}) async {
    String title = '';
    if (lista.any((e) => e.runtimeType == Cliente)) {
      title = 'Clientes';
    }
    if (lista.any((e) => e.runtimeType == Banco)) {
      title = 'Bancos';
    }
    if (lista.any((e) => e.runtimeType == Proveedor)) {
      title = 'Proveedores';
    }

    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile =
            "saldos-${title.toLowerCase()}-${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        Excel excel = Excel.createExcel();

        List<String> titles = [
          title,
          'Monto',
        ];

        Sheet sheetObject = excel['Sheet1'];

        CellStyle cellStyle = CellStyle(
          backgroundColorHex: "#21356E",
          fontColorHex: '#FFFFFF',
          fontFamily: getFontFamily(FontFamily.Calibri),
        );

        int index = 0;

        //Insertar tabla de Saldos
        for (int i = 0; i < titles.length; i++) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: i, rowIndex: index));
          cell.value = titles[i];
          cell.cellStyle = cellStyle;
        }
        index++;
        index++;

        double totalSaldo = 0.0;

        for (var entity in lista) {
          var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
          cellA.value = entity.nombre;
          var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
          cellB.value = roundNumber(entity.saldo!);

          totalSaldo += entity.saldo!;
          index++;
        }

        // Insertar Saldo Total
        var cellAves = sheetObject.cell(CellIndex.indexByString('A$index'));
        cellAves.cellStyle = cellStyle;
        var cellJabas = sheetObject.cell(CellIndex.indexByString('B$index'));
        cellJabas.value = roundNumber(totalSaldo);
        cellJabas.cellStyle = cellStyle;

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista esta vacia');
    }
  }

  Future<void> exportarSaldoClientes({required List<Cliente> lista}) async {
    if (lista.isNotEmpty) {
      final date = DateFormat('ddMMyyyy-hhmmss');
      DateTime fecha = DateTime.now();

      try {
        String directorio = (await getTemporaryDirectory()).absolute.path;
        String nameFile = "reporte-saldos-clientes-${date.format(fecha)}.xlsx";
        String pathDescarga = p.join(directorio, nameFile);

        ByteData data = await rootBundle.load('assets/saldo_clientes.xlsx');
        var bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        var excel = Excel.decodeBytes(bytes);

        Sheet sheetObject = excel['Hoja1'];

        sheetObject.setColWidth(0, 55);
        sheetObject.setColWidth(1, 25);

        CellStyle cellStyleContent = CellStyle(
          fontFamily: getFontFamily(FontFamily.Arial),
          fontSize: 14,
          topBorder: Border(borderStyle: BorderStyle.Thin),
          bottomBorder: Border(borderStyle: BorderStyle.Thin),
          rightBorder: Border(borderStyle: BorderStyle.Thin),
          leftBorder: Border(borderStyle: BorderStyle.Thin),
          bold: true,
        );

        int index = 3;

        for (var i = 0; i < lista.length; i++) {
          final cliente = lista[i];
          var cellA = sheetObject.cell(CellIndex.indexByString('A$index'));
          cellA.value = cliente.nombre;
          cellA.cellStyle = cellStyleContent;
          var cellB = sheetObject.cell(CellIndex.indexByString('B$index'));
          cellB.value = roundNumber(cliente.saldo!);
          cellB.cellStyle = cellStyleContent;
          index++;
        }

        List<int> bytesExcel = excel.encode()!;

        File newFile = File(p.join(pathDescarga))
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesExcel);

        await OpenAppFile.open(newFile.path);
      } catch (e) {
        throw Exception('Open Document Exception: $e');
      }
    } else {
      throw Exception('La lista se encuentra vacia');
    }
  }
}
