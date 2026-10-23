# 📘 Guida Tecnica Dettagliata: Architettura & Ecosistema Antigravity

> **Autore:** [Manuele Francescon](https://github.com/tennet)  
> **Versione:** 2.1.1 — Suite Sub-Agenti & Protocollo Dialettico  
> **Repository Ufficiale:** [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team)  
> **Ambiente Operativo:** Google Antigravity AI | macOS Apple Silicon / Linux / Docker | Node.js v26.8.1 | Python 3.15.0

---

## 1. Mappa Architetturale Completa

L'ambiente separa nettamente il motore di intelligenza artificiale (**Cloud Gemini**) dalla gestione operativa locale dei progetti e delle configurazioni.

```mermaid
flowchart TD
    User["👤 Sviluppatore (Manuele Francescon)"] --> Engine["⚡ Antigravity Engine (Gemini 2.5 Pro / Flash in Cloud)"]
    
    subgraph GlobalGovernance ["Governance Globale (~/.gemini/config/)"]
        Rules["📜 Regole Universali (AGENTS.md / GEMINI.md)"]
        Hooks["🪝 Event Hooks (hooks.json)"]
        MCP["🔌 Protocollo MCP (memory, github)"]
        Skills["🧠 Skills ad Attivazione Rapida"]
    end
    
    subgraph PluginSuite ["Plugin Ufficiale: tennet/antigravity-engineering-team"]
        direction TB
        Orch["🎯 project-orchestrator (Tech Lead)"]
        Arch["🏛️ software-architect (System Design & Target OS Awareness)"]
        Sec["🛡️ security-auditor (Adversarial Threat Modeling & OWASP)"]
        QA["🧪 qa-engineer (Failure Modes, Deadlocks & CI Testability)"]
        IT["🔌 integration-tester (E2E & Socket/DB Integration)"]
        UI["🎨 ui-ux-designer (Modern Frontend, Bento Grid & Dark Theme)"]
        Doc["📝 documentation-engineer (Docs-as-Code & ADR)"]
    end
    
    subgraph ExecutionTarget ["Ambiente Target di Esecuzione Reale"]
        Host["💻 Computer Locale (macOS Apple Silicon)"]
        Containers["🐳 Container Docker / Podman"]
        Servers["🖥️ Server Remoti / VM Proxmox / VPS"]
    end
    
    subgraph CloudSync ["Sincronizzazione Remota"]
        GitHub["☁️ GitHub Remote (github.com/tennet/antigravity-engineering-team)"]
    end
    
    Engine --> GlobalGovernance
    GlobalGovernance --> PluginSuite
    PluginSuite --> ExecutionTarget
    PluginSuite --> GitHub
```

---

## 2. Directory Structure del Plugin

```text
~/.gemini/config/plugins/engineering-team/
├── .gitignore                     # Protezione credenziali e file OS
├── LICENSE                        # Licenza MIT (Copyright Manuele Francescon)
├── README.md                      # Presentazione, disclaimer, matrice ruoli e badge
├── VADEMECUM.md                   # Prontuario pratico in linguaggio semplice
├── plugin.json                    # Manifest del plugin (v2.1.1)
├── agents/                        # I 7 Sub-Agenti Specializzati
│   ├── documentation-engineer.md
│   ├── integration-tester.md
│   ├── project-orchestrator.md
│   ├── qa-engineer.md
│   ├── security-auditor.md
│   ├── software-architect.md
│   └── ui-ux-designer.md
└── docs/                          # Documentazione Tecnica di Dettaglio
    └── GUIDA_TECNICA_DETTAGLIATA.md
```

---

## 3. Il Ciclo di Contraddittorio (Anti-Sycophancy)

Nei sistemi multi-agente convenzionali, gli assistenti tendono ad approvare acriticamente il lavoro precedente (*sycophancy*).  
La suite **`antigravity-engineering-team`** introduce una regola di condotta avversariale obbligatoria:

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Manuele (Utente)
    participant PO as Project Orchestrator
    participant SA as Software Architect
    participant SEC as Security Auditor
    participant QA as QA Engineer

    Dev->>PO: Richiesta architettura o feature complessa
    PO->>SA: Incarico di progettazione (Design v1.0)
    SA-->>PO: Consegna schema, API contracts e budget risorse
    
    par Verifica Incrociata Avversariale
        PO->>SEC: Threat modeling OWASP, SSRF, injection e memory forensics
        PO->>QA: Failure modes, crash recovery (SIGKILL/OOM), deadlocks e testabilità CI
    end
    
    alt Riscontrate criticità bloccanti
        SEC-->>PO: Verdetto: [RESPINTO] + Matrice SEC-xx
        QA-->>PO: Verdetto: [RESPINTO] + Matrice TC-xx
        PO->>SA: Ingiunge refactoring obbligatorio con drop-in remediation
        SA-->>PO: Consegna Revisione Architetturale v1.1 Refactored
    end
    
    SEC-->>PO: Verdetto: [APPROVATO]
    QA-->>PO: Verdetto: [APPROVATO]
    PO-->>Dev: Soluzione validata e pronta per l'implementazione
```

---

## 4. Matrice dei Quality Gate Formali

Tutti i collaudatori e controllori di sicurezza operano con esiti vincolanti:

| Verdetto | Condizione | Impatto sul Flusso |
| :--- | :--- | :--- |
| **`[APPROVATO]`** | Zero vulnerabilità critiche o alte; testabilità e resilienza garantite al 100%. | Autorizza l'avanzamento allo sviluppo o al rilascio su Git. |
| **`[APPROVATO CON RISERVA]`** | Solo rilievi minori o di debito differibile (severità Low/Medium non bloccante). | Richiede tracking formale nei task, ma non blocca l'implementazione. |
| **`[RESPINTO]`** | Rilevata almeno una vulnerabilità Critical/High, rischio crashloop, leak di risorse o assenza di mock per CI. | **Blocco totale del rilascio**: il compito torna all'Architetto/Sviluppatore per la revisione. |

---

## 5. Manutenzione e Sviluppo Continuo
Per aggiornare il plugin o sincronizzare modifiche:
```bash
cd ~/.gemini/config/plugins/engineering-team
git status
git add .
git commit -m "feat(scope): descrizione della modifica"
git push origin main
```
