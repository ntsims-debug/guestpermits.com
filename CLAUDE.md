# guestpermits.com (static site on GitHub Pages)

This repo is the public website for the GuestPermits app: landing page, beta sign-up, support, privacy policy. It is served by GitHub Pages from `main` / root at https://guestpermits.com.

## Never delete these files
- `CNAME` (must contain exactly `guestpermits.com`). If it is missing from `main`, GitHub unlinks the domain and the whole site returns a GitHub 404.
- `.nojekyll`, `favicon.png`, `assets/` (stylesheet, `how-it-works.svg`, `how-it-works.png`), `README.md`.
Do not delete or rename any file unless the owner asked for that specific file.

## Before every commit
1. Run `git fetch origin main` and make sure your copy is up to date with `origin/main`. Never push from a stale copy or a folder that is missing files.
2. Run `git status` and `git diff --stat`. If the stat shows any deleted file, stop and confirm it was asked for.
3. Commit only the files you meant to change.

## After every push (required, do not skip)
1. Wait for the "pages build and deployment" run to finish (check Actions).
2. Check that these return HTTP 200: `https://guestpermits.com/`, `/beta.html`, `/support.html`, `/privacy.html`, and every image, stylesheet and icon they reference. `scripts/check-site.sh` does this.
3. Check that `CNAME` is still in `main`.
4. Report any failure to the owner immediately, before doing other work. Fix a broken deploy before starting anything else.

## Incident, Oct 21, 2026
Commit 4df621d ("Privacy policy: permit count sent to the relay") also deleted `CNAME`, `.nojekyll`, `README.md`, `favicon.png` and both `assets/how-it-works.*` files. guestpermits.com returned a GitHub 404 until the domain was re-saved in Settings → Pages on Oct 23 (the beta sign-up link had been shared with Ansley Park). Files restored in the commit after this note. Cause: the commit was made from a copy of the site that lacked those files.

## Automatic check
`.github/workflows/site-check.yml` runs `scripts/check-site.sh` after each Pages deploy and daily. A failed run emails the repo owner.
