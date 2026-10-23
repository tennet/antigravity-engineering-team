# 🧭 Guida Semplice ad Antigravity (Vademecum Pratico)

> **Autore:** [Manuele Francescon](https://github.com/tennet)  
> **Versione:** 2.1.1  
> **Repository Ufficiale:** [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team)  
> Questa guida spiega **senza paroloni tecnici** cosa c'è nella tua suite di sub-agenti, come ti semplifica il lavoro e **cosa scrivere esattamente in chat** per ottenere qualsiasi risultato.

---

## 🌟 La Mappa Semplice: Come funziona il tuo Studio Personale

Invece di parlare con una sola IA generica, immagina di avere:
1. **Un Team di 7 Collaboratori Specializzati (Subagent)**: ognuno ha un mestiere preciso (il coordinatore, l'architetto, il grafico, il collaudatore, l'esperto di sicurezza, il documentatore e il collaudatore di sistemi).
2. **Il Contraddittorio Costruttivo (Anti-Compiacimento)**: gli agenti non si limitano a dirti "tutto perfetto", ma si sfidano a vicenda per scovare errori prima che il codice arrivi a te.
3. **I Superpoteri (MCP)**: una **Memoria a lungo termine** che non dimentica le tue preferenze tra una sessione e l'altra, e connettori diretti a GitHub.
4. **Git e GitHub**: la cassaforte sul tuo computer e il backup online su [tennet/antigravity-engineering-team](https://github.com/tennet/antigravity-engineering-team).

---

## ⚠️ Da Ricordare: Cloud vs Tuo Computer
- **L'intelligenza artificiale (Gemini)** gira nel Cloud di Google: non appesantisce il tuo computer per "pensare".
- **Il codice, i siti e i file** che gli agenti creano girano **sul tuo computer o sui tuoi server** (macOS, Linux o Docker). Per questo i sub-agenti controllano sempre il tuo sistema operativo reale, evitando di generare comandi incompatibili.

---

## 1. La tua Squadra di 7 Esperti Virtuali

Puoi chiamare ciascun collaboratore semplicemente nominandolo nel messaggio:

| Collaboratore | Chi è e a cosa serve | La frase esatta da scrivere in chat per usarlo |
| :--- | :--- | :--- |
| 🎯 **Il Coordinatore** (`project-orchestrator`) | È il tuo Tech Lead. Mette in ordine le idee, governa il contraddittorio tra gli agenti e controlla che tutti i collaudi siano superati prima della consegna. | *"Chiedi al coordinatore di organizzare il lavoro per creare [tua idea]"* |
| 🏛️ **L'Architetto** (`software-architect`) | Progetta la struttura tecnica, crea diagrammi chiari, sceglie database e contratti dati tenendo conto del tuo sistema operativo reale. | *"Chiedi all'architetto di preparare il piano tecnico per questa funzione"* |
| 🎨 **Il Grafico** (`ui-ux-designer`) | Evita schermate noiose. Disegna pagine web moderne (stile Linear/Stripe), con schede Bento, sfondi scuri eleganti ed effetti di luce. | *"Chiedi al designer di rifare la schermata rendendola moderna e accattivante"* |
| 🧪 **Il Collaudatore** (`qa-engineer`) | Scova i singoli bug, verifica cosa accade in caso di crash o interruzione improvvisa e protegge la memoria da blocchi. | *"Chiedi al collaudatore di trovare e isolare l'errore in questo codice"* |
| 🔌 **Il Tester d'Integrazione** (`integration-tester`) | Controlla che le diverse parti del sistema (sito, database, API e server) parlino davvero tra loro senza blocchi o errori di rete. | *"Chiedi all'integration-tester di verificare il passaggio dati da inizio a fine"* |
| 🛡️ **La Guardia di Sicurezza** (`security-auditor`) | Cerca falle con l'occhio di un attaccante (vulnerabilità OWASP, chiavi segrete esposte, iniezioni nei prompt e abusi di rete). | *"Fai fare un controllo di sicurezza avversariale prima di salvare o pubblicare"* |
| 📝 **Il Documentatore** (`documentation-engineer`) | Mantiene sempre aggiornati il README, le spiegazioni e i registri delle decisioni, scrivendo solo ciò che è stato davvero verificato. | *"Fai aggiornare la documentazione al documentatore"* |

---

## 2. Il Ciclo Dialettico (Come Lavorano Insieme)

Quando chiedi una funzionalità importante o complessa, il Coordinatore avvia un ciclo a 4 passi:

1. **L'Architetto** propone la soluzione tecnica v1.0.
2. **La Sicurezza e il Collaudatore** analizzano il piano cercando punti deboli, crash e falle. Se trovano problemi, emettono un verdetto formale di **`[RESPINTO]`**.
3. **L'Architetto** corregge gli errori e presenta la revisione v1.1.
4. Quando tutti gli specialisti emettono **`[APPROVATO]`**, il lavoro viene implementato, collaudato e salvato.

---

## 3. Prontuario: Cosa scrivere in chat nelle situazioni più comuni

| Obiettivo | Frase da scrivere in chat |
| :--- | :--- |
| **Iniziare un nuovo lavoro completo** | *"Avvia il workflow con il coordinatore per progettare e sviluppare [tua idea]."* |
| **Migliorare la grafica di una pagina** | *"La pagina è troppo semplice: chiedi al designer di ridisegnarla in stile Bento Grid moderno con tema dark."* |
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
