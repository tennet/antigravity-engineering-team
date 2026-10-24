# ⚙️ Canone di Ingegneria DevOps, Affidabilità & Hosting

> **Riferimento Primario per**: `devops-infra-sage`  
> **Fonti Fondamentali**:  
> - Betsy Beyer, Chris Jones, Jennifer Petoff, Niall Richard Murphy, *Site Reliability Engineering: How Google Runs Production Systems* (O'Reilly)  
> - Nigel Poulton, *Docker Deep Dive* (Packt Publishing)  
> - Michael Nygard, *Release It!: Design and Deploy Production-Ready Software* (Pragmatic Bookshelf)

---

## 1. Principi SRE & Gestione del Rischio

1. **Automation over Toil**: Qualsiasi operazione manuale ripetitiva eseguita più di due volte deve essere convertita in script deterministico e idempotente.
2. **Blameless Post-Mortem**: Di fronte a incidenti o bug infrastrutturali, non cercare colpevoli umani o di processo, ma individua i punti ciechi dell'automazione e introduci verifiche preventive nel codice o nella pipeline CI/CD.
3. **Graceful Degradation**: Quando un servizio secondario (es. cache Redis o embedding esterno) fallisce, il sistema non deve andare in crash completo (500), ma deve degradare in modo controllato fornendo risposte parziali o accodando le richieste.

---

## 2. Hardening dei Container Docker & Multi-Architettura

1. **Principio del Minimo Privilegio (Non-Root)**:
   - I container di produzione non devono mai essere eseguiti come `root`.
   - Assegna un utente di sistema dedicato non privilegiato (es. `UID 10001`).
   - Se il container necessita di inizializzare permessi su volumi montati dall'host, l'entrypoint deve avvalersi di utility sicure di cessione privilegi (come `su-exec` su Alpine) per rilasciare i privilegi di root immediatamente prima di avviare il processo principale.
2. **Costruzione Multi-Architettura Determinista**:
   - Compila sempre per `linux/amd64` (server x86, PC Windows) e `linux/arm64` (Apple Silicon M-series, AWS Graviton) tramite `docker buildx`.
   - Separa rigidamente lo stage di compilazione delle dipendenze (builder pesante con strumenti di sviluppo) dallo stage finale di runtime minimale (Alpine o Debian Slim).
3. **Healthcheck con Probing Realistico**:
   - Definisci sempre healthcheck nativi nei file compose.
   - Per servizi a inizializzazione lenta (es. MySQL 8.4 cold-start), configura un `start_period` adeguato (minimo 45-60s) con intervalli brevi e un numero sufficiente di retry per evitare falsi fallimenti durante la creazione iniziale delle tabelle di sistema.

---

## 3. Scripting Cross-Platform Invariante (macOS + Windows)

1. **Doppia Implementazione Simmetrica**: Per ogni automazione di sistema fornisci sempre:
   - `*.sh`: POSIX/Bash per ambienti macOS e Linux, con `set -euo pipefail`.
   - `*.ps1`: PowerShell 7+ nativo per ambienti Windows 11.
2. **Sicurezza Windows senza `cmd.exe`**:
   - Vieta invocazioni shell arbitrarie tramite `cmd.exe /c mklink`. Usa esclusivamente cmdlet nativi di PowerShell 7+ (`New-Item -ItemType Junction` e `New-Item -ItemType HardLink`) che gestiscono nativamente caratteri speciali e percorsi con spazi.
3. **Controllo di Concorrenza Inter-Processo**:
   - Ogni script di sincronizzazione locale deve acquisire un lock di sistema (Mutex nominato su Windows tramite `[System.Threading.Mutex]`, file descriptor lock su macOS/Linux con `flock` o directory atomiche).
