# 📝 Canone di Documentazione Tecnica, Docs-as-Code & Standard Diátaxis

> **Riferimento Primario per**: `documentation-engineer`  
> **Fonti Fondamentali**:  
> - Jared Bhatti, Zachary Sarah Corleissen, Jen Lambourne, David Nunez, Heidi Waterhouse, *Docs for Developers: An Engineer’s Field Guide to Technical Writing* (Apress)  
> - Daniele Procida, *The Diátaxis Documentation Framework* (diataxis.fr)  
> - Standard dei Changelog Semantici (Keep a Changelog & Conventional Commits)

---

## 1. Il Framework Diátaxis (I 4 Quadranti della Documentazione)

La documentazione tecnica non deve mai essere un monolite confuso. Deve essere suddivisa secondo i 4 bisogni dell'utente:

```mermaid
quadrantChart
    title Il Framework Diátaxis per Documentazione Tecnica
    x-axis Teoria Orientata --> Pratica Orientata
    y-axis Acquisizione Conoscenza --> Risoluzione Problemi
    quadrant-1 How-To Guides (Guide Operative per Obiettivi)
    quadrant-2 Tutorials (Percorsi di Apprendimento Passo-Passo)
    quadrant-3 Explanation (Approfondimento Concettuale & Architettura)
    quadrant-4 Reference (Specifiche Tecniche, API & Dictionaries)
```

1. **Tutorials (Orientati all'Apprendimento)**:
   - Guidano un principiante attraverso un percorso completo e sicuro (es. *"Primi Passi: Configura il tuo primo Subagente"*).
2. **How-To Guides (Orientati agli Obiettivi)**:
   - Risolvono un problema pratico specifico in passi numerati (es. *"Come sincronizzare la configurazione tra Mac e Windows con sync.ps1"*).
3. **Reference (Orientati all'Informazione)**:
   - Descrizioni tecniche esatte, parametri, codici di ritorno, schemi di database e flag di configurazione. Niente opinioni, solo fatti tecnici precisi.
4. **Explanation (Orientati alla Comprensione)**:
   - Spiegano *il perché* di una scelta architetturale, i compromessi storici e la visione del sistema (es. *"Perché adottiamo il protocollo dialettico ad anello chiuso invece di un singolo agente"*).

---

## 2. Il Principio Docs-as-Code (Zero Invenzioni)

1. **Onestà Epistemica**:
   - Non documentare mai comportamenti ipotetici o funzionalità non ancora collaudate come se fossero già funzionanti.
   - Ogni comando, opzione o percorso riportato nella documentazione deve essere testato e funzionante.
2. **Documentazione Accanto al Codice**:
   - I file di documentazione risiedono nello stesso repository Git del codice sorgente (`README.md`, `docs/`, `references/`).
   - Le modifiche al codice e gli aggiornamenti della documentazione devono viaggiare insieme nella stessa Pull Request.
3. **Changelog Semantico e Chiaro**:
   - Mantieni un `CHANGELOG.md` leggibile dagli umani suddiviso per versioni semantiche (SemVer `MAJOR.MINOR.PATCH`) con sezioni standard:
     - `Added`: Nuove funzionalità.
     - `Changed`: Modifiche al comportamento esistente.
     - `Fixed`: Risoluzione di bug e difetti.
     - `Security`: Vulnerabilità sanate.
