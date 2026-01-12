# New Workflows (Shadey)

## Current Flow Snapshot (pre-change)
- Formula Builder: single-formula only; heavy text; no per-formula naming; developer selection verbose; deduction preview too prominent.
- Inventory: one-size-fits-all add form geared to hair color; lightener/developer fields irrelevant; developer strength hidden; inventory list mixes categories.
- Shopping List: needed clearer grouping, reasons, and in-store actions (manual add/pin/notes).

## Formulas

### Alternatives considered
- A) Multi-formula cards on one screen with inline editing (chosen).
- B) Step-by-step wizard (slower, more taps).
- C) Template-first flow (rejected per requirement).

### Chosen model: Multi-formula Quick Cards
Why it's better
- Multiple named formulas per service (roots, mids, ends, toner).
- One-screen edit with typeahead + favorites + recents keeps input fast.
- Inline amount controls with 0.1 oz / 1 g step.
- Developer suggestion + override stays in context for each formula.
- Total mix amount + total cost stay visible in the summary bar.
- Deduction impact lives in a small footnote with an expandable breakdown.
- Keeps text minimal while still showing key guidance.

Workflow
1. Add service, set details.
2. Add one or more formulas and name each (e.g., Roots, Ends).
3. Search/add products; adjust amounts inline.
4. Pick developer and mix ratio per formula.
5. Review summary bar and deduction footnote; save.

## Inventory

### Alternatives considered
- A) Category-first inventory with tailored add forms (chosen).
- B) Scan-first flow with confirm screen.
- C) Single universal form.

### Chosen model: Category-first + tailored add forms
Why it's better
- Categories reduce scrolling and help find stock faster.
- Hair color keeps line defaults + fast/bulk shade entry.
- Lightener/developer/treatment use minimal fields (no shade-only noise).
- Mix ratio appears only where relevant (lightener).
- Developer strength is visible everywhere it is picked.
- Low-stock thresholds show source (product/brand/type) in rows.
- Inline +/- stock adjustments reduce detail hopping.

Workflow
1. Inventory shows categories (Hair Color, Lightener, Developer, Treatment).
2. Tap a category to see lines/groups and stock.
3. Add inventory: pick category -> fill the tailored form.
4. Hair color uses line defaults + fast/bulk shade queue.
5. Adjust stock in-line or via scan.

## Shopping List

### Alternatives considered
- A) Store-mode grouped list by brand/line/type (chosen).
- B) Depleted vs low-stock board.
- C) Flat list with filters.

### Chosen model: Store-mode grouped list
Why it's better
- Grouping matches how stylists shop (brand -> line -> type).
- Reason tags explain why items appear (depleted, low stock, manual).
- One-tap purchased with optional auto-restock.
- Manual add, pinning, and notes are first-class.
- Thresholds are controlled centrally in settings.

Workflow
1. Items auto-appear from low/depleted stock.
2. List is grouped by brand, line, then type.
3. Mark purchased (auto-restock optional).
4. Add manual items, pin priority, add notes.
5. Tune thresholds in Settings -> Stock Alerts.
