# Changelog

## Bug Fixes
- Developer ratio suggestions now respect product defaults before type defaults.
- Inventory grouping no longer labels non-line products as Unassigned.
- Low-stock thresholds display their source (product, brand, type) consistently.

## Workflow Redesigns
- Multi-formula Service Editor with named formulas and per-formula developer selection.
- Category-first inventory browsing with drill-down sections.
- Tailored add flows for lightener, developer, and treatment inventory.
- Store-ready shopping list grouped by brand, line, and type with manual add/pin flow.

## UX/UI Polish
- Developer picker labels now include strength where applicable.
- Summary bar shows total mix amount alongside total cost.
- Deduction impact moved to a lightweight footnote with expandable details.
- Formula developer copy reduced to essentials.

## Architecture
- Added `ServiceFormula` Core Data entity and relationships for multi-formula services.
- Added `InventoryCategory` modeling and category summaries.
- Stock alert settings now expose source details for UI consistency.
- Removed formula templates from the data layer and UI.

## Performance
- Reduced inventory list scanning by prioritizing category summaries.

## Tests
- Updated service deduction tests for multi-formula drafts.
