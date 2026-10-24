# 🧪 Canone di Garanzia della Qualità, TDD & Prevenzione Difetti

> **Riferimento Primario per**: `qa-engineer`  
> **Fonti Fondamentali**:  
> - Michael Feathers, *Working Effectively with Legacy Code* (Prentice Hall)  
> - Kent Beck, *Test-Driven Development: By Example* (Addison-Wesley)  
> - Martin Fowler, *Refactoring: Improving the Design of Existing Code* (2nd Edition, Addison-Wesley)

---

## 1. Il Ciclo Virtuoso del TDD (Red-Green-Refactor)

1. **Fase Rossa (Red)**: Prima di scrivere qualsiasi riga di implementazione o correggere un bug segnalato, scrivi un test automatizzato che fallisce e che riproduce fedelmente il comportamento anomalo o il requisito atteso.
2. **Fase Verde (Green)**: Scrivi la quantità minima di codice necessaria a far passare il test con successo. Nessuna sovra-ingegnerizzazione precoce.
3. **Fase di Refactoring (Refactor)**: Pulisci il codice, elimina le duplicazioni, migliora i nomi delle variabili e ottimizzi la struttura mantenendo costantemente la suite di test verde.

---

## 2. Ingegneria dei Casi Limite (Boundary Testing)

Quando testi funzioni, form request o query, sottoponi sistematicamente l'input a questa matrice di stress:

1. **Confini Dimensionali & Numerici**:
   - Valore zero (`0`, `0.0`), numeri negativi (`-1`), valori limite massimi (`PHP_INT_MAX`, interi a 64-bit).
   - Valori speciali IEEE 754: verifica che il sistema rigetti o gestisca esplicitamente `NaN`, `INF` e `-INF` nei payload numerici.
2. **Confini di Stringhe & Payload**:
   - Stringa vuota `""`, stringhe composte esclusivamente da spazi bianchi `"   "`.
   - Stringhe giganti (10 KB, 1 MB, 10 MB) per verificare la protezione contro Memory Exhaustion (OOM).
   - Caratteri speciali Unicode, sequenze UTF-8 multi-byte e coppie surrogate (es. emoji e caratteri speciali asiatici).
3. **Confini Strutturali di Array & JSON**:
   - Array vuoto `[]`, payload con 500+ chiavi.
   - Array annidati ricorsivamente oltre i 5 livelli per verificare l'immunità da Stack Overflow.

---

## 3. Test di Concorrenza & Failure Modes

1. **Riproduzione Determinista delle Race Condition**:
   - Nei test di integrazione con database, testa transazioni concorrenti simulando la contesa su lock univoci per validare che l'applicazione catturi i deadlock e applichi il retry senza crashare.
2. **Isolamento dei Test Harness (Seam Points)**:
   - Ogni test deve essere completamente isolato e indipendente.
   - Non condividere stato mutabile globale tra i test.
   - Ripristina lo schema del database (tramite transazioni o `RefreshDatabase`) al termine di ogni singolo caso di prova.
3. **Eliminazione dei Test Flaky**:
   - Un test che fallisce in modo non deterministico (ad esempio a causa di `sleep()` temporali non sincronizzati) è un bug del test. Sostituisci i ritardi arbitrari con attese basate su polling di eventi (`waitUntil(...)`).
