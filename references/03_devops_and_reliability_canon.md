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

---

## 4. Rotazione Segreti a Caldo & Disciplina RTO/RPO (Lacuna L-03 Risolta)

1. **Ricaricamento Credenziali a Caldo (`SIGHUP` / Signal Handling)**:
   - I processi server all'interno dei container (PHP-FPM, Nginx, Node) devono essere configurati per rileggere le credenziali da directory protette (es. `/run/secrets/`) al ricevimento del segnale `SIGHUP`, senza terminare le connessioni attive né riavviare i container.
   - Non memorizzare segreti in cache permanenti non rinfrescabili in memoria.
2. **Quantificazione Formale degli Obiettivi di Ripristino (RTO / RPO)**:
   - **RTO (Recovery Time Objective)**: Tempo massimo di ripristino dell'intero stack dopo un crash catastrofico: fissato a $\le 15$ minuti tramite automazione `docker compose up -d` e script simmetrici.
   - **RPO (Recovery Point Objective)**: Perdita massima ammissibile di dati: fissata a $\le 1$ ora tramite snapshot periodici o backup atomici pre-deploy.
   - **Verifica Periodica dei Backup**: Un backup non verificato equivale a nessun backup. La pipeline deve eseguire regolarmente un test automatico di ripristino (*restore rehearsal*) su un database temporaneo verificando la coerenza referenziale dei dati.

---

## 5. Hardening Avanzato: 10 Casi Limite & Anti-Allucinazioni DevOps (Stress Test v3.2)

1. **Permessi Volumi Docker: macOS VirtioFS vs Linux Native ext4**:
   - *Trappola*: Pensare che i permessi di un utente `UID 10001` dentro il container si comportino allo stesso modo su Mac e su Linux.
   - *Verità Ingegneristica*: Su macOS Docker Desktop, il driver di condivisione file (VirtioFS) mappa automaticamente i file sull'utente host macOS corrente. Su Linux nativo (ext4), il container scrive con l'effettivo `UID 10001`. L'entrypoint deve usare `chown`/`su-exec` per sincronizzare la proprietà delle cartelle scrivibili (`storage/`, `bootstrap/cache`) all'avvio.
2. **Vulnerabilità Off-by-Slash in Nginx Alias**:
   - *Trappola*: Configurare una direttiva `location /storage { alias /var/www/storage/; }` senza slash finale nella location.
   - *Verità Ingegneristica*: Omettere lo slash finale (`/storage` anziché `/storage/`) consente attacchi di Path Traversal (es. richiedere `/storage_private` permette di risalire e leggere directory adiacenti). Fai sempre coincidere gli slash di apertura e chiusura: `location /storage/ { alias /var/www/storage/; }`.
3. **PowerShell 7+ Junctions vs Symlink Privilegiati su Windows 11**:
   - *Trappola*: Usare `New-Item -ItemType SymbolicLink` per cartelle di progetto su Windows.
   - *Verità Ingegneristica*: La creazione di Symbolic Link su Windows richiede permessi di Amministratore o l'attivazione della modalità sviluppatore (Developer Mode). Per directory e cartelle di sincronizzazione, usa **esclusivamente Junctions** (`New-Item -ItemType Junction`), che non richiedono alcuna elevazione di privilegi su Windows 11.
4. **Healthcheck in Immagini Minimali Distroless o Slim (No `curl`)**:
   - *Trappola*: Inserire `curl -f http://localhost` nel Dockerfile di un'immagine `-slim` o `distroless` dove `curl` non è installato.
   - *Verità Ingegneristica*: Il container fallirà l'healthcheck diventando `unhealthy`. Usa utility già presenti come `php -r "exit(@file_get_contents('http://127.0.0.1/up') ? 0 : 1);"` oppure un healthcheck TCP nativo Bash: `timeout 2 bash -c "</dev/tcp/127.0.0.1/80" || exit 1`.
5. **MySQL 8.4 e Deprecazione di `mysql_native_password`**:
   - *Trappola*: Configurare `default_authentication_plugin=mysql_native_password` in `my.cnf` per MySQL 8.4.
   - *Verità Ingegneristica*: In MySQL 8.4 LTS il plugin legacy `mysql_native_password` è disabilitato di default o rimosso. I client PHP e microservizi devono tassativamente connettersi usando `caching_sha2_password` con supporto SSL/TLS attivo.
6. **Propagazione Segnali `SIGTERM` e Zombie Processes con `exec`**:
   - *Trappola*: Scrivere uno script entrypoint che avvia il servizio in background o senza `exec`: `/entrypoint.sh ➔ php-fpm`.
   - *Verità Ingegneristica*: La shell rimane come PID 1 e intrappola i segnali senza inoltrarli a `php-fpm`. Al comando `docker stop`, il container attende 10 secondi e viene terminato bruscamente da `SIGKILL`. Termina sempre lo script entrypoint con `exec "$@"`.
7. **HTTP/3 QUIC e Binding delle Porte UDP**:
   - *Trappola*: Dichiarare nel docker-compose `- "443:443"` per abilitare HTTP/3.
   - *Verità Ingegneristica*: HTTP/3 gira su protocollo UDP (QUIC). La sintassi `"443:443"` espone esclusivamente la porta TCP. È obbligatorio esporre esplicitamente entrambe: `- "443:443/tcp"` e `- "443:443/udp"`.
8. **Protezione dei Segreti in Build Multi-Stage (No `ARG` per Token)**:
   - *Trappola*: Passare chiavi SSH private o token Composer via `ARG COMPOSER_AUTH=...` durante `docker build`.
   - *Verità Ingegneristica*: I valori `ARG` rimangono persistiti nei metadata dell'immagine (`docker history`) e nei layer intermedi. Usa esclusivamente BuildKit secret mounts: `RUN --mount=type=secret,id=composer_auth ...`.
9. **CRLF vs LF e Script Invarianti**:
   - *Trappola*: Clonare lo script `sync.sh` su Windows con conversione automatica CRLF e poi eseguirlo dentro un container Linux o su macOS.
   - *Verità Ingegneristica*: Lo script fallisce con `\r: command not found`. Configura sempre il file `.gitattributes` con `*.sh text eol=lf` e verifica i file shell con `sed -i 's/\r$//' script.sh`.
10. **Memory Limits & Exit Code 137 (OOM Killer)**:
    - *Trappola*: Assegnare `mem_limit: 512m` al container MySQL credendo che InnoDB limiti automaticamente l'uso di memoria.
    - *Verità Ingegneristica*: InnoDB alloca `innodb_buffer_pool_size`, ma MySQL alloca ulteriore RAM per thread stack, sort buffers e join buffers. Se il totale supera 512 MB, il kernel Linux invia `SIGKILL` (exit code 137). La regola aurea è dimensionare `innodb_buffer_pool_size` a non più del 50-60% del `mem_limit` del container.
