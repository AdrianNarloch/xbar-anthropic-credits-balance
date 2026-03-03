# xbar-anthropic-credits-balance

macOS [xbar](https://xbarapp.com/) plugin that shows your Anthropic prepaid API credits balance in the macOS menu bar.

## Prerequisites

- macOS with `bash`, `curl`, and `python3` available.
- An Anthropic account with prepaid credits enabled.
- Your Anthropic organization ID and dashboard session key:
  1. Log in to Anthropic Console.
  2. Open DevTools (`View` -> `Developer` -> `Developer Tools`) and go to the `Network` tab.
  3. Find a request to `/api/organizations/<org-id>/prepaid/credits`.
  4. Copy the organization ID from the request URL.
  5. Copy `sessionKey` from request cookies.

## Install

1. Install xbar from https://xbarapp.com/.
2. Download or clone this repository.
3. Copy [`anthropic_balance.1m.sh`](./anthropic_balance.1m.sh) into your xbar plugins folder.
4. Edit [`anthropic_balance.1m.sh`](./anthropic_balance.1m.sh) and set:
   - `ENDPOINT_URL` with your organization ID.
   - `SESSION_KEY` with your Anthropic dashboard session key.
5. Make the script executable:
   ```bash
   chmod +x anthropic_balance.1m.sh
   ```
6. Refresh xbar (or restart the app).

The plugin refreshes every minute (`1m`) and shows the prepaid credit balance (`amount`) returned by Anthropic billing endpoint.
