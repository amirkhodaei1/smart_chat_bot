<p align="center">
  <h1 align="center">🧠 Hakim</h1>
  <p align="center"><strong>AI-Powered Quranic Intelligence Platform</strong></p>
  <p align="center">
    A modern platform that transforms Quranic verses into structured knowledge, semantic understanding, and practical life guidance through an intelligent multi-stage reasoning pipeline.
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flask-3.x-000000?style=for-the-badge&logo=flask&logoColor=white"/>
  <img src="https://img.shields.io/badge/GetX-State_Management-8A2BE2?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white"/>
  <img src="https://img.shields.io/badge/REST_API-Success-2EA043?style=for-the-badge"/>
</p>

---

## ✨ What is Hakim?

Hakim is a **full-stack AI-powered Quranic intelligence platform** designed to bridge the gap between traditional Quranic study and contemporary Artificial Intelligence technologies. 

Rather than functioning as a conventional chatbot that simply generates raw text, Hakim implements a structured multi-stage processing pipeline. It retrieves contextual information, constructs optimized prompts, validates AI responses, and delivers a consistent output format specifically tailored for a premium mobile experience.

## 🚀 Key Features

* **Intelligent Quran Analysis:** Semantic verse interpretation, spiritual reflections, and practical life guidance.
* **Premium Share Cards:** Generate beautiful, dynamic, high-resolution shareable content directly from AI responses.
* **Smart JSON Validation Layer:** Ensures LLM outputs are perfectly structured for the mobile UI to prevent rendering errors.
* **Lightweight Retrieval Engine:** A built-in TF-IDF scoring and inverted index system to enrich AI prompts with accurate context.
* **Voice Interaction:** Integrated speech-to-text pipeline for natural conversations.
* **Session Memory:** Persistent conversation history managed locally via SQLite.
* **Production-Ready Architecture:** Clean separation of frontend and backend, capable of running efficiently on shared Linux/cPanel environments.

---

## 🏗 System Architecture

Hakim follows a layered architecture that separates presentation, application logic, retrieval, AI communication, and response processing. This separation improves maintainability, testing, and future extensibility.

```mermaid
flowchart TD

A[Flutter Mobile Application] --> B[Repository Layer]
B --> C[API Service]
C --> D[REST API]

D --> E[Flask Backend]

E --> F[Session Manager]
E --> G[Retrieval Engine]
E --> H[Prompt Builder]
E --> I[LLM Gateway]

G --> J[Knowledge Base]
F --> K[(SQLite Database)]

J & K --> H
H --> I

I --> L[Response Validator]

L --> M[JSON Sanitizer]
L --> N[Schema Enforcer]
L --> O[Audio Link Generator]
L --> P[Share Card Formatter]

P --> Q[Structured JSON Response]
Q --> A
