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

## 1. La tua Squadra di 9 Esperti Virtuali (Nomi Canonici & Nuovi Alias Rapidi)

Puoi chiamare ciascun collaboratore usando sia il suo **nome canonico formale**, sia il suo **nuovo alias rapido** ispirato ai più grandi protagonisti della tecnologia contemporanea:

| Alias Rapido | Collaboratore Canonico | Chi è e a cosa serve | Come richiamarlo al volo in chat |
| :---: | :--- | :--- | :--- |
| **`@turing`** | 🎯 **Il Coordinatore** (`project-orchestrator`) | Il tuo Tech Lead (Alan Turing). Rigore logico, chiarezza computabile, governa il contraddittorio ed esige semafori verdi prima del rilascio. | `@turing organizza lo sviluppo di [tua idea]` |
| **`@werner`** | 🏛️ **L'Architetto** (`software-architect`) | Il CTO del Cloud. Progetta l'architettura tecnica, contratti API tipizzati, flussi di dati e resilienza (*"Everything fails all the time"*). | `@werner disegna l'architettura per questa funzione` |
| **`@taylor`** | 🧙‍♂️ **Il Saggio del Backend** (`polyglot-backend-sage`) | Il maestro di Laravel, PHP 8.4 e MySQL. Scrive Action atomiche, elimina query lente ($N+1$) e garantisce zero Gap Lock deadlocks. | `@taylor implementa la logica backend e ottimizza le query` |
| **`@linus`** | 🚀 **Il Sistemista & DevOps** (`devops-infra-sage`) | Il padrone dei sistemi. Governa container Docker multi-arch, webroot hardening e script bivalenti simmetrici (macOS e Windows 11). | `@linus prepara docker-compose e gli script di deploy` |
| **`@steve`** | 🎨 **Il Grafico** (`ui-ux-designer`) | L'esteta del frontend. Disegna layout moderni in stile Linear/Vercel: Bento Grid, dark theme zinc profondo e micro-interazioni fluide. | `@steve crea un'interfaccia bento grid per questa schermata` |
| **`@carmack`** | 🧪 **Il Collaudatore** (`qa-engineer`) | La leggenda dell'affidabilità. TDD rigoroso, scova bug estremi, boundary testing su valori speciali (`NaN`/`INF`) e anti-crash. | `@carmack esegui i test boundary e cerca deadlock` |
| **`@rauch`** | 🔌 **Il Tester d'Integrazione** (`integration-tester`) | Il connettore globale. Verifica che API, database, frontend e code dialoghino davvero, applicando Circuit Breakers e testando la latenza. | `@rauch testa il flusso end-to-end simulando latenza di rete` |
| **`@geohot`** | 🛡️ **La Guardia di Sicurezza** (`security-auditor`) | L'hacker avversariale spietato. Scova falle BOLA/IDOR, command injection, threat modeling STRIDE e possiede **Diritto di Veto**. | `@geohot esegui un audit avversariale su questo codice` |
| **`@guido`** | 📝 **Il Documentatore** (`documentation-engineer`) | Il custode della chiarezza (*"Readability counts"*). Scrive documentazione Diátaxis e registri ADR riportando solo fatti verificati. | `@guido aggiorna la guida tecnica e il changelog` |

> [!TIP]
> **Compatibilità Totale a Doppio Senso:**  
> Puoi usare indifferentemente `@turing` o `@project-orchestrator`, `@taylor` o `@polyglot-backend-sage`, `@linus` o `@devops-infra-sage`. Entrambe le sintassi puntano al medesimo cervello e alle stesse competenze!

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
