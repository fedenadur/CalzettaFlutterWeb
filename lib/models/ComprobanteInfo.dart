class ComprobanteInfo {
  final String codCli;
  final String comprobante;
  final int comprobanteID;
  final String tipoComprob;
  final String fechaemi;
  final String fechaVen;
  final double lImporte;
  final String fechaRel;
  final String comprobRel;
  final int codAsocID;
  final int sucAsoc;
  final int nroAsoc;
  final double pendiente;

  ComprobanteInfo({
    this.codCli,
    this.comprobante,
    this.comprobanteID,
    this.tipoComprob,
    this.fechaemi,
    this.fechaVen,
    this.lImporte,
    this.fechaRel,
    this.comprobRel,
    this.codAsocID,
    this.sucAsoc,
    this.nroAsoc,
    this.pendiente
  });
}
