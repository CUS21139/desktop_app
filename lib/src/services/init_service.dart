import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';


import '/src/models/banco.dart';
import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/compra_vivo.dart';
import '/src/models/compra_beneficiado.dart';
import '/src/models/estado_gavipo_mov.dart';
import '/src/models/ordenes_vivo.dart';
import '/src/models/ordenes_beneficiado.dart';
import '/src/models/pesador.dart';
import '/src/models/producto_vivo.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/models/proveedor.dart';
import '/src/models/usuario.dart';
import '/src/models/venta_vivo.dart';
import '/src/models/venta_beneficiado.dart';
import '/src/models/vehiculo.dart';
import '/src/models/zona.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/compras_vivo_provider.dart';
import '/src/presentation/providers/compras_beneficiado_provider.dart';
import '/src/presentation/providers/estado_gavipo_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_modelo_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_modelo_vivo_provider.dart';
import '/src/presentation/providers/ordenes_vivo_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '/src/presentation/providers/productos_vivo_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/ventas_beneficiado_provider.dart';
import '/src/presentation/providers/ventas_vivo_provider.dart';
import '/src/presentation/providers/vehiculos_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import 'bancos_service.dart';
import 'caja_mov_service.dart';
import 'camales_service.dart';
import 'clientes_service.dart';
import 'compras_vivos_service.dart';
import 'compras_beneficiado_service.dart';
import 'estados_cta_service.dart';
import 'login_service.dart';
import 'ordenes_beneficiado_service.dart';
import 'ordenes_vivo_service.dart';
import 'ordenes_modelo_beneficiado_service.dart';
import 'ordenes_modelo_vivo_service.dart';
import 'pesadores_service.dart';
import 'productos_beneficiado_service.dart';
import 'productos_vivo_service.dart';
import 'proveedores_service.dart';
import 'ventas_beneficiado_service.dart';
import 'ventas_vivo_service.dart';
import 'vehiculos_service.dart';
import 'zonas_service.dart';

class InitService {
  static Future<void> cargarDatos(BuildContext context, String token) async {
    final bancoServ = BancosService();
    final cajaServ = CajaService();
    final camalServ = CamalesService();
    final clienteServ = ClientesService();
    final compraVivosServ = ComprasVivosService();
    final compraBenServ = ComprasBeneficiadoService();
    final estadoCtaServ = EstadoCtaService();
    final ordenVivoServ = OrdenesVivoService();
    final ordenBenServ = OrdenesBeneficiadoService();
    final ordenMVivoServ = OrdenesModeloVivosService();
    final ordenMBenServ = OrdenesModeloBeneficiadoService();
    final pesadorServ = PesadoresService();
    final productoVivoServ = ProductosVivoService();
    final productoBenServ = ProductosBeneficiadoService();
    final proveedorServ = ProveedoresService();
    final usuarioServ = LoginService();
    final ventasVivoServ = VentasVivoService();
    final ventasBenServ = VentasBeneficiadoService();
    final vehiculosServ = VehiculosService();
    final zonasServ = ZonasService();

    final bancoProv = Provider.of<BancosProv>(context, listen: false);
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final camalProv = Provider.of<CamalesProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final compraVivoProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final compraBenProv =
        Provider.of<ComprasBeneficiadoProv>(context, listen: false);
    final gavipoProv = Provider.of<EstadoGavipoProv>(context, listen: false);
    final ordenVivoProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final ordenBenProv =
        Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ordenMVivoProv =
        Provider.of<OrdenesModeloVivoProv>(context, listen: false);
    final ordenMBenProv =
        Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);
    final pesadorProv = Provider.of<PesadoresProv>(context, listen: false);
    final productoVivoProv =
        Provider.of<ProductosVivoProv>(context, listen: false);
    final productoBenProv =
        Provider.of<ProductosBeneficiadoProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
    final ventaVivoProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ventaBenProv =
        Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final vehiculosProv =
        Provider.of<VehiculosProvider>(context, listen: false);
    final zonaProv = Provider.of<ZonasProv>(context, listen: false);

