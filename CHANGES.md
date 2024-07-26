## 0.0.7 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.6 (2024-03-13)

### Changed

- Uses `expect-test-helpers` (reduce core dependencies)
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

## 0.0.5 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.4 (2024-02-09)

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.

## 0.0.3 (2024-01-18)

### Changed

- Internal changes related to build and release process.

### Removed

- Refactor to remove `Core_kernel` dependencies.

## 0.0.2 (2023-11-03)

### Changed

- Now generating opam file from dune-project.
- Experiment with `command-unix-for-opam`.

## 0.0.1 (2023-11-01)

Initial release
