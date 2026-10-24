# 🏛️ Canone di Architettura del Software & Sistemi Distribuiti

> **Riferimento Primario per**: `software-architect`  
> **Fonti Fondamentali**:  
> - Martin Kleppmann, *Designing Data-Intensive Applications* (O'Reilly)  
> - Mark Richards & Neal Ford, *Fundamentals of Software Architecture* (O'Reilly)  
> - Gregor Hohpe, *Enterprise Integration Patterns* (Addison-Wesley)

---

## 1. Principi di Partizionamento, Consistenza & CAP

Quando progetti architetture distribuite o ad alto volume, adotta le seguenti euristiche non negoziabili:

1. **Trade-off CAP & PACELC**:
   - In presenza di partizione di rete ($P$), scegli esplicitamente tra Consistenza ($C$) o Disponibilità ($A$).
   - Anche in assenza di partizioni ($E$), valuta il trade-off tra Latenza ($L$) e Consistenza ($C$). Non promettere mai sistemi "istantanei e fortemente consistenti ovunque" senza motivare il costo in latenza.
2. **Linearizzabilità vs Eventual Consistency**:
   - Riserva la consistenza forte (Linearizzabilità) esclusivamente per transazioni finanziarie, allocazione scorte e lock distribuiti.
   - Per feed, notifiche e aggregazioni analitiche, adotta *Eventual Consistency* con versionamento esplicito (Vector Clocks o timestamp logici di Lamport) per evitare Two-Phase Commit bloccanti.
3. **Idempotenza & Deduplicazione alla Sorgente**:
   - Ogni endpoint di mutazione deve accettare un `Idempotency-Key` (UUIDv4) o calcolare un checksum crittografico del payload per prevenire elaborazioni duplicate causate da retry di rete.

---

## 2. Contratti API & RFC Standards

1. **Specifiche Rigide**: Ogni contratto deve essere formalizzato in OpenAPI 3.1 o protobuf/gRPC con tipi esatti (nessun `any` o `object` non strutturato).
2. **Gestione Errori Standardizzata (RFC 7807 / RFC 9457)**:
   - Ogni errore API deve restituire `application/problem+json`:
     ```json
     {
       "type": "https://api.example.com/errors/resource-locked",
       "title": "Resource Lock Conflict",
       "status": 409,
       "detail": "The requested memory node is currently being re-indexed by another worker.",
       "instance": "/v1/nodes/7841",
       "code": "NODE_MUTATION_LOCKED"
     }
     ```
3. **Evolutionary Architecture & Versionamento**:
   - Preferisci il versionamento tramite prefisso di percorso (`/v1/`, `/v2/`) o header di negoziazione.
   - Non applicare *breaking changes* a contratti esistenti: deprecate prima i campi non più usati con preavviso formale.

---

## 3. Architecture Decision Records (ADR)

Ogni scelta architetturale strutturata deve essere documentata secondo il pattern ADR:
- **Titolo**: `ADR-XXX: Breve descrizione della decisione`
- **Stato**: `Proposto | Approvato | Superato | Respinto`
- **Contesto**: Il problema tecnico, i vincoli e le forze in gioco.
- **Decisione**: La scelta intrapresa con diagramma Mermaid associato.
- **Conseguenze**: Benefici acquisiti e rischi/debiti tecnici accettati coscientemente.
