# 🔌 Canone di Integrazione di Sistema, Reti & Resilienza

> **Riferimento Primario per**: `integration-tester`  
> **Fonti Fondamentali**:  
> - Michael Nygard, *Release It!: Design and Deploy Production-Ready Software* (Pragmatic Bookshelf)  
> - Sam Newman, *Building Microservices: Designing Fine-Grained Systems* (2nd Edition, O'Reilly)  
> - Martin Fowler, *Patterns of Enterprise Application Architecture* (Addison-Wesley)

---

## 1. Pattern di Stabilità Sistemica & Resilienza

Quando diversi sottosistemi cooperano (API web, database, code di messaggi, servizi di embedding esterni), devono essere protetti dai failure pattern noti:

1. **Circuit Breaker Pattern**:
   - Quando un servizio esterno (es. provider di intelligenza artificiale o database remoto) fallisce consecutivamente per $N$ volte, il circuito deve passare allo stato `OPEN`.
   - Nello stato `OPEN`, le chiamate successive falliscono istantaneamente a costo zero (senza attendere timeout lunghi), proteggendo i thread pool del server locale da esaurimento.
   - Dopo un tempo di raffreddamento, il circuito entra in stato `HALF-OPEN` per testare la ripresa del servizio.
2. **Bulkhead Pattern (Paratie Stagne)**:
   - Isola i pool di risorse (connessioni DB, code di esecuzione) per tenant o per tipologia di operazione. Il blocco di un'operazione batch non deve saturare le risorse dedicate agli endpoint critici utente.
3. **Timeout Rigorosi & Deadline Propagation**:
   - Ogni chiamata HTTP o socket di rete deve avere un timeout esplicito di connessione (es. 2s) e di lettura (es. 10s).
   - In catene di chiamate distribuite, propaga la scadenza (*deadline budget*): se la richiesta principale ha un timeout di 5 secondi, non consentire a un servizio intermedio di attendere oltre il tempo rimanente.

---

## 2. Testing End-to-End & Piramide dei Test

1. **Rapporto dei Test**:
   - Mantieni una solida piramide: 70% Unit Test (veloci, in memoria), 20% Integration Test (con DB e componenti reali), 10% End-to-End (flusso completo utente-interfaccia-backend).
2. **Consumer-Driven Contracts (Pact)**:
   - Quando validi contratti API tra frontend e backend, verifica che i test del consumatore guidino le aspettative del fornitore, prevenendo disallineamenti di campi o formati di date.
3. **Simulazione di Reti Degradate**:
   - Nelle sessioni di collaudo avanzate, simula latenze di rete (100ms - 1500ms), disconnessioni socket e risposte HTTP 429 (Rate Limit) per verificare che l'interfaccia gestisca il backoff e informi l'utente senza bloccarsi.
