# Verification Checklist

## Formula Builder (Multi-Formula)
- Open a client -> Add Service.
- Add a second formula, name both (e.g., Roots, Toner).
- Search a shade by code or name; confirm results update as you type.
- Tap a favorite or recent chip; verify it adds a selection and clears search.
- Adjust amount with +/- and by typing; verify the step matches settings (0.1 oz or 1 g).
- Change ratio part; verify it persists per selection.
- Select a developer per formula; verify strength appears in labels when applicable.
- Override mix ratio; tap Use suggested to revert.
- Confirm summary bar shows total mix amount and total cost.
- Confirm deduction impact appears as a small footnote at the bottom.
- Expand deduction preview; verify per-item amounts and modes are listed.
- Save the service; verify inventory deduction reflects open-stock vs new-unit choice.

## Inventory (Category-First + Tailored Add)
- Open Inventory; confirm category rows appear when not searching.
- Tap Hair Color; verify line sections with expandable shades.
- Tap Lightener; verify grouped items and stock counts.
- Add Inventory -> pick Lightener; fill Brand, Line, Amount, Amount per unit, Price, Mix ratio; save.
- Add Inventory -> pick Developer; fill Brand, Line, Amount, Amount per unit, Price, Strength; save.
- Add Inventory -> pick Treatment; fill minimal fields and save.
- For Hair Color: set line defaults, fast add a shade, then bulk add; confirm queued shades save correctly.
- In category detail, use +/- to adjust stock; verify inventory updates.
- Verify low-stock labels show value and source (Product/Brand/Type).

## Shopping List
- Reduce stock below threshold; verify item appears with correct reason tag.
- Mark item Purchased; verify behavior with auto-restock off (item moves to Purchased).
- Enable auto-restock in Settings; mark another item Purchased and confirm it restocks and disappears.
- Add manual item, set quantity + note, and pin; verify it stays pinned.
- Edit item note/quantity; verify updates persist.
- Check grouping by brand -> line -> type.

## Settings / Management
- Settings -> Product Types: edit a type and confirm ratios update in formula suggestions.
- Settings -> Color Lines: edit a line default ratio and verify it updates in formula suggestions.
- Settings -> Stock Alerts: set brand and type thresholds; verify inventory row labels show new source/value.

## Regression Checks
- Open existing client services; verify legacy formula items still display.
- Open inventory detail view; verify stock badges, cost display, and low-stock source are correct.
- Create a new service with photos; verify before/after images save correctly.
