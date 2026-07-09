const eurInput = document.getElementById("eur");
const usdInput = document.getElementById("usd");
const rateText = document.getElementById("rate-text");
const updated = document.getElementById("updated");
const refreshBtn = document.getElementById("refresh");

const RATE_API = "https://open.er-api.com/v6/latest/EUR";
const FALLBACK_RATE = 1.08; // used only if the live rate can't be fetched

let eurToUsd = FALLBACK_RATE;
let lastEdited = "eur";

function formatAmount(value) {
  if (!Number.isFinite(value)) return "";
  return value.toFixed(2);
}

function parseAmount(text) {
  const value = parseFloat(text.replace(",", "."));
  return Number.isFinite(value) ? value : null;
}

function convertFromEur() {
  const amount = parseAmount(eurInput.value);
  usdInput.value = amount === null ? "" : formatAmount(amount * eurToUsd);
}

function convertFromUsd() {
  const amount = parseAmount(usdInput.value);
  eurInput.value = amount === null ? "" : formatAmount(amount / eurToUsd);
}

function reconvert() {
  if (lastEdited === "usd") {
    convertFromUsd();
  } else {
    convertFromEur();
  }
}

eurInput.addEventListener("input", () => {
  lastEdited = "eur";
  convertFromEur();
});

usdInput.addEventListener("input", () => {
  lastEdited = "usd";
  convertFromUsd();
});

async function fetchRate() {
  refreshBtn.disabled = true;
  rateText.textContent = "Loading exchange rate…";
  try {
    const response = await fetch(RATE_API, { signal: AbortSignal.timeout(6000) });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    const rate = data?.rates?.USD;
    if (!Number.isFinite(rate)) throw new Error("Missing USD rate in response");

    eurToUsd = rate;
    rateText.textContent = `1 EUR = ${rate.toFixed(4)} USD`;
    updated.textContent = `Updated ${new Date().toLocaleTimeString()}`;
  } catch (err) {
    rateText.textContent = `1 EUR = ${FALLBACK_RATE.toFixed(4)} USD (offline rate)`;
    updated.textContent = "Could not reach the rate service — using a fallback rate.";
  } finally {
    refreshBtn.disabled = false;
    reconvert();
  }
}

refreshBtn.addEventListener("click", fetchRate);

eurInput.value = "100";
fetchRate();
