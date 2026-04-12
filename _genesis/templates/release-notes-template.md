---
version: "1.0"
status: draft
last_updated: 2026-04-12
requires: ""
release_version: ""
release_date: ""
---

# Release Notes — v{VERSION}

> Per-version release notes for LTC Project Template. Fill in each section below.
> `requires:` enforces the version chain — downstream repos must be on that version before applying this release.

## Version

`v{VERSION}` — e.g. `v2.1.0`. Matches the git tag and CHANGELOG.md entry for this release.

## Date

`YYYY-MM-DD` — the date this release was tagged and published.

## Requires

Minimum prior template version required before applying this release. If this release can be applied from any version, write `none`. Used by `template-sync.sh` and the migration guide for chain enforcement.

Example: `v2.0.0`

## Summary

2–3 sentence plain-language description of what this release delivers and why it matters to downstream repos. Write for a project manager who will decide whether to adopt this release now or defer.

Example: _This release introduces the template manifest and checkpoint system, enabling downstream repos to track which template version they are on. No breaking changes. Repos on v2.0.0 can apply directly._

## Breaking Changes

List each breaking change as a bullet. If there are none, write `None`.

- `{filename}` — describe what changed and why it is breaking (e.g. renamed, removed, schema change)

Example:
- `scripts/template-sync.sh` — `--base` flag renamed to `--from`; update any CI scripts that call it directly

## Added

New files, scripts, skills, or features introduced in this release. One bullet per item.

- `{path}` — brief description of the new artifact and its purpose

Example:
- `_genesis/templates/template-manifest.yml` — declares canonical file list and expected hashes for version verification
- `scripts/template-release.sh` — automates tagging, changelog skeleton generation, and release notes scaffolding

## Changed

Modifications to existing files. One bullet per item. Note the nature of the change.

- `{path}` — what changed and why

Example:
- `scripts/template-sync.sh` — added `--checkpoint` flag to write `.template-checkpoint.yml` after sync
- `CHANGELOG.md` — added v2.1.0 entry with all artifacts from this release

## Removed

Files, scripts, or features deprecated or deleted in this release. One bullet per item.

- `{path}` — reason for removal and what replaces it (if anything)

Example:
- `scripts/legacy-sync.sh` — superseded by `template-sync.sh --checkpoint`; delete from downstream repos

## Migration Steps

Ordered steps for a downstream repo maintainer to apply this release. Be explicit — assume the reader has not read the DESIGN.md.

1. Confirm your repo is on `requires: v{PRIOR_VERSION}` before proceeding. Run `cat .template-checkpoint.yml` to check.
2. Run `./scripts/template-sync.sh --from v{PRIOR_VERSION} --to v{VERSION} --dry-run` and review the diff.
3. Apply the sync: `./scripts/template-sync.sh --from v{PRIOR_VERSION} --to v{VERSION}`.
4. Resolve any conflicts noted in the dry-run output.
5. {Add any release-specific steps here — e.g. rename a file, update a config value, run a migration script.}
6. Run `./scripts/template-check.sh` to verify the repo passes all structural checks.
7. Commit: `chore(genesis): apply template v{VERSION}`.

## Links

- [[CHANGELOG]]
- [[version-registry]]
- [[versioning]]
