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

##  License
TBD — Likely open-source (MIT or Apache 2.0) for academic and research use.

---

##  Acknowledgments
We thank **Dr. Mehrdad Koohikamali** for his mentorship and guidance, and the Cal Poly Pomona MSBA program for providing the platform to merge analytics, business strategy, and innovation into impactful projects.

---

> *Aura — where data meets dialogue to redefine retail personalization.*
