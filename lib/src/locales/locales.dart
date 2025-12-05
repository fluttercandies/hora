/// Hora locale definitions.
///
/// This library exports all 143 built-in locale classes for Hora.
///
/// ## Recommended Usage (Tree-Shakable)
///
/// Import only the locales you need:
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/locales/ja.dart';
/// import 'package:hora/src/locales/ko.dart';
///
/// void main() {
///   final h = Hora.now(locale: const HoraLocaleJa());
///   print(h.format('YYYY年MM月DD日')); // 2024年12月05日
/// }
/// ```
///
/// ## Not Recommended (Imports All Locales)
///
/// Importing this file will include all 143 locales in your bundle:
///
/// ```dart
/// // ⚠️ This imports ALL locales - not tree-shakable
/// import 'package:hora/src/locales/locales.dart';
/// ```
///
/// ## Default Locales
///
/// The following locales are exported from `hora.dart` for convenience:
/// - `HoraLocaleEn` - English (default)
/// - `HoraLocaleZhCn` - Chinese Simplified
///
/// ## Available Locales
///
/// This library includes locales for:
/// - European languages: de, fr, es, it, pt, nl, pl, ru, uk, etc.
/// - Asian languages: zh, ja, ko, th, vi, id, ms, etc.
/// - Middle Eastern languages: ar, fa, he, tr, etc.
/// - And many more regional variants.
library;

export 'af.dart';
export 'am.dart';
export 'ar.dart';
export 'ar_dz.dart';
export 'ar_iq.dart';
export 'ar_kw.dart';
export 'ar_ly.dart';
export 'ar_ma.dart';
export 'ar_sa.dart';
export 'ar_tn.dart';
export 'az.dart';
export 'be.dart';
export 'bg.dart';
export 'bi.dart';
export 'bm.dart';
export 'bn.dart';
export 'bn_bd.dart';
export 'bo.dart';
export 'br.dart';
export 'bs.dart';
export 'ca.dart';
export 'cs.dart';
export 'cv.dart';
export 'cy.dart';
export 'da.dart';
export 'de.dart';
export 'de_at.dart';
export 'de_ch.dart';
export 'dv.dart';
export 'el.dart';
export 'en.dart';
export 'en_au.dart';
export 'en_ca.dart';
export 'en_gb.dart';
export 'en_ie.dart';
export 'en_il.dart';
export 'en_in.dart';
export 'en_nz.dart';
export 'en_sg.dart';
export 'en_tt.dart';
export 'eo.dart';
export 'es.dart';
export 'es_do.dart';
export 'es_mx.dart';
export 'es_pr.dart';
export 'es_us.dart';
export 'et.dart';
export 'eu.dart';
export 'fa.dart';
export 'fi.dart';
export 'fo.dart';
export 'fr.dart';
export 'fr_ca.dart';
export 'fr_ch.dart';
export 'fy.dart';
export 'ga.dart';
export 'gd.dart';
export 'gl.dart';
export 'gom_latn.dart';
export 'gu.dart';
export 'he.dart';
export 'hi.dart';
export 'hr.dart';
export 'ht.dart';
export 'hu.dart';
export 'hy_am.dart';
export 'id.dart';
export 'is.dart';
export 'it.dart';
export 'it_ch.dart';
export 'ja.dart';
export 'jv.dart';
export 'ka.dart';
export 'kk.dart';
export 'km.dart';
export 'kn.dart';
export 'ko.dart';
export 'ku.dart';
export 'ky.dart';
export 'lb.dart';
export 'lo.dart';
export 'lt.dart';
export 'lv.dart';
export 'me.dart';
export 'mi.dart';
export 'mk.dart';
export 'ml.dart';
export 'mn.dart';
export 'mr.dart';
export 'ms.dart';
export 'ms_my.dart';
export 'mt.dart';
export 'my.dart';
export 'nb.dart';
export 'ne.dart';
export 'nl.dart';
export 'nl_be.dart';
export 'nn.dart';
export 'oc_lnc.dart';
export 'pa_in.dart';
export 'pl.dart';
export 'pt.dart';
export 'pt_br.dart';
export 'rn.dart';
export 'ro.dart';
export 'ru.dart';
export 'rw.dart';
export 'sd.dart';
export 'se.dart';
export 'si.dart';
export 'sk.dart';
export 'sl.dart';
export 'sq.dart';
export 'sr.dart';
export 'sr_cyrl.dart';
export 'ss.dart';
export 'sv.dart';
export 'sv_fi.dart';
export 'sw.dart';
export 'ta.dart';
export 'te.dart';
export 'tet.dart';
export 'tg.dart';
export 'th.dart';
export 'tk.dart';
export 'tl_ph.dart';
export 'tlh.dart';
export 'tr.dart';
export 'tzl.dart';
export 'tzm.dart';
export 'tzm_latn.dart';
export 'ug_cn.dart';
export 'uk.dart';
export 'ur.dart';
export 'uz.dart';
export 'uz_latn.dart';
export 'vi.dart';
export 'x_pseudo.dart';
export 'yo.dart';
export 'zh.dart';
export 'zh_cn.dart';
export 'zh_hk.dart';
export 'zh_tw.dart';
