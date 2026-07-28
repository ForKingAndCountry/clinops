# ClinOps — Design Prompt (for your editor / Claude Code)

This is a **branding-specific design prompt**, meant to replace the generic token section in
`UI_Generation_Prompt.md` now that you've settled on the name **ClinOps**. Paste the block
below into your editor's AI (Claude Code, Cursor, etc.) when you're ready to actually skin
the UI — either right after the navigation shell is scaffolded, or as a follow-up pass on
what's already built.

It's opinionated on purpose: a system this operational shouldn't look like a generic admin
template or a default AI-generated theme. The direction below is built specifically around
what ClinOps is and who uses it, not a reusable template.

---

## Design Brief (context — don't skip this, it's what the prompt below is derived from)

- **Subject:** ClinOps — an offline-first clinical operations system running OPD and IPD
  workflows end-to-end, from patient registration through discharge, plus automated MoH
  BPHS reporting, for private clinics and hospitals in Liberia.
- **Audience:** three very different viewers matter —
  1. Clinic staff (reception, nurses, doctors, pharmacists, billing officers) — busy,
     not tech-savvy, using the system all day on modest hardware.
  2. Clinic owners/administrators and MoH reviewers — need to trust the system with
     revenue and compliance data at a glance.
  3. Prospective pilot clients seeing a demo for the first time — this needs to look
     credible and considered within the first 10 seconds on screen.
- **The system's single job, visually:** make it obvious, at every screen, that a patient's
  information is never lost and every order is unambiguous — the UI itself should feel
  like proof of those two claims, not just describe them.
- **Signature idea — "The Thread":** the real product mechanic is a patient moving through
  a connected sequence of stations (Reception → Vitals → Doctor → Lab → Pharmacy →
  Billing → Discharge). That connected, continuous line is literally what the system does,
  so it becomes the one signature visual motif — a subtle flowing/connecting line used in
  the logo mark, status progression indicators, and empty/loading states. It should show up
  once, deliberately, per screen — not as a background texture everywhere.

---

## The Prompt

