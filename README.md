# MSBA-Capstone[aura_capstone_readme.md](https://github.com/user-attachments/files/22725764/aura_capstone_readme.md)
# Aura: Interactive Recommendation System with Conversational Chatbot for Retail Businesses

##  MSBA Capstone Project — Class of 2026

**Team Members:**  
Asli Kurt, Bhavya Patel, Hyeri Jeong, Jordan Pollard, Joshua Thompson  
**Faculty Mentor:** Dr. Mehrdad Koohikamali  

**Dataset:** [Amazon Reviews 2023](https://amazon-reviews-2023.github.io/)

---

##  Project Overview

**Aura** is an interactive, conversational recommendation system designed to transform how retail customers discover products. Unlike traditional, passive recommenders that silently serve suggestions, Aura enables **natural, two-way conversations** with users — allowing them to express preferences, ask questions, and refine results in real time.

The project aims to show how small and medium-sized retailers can benefit from AI-driven personalization typically accessible only to large corporations. Through a combination of **machine learning**, **large language models (LLMs)**, and **retrieval-augmented generation (RAG)**, Aura delivers an engaging and business-relevant user experience that bridges data-driven insights with practical retail value.

---

##  Motivation

Modern recommendation systems drive billions in sales for e-commerce leaders like Amazon. However, small retailers rarely have access to similar tools due to cost, complexity, or lack of data science resources. Aura addresses this gap by developing an open, scalable, and conversational recommender that:
- Enhances **customer satisfaction** through interactive discovery.
- Increases **conversion rates** via personalized and explainable recommendations.
- Provides **business intelligence** by analyzing user interactions for pricing, demand, and product positioning insights.

---

##  Technical Focus

The system integrates traditional recommender techniques with LLM-based reasoning. Core technologies include:

| Dimension | Classical Recommendation System | Conversational Recommendation System |
|------------|----------------------------------|--------------------------------------|
| Core Function | Suggests items from past behavior | Engages via chat, explains and adapts contextually |
| Interaction Style | Passive lists ("You may also like...") | Active conversation with reasoning and refinement |
| Granularity | Individual items | Curated bundles, outfits, or contextual sets |
| Business Use Case | Click/purchase prediction | Engagement, trust, and satisfaction optimization |
| Technology Stack | Collaborative filtering, matrix factorization | RAG with recommendation engine + LLM layer |
| UX | One-way | Two-way dialogue |

---

##  Project Objectives

1. **Develop and evaluate recommender models** for personalization and accuracy within a chosen retail industry.  
2. **Build a chatbot interface** enabling users to interact through natural language.  
3. **Simulate business scenarios** to assess impact on satisfaction, efficiency, and sales outcomes.  
4. **Deliver insights** that connect technical performance with measurable business value.

---

##  Project Timeline & Deliverables

### **Semester 1 (Fall 2025)** — *Data & Foundations*
- Explore Amazon Reviews dataset and select retail subdomain.
- Data preprocessing: cleaning, feature extraction, sentiment tagging.
- Conduct EDA: category frequency, sentiment analysis, rating trends.
- Build baseline recommenders (collaborative filtering, content-based).

### **Semester 2 (Spring 2026)** — *Advanced Models & Chatbot Development*
- Develop hybrid recommender combining collaborative, content-based, and embedding models.
- Implement retrieval + ranking pipeline.
- Build prototype chatbot (front-end + NLP interface).

### **Semester 3 (Summer 2026)** — *Integration & Evaluation*
- Implement RAG system integrating LLM reasoning with recommender output.
- Run scenario simulations and measure business outcomes.
- Evaluate using:
  - **Technical:** Recall@k, NDCG, personalization index.
  - **Business:** Conversion lift, simulated customer satisfaction.
- Deliver final demo and business impact report.

---

##  Team Roles & Expertise

**Asli Kurt — Marketing & Strategy Lead**  
Defines user personas, leads segmentation, ensures business relevance and alignment with market strategy.

**Joshua Thompson — Lead AI/ML Engineer**  
Designs and develops ML models, manages RAG system architecture, and leads implementation using Python and R.

**Jordan Pollard — Data & Behavioral Analyst**  
Handles data collection, cleaning, and preprocessing; leads EDA and user behavior analytics.

**Hyeri Jeong — Business & Market Analyst**  
Bridges technical outputs with strategic business insights; evaluates market trends, domain selection, and model impacts.

**Bhavya Patel — LLM Architect**  
Designs and implements the LLM and RAG components; oversees model fine-tuning and conversational logic.

---

##  Future Enhancements

- **Visual Recommendations:** Integrate computer vision for photo-based product suggestions (e.g., interior design or fashion use cases).
- **Bundle & Complementary Recommendations:** Suggest sets of related items for increased cart value.
- **Context-Aware Personalization:** Combine sentiment, preference, and contextual cues (e.g., seasonality, trends).

---

##  Evaluation Metrics

| Type | Metric | Description |
|------|---------|-------------|
| Offline | Recall@k, NDCG | Standard recommender accuracy measures |
| Personalization | Diversity, novelty index | Degree of user-tailored results |
| Business | Conversion lift, satisfaction proxy | Simulated business impact |

---

##  Repository Structure (Planned)

```
Aura/
│
├── data/                # Raw and processed data
├── notebooks/           # EDA, model development, and experiments
├── src/                 # Model and API source code
├── chatbot/             # Conversational UI prototype
├── reports/             # Documentation and presentations
└── README.md            # Project overview
```

---

##  Data Assets for Sampling

- `Home_and_Kitchen.jsonl.gz` / `meta_Home_and_Kitchen.jsonl.gz` - raw Amazon review and metadata dumps (>8B rows combined).
- `Home_and_Kitchen.parquet` / `meta_Home_and_Kitchen.parquet` - columnar conversions that keep schema parity with the raw dumps while enabling fast predicate pushdown.
- `Home_and_Kitchen_verified_sample_{1,5,15,30}pct_seed42.parquet` - progressively larger stochastic subsets (`pandas.DataFrame.sample(frac=?, random_state=42)`) used for debugging and profiling the filters.
- `core_hk_reviews_with_meta_sample_30pct.parquet` plus `_stats.json` - recommender-ready artifact produced by `sampling_file.py` after all filters, merges, and logging complete.

---

##  Sampling & Reduction Strategy

1. **Columnar conversion** - Convert both review and metadata JSONL streams to Parquet once so every downstream job benefits from compression and vectorized IO.
2. **Seeded frac sampling** - Generate 1%, 5%, 15%, and 30% review subsets (seed 42) to iterate quickly while approximating the full distribution.
3. **Verified-only enforcement** - Keep only rows with `verified_purchase == True` to reduce spam and align train/test distributions.
4. **K-core pruning** - Apply `k_user = k_item = 5` (tunable via CLI) so each user and ASIN has at least five interactions, creating denser matrices for MF/NN models.
5. **Optional deterministic downsample** - If `--target_rows` is provided (default 100k), run a seeded sample on the k-core output to stay within hardware limits without sacrificing reproducibility.
6. **Metadata alignment & dedupe** - Filter metadata to only the surviving `parent_asin` values and drop duplicates so a single, authoritative set of attributes accompanies each product.
7. **Merge + stats logging** - Left join reviews with filtered metadata, emit the merged Parquet, and save `_stats.json` capturing user/item counts, sparsity, and interaction quantiles for quick QA.

---

##  Data Pipeline Architecture

```mermaid
flowchart LR
    RAW_REVIEWS["Raw Reviews<br/>Home_and_Kitchen.jsonl.gz"] --> PARQUET_REVIEWS["Parquet Conversion<br/>Home_and_Kitchen.parquet"]
    RAW_META["Raw Metadata<br/>meta_Home_and_Kitchen.jsonl.gz"] --> PARQUET_META["Parquet Conversion<br/>meta_Home_and_Kitchen.parquet"]

    PARQUET_REVIEWS -->|Seeded frac sample<br/>(1%,5%,15%,30%)| STOCHASTIC_SAMPLE["Verified Review Samples"]
    STOCHASTIC_SAMPLE -->|verified_purchase filter| VERIFIED_ONLY["Verified Interactions"]
    VERIFIED_ONLY -->|k_user = k_item = 5| KCORE["K-core Reviews"]
    KCORE -->|optional target_rows cap| ROW_CAP["Downsampled K-core"]

    PARQUET_META --> META_FILTER["Filter to surviving parent_asin + dedupe"]
    ROW_CAP --> MERGE["Left Merge on parent_asin"]
    META_FILTER --> MERGE

    MERGE --> FINAL["core_hk_reviews_with_meta_sample_30pct.parquet<br/>+ stats JSON"]
```

---

##  Running `sampling_file.py`

```powershell
python sampling_file.py `
  --reviews_parquet Home_and_Kitchen_verified_sample_30pct_seed42.parquet `
  --meta_parquet meta_Home_and_Kitchen.parquet `
  --out_parquet core_hk_reviews_with_meta_sample_30pct.parquet `
  --k_user 5 `
  --k_item 5 `
  --target_rows 100000 `
  --verified_only
```

- `--reviews_parquet` / `--meta_parquet`: point to any of the raw or sampled Parquet assets.
- `--k_user` and `--k_item`: adjust the minimum interaction thresholds for the k-core filter.
- `--target_rows`: set to `None` to retain the full k-core output, or keep the default (100k) for faster iterations.
- `--keep_review_cols`: extend the default (`rating`, `timestamp`, `title`, `text`, `verified_purchase`) when additional features are required.
- Script output includes tqdm step tracking, post-stage shape summaries, the merged Parquet, and an auto-generated `_stats.json` for documentation.

---

##  License
TBD - Likely open-source (MIT or Apache 2.0) for academic and research use.

---

##  Acknowledgments
We thank **Dr. Mehrdad Koohikamali** for his mentorship and guidance, and the Cal Poly Pomona MSBA program for providing the platform to merge analytics, business strategy, and innovation into impactful projects.

---

> *Aura — where data meets dialogue to redefine retail personalization.*
