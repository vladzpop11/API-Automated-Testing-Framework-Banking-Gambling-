Automated API Testing Framework: Banking & Gambling Simulation

📌 Project Overview
This repository contains a complete, end-to-end API test automation framework. Unlike standard automation portfolios that rely on external, often unstable public APIs, this project includes a custom-built, local REST API server developed in Python (Flask) with an integrated SQLite database. 

The testing framework is built using **Robot Framework** following the **Keyword-Driven Testing** methodology and the Page Object Model (adapted for APIs) to ensure clean, maintainable, and highly readable test automation code.

 🚀 Key Technical Features
*   Custom API Backend: A fully functional mock server (`api_server.py`) handling financial transactions and simulated betting logic with strict business rules.
*   Database Validation (White-Box Testing): Tests do not just verify HTTP status codes; they query the underlying SQLite database (`transactions.db`) to ensure data integrity and exact matching of payloads.
*   Separation of Concerns: Test data, environment variables, and complex keywords are abstracted into a centralized `resources.robot` file, keeping the test suites declarative and focused.
*   Comprehensive Test Coverage: Includes positive flows, edge cases, and negative testing (e.g., rejecting invalid odds, handling missing required fields, verifying maximum bet limits).
*   Dynamic Environment Management: Automated `Suite Setup` and `Teardown` processes handle the startup and graceful shutdown of the API server during test execution.

 🛠️ Technology Stack
*   Backend: Python 3, Flask, SQLite3
*   Test Automation: Robot Framework, RequestsLibrary
*   Dependencies Management: `requirements.txt`

📂 Repository Structure
*   api_server.py : The application server under test (SUT).
*   resources.robot : Core configuration, global variables, and custom keywords.
*   api_tests.robot : Test suite for the banking/transactional endpoints.
*   bets_tests.robot : Test suite for the gambling/betting endpoints with business logic validation.
*   requirements.txt` : List of Python dependencies.

⚙️ Installation & Setup

1. Clone the repository:
```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
   cd your-repo-name

2. Create virtual environment
```bash
    python3 -m venv venv 
    source venv/bin/activate # On Windows use: venv\Scripts\activate

3. Install Dependencies
pip install -r requirements.txt


🧪 Running the Tests
The testing framework handles starting and stopping the API server automatically. You do not need to start api_server.py manually.
Run the entire test suite: robot. 

Run specifically the banking tests: robot api_tests.robot
Run specifically the betting tests: robot bets_tests.robot
