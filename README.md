# MSBA-Capstone

Home & Kitchen recommendation capstone focused on distilling the >8B-row Amazon review corpus into a research-ready, metadata-enriched subset that can be trained, visualized, and iterated on within local hardware limits.

## Data Assets
- `Home_and_Kitchen.jsonl.gz` / `meta_Home_and_Kitchen.jsonl.gz`: original Amazon review + metadata dumps.
- `Home_and_Kitchen.parquet` / `meta_Home_and_Kitchen.parquet`: columnar conversions for faster IO.
- `Home_and_Kitchen_verified_sample_{1,5,15,30}pct_seed42.parquet`: progressively larger stochastic samples (`pandas.DataFrame.sample(frac=*, random_state=42)`) used while tuning filters.
- `core_hk_reviews_with_meta_sample_30pct.parquet`: final working set created by `sampling_file.py`, paired with `_stats.json` for quick coverage diagnostics.

## Sampling & Reduction Strategy
1. **Columnar conversion** – Convert both review and metadata JSONL streams into Parquet once so every downstream job benefits from compression and predicate pushdown.
2. **Iterative stochastic sampling** – Create 1%, 5%, 15%, and 30% review subsets (seed 42) to validate code paths and profiling without paying the 11TB cost of the full table.
3. **Verified-only filter** – Restrict interactions to `verified_purchase == True` to eliminate spam and keep the signal consistent between sampling tiers.
4. **K-core pruning** – Apply `k_user = k_item = 5` (tuned through experimentation) so that every remaining user and parent ASIN has at least five interactions, ensuring matrices are dense enough for MF/NN models.
5. **Optional deterministic downsample** – When a target row budget is provided (`--target_rows`, default 100k), run a seeded random sample on the k-core output to keep experiments reproducible.
6. **Metadata alignment & merge** – Filter metadata to only the surviving ASINs, drop duplicates, and perform a left merge so that every interaction ships with titles, categories, brand, image URLs, etc.
7. **Artifact logging** – Persist both the merged Parquet and an accompanying `_stats.json` capturing entity counts, sparsity, and frequency quantiles for quick sanity checks across sampling runs.

## Architecture & Flow
```mermaid
flowchart LR
    RAW_REVIEWS[Raw Reviews\nHome_and_Kitchen.jsonl.gz] --> PARQUET_REVIEWS[Parquet Conversion\nHome_and_Kitchen.parquet]
    RAW_META[Raw Metadata\nmeta_Home_and_Kitchen.jsonl.gz] --> PARQUET_META[Parquet Conversion\nmeta_Home_and_Kitchen.parquet]

    PARQUET_REVIEWS -->|Seeded frac sample\n(1%,5%,15%,30%)| STOCHASTIC_SAMPLE[Verified Review Samples]
    STOCHASTIC_SAMPLE -->|verified_purchase filter| VERIFIED_ONLY[Verified Interactions]
    VERIFIED_ONLY -->|k_user=k_item=5| KCORE[K-core Reviews]
    KCORE -->|optional target_rows cap| ROW_CAP[Downsampled K-core]

    PARQUET_META --> META_FILTER[Filter to surviving parent_asin + dedupe]
    ROW_CAP --> MERGE[Left Merge on parent_asin]
    META_FILTER --> MERGE

    MERGE --> FINAL[core_hk_reviews_with_meta_sample_30pct.parquet\n+ stats JSON]
```

## Running the Pipeline
```bash
python sampling_file.py \
  --reviews_parquet Home_and_Kitchen_verified_sample_30pct_seed42.parquet \
  --meta_parquet meta_Home_and_Kitchen.parquet \
  --out_parquet core_hk_reviews_with_meta_sample_30pct.parquet \
  --k_user 5 \
  --k_item 5 \
  --target_rows 100000 \
  --verified_only
```

Key switches:
- `--reviews_parquet` / `--meta_parquet` – point to any of the stored samples or the full Parquets.
- `--k_user`, `--k_item` – tighten or relax the interaction density requirements.
- `--target_rows` – set `None` if you want the entire k-core preserved.
- `--keep_review_cols` – extend beyond the defaults (`rating`, `timestamp`, `title`, `text`, `verified_purchase`) when feature engineering needs additional signals.

The script emits tqdm progress for every stage, prints dataset sizes after each reduction, and writes a `_stats.json` sibling file that documents sparsity and quantiles so each sampling run can be compared at a glance.
