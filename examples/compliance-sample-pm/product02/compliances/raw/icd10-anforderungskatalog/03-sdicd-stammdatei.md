# Chapter 3: ICD-10-GM-Stammdatei (SDICD)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 3 ICD-10-GM-Stammdatei

## 3.1 Grundlegende Anforderungen

### P10-400 — Einsatzpflicht SDICD

| Feld | Wert |
|---|---|
| ID | P10-400 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die von der KBV bereitgestellte ICD-10-GM-Stammdatei (SDICD) einsetzen. Eigene oder modifizierte ICD-Stammdateien sind nicht zulaessig. |

### P10-410 — Gueltigkeit der SDICD

| Feld | Wert |
|---|---|
| ID | P10-410 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Gueltigkeitszeitraeume der SDICD beachten. Zum Quartalsbeginn muss die jeweils gueltige Version eingesetzt werden. Veraltete Versionen duerfen nicht fuer die Kodierung verwendet werden. |

### P10-420 — Inhaltliche Unveraenderbarkeit

| Feld | Wert |
|---|---|
| ID | P10-420 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Die Inhalte der SDICD duerfen nicht veraendert werden. Herstellereigene Ergaenzungen (z.B. Suchbegriffe) muessen getrennt von den Originaldaten gefuehrt werden. |

## 3.2 Validierung und Pruefungen

### P10-430 — Existenzpruefung

| Feld | Wert |
|---|---|
| ID | P10-430 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Bei jeder Kodierung muss das PVS pruefen, ob der eingegebene ICD-10-GM-Kode in der aktuell gueltigen SDICD existiert. Nicht existierende Kodes muessen abgelehnt werden. |

### P10-440 — Nicht abrechenbare Kodes

| Feld | Wert |
|---|---|
| ID | P10-440 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Kodes, die in der SDICD als "nicht abrechenbar" gekennzeichnet sind (z.B. Kapitelueberschriften, Gruppenbezeichnungen), duerfen nicht als Behandlungsdiagnose verwendet werden. Das PVS muss diese Kodes bei der Eingabe ablehnen. |

### P10-450 — Kode ohne Inhalt

| Feld | Wert |
|---|---|
| ID | P10-450 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | ICD-Kodes, die als "ohne Inhalt" markiert sind (Platzhalter fuer zukuenftige Erweiterungen), duerfen nicht kodiert werden. |

### P10-460 — Sekundaerkodes (Kreuz-Stern-System)

| Feld | Wert |
|---|---|
| ID | P10-460 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Kodes mit Stern-Markierung (*) und Ausrufezeichen-Markierung (!) sind Sekundaerkodes und duerfen nur in Verbindung mit einem Primaerkode (Kreuz-Kode, †) verwendet werden. Das PVS muss die korrekte Kombination pruefen. Alleinstehende Sekundaerkodes muessen abgelehnt werden. |

### P10-470 — Geschlechtsbezug

| Feld | Wert |
|---|---|
| ID | P10-470 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss den Geschlechtsbezug des ICD-Kodes (aus SDICD) gegen das dokumentierte Geschlecht des Patienten pruefen. Bei Diskrepanz muss ein Warnhinweis angezeigt werden. |

### P10-480 — Altersgruppenbezug

| Feld | Wert |
|---|---|
| ID | P10-480 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss den Altersbezug des ICD-Kodes (aus SDICD) gegen das Alter des Patienten pruefen. Bei Diskrepanz muss ein Warnhinweis angezeigt werden (z.B. paediatrische Kodes bei Erwachsenen). |

### P10-490 — Seltene Diagnosen in Mitteleuropa

| Feld | Wert |
|---|---|
| ID | P10-490 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Bei ICD-Kodes, die in der SDICD als "selten in Mitteleuropa" gekennzeichnet sind, muss das PVS einen Hinweis anzeigen. Die Kodierung darf aber nicht blockiert werden. |

### P10-500 — IfSG-Meldepflicht

| Feld | Wert |
|---|---|
| ID | P10-500 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Bei ICD-Kodes mit IfSG-Meldepflicht (Infektionsschutzgesetz) muss das PVS den Anwender auf die Meldepflicht hinweisen (Attribut aus SDICD). |

### O10-510 — IfSG-Abrechnungsbesonderheit

| Feld | Wert |
|---|---|
| ID | O10-510 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS bei IfSG-meldepflichtigen Diagnosen auf Abrechnungsbesonderheiten (z.B. erweiterter Leistungsumfang) hinweisen. |

## 3.3 Suche und Navigation

### KP10-540 — Freitext-Suche in der SDICD

| Feld | Wert |
|---|---|
| ID | KP10-540 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn das PVS eine Diagnosensuche anbietet, muss eine Freitextsuche in den Klartexten der SDICD moeglich sein. Die Suche soll sowohl im Titel als auch in Inklusiva und Exklusiva suchen. |

### O10-541 — ICD-Favoritenlisten

| Feld | Wert |
|---|---|
| ID | O10-541 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS anwender- oder fachgruppenbezogene Favoritenlisten fuer haeufig verwendete ICD-Kodes bereitstellen. |

### KP10-542 — Ungeeignet als Dauerdiagnose

| Feld | Wert |
|---|---|
| ID | KP10-542 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn das PVS Dauerdiagnosen unterstuetzt, muss es bei ICD-Kodes, die in der SDICD als "ungeeignet als Dauerdiagnose" gekennzeichnet sind, einen Warnhinweis anzeigen. |

---

## Summary

| ID | Type | Short Title |
|---|---|---|
| P10-400 | P | Einsatzpflicht SDICD |
| P10-410 | P | Gueltigkeit SDICD |
| P10-420 | P | Inhaltliche Unveraenderbarkeit |
| P10-430 | P | Existenzpruefung ICD-Kode |
| P10-440 | P | Nicht abrechenbare Kodes ablehnen |
| P10-450 | P | Kode ohne Inhalt ablehnen |
| P10-460 | P | Sekundaerkodes Kreuz-Stern pruefen |
| P10-470 | P | Geschlechtsbezug pruefen |
| P10-480 | P | Altersgruppenbezug pruefen |
| P10-490 | P | Seltene Diagnosen Hinweis |
| P10-500 | P | IfSG-Meldepflicht Hinweis |
| O10-510 | O | IfSG-Abrechnungsbesonderheit |
| KP10-540 | KP | Freitext-Suche SDICD |
| O10-541 | O | ICD-Favoritenlisten |
| KP10-542 | KP | Ungeeignet als Dauerdiagnose |