    final usuario = Provider.of<UsuariosProv>(context, listen: false).usuario;

    final now = DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    await Future.wait([
      /*0*/bancoServ.getBancos(token),
      /*1*/cajaServ.crearCaja(token, now, usuario.nombre),
      /*2*/camalServ.getCamales(token),
      /*3*/clienteServ.getClientes(token),
      /*4*/compraVivosServ.getCompras(token, ini, fin),
      /*5*/compraBenServ.getCompras(token, ini, fin),
      /*6*/estadoCtaServ.getEstadoGavipo(token, ini.subtract(const Duration(days: 5))),
      /*7*/ordenVivoServ.getOrdenes(token, ini, fin),
      /*8*/ordenBenServ.getOrdenes(token, ini, fin),
      /*9*/ordenMVivoServ.getOrdenes(token),
      /*10*/ordenMBenServ.getOrdenes(token),
      /*11*/pesadorServ.getPesadores(token),
      /*12*/productoVivoServ.getProductos(token),
      /*13*/productoBenServ.getProductos(token),
      /*14*/proveedorServ.getProveedores(token),
      /*15*/usuarioServ.getUsers(token),
      /*16*/ventasVivoServ.getVentas(token, ini, fin),
      /*17*/ventasBenServ.getVentas(token, ini, fin),
      /*18*/vehiculosServ.getVehiculos(token),
      /*19*/zonasServ.getZonas(token),
    ]).then((value) {
      //Bancos
      bancoProv.bancos = value[0] as List<Banco>;

      //Camales
      camalProv.camales = value[2] as List<Camal>;

      //Clientes
      clienteProv.clientes = value[3] as List<Cliente>;

      //Compras Vivo
      compraVivoProv.compras = value[4] as List<CompraVivo>;
      compraVivoProv.comprasResumen = value[4] as List<CompraVivo>;
      //Compras Beneficiado
      compraBenProv.compras = value[5] as List<CompraBeneficiado>;
      compraBenProv.comprasResumen = value[5] as List<CompraBeneficiado>;

      //Moviminetos MABEL
      gavipoProv.movimientos = value[6] as List<EstadoGavipoMov>;

      //Ordenes Vivo
      ordenVivoProv.ordenes = value[7] as List<OrdenVivo>;
      ordenVivoProv.ordenesResumen = value[7] as List<OrdenVivo>;
      //Ordenes Beneficiado
      ordenBenProv.ordenes = value[8] as List<OrdenBeneficiado>;
      ordenBenProv.ordenesResumen = value[8] as List<OrdenBeneficiado>;

      //Ordenes Modelo Vivo
      ordenMVivoProv.ordenes = value[9] as List<OrdenVivo>;
      //Ordenes Modelo Beneficiado
      ordenMBenProv.ordenes = value[10] as List<OrdenBeneficiado>;

      //Pesador
      pesadorProv.pesadores = value[11] as List<Pesador>;

      //Producto Vivo
      productoVivoProv.productos = value[12] as List<ProductoVivo>;
      //Producto Beneficiado
      productoBenProv.productos = value[13] as List<ProductoBeneficiado>;

      //Proveedor
      proveedorProv.proveedores = value[14] as List<Proveedor>;

      //Usuario
      usuarioProv.usuarios = value[15] as List<Usuario>;

      //Ventas Vivo
      ventaVivoProv.setVentas(value[16] as List<VentaVivo>, false);
      ventaVivoProv.ventasResumen = value[16] as List<VentaVivo>;
      //Ventas Beneficiado
      ventaBenProv.setVentas(value[17] as List<VentaBeneficiado>, false);
      ventaBenProv.ventasResumen = value[17] as List<VentaBeneficiado>;

      //Vehiculos
      vehiculosProv.vehiculos = value[18] as List<Vehiculo>;

      //Zonas
      zonaProv.zonas = value[19] as List<Zona>;
    }).catchError((e) => throw Exception(e));

    await cajaServ.getCaja(token, now).then((cajaResponse) {
      cajaProv.caja = cajaResponse['caja'];
      cajaProv.cajaMov = cajaResponse['movs'];
    });
  }
}
