# Package Checker

Checks for packages within Building Link using the Building Link API.

It also calls the carrier API, when it can, to figured out who the package is from.

## Usage

1. Create a file `.env`
2. Add the following to the `.env` file in the form of `KEY=VALUE`:
  * `BL_USERNAME`
  * `BL_PASSWORD`
  * `UPS_LOGIN`
  * `UPS_KEY`
  * `UPS_PASSWORD`
3. Run `script/check`

## Project status

Initial proof of concept. May or may not work.
