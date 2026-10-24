# 📘 Guida Tecnica Dettagliata: Architettura & Ecosistema Antigravity v3.0.0

> **Autore:** [Manuele Francescon](https://github.com/tennet)  
> **Versione:** 3.0.0 — Suite Sub-Agenti a 9 Specialisti, Saggio Polimorfico & DevOps Multi-Node  
> **Repository Ufficiale:** [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team)  
> **Ambiente Operativo:** Google Antigravity AI | macOS Apple Silicon / Windows 11 / Linux | Node.js | Python | PHP 8.4+

---

## 1. Mappa Architetturale Completa

L'ambiente separa nettamente il motore di intelligenza artificiale (**Cloud Gemini**) dalla gestione operativa locale dei progetti e delle configurazioni.

```mermaid
flowchart TD
    User["👤 Sviluppatore (Manuele Francescon)"] --> Engine["⚡ Antigravity Engine (Gemini in Cloud)"]
    
    subgraph GlobalGovernance ["Governance Globale (~/.gemini/config/)"]
        Rules["📜 Regole Universali (AGENTS.md / GEMINI.md)"]
        Hooks["🪝 Event Hooks (hooks.json Fail-Secure)"]
        MCP["🔌 Protocollo MCP (memory, github)"]
        Skills["🧠 Skills ad Attivazione Rapida"]
    end
    
    subgraph PluginSuite ["Plugin: tennet/antigravity-engineering-team (v3.0.0)"]
        Orch["🎯 project-orchestrator (Tech Lead)"]
        Arch["🏛️ software-architect (System Design)"]
        Backend["🧙‍♂️ polyglot-backend-sage (Core & Database Master)"]
        DevOps["🚀 devops-infra-sage (Hosting, Docker & Multi-Node Sync)"]
        UI["🎨 ui-ux-designer (Modern Bento Grid UI)"]
        QA["🧪 qa-engineer (Failure Modes & TDD)"]
        IT["🔌 integration-tester (E2E & Socket/DB)"]
        Sec["🛡️ security-auditor (Threat Modeling & Veto)"]
        Doc["📝 documentation-engineer (Docs-as-Code & ADR)"]
    end
    
    subgraph ExecutionTarget ["Ambiente Target Reale (4 Nodi Eterogenei)"]
        M1["💻 Mac 1 (MacBook Air M4 Apple Silicon)"]
        M2["💻 Mac 2 (macOS)"]
        M3["💻 Mac 3 (macOS)"]
        PC["🖥️ PC Windows (PowerShell / WSL2)"]
    end
    
    Engine --> GlobalGovernance
    GlobalGovernance --> PluginSuite
    PluginSuite --> ExecutionTarget
```

---

## 2. Directory Structure del Plugin (v3.0.0)

```text
~/.gemini/config/plugins/engineering-team/
├── .gitignore                     # Protezione credenziali e file OS
├── LICENSE                        # Licenza MIT (Copyright Manuele Francescon)
├── README.md                      # Presentazione v3.0.0, disclaimer, matrice ruoli e badge
├── VADEMECUM.md                   # Prontuario pratico per tutti i 9 agenti
├── plugin.json                    # Manifest del plugin (v3.0.0)
├── agents/                        # I 9 Sub-Agenti Specializzati
│   ├── devops-infra-sage.md       # [NUOVO] DevOps, hosting, Docker e sync multipiattaforma
│   ├── documentation-engineer.md
│   ├── integration-tester.md
│   ├── polyglot-backend-sage.md   # [NUOVO] Saggio polimorfico (Laravel/Node/Python/MySQL)
│   ├── project-orchestrator.md
│   ├── qa-engineer.md
│   ├── security-auditor.md
│   ├── software-architect.md
│   └── ui-ux-designer.md
└── docs/                          # Documentazione Tecnica di Dettaglio
    └── GUIDA_TECNICA_DETTAGLIATA.md
```

---

## 3. Il Protocollo Deterministico del Sub-Agente Polimorfico

`polyglot-backend-sage` non è un generico assistente, ma adotta il **Deterministic Manifest Detection Protocol**:

| Stack Rilevato | Manifest Trigger | Specializzazione Applicata |
| :--- | :--- | :--- |
| **LARAVEL_MODERN** | `composer.json` con `laravel/framework` | PHP 8.4+, Laravel 11/12 lean skeleton, Action pattern, prevenzione $N+1$ con `Model::with()`, indici compositi MySQL/SQLite, `DB::transaction()`. |
| **PHP_VANILLA** | `composer.json` senza Laravel | PHP 8.4+, architettura PSR-4, PSR-7/15, typed constants, property hooks. |
| **NODE_TYPESCRIPT** | `package.json` + `tsconfig.json` | Strict TypeScript, validazione runtime Zod, Fastify/Express/Nest, async/await privo di unhandled rejections. |
| **PYTHON_MODERN** | `pyproject.toml` / `requirements.txt` | Python 3.12+, FastAPI, Pydantic v2, SQLAlchemy 2.0 con type hints completi. |

---

## 4. Architettura di Sincronizzazione Multi-Nodo (3 Mac + 1 PC)

Progettata da `devops-infra-sage` per evitare i fallimenti dello storage cloud consumer non strutturato:

1. **Separazione Netta**:
   - **Control Plane (Configurazioni, Skills, Agenti)**: sincronizzato tramite il repository Git `tennet/antigravity-engineering-team` con gestione CRLF normalizzata via `.gitattributes`.
   - **Data Plane (Memoria MCP & Knowledge Graph)**: file isolati per singolo nodo (`memory_mac_m4.jsonl`, `memory_pc_win.jsonl`) con unificazione automatica all'avvio priva di collisioni o race condition.
2. **Scripting Bivalente Simmetrico**:
   - `sync.sh` per i nodi macOS (POSIX zsh/bash compatibile con Apple Silicon, backup atomico preventivo, zero `rm -rf`).
   - `sync.ps1` per il nodo Windows (PowerShell 7+ nativo, gestione automatica delle Directory Junctions tramite `New-Item -ItemType Junction`, lock inter-processo con Mutex, zero dipendenze da `cmd.exe`).

---

## 5. Risultati del Test Avversariale "Tutti contro Tutti" (Stress Test v3.0.0)

Durante il ciclo di convalida della versione 3.0.0, l'intero team ha simulato un'arena avversariale in cui `polyglot-backend-sage` e `devops-infra-sage` hanno prodotto implementazioni complesse (pipeline multi-tenant e kit infrastrutturale), sottoposte all'attacco incrociato di `security-auditor` e `qa-engineer`.

### A. Rilievi Emersi dal Contraddittorio & Refactoring Applicato

| Modulo | Vulnerabilità / Criticità Rilevata | Agente Segnalatore | Soluzione & Refactoring Applicato |
| :--- | :--- | :--- | :--- |
| **Backend** | **BOLA Cross-Tenant nelle Relazioni**: `MemoryRelation` consentiva relazioni tra nodi appartenenti a tenant diversi, portando a data leak nelle query eager-loaded. | `security-auditor` | Aggiunto guard vincolante in `MemoryRelation::booted()` che impone l'uguaglianza rigorosa `sourceNode->tenant_id === targetNode->tenant_id === relation->tenant_id`. |
| **Backend** | **Gap-Lock Deadlock (InnoDB 1213)**: `SELECT ... FOR UPDATE` su riga non esistente generava un Gap Lock, bloccando gli INSERT concorrenti in deadlock. | `qa-engineer` | Eliminato il Gap Lock: lookup non-bloccante, Record Lock mirato per ID sui record esistenti, o inserimento diretto con cattura del vincolo univoco (MySQL 1062) e retry con backoff/jitter. |
| **Backend** | **DoS da Ricorsione JSON**: La canonicalizzazione di array profondamente annidati causava rischio di Stack Overflow in PHP. | `security-auditor` | Introdotto controllo di profondità rigido (`MAX_PROPERTIES_DEPTH = 5`) sia nella validazione FormRequest sia nella funzione di hashing. |
| **Backend** | **Cicli Auto-Referenziali**: Mancanza di vincolo anti-ciclo su `source_node_id === target_node_id`. | `qa-engineer` | Aggiunto vincolo `CHECK (source_node_id != target_node_id)` a livello di migrazione DDL e nel lifecycle model. |
| **DevOps** | **Command Injection / Quoting in `sync.ps1`**: L'invocazione di `cmd.exe /c mklink` falliva con caratteri `&` o percorsi con spazi. | `security-auditor` | Sostituita con cmdlets nativi di PowerShell 7+ (`New-Item -ItemType Junction` e `HardLink`), eliminando qualsiasi chiamata a `cmd.exe`. |
| **DevOps** | **Collisione di Concorrenza su Windows**: Esecuzioni simultanee dello script collidavano sulle cartelle di staging. | `qa-engineer` | Introdotto Mutex globale di sincronizzazione (`[System.Threading.Mutex]`) e suffissi con ID di processo (`$PID`). |
| **DevOps** | **Bypass Nginx `^~ /storage/`**: L'operatore `^~` disabilitava la valutazione di tutte le regex globali, permettendo il download di dump `.sql` o file di log in `/storage/`. | `security-auditor` | Rimosso `^~`, ripristinata la priorità standard e inserite regole annidate di `deny all` per `.sql`, `.log`, `.env*` e dotfiles. |
| **DevOps** | **Permessi Volume Docker su Non-Root (UID 10001)**: L'utente non privilegiato non poteva scrivere su `storage/` e `bootstrap/cache` montati da host. | `qa-engineer` | Aggiunto `su-exec` all'immagine Alpine, creato volume dedicato `app_bootstrap_cache` e affidata all'entrypoint la sincronizzazione iniziale dei permessi prima del drop privilegi. |

### B. Esito Finale del Test
A valle del refactoring drop-in, tutti i 4 Quality Gate hanno rilasciato verdetto unanime **`[APPROVATO]`**, certificando l'idoneità del team e delle architetture per ambienti di sviluppo e produzione multi-macchina.
