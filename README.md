# 🧠 Hakim — AI-Powered Quranic Intelligence Platform

> **A full-stack AI-powered Quranic assistant built with Flutter and Python, designed to transform Quranic verses into structured knowledge, practical guidance, and meaningful reflection.**

---

# Overview

Hakim is a full-stack mobile application that combines **Flutter** on the client side with a **Python (Flask)** backend.

Instead of acting as a generic chatbot, Hakim implements a structured AI processing pipeline that retrieves contextual information, builds optimized prompts, validates model responses, and returns a consistent JSON schema specifically designed for the mobile application.

The platform focuses on making Quranic interpretation more accessible through semantic analysis, contextual explanations, practical guidance, and beautifully generated shareable content.

---

# Architecture

```
                 Flutter Mobile Client
                          │
                          ▼
                     REST API Layer
                          │
                          ▼
                    Python Flask Server
                          │
        ┌─────────────────┼──────────────────┐
        │                 │                  │
        ▼                 ▼                  ▼
 Retrieval Engine   Session Manager     LLM Gateway
 (TF-IDF Index)      (SQLite WAL)      (GapGPT API)
        │                 │                  │
        └─────────────────┼──────────────────┘
                          ▼
              Response Validation Layer
                          │
         • JSON Sanitization
         • Schema Enforcement
         • Audio Link Generator
         • Share Card Formatter
                          │
                          ▼
               Structured JSON Response
```

---

# Core Components

## Lightweight Retrieval Engine

Instead of relying on large vector databases, Hakim uses a lightweight retrieval engine based on:

* TF-IDF scoring
* Inverted Index
* Phrase matching
* Chunk-based document retrieval

Knowledge is stored in `knowledge.txt` and indexed into semantic chunks.

Document ranking follows the classic TF-IDF scoring model with additional phrase-matching prioritization for more relevant contextual retrieval.

---

## JSON Response Sanitizer

Large Language Models occasionally generate malformed JSON or include Markdown formatting.

Hakim automatically:

* Removes Markdown wrappers
* Repairs malformed JSON
* Enforces a strict response schema
* Validates required fields
* Prevents frontend parsing failures

---

## Quran Audio Engine

The backend automatically extracts Surah and Verse identifiers from AI responses and generates valid Tanzil audio links.

The engine includes custom regex processing to prevent numeric conflicts caused by file extensions and guarantees correct six-digit Quranic identifiers.

---

## Share Card Engine

Hakim generates high-quality shareable cards optimized for:

* Instagram Stories
* Telegram
* WhatsApp
* RTL Languages
* High-resolution export

The rendering engine dynamically scales typography to prevent text truncation while maintaining visual consistency.

---

# Features

## AI-powered Quran Analysis

* Semantic verse interpretation
* Context-aware explanations
* Multi-layer reasoning
* Practical life guidance
* Structured AI responses

## Smart Conversation System

* Persistent chat sessions
* SQLite conversation history
* Session isolation
* Fast API communication
* Error recovery

## Premium Sharing

* Dynamic typography
* RTL support
* High-resolution rendering
* Social-media optimized layouts

## Voice Features

* Speech-to-text support
* Audio interaction pipeline

---

# Technology Stack

## Mobile

* Flutter
* Dart
* GetX
* Screenshot
* Share Plus

## Backend

* Python
* Flask
* SQLite
* Flask-CORS
* python-dotenv
* Requests

## Infrastructure

* REST API
* Linux (Ubuntu)
* cPanel Deployment
* Passenger WSGI

---

# Project Structure

```
smart_chat_bot/

├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── viewmodels/
│   │   ├── views/
│   │   └── main.dart
│   │
│   ├── assets/
│   └── pubspec.yaml
│
├── backend/
│   ├── app.py
│   ├── passenger_wsgi.py
│   ├── requirements.txt
│   ├── knowledge.txt
│   └── assistant.db
│
└── README.md
```

---

# Installation

## Clone Repository

```bash
git clone https://github.com/amirkhodaei1/smart_chat_bot.git

cd smart_chat_bot
```

---

## Backend

```bash
cd backend

python -m venv venv

source venv/bin/activate
# Windows:
# venv\Scripts\activate

pip install -r requirements.txt

python app.py
```

Create a `.env` file:

```env
GAPGPT_API_KEY=YOUR_API_KEY
```

---

## Flutter

```bash
cd frontend

flutter pub get

flutter run
```

---

# AI-Assisted Development

Hakim was developed using an **AI-first software engineering workflow**.

Approximately **90% of the implementation** was completed through an iterative collaboration between the developer and modern AI coding tools.

AI contributed to:

* Flutter application development
* Backend implementation
* REST API integration
* Software architecture discussions
* State management
* Debugging
* Code refactoring
* Prompt engineering
* Technical documentation
* Performance optimization

The developer remained responsible for:

* Project vision and requirements
* Architecture decisions
* Code review
* Integration
* Testing
* Debugging
* Deployment
* Final engineering decisions

This project demonstrates how modern AI-assisted development can significantly accelerate software engineering while maintaining full developer ownership and technical responsibility.

---

# Future Improvements

* Advanced Quran search
* Multi-model AI support
* Cloud synchronization
* User authentication
* Offline mode
* Voice conversations
* Cross-device synchronization
* Better retrieval strategies

---

# License

This project is released under the **MIT License**.

---

<p align="center">

**Hakim**

*Where Artificial Intelligence Meets Quranic Understanding.*

</p>
