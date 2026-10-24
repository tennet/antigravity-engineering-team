# 💾 Canone di Ingegneria dei Database & Backend

> **Riferimento Primario per**: `polyglot-backend-sage`  
> **Fonti Fondamentali**:  
> - Alex Petrov, *Database Internals: A Deep Dive into How Distributed Data Systems Work* (O'Reilly)  
> - Silvia Botros & Jeremy Tinley, *High Performance MySQL* (4th Edition, O'Reilly)  
> - Matt Stauffer, *Laravel: Up & Running* (3rd Edition, O'Reilly)  
> - Eric Evans, *Domain-Driven Design: Tackling Complexity in the Heart of Software* (Addison-Wesley)

---

## 1. Meccanica dei Lock InnoDB & Prevenzione Deadlock

1. **Gap Lock & Next-Key Lock Avoidance**:
   - In isolamento `REPEATABLE READ` (default MySQL InnoDB), una query di lettura con lock (`SELECT ... FOR UPDATE`) su un intervallo di indici o su una chiave inesistente acquisisce un **Gap Lock**.
   - I Gap Lock sono mutuamente compatibili tra letture concorrenti, ma **bloccano qualsiasi `INSERT`** concorrente nello stesso intervallo.
   - **Regola Aurea**: Non eseguire mai `SELECT ... FOR UPDATE` su righe che potrebbero non esistere. Esegui prima un lookup non-bloccante (`SELECT`); se il record esiste, bloccalo puntualmente per chiave primaria (`WHERE id = ? FOR UPDATE`). Se non esiste, procedi con `INSERT` atomico gestendo l'eccezione di chiave duplicata (MySQL 1062).
2. **Exponential Backoff con Full Jitter**:
   - Quando si gestiscono deadlock transazionali (MySQL 1213), il retry non deve mai avvenire a intervalli fissi.
   - Applica la formula del **Decorrelated Jitter**:
     $$\text{sleep} = \text{random}(0, \min(\text{cap}, \text{base} \cdot 2^{\text{attempt}}))$$
     Questo disperde le richieste concorrenti ed elimina le tempeste di contesa (*Thundering Herd*).

---

## 2. Ingegneria degli Indici MySQL (Regola ESR)

Quando progetti indici compositi per query complesse, rispetta rigorosamente la sequenza **ESR (Equality, Sort, Range)**:
1. **Equality ($=$)**: Inserisci prima le colonne filtrate con confronto esatto (es. `tenant_id = ?`, `status = ?`).
2. **Sort (`ORDER BY`)**: Inserisci poi la colonna utilizzata per l'ordinamento (es. `created_at DESC`), eliminando il pesante `Using filesort` di MySQL.
3. **Range ($<, >, \text{BETWEEN}$)**: Inserisci infine le colonne con filtri a intervallo. Non inserire colonne di range prima di colonne di ordinamento, altrimenti l'ordinamento richiederà scansione temporanea su disco.

---

## 3. Disciplina Eloquent & Action Pattern

1. **Divieto Assoluto dell'Anti-Pattern $N+1$**:
   - Obbligo di eager loading (`with(...)`) con selezione esplicita delle colonne necessarie.
   - In sviluppo/test imponi sempre `Model::preventLazyLoading(!app()->isProduction())`.
2. **Clean Architecture: Action Pattern**:
   - Un'Action (`app/Actions/`) è una classe PHP finale con un unico metodo pubblico `execute(...)`.
   - Incapsula la mutazione in `DB::transaction()`.
   - Riceve e restituisce oggetti immutabili (DTO / Result Objects), mai intere istanze Request HTTP non tipizzate.
3. **Resilienza della Memoria su Grandi Volumi**:
   - Vieta tassativamente `->get()` su tabelle potenzialmente ampie.
   - Usa `->chunkById()` per mutazioni batch o `->lazy()` per pipeline in streaming, evitando esaurimenti di RAM (OOM).
