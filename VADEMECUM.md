# 🧭 Guida Semplice ad Antigravity (Vademecum Pratico v3.0.0)

> **Autore:** [Manuele Francescon](https://github.com/tennet)  
> **Versione:** 3.0.0 (Suite a 9 Specialisti)  
> **Repository Ufficiale:** [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team)  
> Questa guida spiega **senza paroloni tecnici** cosa c'è nella tua suite di sub-agenti, come ti semplifica il lavoro e **cosa scrivere esattamente in chat** per ottenere qualsiasi risultato.

---

## 🌟 La Mappa Semplice: Come funziona il tuo Studio Personale

Invece di parlare con una sola IA generica, immagina di avere:
1. **Un Team di 9 Collaboratori Specializzati (Subagent)**: ognuno ha un mestiere preciso (il coordinatore, l'architetto, il saggio backend, il grafico, il sistemista devops, il collaudatore, il tester d'integrazione, l'esperto di sicurezza e il documentatore).
2. **Il Contraddittorio Costruttivo (Anti-Compiacimento)**: gli agenti non si limitano a dirti "tutto perfetto", ma si sfidano a vicenda per scovare errori prima che il codice arrivi a te.
3. **I Superpoteri (MCP)**: una **Memoria a lungo termine** che non dimentica le tue preferenze tra una sessione e l'altra, e connettori diretti a GitHub.
4. **Git e GitHub**: la cassaforte sul tuo computer e il backup online su [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team).

---

## ⚠️ Da Ricordare: Cloud vs Tuo Computer
- **L'intelligenza artificiale (Gemini)** gira nel Cloud di Google: non appesantisce il tuo computer per "pensare".
- **Il codice, i siti e i file** che gli agenti creano girano **sul tuo computer o sui tuoi server** (macOS, Linux o Docker). Per questo i sub-agenti controllano sempre il tuo sistema operativo reale, evitando di generare comandi incompatibili.

---

## 1. La tua Squadra di 9 Esperti Virtuali

Puoi chiamare ciascun collaboratore semplicemente nominandolo nel messaggio:

| Collaboratore | Chi è e a cosa serve | La frase esatta da scrivere in chat per usarlo |
| :--- | :--- | :--- |
| 🎯 **Il Coordinatore** (`project-orchestrator`) | È il tuo Tech Lead. Mette in ordine le idee, governa il contraddittorio tra gli agenti e controlla che tutti i collaudi siano superati prima della consegna. | *"Chiedi al coordinatore di organizzare il lavoro per creare [tua idea]"* |
| 🏛️ **L'Architetto** (`software-architect`) | Progetta la struttura tecnica, crea diagrammi chiari, sceglie database e contratti dati tenendo conto del tuo sistema operativo reale. | *"Chiedi all'architetto di preparare il piano tecnico per questa funzione"* |
| 🧙‍♂️ **Il Saggio del Backend** (`polyglot-backend-sage`) | Il "braccio esperto" server-side. Riconosce da solo lo stack (Laravel/PHP, Node/TS, Python) e scrive codice ad alte prestazioni, eliminando query lente ($N+1$) e curando le transazioni del database. | *"Chiedi al backend-sage di implementare le API e la logica del database per questo modulo"* |
| 🎨 **Il Grafico** (`ui-ux-designer`) | Evita schermate noiose. Disegna pagine web moderne (stile Linear/Stripe), con schede Bento, sfondi scuri eleganti ed effetti di luce. | *"Chiedi al designer di rifare la schermata rendendola moderna e accattivante"* |
| 🚀 **Il Sistemista & DevOps** (`devops-infra-sage`) | Gestisce container Docker, server web, sicurezza della cartella public, deployment e crea gli script simmetrici per far dialogare Mac e PC Windows. | *"Chiedi al devops-sage di configurare Docker o preparare lo script di sincronizzazione"* |
| 🧪 **Il Collaudatore** (`qa-engineer`) | Scova i singoli bug, verifica cosa accade in caso di crash o interruzione improvvisa e protegge la memoria da blocchi. | *"Chiedi al collaudatore di trovare e isolare l'errore in questo codice"* |
| 🔌 **Il Tester d'Integrazione** (`integration-tester`) | Controlla che le diverse parti del sistema (sito, database, API e server) parlino davvero tra loro senza blocchi o errori di rete. | *"Chiedi all'integration-tester di verificare il passaggio dati da inizio a fine"* |
| 🛡️ **La Guardia di Sicurezza** (`security-auditor`) | Cerca falle con l'occhio di un attaccante (vulnerabilità OWASP, chiavi segrete esposte, iniezioni nei prompt e abusi di rete). | *"Fai fare un controllo di sicurezza avversariale prima di salvare o pubblicare"* |
| 📝 **Il Documentatore** (`documentation-engineer`) | Mantiene sempre aggiornati il README, le spiegazioni e i registri delle decisioni, scrivendo solo ciò che è stato davvero verificato. | *"Fai aggiornare la documentazione al documentatore"* |

---

## 2. Il Ciclo Dialettico (Come Lavorano Insieme)

Quando chiedi una funzionalità importante o complessa, il Coordinatore avvia il ciclo a 5 fasi:

1. **Ispezione Iniziale (Fase 1)**: Il DevOps e il Backend Sage controllano l'ambiente reale (OS, porte, database, file di configurazione).
2. **Proposta e Contraddittorio (Fase 2)**: L'Architetto propone la soluzione tecnica v1.0; la Sicurezza e il QA la attaccano cercando falle o crash. Se ci sono problemi, viene emesso **`[RESPINTO]`** e l'Architetto la corregge in v1.1.
3. **Implementazione Parallela (Fase 3)**: Il Backend Sage scrive la logica di dominio, il Designer crea l'interfaccia Bento e il DevOps prepara Docker e gli script di deploy.
4. **Collaudo Incrociato a 4 Gate (Fase 4)**: I 4 collaudatori (QA, Integrazione, Sicurezza, Resilienza) eseguono i test.
5. **Chiusura Verificabile (Fase 5)**: Il Documentatore aggiorna le guide e l'Orchestratore ti mostra il report finale, chiedendoti approvazione prima di salvare su GitHub.

---

## 3. Prontuario: Cosa scrivere in chat nelle situazioni più comuni

| Obiettivo | Frase da scrivere in chat |
| :--- | :--- |
| **Iniziare un nuovo lavoro completo** | *"Avvia il workflow con il coordinatore per progettare e sviluppare [tua idea]."* |
| **Implementare API o logica database** | *"Chiedi al backend-sage di scrivere il codice per questo servizio con query ottimizzate."* |
| **Migliorare la grafica di una pagina** | *"La pagina è troppo semplice: chiedi al designer di ridisegnarla in stile Bento Grid moderno con tema dark."* |
| **Configurare Docker o hosting** | *"Chiedi al devops-sage di preparare il file docker-compose e proteggere la webroot."* |
| **Risolvere un errore che si blocca** | *"Questa funzione dà errore o crash: fai intervenire il collaudatore per isolare il problema con un test."* |
| **Controllare la sicurezza prima del rilascio** | *"Fai fare un audit avversariale al security-auditor per verificare che non ci siano vulnerabilità prima di pubblicare."* |
| **Testare se il frontend dialoga con i dati** | *"Fai controllare la cooperazione tra interfaccia e dati all'integration-tester."* |
| **Aggiornare guide e spiegazioni** | *"Chiedi al documentatore di aggiornare il README e spiegare come funziona il codice."* |
| **Salvare tutto su GitHub** | *"Salva le modifiche su Git e inviale su GitHub."* |

---

## 4. I Superpoteri Installati (MCP)

### 🧠 1. La Memoria a Lungo Termine (`memory`)
* **A cosa serve**: Di solito le IA dimenticano tutto appena chiudi la sessione. Con questa memoria, Antigravity ricorda per sempre:
  - Che parliamo sempre in **italiano chiaro e pratico**.
  - Che preferisci un design moderno, scuro e a schede (**Bento Grid**).
  - Che prima di fare commit, push o cancellazioni serve sempre il tuo **OK esplicito**.
* **Cosa scrivergli per aggiungere ricordi**:
  > *"Ricordati nella tua memoria che in questo progetto dobbiamo usare sempre la porta 3000."*

---

*Per chi desidera approfondire la parte ingegneristica, l'architettura tecnica dettagliata è consultabile in [docs/GUIDA_TECNICA_DETTAGLIATA.md](docs/GUIDA_TECNICA_DETTAGLIATA.md).*
