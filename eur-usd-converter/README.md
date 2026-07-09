# EUR ⇄ USD Converter

A single-page currency converter. Enter an amount in either the EUR or USD
field and the other field updates automatically using the current
EUR→USD exchange rate.

## Features

- Live exchange rate fetched from [open.er-api.com](https://www.exchangerate-api.com/docs/free) (no API key required).
- Falls back to a fixed rate if the rate service is unreachable.
- Manual refresh button to re-fetch the latest rate.

## Usage

Open `index.html` in a browser, or serve the folder locally:

```sh
cd eur-usd-converter
python3 -m http.server 8000
```

Then visit `http://localhost:8000`.
