# Chapter 7: Ablaufdiagramme

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 7 Ablaufdiagramme

## Overview

Die Ablaufdiagramme veranschaulichen die Zusammenhaenge zwischen den verschiedenen Anforderungen und den Ablauf der Diagnosenerfassung und -validierung im PVS.

## 7.1 Diagnosenerfassung (Forward-Coding)

```
Anwender gibt Diagnosetext ein
  │
  ├─> Suche in SDKH (Kodierhilfe) → KP11-50
  │     └─> Suchergebnisse anzeigen → KP11-60
  │           └─> Kodierhinweise anzeigen → KP11-90
  │
  ├─> Suche in SDICD (Stammdatei) → KP10-540
  │
  └─> Anwenderdefinierte Kuerzel → O10-300
        │
        v
  ICD-10-GM-Kode ausgewaehlt
        │
        ├─> Existenzpruefung → P10-430
        ├─> Nicht-abrechenbar pruefen → P10-440
        ├─> Kode ohne Inhalt pruefen → P10-450
        ├─> Sekundaerkode pruefen → P10-460
        ├─> Geschlechtsbezug pruefen → P10-470
        ├─> Altersgruppenbezug pruefen → P10-480
        ├─> Seltene Diagnose Hinweis → P10-490
        ├─> IfSG-Meldepflicht Hinweis → P10-500
        └─> Strichergaenzung pruefen → KP10-330
              │
              v
  Diagnosensicherheit erfassen → P10-110
        │
        v
  Weitere Informationen (SL/Erlaeuterung) → P10-111
        │
        v
  Diagnose dem Behandlungsfall zuordnen → P10-90
        │
        v
  Klartext anzeigen → P10-375
```

## 7.2 Dauerdiagnosen-Uebernahme

```
Quartalsstart
  │
  v
Dauerdiagnosen-Pool anzeigen
  │
  ├─> Optional: Vorauswahl begrenzen → O10-270
  │
  └─> Anwender waehlt Diagnosen aus
        │
        ├─> DS pruefen/bestaetigen → KP10-231
        ├─> Weitere Info erfassen → KP10-232
        │
        └─> Explizite Bestaetigung → KP10-240
              │
              v
        Uebernahme als Behandlungsdiagnose → KP10-230
              │
              v
        Uebertragung in FK 6001 → P10-90
```

## 7.3 Kodierregelwerk-Ausfuehrung

```
Diagnosen des Behandlungsfalls vorhanden
  │
  ├─> Behandlungsfallbezogen → KP10-700
  │     └─> Validierung → KP10-710
  │
  └─> Quartalsuebergreifend → KP10-720
        └─> Validierung → KP10-730
              │
              v
        Regelverstoss erkannt?
        │           │
        Nein        Ja
        │           │
        v           v
      Fertig    Uebersicht → KP10-740
                    │
                    v
              Hinweis + Vorschlag → KP10-750
                    │
                    ├─> DELETE → KP10-760
                    ├─> REPLACE → KP10-770
                    ├─> ADD → KP10-780
                    └─> Abbruch → KP10-790
```

## 7.4 Verschluesselungsanleitung-Zugriff

```
Anwender kodiert Diagnose
  │
  ├─> Kontextbezogener Aufruf → P11-740
  │     └─> VA zum aktuellen ICD-Kode anzeigen
  │
  └─> Browse-Modus → P11-750
        └─> Gesamte VA anzeigen
              │
              └─> Jaehrliche Aenderungen → P11-760
```
