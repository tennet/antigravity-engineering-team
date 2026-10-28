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
4. **Metodo `casts()` Moderno (Laravel 13 & 11/12)**:
   - Sostituisci la vecchia proprietà `$casts` con il metodo nativo `protected function casts(): array`, che consente casting tipizzato ad alta precisione, Enums nativi e istanze di configurazione dinamica.

---

## 4. Ecosistema Ufficiale Laravel 13 & Package di Primo Livello

Quando un progetto richiede estensioni, tempo reale, alta concorrenza o diagnostica, Taylor adotta prioritariamente i componenti dell'ecosistema ufficiale di Laravel (standard consolidato Laravel 13):

1. **Real-Time & WebSocket: `Laravel\Reverb`**:
   - Server WebSocket nativo per PHP ad alta velocità e scalabilità, completamente integrato con Laravel Broadcasting ed Echo. Elimina dipendenze da Node.js/Pusher.
2. **Concorrenza & Task Paralleli: `Laravel\Concurrency`**:
   - Invocazione di task paralleli non-bloccanti tramite l'API nativa `Concurrency::run([fn() => ..., fn() => ...])` con driver fork o process.
3. **Runtime In-Memory ad Alte Prestazioni: `Laravel\Octane`**:
   - Integrazione con FrankenPHP o RoadRunner per mantenere l'applicazione avviata in RAM (decine di migliaia di req/s).
   - *Regola aurea*: Attenzione maniacale agli state leak in memoria; azzera singletons o registri statici alla fine di ogni richiesta.
4. **Observability & Code di Produzione**:
   - **`Laravel\Pulse`**: Telemetria in tempo reale su endpoint lenti, query pesanti, picchi di memoria e code sature.
   - **`Laravel\Horizon`**: Dashboard di controllo e bilanciamento automatico delle code Redis con metriche di throughput e retry backoff.
   - **`Laravel\Telescope`**: Assistente locale di debug per ispezione di query, log, mail e notifiche.
5. **Autenticazione & Feature Flagging**:
   - **`Laravel\Sanctum`**: Autenticazione token e sessione SPA con cookie CSRF integrati.
   - **`Laravel\Pennant`**: Gestione dichiarativa di feature flags per rollout graduali o test A/B.
6. **Developer Experience & Testing d'Elite**:
   - **`Laravel\Prompts`**: Form CLI avanzati e interattivi per comandi `artisan` (spinner, text, multiselect, validazione inline).
   - **`Pest PHP v3`**: Suite di test moderna, arch-testing (`arch()->expect('App\Actions')->toBeFinal()`), mutation testing e test paralleli.

---

## 4. MySQL 8.4 Online DDL & Metadata Lock (MDL) Avoidance (Lacuna L-03 Risolta)

Quando esegui migrazioni o alterazioni DDL su tabelle con volumi elevati o sotto carico di produzione concorrente:

1. **Prevenzione delle Code di Blocco su Metadata Lock (MDL)**:
   - Qualsiasi istruzione DDL (`ALTER TABLE`) acquisisce un Exclusive Metadata Lock prima di iniziare. Se una query lenta `SELECT` è in esecuzione, l'istruzione DDL attende l'MDL, e **tutte le successive query `SELECT` rimangono bloccate in coda**, saturando il pool di connessioni (errore `Too many connections`).
   - Imposta sempre un timeout breve per l'acquisizione del lock prima di eseguire DDL:
     ```sql
     SET SESSION lock_wait_timeout = 5;
     ```
   - In caso di timeout, la migrazione fallisce immediatamente rilasciando le connessioni senza impattare il traffico di produzione.
2. **Uso Esplicito della Clausola Online DDL**:
   - Per aggiunta di indici o colonne nullable:
     ```sql
     ALTER TABLE memory_nodes ADD COLUMN last_indexed_at DATETIME NULL,
       ALGORITHM=INPLACE, LOCK=NONE;
     ```
   - Se MySQL segnala `ALGORITHM=INPLACE is not supported`, non forzare un `LOCK=EXCLUSIVE`. Ricorri a strumenti di shadow-copy non bloccanti come **`gh-ost`** o **`pt-online-schema-change`**.

---

## 5. Hardening Avanzato: 10 Casi Limite & Anti-Allucinazioni Backend (Stress Test v3.2)

1. **Gap Locks su Vincoli Esterni in `READ COMMITTED`**:
   - *Trappola*: Credere che `READ COMMITTED` elimini tutti i Gap Lock.
   - *Verità Ingegneristica*: Anche in `READ COMMITTED`, MySQL InnoDB acquisisce Gap Lock per verificare vincoli di chiave esterna (`FOREIGN KEY`) e verificare l'unicità di chiavi secondarie (`UNIQUE INDEX`).
