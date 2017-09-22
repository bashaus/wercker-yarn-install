# Yarn Install

Install Node dependencies via Yarn. Saves cache to the `$WERCKER_CACHE_DIR` for
persistence.

## Notes

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
RFC 2119.

## Sample Usage

    build:
      box: node:latest
      steps:
        - bashaus/yarn-install:
          production: true

&nbsp;

## Step Properties

### clear-cache-on-failed

This script attempts to run `yarn install` three times before failing.
After each failure, should the Yarn cache directory be cleared? Enable
with `true` or disable with `false`.

* Since: `0.0.1`
* Property is `Optional`
* Default value is: `true` (clear cache on failure)
* Recommended location: `Inline`
* `Validation` rules:
  * Must be either `true`, `false`, `1` or `0`

&nbsp;

### production

Whether to install development dependencies. Exclude `devDependencies` with
`true` or include with `false`.

* Since: `0.0.1`
* Property is `Optional`
* Default value is: `true` (exclude `devDependencies`)
* Recommended location: `Inline`
* `Validation` rules:
  * Must be either `true`, `false`, `1` or `0`

&nbsp;

### opts

Any additional options and flags that you would like to pass to Yarn.

* Since: `0.0.1`
* Property is `Optional`
* Recommended location: `Inline`

&nbsp;
