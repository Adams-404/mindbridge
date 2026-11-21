# MindBridge Web

A responsive React + TypeScript web application powered by Vite. Features both the public landing page and an interactive web prototype of MindBridge AI, ready to expand into the full web application.

## Quickstart

From the repository root:

```bash
cd web
npm install
npm run dev
```

Open http://localhost:4173.

## Scripts

- `npm run dev` — start the Vite development server (port 4173).
- `npm run build` — build typechecked production bundle into `dist/`.
- `npm run preview` — locally preview the production build.
- `npm test` — run Vitest component and accessibility tests.
- `npm run typecheck` — run TypeScript compiler checks without emitting files.

## Architecture

```
web/
├── index.html              # HTML entry point with metadata, Google Fonts, and favicon
├── public/                 # Static assets (brand SVG favicon, illustrations)
├── src/
│   ├── App.tsx             # Root component managing view modes and routing
│   ├── main.tsx            # React DOM mounting entry point
│   ├── components/
│   │   ├── landing/        # Hero, Features, WhySection, LanguageSection, Safety, Steps, Faq, Download
│   │   ├── layout/         # Header (with bilingual EN/HA toggle and mobile drawer) and Footer
│   │   └── app/            # Interactive Web Prototype (Home, Learn, Check-in, Reset, Support, Settings)
│   ├── data/               # Learning articles, FAQ, mood options, and EN/HA translation dictionaries
│   ├── styles/             # Modular CSS design tokens matching the MindBridge brand system
│   ├── test/               # Vitest + React Testing Library suites
│   └── types/              # TypeScript models and interfaces
└── vite.config.ts          # Vite and Vitest configuration
```

## Accessibility & Localization

- Built following WCAG 2.2 AA standards: semantic landmarks, skip link, visible focus indicator, ARIA expanded states on mobile drawer and FAQ accordions.
- First-class English and Hausa language switcher in the header and settings.
- Motion-reduced setting and prefers-reduced-motion queries supported.

## Deployment

Build the static output:
```bash
npm run build
```
The output directory is `dist/` and can be deployed directly to Vercel, Netlify, Cloudflare Pages, or GitHub Pages.
