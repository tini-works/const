# Chapter 8: Diagnosekategorien

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 8 Diagnosekategorien und Feldkennungen

## 8.1 Uebersicht Diagnosekategorien

| Kategorie | FK | Beschreibung | Quartalsuebergreifend |
|---|---|---|---|
| Akutdiagnose | 6001 | Behandlungsdiagnose des aktuellen Falls | Nein |
| Dauerdiagnose | 3673 | Chronische/langfristige Diagnose | Ja |
| Anamnestische Diagnose | 3673 | Fruehere relevante Diagnose | Ja |

## 8.2 Akutdiagnosen (FK 6001)

- Jede Akutdiagnose besteht aus:
  - **ICD-10-GM-Kode** (Pflicht)
  - **Diagnosensicherheit** (Pflicht): V, G, A, Z
  - **Seitenlokalisation** (bedingt): R, L, B — wenn Kode seitenlokalisierbar
  - **Erlaeuterungstext** (optional): Freitext zur Praezisierung
  - **Ausnahmetatbestand** (optional): Kennzeichnung fuer Abrechnungsausnahmen

- Akutdiagnosen werden pro Behandlungsfall erfasst und in der Quartalsabrechnung uebertragen
- Kein automatisches Hinzufuegen ohne Anwenderaktion (P10-320)

## 8.3 Dauerdiagnosen (FK 3673)

- Quartalsuebergreifend gespeicherte Diagnosen
- Typisch fuer chronische Erkrankungen (z.B. Diabetes mellitus, Hypertonie)
- Uebernahme in die Abrechnung nur nach expliziter Bestaetigung (KP10-240)
- Diagnosensicherheit muss bei Uebernahme geprueft werden (KP10-231)
- Bestimmte ICD-Kodes sind als "ungeeignet als Dauerdiagnose" gekennzeichnet (KP10-542)

## 8.4 Anamnestische Diagnosen (FK 3673)

- Fruehere Diagnosen mit Relevanz fuer die aktuelle Behandlung
- Beispiele: Z.n. Myokardinfarkt, Z.n. Appendektomie
- Gleiche Regeln wie Dauerdiagnosen bezueglich Uebernahme (KP10-250)
- Pool kann optional begrenzt werden (O10-260)

## 8.5 Diagnosensicherheit (DS)

| Kuerzel | Bedeutung | Typische Verwendung |
|---|---|---|
| V | Verdacht auf | Noch nicht bestaetigte Diagnose, Abklaerung laeuft |
| G | Gesichert | Diagnose ist durch Befunde bestaetigt |
| A | Ausgeschlossen | Diagnose wurde differentialdiagnostisch ausgeschlossen |
| Z | Symptomloser Zustand nach | Zustand nach abgeheilter Erkrankung |

- DS ist Pflicht bei jeder Behandlungsdiagnose (P10-110)
- Kein Defaultwert zulaessig — Anwender muss bewusst waehlen
- Bei Uebernahme von Dauerdiagnosen muss DS aktualisierbar sein (KP10-231)

## 8.6 Seitenlokalisation (SL)

| Kuerzel | Bedeutung |
|---|---|
| R | Rechts |
| L | Links |
| B | Beidseitig |

- SL ist nur relevant bei ICD-Kodes, die in der SDICD als seitenlokalisierbar gekennzeichnet sind
- Erfassung erfolgt ueber P10-111

## 8.7 Kreuz-Stern-Systematik

- **Kreuz-Kode (†)**: Primaerkode — beschreibt die Aetiologie
- **Stern-Kode (*)**: Sekundaerkode — beschreibt die Manifestation
- **Ausrufezeichen-Kode (!)**: Sekundaerkode — zusaetzliche Information

Regeln:
- Stern-Kodes duerfen nur zusammen mit einem Kreuz-Kode kodiert werden (P10-460)
- Ausrufezeichen-Kodes duerfen nur als Ergaenzung verwendet werden
- Das Kodierregelwerk (SDKRW) kann ADD-Korrekturen vorschlagen, um fehlende Paare zu ergaenzen (KP10-780)
