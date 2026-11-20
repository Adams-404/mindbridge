# MindBridge landing page

A responsive static landing page. No build system or backend is required.

## Preview
From the repository root:

```bash
cd web
python3 -m http.server 4173
```

Open http://localhost:4173.

## Files
- `index.html` — semantic page structure and content.
- `styles.css` — responsive visual system and layout.
- `script.js` — accessible mobile navigation toggle.

The page uses Google Fonts as a progressive enhancement. System fallbacks are defined. Before production, add a project-owned favicon and social preview image, configure the final domain/canonical URL, and run the accessibility and cross-browser QA issues.

The download CTA intentionally links to the public repository while the app is in development. Replace it with official store/release links only when a tested distribution is available.
