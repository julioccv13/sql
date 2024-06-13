SELECT
  bs.BUKRS AS sociedad
  , bs.LIFNR AS cuenta
  , bs.XREF3 AS clave_referencia_3
  , bs.H_BUDAT AS fecha_contabilizacion
  , bs.H_BLDAT AS fecha_documento
  , bs.AUGDT AS compensacion
  , bk.XBLNR AS referencia
  , bs.BELNR AS numero_documento
  , bs.H_BLART AS clase_documento
  , CASE
      WHEN bs.SHKZG = 'H' THEN SAFE_MULTIPLY(bs.DMBTR, -1)
      ELSE bs.DMBTR
    END AS importe_moneda_local
  , bs.H_HWAER AS moneda_local
  , bs.H_WAERS AS moneda_documento
  , bs.WRBTR AS importe_moneda_documento
  , bs.AUGBL AS documento_compensacion
  , bs.SGTXT AS texto
FROM
  `datalake-vanti.qa_raw_sap.bseg` bs
LEFT OUTER JOIN
  `datalake-vanti.qa_raw_sap.bkpf` bk
  ON bs.BUKRS = bk.BUKRS
  AND bs.GJAHR = bk.GJAHR
  AND bs.BELNR = bk.BELNR
WHERE bs.KOART = 'K'
AND bs.H_BSTAT NOT IN ('D', 'M')
AND bs.H_BUDAT BETWEEN '2022-01-01' AND '2024-01-01'
AND bs.BUKRS IN ('0015')

UNION ALL

SELECT
  bs.BUKRS AS sociedad
  , bs.KUNNR AS cuenta
  , bs.XREF3 AS clave_referencia_3
  , bs.H_BUDAT AS fecha_contabilizacion
  , bs.H_BLDAT AS fecha_documento
  , bs.AUGDT AS compensacion
  , bk.XBLNR AS referencia
  , bs.BELNR AS numero_documento
  , bs.H_BLART AS clase_documento
  , CASE
      WHEN bs.SHKZG = 'H' THEN SAFE_MULTIPLY(bs.DMBTR, -1)
      ELSE bs.DMBTR
    END AS importe_moneda_local
  , bs.H_HWAER AS moneda_local
  , bs.H_WAERS AS moneda_documento
  , bs.WRBTR AS importe_moneda_documento
  , bs.AUGBL AS documento_compensacion
  , bs.SGTXT AS texto
FROM
  `datalake-vanti.qa_raw_sap.bseg` bs
LEFT OUTER JOIN
  `datalake-vanti.qa_raw_sap.bkpf` bk
  ON bs.BUKRS = bk.BUKRS
  AND bs.GJAHR = bk.GJAHR
  AND bs.BELNR = bk.BELNR
JOIN
  `datalake-vanti.qa_raw_sap.lfa1` lf
  ON bs.KUNNR = lf.KUNNR
WHERE lf.KUNNR IS NOT NULL
AND bs.KOART = 'D'
AND bs.H_BSTAT NOT IN ('D', 'M')
AND bs.H_BUDAT  BETWEEN '2022-01-01' AND '2024-01-01'
AND bs.BUKRS IN ('0015')


