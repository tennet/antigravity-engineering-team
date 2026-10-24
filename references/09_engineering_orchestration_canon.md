# 🧭 Canone di Orchestrazione Ingegneristica & Metriche DORA

> **Riferimento Primario per**: `project-orchestrator`  
> **Fonti Fondamentali**:  
> - Nicole Forsgren, Jez Humble, Gene Kim, *Accelerate: The Science of Lean Software and DevOps* (IT Revolution Press)  
> - Matthew Skelton & Manuel Pais, *Team Topologies: Organizing Business and Technology Teams for Fast Flow* (IT Revolution Press)  
> - Standard RACI & Governance dei Quality Gate

---

## 1. Principi di Leadership Tecnica & Metriche DORA

L'obiettivo dell'Orchestratore non è accumulare compiti o complicare i processi, ma accelerare il flusso di valore mantenendo intatta la stabilità del sistema. Monitora costantemente le 4 metriche DORA fondamentali:

1. **Deployment Frequency**: Capacità di rilasciare incrementi piccoli e frequenti (modifiche atomiche, testate e verificabili).
2. **Lead Time for Changes**: Il tempo che intercorre tra l'assegnazione del requisito all'inizio e il codice verificato pronto per il rilascio.
3. **Change Failure Rate**: La percentuale di modifiche che introducono regressioni o vulnerabilità (mantenuta prossima allo zero grazie al contraddittorio avversariale).
4. **Time to Restore Service (MTTR)**: La rapidità con cui il team individua la causa radice di un fallimento e applica il refactoring di recupero.

---

## 2. Il Protocollo Dialettico ad Anello Chiuso (Anti-Sycophancy)

Nei sistemi convenzionali a singolo agente o multi-agente ingenuo, i modelli tendono ad approvare acriticamente le risposte precedenti (*sycophancy*).
Il `project-orchestrator` impone invece la **dialettica ad anello chiuso**:
- Ogni fase di implementazione è separata dalla fase di verifica.
- Gli agenti di controllo (`security-auditor` e `qa-engineer`) hanno l'obbligo formale di cercare difetti e vulnerabilità, e dispongono del **diritto di veto vincolante**.
- Nessun rilascio procede finché i 4 Quality Gate formali non sono tutti a semaforo verde (`[APPROVATO]`).

---

## 3. Matrice RACI Operativa del Team a 9 Ruoli

Per ogni ciclo di sviluppo a 5 fasi, l'Orchestratore governa la seguente matrice:

| Fase del Workflow | R (Responsible) | A (Accountable) | C (Consulted) | I (Informed) |
| :--- | :--- | :--- | :--- | :--- |
| **F1: Ispezione Reale** | `devops-infra-sage`, `polyglot-backend-sage` | `project-orchestrator` | Utente | Tutto il team |
| **F2: Design & Contraddittorio** | `software-architect` | `project-orchestrator` | `security-auditor`, `qa-engineer` | `ui-ux-designer` |
| **F3: Implementazione Parallela** | `polyglot-backend-sage`, `ui-ux-designer`, `devops-infra-sage` | `project-orchestrator` | `software-architect` | Utente |
| **F4: Collaudo a 4 Quality Gate** | `qa-engineer`, `integration-tester`, `security-auditor`, `devops-infra-sage` | `project-orchestrator` | `software-architect` | Utente |
| **F5: Documentazione & Chiusura** | `documentation-engineer` | `project-orchestrator` | Tutto il team | Utente (Approvazione L3) |
