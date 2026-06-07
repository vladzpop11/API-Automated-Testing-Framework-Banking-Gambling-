{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica-Bold;\f1\fswiss\fcharset0 Helvetica;\f2\fmodern\fcharset0 Courier;
}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat2\levelspace360\levelindent0{\*\levelmarker \{decimal\}}{\leveltext\leveltemplateid1\'01\'00;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid1}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}}
\paperw11900\paperh16840\margl1440\margr1440\vieww28600\viewh15100\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\b\fs24 \cf0 Automated API Testing Framework: Banking & Gambling Simulation
\f1\b0 \
\
\uc0\u55357 \u56524  Project Overview\
This repository contains a complete, end-to-end API test automation framework. Unlike standard automation portfolios that rely on external, often unstable public APIs, this project includes a custom-built, local REST API server developed in Python (Flask) with an integrated SQLite database. \
\
The testing framework is built using **Robot Framework** following the **Keyword-Driven Testing** methodology and the Page Object Model (adapted for APIs) to ensure clean, maintainable, and highly readable test automation code.\
\
 \uc0\u55357 \u56960  Key Technical Features\
*   
\f0\b Custom API Backend:
\f1\b0  A fully functional mock server (`api_server.py`) handling financial transactions and simulated betting logic with strict business rules.\
*   
\f0\b Database Validation (White-Box Testing):
\f1\b0  Tests do not just verify HTTP status codes; they query the underlying SQLite database (`transactions.db`) to ensure data integrity and exact matching of payloads.\
*   
\f0\b Separation of Concerns:
\f1\b0  Test data, environment variables, and complex keywords are abstracted into a centralized `resources.robot` file, keeping the test suites declarative and focused.\
*   
\f0\b Comprehensive Test Coverage:
\f1\b0  Includes positive flows, edge cases, and negative testing (e.g., rejecting invalid odds, handling missing required fields, verifying maximum bet limits).\
*   
\f0\b Dynamic Environment Management:
\f1\b0  Automated `Suite Setup` and `Teardown` processes handle the startup and graceful shutdown of the API server during test execution.\
\
 \uc0\u55357 \u57056 \u65039  Technology Stack\
*   
\f0\b Backend:
\f1\b0  Python 3, Flask, SQLite3\
*   
\f0\b Test Automation
\f1\b0 : Robot Framework, RequestsLibrary\
*   
\f0\b Dependencies Management
\f1\b0 : `requirements.txt`\
\
\uc0\u55357 \u56514  Repository Structure\
*   api_server.py : The application server under test (SUT).\
*   resources.robot : Core configuration, global variables, and custom keywords.\
*   api_tests.robot : Test suite for the banking/transactional endpoints.\
*   bets_tests.robot : Test suite for the gambling/betting endpoints with business logic validation.\
*   requirements.txt` : List of Python dependencies.\
\
\uc0\u9881 \u65039  Installation & Setup\
\
1. Clone the repository:\
```bash\
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)\
   cd your-repo-name\
\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\cf0 2. Create virtual environment\expnd0\expndtw0\kerning0
\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\ls1\ilvl0\cf0 \kerning1\expnd0\expndtw0 ```bash\expnd0\expndtw0\kerning0
\
\pard\pardeftab720\partightenfactor0
\cf0     python3 -m venv venv \
    source venv/bin/activate # On Windows use: venv\\Scripts\\activate\
\
3. Install Dependencies\
pip install -r requirements.txt\
\
\
\pard\pardeftab720\sa298\partightenfactor0
\cf0 \uc0\u55358 \u56810  Running the Tests\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 The testing framework handles starting and stopping the API server automatically. You do not need to start api_server.py manually.\
\pard\pardeftab720\partightenfactor0
\cf0 Run the entire test suite: robot. \
\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 Run specifically the banking tests: robot api_tests.robot\
\pard\pardeftab720\partightenfactor0
\cf0 Run specifically the betting tests: robot bets_tests.robot\
\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 \
\
}