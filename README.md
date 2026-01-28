# NPHD9040 Course Website

This repo is a Quarto website. Rendered output is written to `docs/` (GitHub Pages-friendly).

## Render From CLI (Recommended)

This repo includes a tiny, local (no-admin) toolchain installer using micromamba.

1) Bootstrap Quarto + R + required R packages:

```bash
scripts/bootstrap-env.sh
```

2) Render the site:

```bash
scripts/render.sh
```

After rendering, commit and push the updated `docs/` output as needed.
