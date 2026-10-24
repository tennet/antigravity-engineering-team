# 🎨 Canone di Design UI/UX, Bento Grid & Sistemi Visivi

> **Riferimento Primario per**: `ui-ux-designer`  
> **Fonti Fondamentali**:  
> - Adam Wathan & Steve Schoger, *Refactoring UI* (Full-Stack Radio)  
> - Steve Krug, *Don't Make Me Think: A Common Sense Approach to Web Usability* (New Riders)  
> - Standard dei Design System: Vercel Geist, Tailwind UI, shadcn/ui, Linear Design Specs

---

## 1. Principi di Architettura Visiva & Spaziatura

1. **Gerarchia Visiva Prima del Colore**:
   - Una schermata deve comunicare la priorità informativa anche se visualizzata in scala di grigi.
   - Non usare colori accesi per differenziare testi secondari; usa variazioni di peso font (`font-medium` vs `font-normal`) e scala di contrasto del testo (`text-zinc-100` vs `text-zinc-400`).
2. **Griglia 4px/8px Baseline**:
   - Tutte le dimensioni, margini e padding devono essere multipli rigorosi di 4px o 8px (`p-2`, `p-4`, `p-6`, `gap-4`, `gap-6`).
   - Evita spaziature arbitrarie (es. `margin: 13px`) che rompono l'armonia ritmica della pagina.
3. **Bento Grid Asimmetrica**:
   - Organizza le dashboard in blocchi modulari con campiture asimmetriche (es. schede primarie a 2 colonne di ampiezza, statistiche secondarie su colonna singola).
   - Ogni scheda (*card*) deve avere confini chiari: sfondo scuro profondo (`#09090b` / `#18181b`), bordo sottile e netto a contrasto controllato (`border-zinc-800`), e raggio di curvatura coerente (`rounded-xl` o `rounded-2xl`).

---

## 2. Palette Dark Mode ad Alto Impatto (Zinc & Cyan)

1. **Evita il Nero Puro (`#000000`) per le Superfici Grandi**:
   - Usa tinte scure neutre graduate per creare profondità e stratificazione:
     - Background pagina: `#09090b` (Zinc 950)
     - Sfondo card/pannelli: `#18181b` (Zinc 900)
     - Sfondo elementi interattivi (input, hover): `#27272a` (Zinc 800)
     - Bordi strutturali: `#3f3f46` (Zinc 700) a bassa opacità
2. **Colore Accento Funzionale**:
   - Usa un colore accento vivace (es. Cyan neon `#06b6d4` / `#22d3ee`) con parsimonia estrema: solo per inviti all'azione (CTA primari), indicatori di stato attivo o focus states.

---

## 3. Micro-Interazioni, Feedback di Stato & Accessibilità

1. **Feedback Istantaneo**:
   - Ogni interazione utente (hover, active, focus, click) deve produrre una risposta visiva immediata con transizioni fluide (durata 150ms-200ms con easing `ease-out`).
2. **I 4 Stati Obbligatori dei Componenti**:
   - Ogni componente che carica o elabora dati deve implementare i 4 stati:
     1. *Loading State*: Skeleton loader ad animazione shimmer (mai spinner isolati che disorientano).
     2. *Empty State*: Grafica pulita, messaggio contestuale chiaro e invito all'azione per iniziare.
     3. *Error State*: Indicazione esatta del problema con possibilità di riprovare (*Retry*).
     4. *Success / Data State*: Presentazione fluida dei dati.
3. **Accessibilità (WCAG AA)**:
   - Rispetta un rapporto di contrasto minimo di 4.5:1 per il testo normale e 3:1 per il testo grande.
   - Tutti i controlli interattivi devono essere navigabili tramite tastiera con `focus-visible:ring-2` evidente.