```
Apply a distinctive, brand-specific visual design to the ClinOps Flutter app, replacing any
placeholder/default Material styling. Do not reach for generic AI-design defaults — no warm
cream background with terracotta accents, no near-black background with a single neon
accent, no broadsheet/hairline-rule newspaper layout. This needs to look like it was
designed specifically for a Liberian clinical operations product, not a template.

BRAND CONTEXT:
ClinOps is an offline-first system that runs a clinic's full patient journey — registration,
queueing, consultation, lab, pharmacy, billing, and inpatient care — and automatically
generates Ministry of Health compliance reports. Its two defining promises are: patients are
always findable (never lose the chart), and clinical orders are always unambiguous (never
misread). The audience ranges from busy clinical staff on old hardware to MoH reviewers and
prospective pilot clients seeing it for the first time. The tone should read as calm,
precise, and trustworthy — operational infrastructure, not a consumer health app.

DESIGN TOKEN SYSTEM (use these, don't substitute a generic palette):

Color — a deep, desaturated petrol/teal as the primary brand color (evokes clinical trust
without being a generic hospital blue), a warm ochre/gold as the single accent color used
sparingly for primary actions and the signature motif (distinct from typical AI-default
terracotta — lean more gold/amber than clay), and a warm off-white (not stark white, not
cream-beige) neutral background. Concretely:
  - Primary (Petrol): #0F4C4C — used for nav shell, headers, primary structure
  - Primary Dark: #0A3535 — hover/pressed states, dark-mode base if needed
  - Accent (Ochre): #C98A2C — primary buttons, the signature thread motif, key highlights
    only — this color should feel earned/rare on screen, not everywhere
  - Neutral Background: #F7F5F1 — warm off-white, not pure white, not beige-cream
  - Neutral Surface: #FFFFFF — cards/panels sitting on the background
  - Neutral Ink: #1C2624 — primary text, a near-black with a slight green undertone to
    harmonize with the petrol, not pure black
  - Neutral Muted: #6B7674 — secondary text, captions, placeholder text
  - Semantic Success (paid/cleared): #2E7D5B
  - Semantic Warning (pending/awaiting): #C98A2C (reuse the accent — pending states are
    literally "on the thread," which reinforces the motif)
  - Semantic Danger (unpaid/blocked): #B3402C
  - Semantic Info (in-progress): #2E6E8E

Type — pair a slightly technical, structured grotesk for headings/UI chrome with a
humanist sans for body copy, plus a monospace utility face for anything identity-critical:
  - Display/Heading face: Space Grotesk (or General Sans if available) — used for section
    titles, station names, and dashboard numbers. Gives the system a precise, "operational"
    character without being cold.
  - Body face: Inter or IBM Plex Sans — used for all body text, form labels, table content.
    Chosen for legibility at small sizes on low-DPI station monitors, not for personality.
  - Utility/Data face: IBM Plex Mono or JetBrains Mono — used specifically for hospital IDs,
    timestamps, and structured prescription values (dose/route/frequency). Using a
    monospace face here is a deliberate design choice, not decoration: it visually signals
    "this is exact, structured data" and reinforces the no-ambiguity promise wherever a
    prescription or ID appears.
  - Type scale: define clear Display / H1 / H2 / Body / Label / Caption sizes with
    intentional weight differences (Space Grotesk Medium/Semibold for headings, Inter
    Regular/Medium for body) rather than relying on size alone to create hierarchy.

Layout & spacing — 8px base spacing scale (8/16/24/32/48), 6px corner radius on cards and
inputs (soft but not pill-shaped — this is operational software, not a consumer app),
1px hairline borders in a muted neutral rather than heavy drop shadows for card separation.

Signature element — "The Thread": a thin, continuous connecting line (in the ochre accent)
that visually links sequential steps wherever the product shows a progression:
  - The station queue view: a subtle connecting line running behind/through the
    RECEPTION → VITALS → DOCTOR → LAB → PHARMACY → BILLING → DISCHARGE stage indicators.
  - The patient chart timeline: the same thin line connecting chronological visit entries.
  - Logo/wordmark: "ClinOps" set in the display face, with a small thread-line flourish
    integrated into or underlining the mark (keep this simple — a single elegant line, not
    an elaborate icon).
  - Use this motif ONCE per screen, deliberately, as the memorable signature — do not turn
    it into a repeating background pattern or apply it decoratively elsewhere.

VOICE & COPY (apply to every label, button, empty state, and error message):
- Name things by what staff actually do: "Find Patient," not "Query Records." "Add
  Payment," not "Submit Transaction."
- Buttons and their resulting confirmations share the same verb: a "Discharge Patient"
  button that succeeds should confirm "Patient discharged," not "Operation complete."
- Empty states are invitations to act, not apologies: e.g., the Find Patient no-results
  state should read something like "No matching patient — register them as new?" with a
  direct action, not "No records found."
- Errors state what happened and what to do, plainly: e.g., "Cannot discharge — GLD 1,200
  balance still due" rather than a generic "Action failed."
- Keep everything in plain, sentence-case, conversational-but-precise language — this is
  read by busy clinical staff mid-shift, not browsed leisurely.

APPLY TO THESE SCREENS FIRST (highest demo visibility):
1. Login screen — establishes first impression; feature the ClinOps wordmark/thread motif
   clearly here.
2. Find Patient / search results — the #1 differentiator screen, make it feel fast and
   precise (Utility/mono face for the hospital ID in results is a good place to reinforce
   the design's exactness).
3. Station Queue view — this is where the Thread motif does its clearest work.
4. Doctor Console structured order builder — mono face for dose/route/frequency values,
   strong visual separation between structured orders and free-text notes.
5. Ward/Bed dashboard — color-coded bed status using the semantic palette above.

PROCESS: before writing any code, write out a short confirmation of the token system above
in your own words (colors as named hex values, type roles, the signature element) and check
it doesn't drift toward generic defaults. Then apply it consistently — derive every color
and type choice used anywhere in the app from this token set, don't introduce ad hoc colors
per screen. Build to a quality floor: responsive down to mobile/tablet sizing already
defined in the design system prompt, visible keyboard focus states, and reduced-motion
respected for any animation on the Thread motif or transitions.

After implementing, take a screenshot of the Login and Station Queue screens and critique
them against this brief: does this look like it was designed specifically for ClinOps, or
could it be any admin dashboard with the labels changed? Revise anything that reads as
generic before moving on to the remaining screens.
```

---

## Notes for you

- This prompt assumes the **structural** design system (shared widgets, navigation shell,
  responsive rules) from `UI_Generation_Prompt.md` is already in place — this pass is about
  *skinning* that structure with ClinOps-specific brand decisions, not rebuilding it.
- If your editor's output still leans generic after this prompt, the sharpest follow-up is:
  *"Show me the Thread motif on the Station Queue screen specifically — right now it doesn't
  read as a deliberate signature element, make it more visible without turning it into
  decoration."*
- The gold/ochre accent is deliberately used sparingly (primary actions + the Thread motif
  only) — if it starts showing up on every button and badge, ask your editor to pull it back
  and reserve petrol/neutral tones for everything that isn't a primary action.
- Worth testing the palette against real Liberian daylight/screen-glare conditions if
  possible — ask whoever's demoing to view it on the actual pilot-site hardware before
  finalizing, since color perception can shift a lot on older/cheaper monitors.
