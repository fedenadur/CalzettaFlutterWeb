import './ComprobanteInfo.dart';

class CuentaCorrienteAgrupamiento {
  final List<ComprobanteInfo> comprobantesRelacionados;
  final double saldoPendiente;
  final String codComprob;

  CuentaCorrienteAgrupamiento(
      {this.comprobantesRelacionados, this.saldoPendiente, this.codComprob});
}