2. **PHP 8.4 Property Hooks vs Eloquent Magic Accessors**:
   - *Trappola*: Applicare Property Hooks (`get => ...`) direttamente sui campi del database di un `Model` Eloquent.
   - *Verità Ingegneristica*: I Property Hooks di PHP 8.4 intercettano l'accesso diretto alla proprietà di classe, bypassando l'array interno `$attributes` e i magic method `__get`/`__set` di Eloquent. Usa i Property Hooks su DTO, Value Objects e FormRequest; sui Model Eloquent usa sempre i metodi `Attribute::make()`.
3. **Savepoints & Deadlock 1213**:
   - *Trappola*: Tentare il rollback di un singolo `SAVEPOINT` dopo un deadlock MySQL.
   - *Verità Ingegneristica*: In caso di errore 1213, InnoDB abortisce e fa il rollback dell'**intera transazione**, invalidando tutti i savepoint intermedi. Qualsiasi retry deve rieseguire la transazione dall'inizio (`DB::transaction`).
4. **Cursor Pagination & Ordinamenti Non Univoci**:
   - *Trappola*: Usare `cursorPaginate()` con ordinamento su colonne non univoche (es. `status`).
   - *Verità Ingegneristica*: La paginazione a cursore richiede un ordinamento strettamente deterministico; se la colonna non è univoca, è obbligatorio aggiungere una colonna univoca di spareggio: `$query->orderBy('status')->orderBy('id')`.
5. **Memory Leak in Worker a Lunga Esecuzione (`queue:work`)**:
   - *Trappola*: Credere che `gc_collect_cycles()` prevenga ogni memory leak nei demoni di coda.
   - *Verità Ingegneristica*: Se il query log di Laravel è attivo (`DB::enableQueryLog()`), ogni singola query viene accumulata in RAM fino al crash OOM. Nei worker e nei comandi CLI batch, disabilita esplicitamente il log con `DB::disableQueryLog()` e svuota le istanze statiche al termine di ogni job.
6. **TempTable Engine & OOM in MySQL 8.4**:
   - *Trappola*: Query complesse con `UNION` e grandi aggregazioni che saturano la RAM del container.
   - *Verità Ingegneristica*: MySQL 8.4 usa di default l'engine `TempTable` per tabelle temporanee interne. Se `temptable_max_ram` viene superato, alloca file memory-mapped (`temptable_use_mmap`). Nei container con vincoli rigidi di RAM, mappa `temptable_max_ram` in proporzione (es. 64M) per evitare che il processo `mysqld` venga terminato da Linux OOM Killer (exit code 137).
7. **BOLA su Relazioni Polimorfiche (`MorphTo`)**:
   - *Trappola*: Accettare `commentable_type` e `commentable_id` dal client senza validazione.
   - *Verità Ingegneristica*: Un attaccante può passare classi interne arbitrarie (`App\Models\User`, `App\Models\Invoice`). Definisci sempre un **Morph Map esplicito** (`Relation::enforceMorphMap([...])`) vietando nomi di classe FQCN non registrati.
8. **Auto-Increment Gaps con `upsert()`**:
   - *Trappola*: Allarmarsi perché gli ID auto-incrementali saltano blocchi di numeri.
   - *Verità Ingegneristica*: Con `innodb_autoinc_lock_mode = 2` (default MySQL 8), le istruzioni bulk INSERT/UPSERT allocano intervalli di ID consecutivi prima di risolvere le chiavi duplicate. Gli ID non consumati vanno persi per design (garanzia di concorrenza, non di sequenzialità continua).
9. **Ricerca Fulltext InnoDB & Multi-Tenancy**:
   - *Trappola*: Eseguire `MATCH(...) AGAINST(...)` senza scope tenant.
   - *Verità Ingegneristica*: L'indice FULLTEXT di MySQL InnoDB non può includere il `tenant_id` come prefisso B-Tree. Filtra sempre esplicitamente con `WHERE tenant_id = ? AND MATCH(...) AGAINST(...)` per impedire information disclosure tra tenant.
10. **Evitare N+1 nelle Relazioni Annidate**:
    - *Trappola*: Caricare `Model::with('relation')` e poi accedere a una sotto-relazione `$item->relation->subrelation`.
    - *Verità Ingegneristica*: Impiega il caricamento a catena punto-notazione: `Model::with(['relation.subrelation'])` specificando le sole colonne necessarie: `Model::with(['relation:id,parent_id', 'relation.subrelation:id,relation_id,name'])`.
