*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           DateTime
Library           operatingSystem

Suite Setup       Create Test Database
Suite Teardown    Remove Test Database

*** Variables ***
${API_URL}        http://localhost:5000
${DB_PATH}        /Users/vladpop/Desktop/TestClaude/api_test_suite/transactions.db
${VALID_USER}     testuser01
${VALID_GAME}     Blackjack
${VALID_AMOUNT}    50.00
${VALID_ODDS}     2.10

*** Keywords ***
Create Test Database
    # Create a unique test database or ensure isolation
    Log    Test database initialized at ${DB_PATH}

Remove Test Database
    # Teardown - clean up if needed
    Log    Test teardown completed

Clear Transactions
    Connect To Database    sqlite3    ${DB_PATH}
    Execute Sql    DELETE FROM transactions
    Execute Sql    DELETE FROM bets
    Disconnect From Database

Start API Server
    [Arguments]    ${server}
    Log    Starting Flask API server on port 5000
    Run Process    python3    api_server.py    cwd=${DB_PATH}/..
    Sleep    2s

Stop API Server
    [Arguments]    ${server}
    Log    Shutting down API server
    Run Process    pkill    -f    api_server.py
    Sleep    1s

Create Session    banking    ${API_URL}

*** Keywords (Banking) ***
Create Transaction With Payload
    [Arguments]    ${user}    ${amount}    ${currency}=EUR
    ${payload}=    Create Dictionary    user_id=${user}    amount=${amount}    currency=${currency}
    ${resp}=        POST On Session    banking    /transactions    json=${payload}
    [Return]    ${resp.json()['id']}

Get Transaction Count From DB
    [Arguments]    ${tid}
    Connect To Database    sqlite3    ${DB_PATH}
    ${result}=    Query    SELECT COUNT(*) FROM transactions WHERE id=${tid}
    Disconnect From Database
    [Return]    ${result[0][0]}

Get Transaction From DB
    [Arguments]    ${tid}
    Connect To Database    sqlite3    ${DB_PATH}
    ${row}=    Query    SELECT * FROM transactions WHERE id=${tid}
    Disconnect From Database
    [Return]    ${row[0]}

*** Keywords (Gambling - Bets) ***
Place Betting Slip
    [Arguments]    ${user}    ${game}    ${amount}    ${odds}
    ${payload}=    Create Dictionary    user_id=${user}    game=${game}    amount=${amount}    odds=${odds}
    ${resp}=        POST On Session    banking    /bets    json=${payload}
    [Return]    ${resp.json()['id']}

Get Bet From DB
    [Arguments]    ${bid}
    Connect To Database    sqlite3    ${DB_PATH}
    ${row}=    Query    SELECT * FROM bets WHERE id=${bid}
    Disconnect From Database
    [Return]    ${row[0]}

Get User Bets
    [Arguments]    ${user}
    Connect To Database    sqlite3    ${DB_PATH}
    ${rows}=    Query    SELECT * FROM bets WHERE user_id=${user}
    Disconnect From Database
    [Return]    ${rows}

Validate Odds In Range
    [Arguments]    ${game}    ${min}=1.90    ${max}=2.30
    ${resp}=        GET On Session    banking    /bets/odds/${game}
    Should Be True    ${resp.status_code} == 200
    ${odds}=    Set Variable    ${resp.json()['odds']}
    Should Be >=    ${odds}    ${min}
    Should Be <=    ${odds}    ${max}
    [Return]    ${odds}