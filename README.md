![KnightBase logo — moonlit owl artwork](https://github.com/o-rnob/Knightbase-DB/raw/main/logo.png)

# KnightBase DB — Bangladesh's Biggest Open-Source Financial Asset Records and Database

[#knightbase](#knightbase)

**Financial Asset Records and Database — by Ow1nomics**

![License: MIT](https://img.shields.io/badge/license-MIT-green)
![SQLite](https://img.shields.io/badge/database-SQLite3-003B57)
![Dhaka Stock Exchange](https://img.shields.io/badge/market-DSE%20%2F%20CSE-orange)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android-informational)

KnightBase is a consolidated, queryable SQLite database of **Dhaka Stock Exchange (DSE)** and **Chittagong Stock Exchange (CSE)** price history, the **DSEX and DS30 benchmark indices**, **Bangladesh macroeconomic indicators** (CPI, FX reserves, exchange rates, remittances), and **DSE corporate-action disclosures**. It is built for analysts, quants, students, journalists, and developers who need reliable, source-attributed historical data on the Bangladesh capital market — and it is designed to be queried directly by both humans and AI assistants.

If you are searching for **Dhaka Stock Exchange historical data**, a **Bangladesh stock market SQLite database**, **DSEX / DS30 index data**, or an **open-source Bangladesh financial dataset**, this repository is built for exactly that use case.

---

## Table of contents

[#table-of-contents](#table-of-contents)

- [What this is](#what-this-is)
- [Quick stats](#quick-stats)
- [Getting the database](#getting-the-database)
- [How to use KnightBase](#how-to-use-knightbase)
  - [Linux](#linux)
  - [macOS](#macos)
  - [Windows](#windows)
  - [Android](#android)
  - [Using KnightBase with Python / pandas](#using-knightbase-with-python--pandas)
  - [Using KnightBase with an AI assistant](#using-knightbase-with-an-ai-assistant)
- [Schema](#schema)
- [Known gaps](#known-gaps-read-this-before-trusting-a-0-rows-returned)
- [Sources & attribution](#sources--attribution)
- [Citation](#citation)
- [A note on the name](#a-note-on-the-name)

---

## What this is

[#what-this-is](#what-this-is)

`knightbase.db` is a single SQLite file consolidating multiple public data sources on the Dhaka Stock Exchange and the Bangladeshi macroeconomy into one queryable schema. It is built with one rule above all others:

> **Every skip, every conflict, every rename, and every known gap is logged and queryable — nothing is silently fixed, averaged, or guessed at.**

If a number looks wrong, you can query `data_quality_log` and find out exactly why it's there, or why it isn't.

## Quick stats

[#quick-stats](#quick-stats)

|                                        |                                                                                                                                |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Price rows                             | 2,566,157                                                                                                                      |
| Unique tickers (all sources combined)  | ~870 (raw identifiers; not deduplicated across ID systems — see Known Gaps)                                                    |
| Price coverage                         | 1999-01-10 → 2026-08-06 (with a documented gap; see below)                                                                     |
| DSEX / DS30 index coverage             | 2013-01-30 → 2026-08-06, no gaps                                                                                               |
| Corporate action snapshots             | 2 dated snapshots: 2020-12-06 and 2026-08-02                                                                                   |
| Macro coverage                         | Bangladesh CPI 1987–2025 (World Bank); Bangladesh Bank CPI/FX/exchange-rate/remittances 1973–2021 + live FX reserves 2024–2026 |
| Data quality log entries               | 463                                                                                                                            |

---

## Getting the database

[#getting-the-database](#getting-the-database)

Clone the repository, or download `knightbase.db` directly from the repo's file listing:

```bash
git clone https://github.com/o-rnob/Knightbase-DB.git
cd Knightbase-DB
```

The database ships as a single portable `.db` file — no server, no external dependencies, and no installation of a database engine beyond the standard SQLite3 library, which most operating systems already include.

---

## How to use KnightBase

[#how-to-use-knightbase](#how-to-use-knightbase)

KnightBase is a **standard SQLite3 file**, so it works anywhere SQLite runs — desktop, laptop, server, or mobile. Pick your platform below.

### Linux

[#linux](#linux)

Most distributions ship with SQLite3 pre-installed. If it isn't available, install it with your package manager:

```bash
# Debian / Ubuntu
sudo apt update && sudo apt install sqlite3

# Fedora
sudo dnf install sqlite

# Arch
sudo pacman -S sqlite
```

Open the database and run a query:

```bash
sqlite3 knightbase.db
sqlite> SELECT ticker, date, close FROM prices WHERE ticker = 'ACI' ORDER BY date DESC LIMIT 10;
sqlite> .quit
```

For a graphical interface, install **DB Browser for SQLite**:

```bash
sudo apt install sqlitebrowser   # Debian/Ubuntu
sudo dnf install sqlitebrowser   # Fedora
```

### macOS

[#macos](#macos)

macOS includes SQLite3 by default. Open a terminal and run:

```bash
sqlite3 knightbase.db
sqlite> SELECT * FROM dsex_index ORDER BY date DESC LIMIT 5;
sqlite> .quit
```

If you prefer a newer version or a GUI, install via Homebrew:

```bash
brew install sqlite3
brew install --cask db-browser-for-sqlite
```

### Windows

[#windows](#windows)

**Option 1 — SQLite command-line tools:**

1. Download the `sqlite-tools` ZIP for Windows from [sqlite.org/download.html](https://sqlite.org/download.html).
2. Extract it and add the folder to your `PATH`, or run `sqlite3.exe` directly from the extracted folder.
3. Open the database:

```powershell
sqlite3.exe knightbase.db
sqlite> SELECT ticker, close FROM prices WHERE date = '2026-08-06' LIMIT 20;
sqlite> .quit
```

**Option 2 — DB Browser for SQLite (recommended for beginners):**
Download the installer from [sqlitebrowser.org](https://sqlitebrowser.org), install it, then open `knightbase.db` via **File → Open Database**. This gives you a spreadsheet-style view of every table plus a built-in query editor — no command line required.

**Option 3 — Windows Subsystem for Linux (WSL):**
If you have WSL installed, follow the [Linux instructions](#linux) inside your WSL distribution for the full command-line experience.

### Android

[#android](#android)

KnightBase can be queried directly on an Android device using **Termux**, a free terminal emulator available on F-Droid and the Play Store:

1. Install [Termux](https://f-droid.org/en/packages/com.termux/).
2. Install SQLite and Git inside Termux:

```bash
pkg update && pkg install sqlite git
```

3. Clone the repository and query the database:

```bash
git clone https://github.com/o-rnob/Knightbase-DB.git
cd Knightbase-DB
sqlite3 knightbase.db
sqlite> SELECT COUNT(*) FROM prices;
sqlite> .quit
```

For a no-code option, apps like **DB Browser** or generic **SQLite Viewer** apps on the Play Store can open `knightbase.db` for browsing and simple queries without a terminal.

### Using KnightBase with Python / pandas

[#using-knightbase-with-python--pandas](#using-knightbase-with-python--pandas)

Python's standard library includes SQLite support, making KnightBase ideal for data analysis and backtesting workflows:

```python
import sqlite3
import pandas as pd

conn = sqlite3.connect("knightbase.db")

df = pd.read_sql_query(
    "SELECT date, close FROM dsex_index ORDER BY date",
    conn
)

print(df.tail())
conn.close()
```

This works identically on Linux, macOS, and Windows, and on Android via Termux with `pip install pandas`.

### Using KnightBase with an AI assistant

[#using-knightbase-with-an-ai-assistant](#using-knightbase-with-an-ai-assistant)

Because KnightBase is a plain, self-contained SQLite file, it is well suited to being queried by AI coding assistants and LLM agents rather than only by hand-written SQL. A few practical ways to connect an AI assistant to KnightBase:

**Claude Code / Cursor / other coding agents with file access:**
Point the agent at the cloned repository and ask it directly, e.g. *"Open knightbase.db and show me ACI's closing price history for 2024."* Coding agents with a sandboxed shell can run `sqlite3` or Python against the file the same way a human would, following the platform instructions above.

**Claude, ChatGPT, or other chat assistants with file upload / code execution:**
Upload `knightbase.db` directly into a conversation that supports file analysis or code execution, then ask natural-language questions such as *"What was DSEX's highest closing value in 2025?"* or *"List all tickers with more than 500,000 BDT average daily volume in the last year."* The assistant can write and run the underlying SQL for you.

**Model Context Protocol (MCP):**
KnightBase works out of the box with any MCP-compatible **SQLite server** (for example, the official `mcp-server-sqlite` reference server). Point the server at the local `knightbase.db` path, connect it to an MCP-aware client, and query the database using natural language while retaining full auditability of the underlying SQL.

**Retrieval-augmented generation (RAG) and analytics pipelines:**
Because every table is documented with explicit column meanings and a dedicated `data_quality_log`, KnightBase is straightforward to wire into LangChain's `SQLDatabase` toolkit, LlamaIndex's SQL query engine, or any custom text-to-SQL pipeline — the schema comments and known-gaps documentation below are written so an LLM can reason about data reliability, not just table structure.

> **Tip for AI-assisted queries:** always ask the assistant to check `data_quality_log` and `price_conflicts` alongside `prices` before treating a result as final — this mirrors the manual best practice described in [Known gaps](#known-gaps-read-this-before-trusting-a-0-rows-returned) below.

---

## Schema

[#schema](#schema)

### `prices`

[#prices](#prices)

The unified price table. Every source lands here with a `source` tag — nothing is merged or overwritten across sources.

| column                          | type    | notes                                                                              |
| -------------------------------- | ------- | ----------------------------------------------------------------------------------- |
| ticker                           | TEXT    | raw identifier as given by the source (see "Ticker identity" below)                |
| date                              | TEXT    | ISO YYYY-MM-DD                                                                      |
| open, high, low, close, volume   | REAL    | nullable — some sources (Eikon) provide close only                                 |
| source                            | TEXT    | which pipeline this row came from                                                  |
| adjusted                          | INTEGER | 1 only for the 8 genuinely split/dividend-adjusted tickers; 0 for everything else   |

**Sources present in `prices`:**

| source value                        | rows    | tickers | date range               | notes                                                                      |
| ------------------------------------ | ------- | ------- | -------------------------- | ----------------------------------------------------------------------------- |
| `dse_archive_unadjusted`             | ~1.07M  | 505     | 1999–2020                  | original audited base                                                        |
| `dse_archive_adjusted`               | ~14K    | 8       | 2012–2020                  | only tickers with genuine split/dividend adjustment                          |
| `prices_eikon` (Refinitiv)           | ~1.35M  | 364     | 2003–2023                  | **close price only**, RIC-style identifiers                                  |
| `bdshare_gap_2025_2026`              | 113,829 | 361     | 2025-04-09 → 2026-08-06     | fills the 2020→2025 gap for existing tickers                                 |
| `bdshare_new_companies_2024_2026`    | 16,660  | 35      | 2024-08-11 → 2026-08-06     | companies with no prior history in this DB — **see cap limitation below**    |

### `price_conflicts`

[#price_conflicts](#price_conflicts)

Schema ready for use: `(ticker, date, source_a, value_a, source_b, value_b, pct_diff, resolved)`. **Currently 0 rows** — this is expected, not a bug: the sources currently loaded don't share overlapping ticker+date pairs (archive ends 2020, gap-fill starts 2025, Eikon uses a different identifier system entirely). If a future source overlaps an existing one, close-price disagreements >0.5% populate here unresolved, for manual review — the pipeline never auto-picks a winner or averages.

### `ticker_renames`

[#ticker_renames](#ticker_renames)

5 confirmed DSE code changes found during this build (old LTD-style code → new PLC-style code): `ONEBANKLTD→ONEBANKPLC`, `NPOLYMAR→NPOLYMER`, `BSCCL→BSCPLC`, `SALVOCHEM→SALVO`, `LHBL→LHB`. Gap-fill price data for these is stored under the **old** code for consistency with the archive.

### `dsex_index`, `ds30_index`

[#dsex_index-ds30_index](#dsex_index-ds30_index)

Clean daily OHLCV for the two DSE benchmark indices, 2013-01-30 → 2026-08-06. No gaps, no dupes.

### `cpi_bangladesh_annual`

[#cpi_bangladesh_annual](#cpi_bangladesh_annual)

World Bank annual CPI inflation, Bangladesh only, 1987–2025. Labeled `annual_partial_macro_worldbank` deliberately — this is inflation only, not general macro data.

### `bb_macro_annual`

[#bb_macro_annual](#bb_macro_annual)

Bangladesh Bank's own annual series: CPI (point-to-point, 2005 base), FX reserves (end-period, million USD), exchange rate (buying rate + weighted average, Tk/USD), remittances (million USD and Tk crore). 1973–2021 depending on series. Labeled `annual_partial_macro_bangladeshbank`.

### `bb_fx_reserves_monthly`

[#bb_fx_reserves_monthly](#bb_fx_reserves_monthly)

Live-pulled from Bangladesh Bank's current FX reserve page. Monthly, gross + BPM6 basis, **July 2024 → June 2026 only** — see gap note below.

### `corporate_action_snapshots`

[#corporate_action_snapshots](#corporate_action_snapshots)

Two dated, point-in-time snapshots — **not a continuous time series**:

- `2020-12-06`: 235 companies (reconstructed from a Markdown export; see caveat below)
- `2026-08-02`: 81 companies (extracted directly from the source PDF's real table structure — high confidence)

### `eikon_securities`, `data_quality_log`

[#eikon_securities-data_quality_log](#eikon_securities-data_quality_log)

Carried forward from the original audited `dse_master.db`, extended with 180 new entries from this build (gap tickers, cap limitations, corrupted-source exclusion, parsing caveats — see below).

---

## Known gaps (read this before trusting a "0 rows returned")

[#known-gaps-read-this-before-trusting-a-0-rows-returned](#known-gaps-read-this-before-trusting-a-0-rows-returned)

**Ticker identity is not unified across sources.** Archive uses plain DSE trading codes (`ACI`), Eikon uses RIC-style identifiers (`ACIF.DH(P)`), and no mapping table links them. A query for "ACI's full 1999–2026 history" will only return the archive+gap-fill rows, not Eikon's, unless you know to check both identifier systems.

**112 tickers have no data anywhere from 2020 to 2026.** These traded at some point in the archive (1999–2020) but returned nothing when queried for 2025–2026 — confirmed via repeated retries, not a network fluke. Query `data_quality_log WHERE issue='no_data_apr2025_aug2026'` for the full list and whether each was already dead before the archive ended (`suspended_or_delisted_before_archive_end_2020`) or went dark sometime after (`suspended_or_delisted_after_archive_end_2020`).

**35 "new company" tickers only have data back to August 2024**, even for companies that plausibly existed earlier — this is a confirmed limitation of the `bdshare` library's `get_hist_data` function, which silently caps historical range at ~476 trading days regardless of the requested start date (verified by testing it against `ONEBANKPLC`, a ticker known to have data back to 1999). **This means "no data before Aug 2024" is not proof the company didn't trade before then** — it's proof the tool wouldn't return it. Full manual backfill via `dsebd.org`'s own archive tool, one ticker at a time, remains undone.

**Macro data has a 2021–2024 hole.** Bangladesh Bank's own downloadable historical file and "monthly trends" file (despite its name) both stop at FY2020-21. The live FX-reserves page only goes back to July 2024. Nothing currently in this database covers CPI, FX reserves, or exchange rate for that ~3-year window.

**No usable interest/policy rate series.** Bangladesh Bank publishes bond-level instrument data (individual ISINs, coupon rates, issue dates) rather than a clean policy-rate time series, and their live interest-rate page is a query form (one month/year at a time), not bulk-exportable. Not collected.

**Corporate actions beyond the two snapshot dates: not collectable retroactively.** DSE doesn't publish a historical AGM/dividend feed — only current notices. The two snapshots here are the only two "photographs" available; the gap between Dec 2020 and Aug 2026 cannot be filled after the fact.

**Fundamentals (balance sheet, income statement) are not in this database.** They live in a separate companion repo, [Datanest](https://github.com/o-rnob/Datanest), covering 11 DSE-listed banks.

**The Dec 2020 AGM snapshot was reconstructed from a Markdown table export**, not a clean table extraction like the 2026 PDF snapshot — a small number of rows may have fields shifted (e.g., a shareholding percentage landing in the `time` column) where a company's record had unusual extra or missing fields. The Aug 2026 snapshot came from direct PDF table extraction and is high-confidence.

**One uploaded source was corrupted and excluded entirely, not repaired or guessed at:** a `merged.csv` covering the "Unadjusted Data" folder of a secondary historical zip had 504 of 505 per-ticker files completely empty, with all ~1.1M data rows dumped under a mislabeled `ZEALBANGLA` section containing values (~1,800) far too high to be that company's actual stock price — almost certainly an index series mislabeled during export. Logged in `data_quality_log`, not included in `prices`.

**Index/sector aggregate rows were mixed into the original archive source and have been excluded**, not silently kept: 30,192 rows tagged as index-level (`DSEX`, `DS30`, `Index_00DSEGEN`...) or sector-aggregate (`Sector_Bank`, `Sector_Insurance`...) data were sitting in what should have been a pure per-company price table. These are logged, not deleted from history — just kept out of `prices` to avoid polluting per-ticker queries.

---

## Sources & attribution

[#sources--attribution](#sources--attribution)

| Source                                                            | What it provided                                                                      | License / terms                                                     |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Original `dse_master.db` audit (prior work)                          | Archive base, Eikon prices                                                              | Own compiled work                                                       |
| [`bdshare`](https://pypi.org/project/bdshare/) (Python package)      | 2025–2026 price gap-fill, new-company prices                                            | Scrapes `dsebd.org` public pages                                        |
| Dhaka Stock Exchange (`dsebd.org`)                                    | Underlying live price/company/AGM data                                                  | Public disclosure, DSE's own terms apply                                |
| Bangladesh Bank (`bb.org.bd`)                                         | CPI, FX reserves, exchange rate, remittances                                            | Public statistics, BB's own terms apply                                 |
| World Bank Open Data                                                  | Bangladesh CPI (World Bank series)                                                      | [CC BY 4.0](https://datacatalog.worldbank.org/public-licenses)          |
| investing.com exports                                                | DSEX, DS30 index history                                                                | User-exported; investing.com's own terms apply for redistribution        |
| Mendeley/Harvard Dataverse DSE dataset                                | Referenced for cross-validation during audit; **not currently loaded into `prices`**     | See original dataset's license before use                               |

This repository's **code and schema** are MIT licensed (see `LICENSE`). The **underlying data** originates from the third parties above — verify their individual terms before redistributing the data itself at scale.

---

## Citation

[#citation](#citation)

See `CITATION.cff`. In short:

```
Ornob, K. M. Miad Hassan (Ow1nomics). (2026). KnightBase: A Consolidated
Financial Asset Database for the Dhaka Stock Exchange (1999-2026).
https://github.com/o-rnob/knightbase
```

---

## A note on the name

[#a-note-on-the-name](#a-note-on-the-name)

This is described as a comprehensive, consolidated open-source dataset for DSE — genuinely one of the more complete ones assembled outside an institution, to the builder's knowledge. It has not been formally benchmarked against every other Bangladesh financial dataset that may exist, so claims of being the single largest/most comprehensive should be read as the builder's good-faith assessment, not a verified superlative.
