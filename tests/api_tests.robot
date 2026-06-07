*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    DateTime
Resource    ../resources.robot

Suite Setup    Start API Server    ${API_SERVER}
Suite Teardown    Stop API Server

*** Variables ***
${API_URL}    http://localhost:5000
${DB_PATH}    /Users/vladpop/Desktop/TestClaude/api_test_suite/transactions.db
${VALID_USER}    testuser01
${VALID_AMOUNT}    100.50
${VALID_CURRENCY}    EUR
${INVALID_USER}    invalid_user

*** Test Cases ***
Health Check Endpoint Returns OK
    [Documentation]    Verify the health endpoint returns 200 status and ok status
    Create Session    banking    ${API_URL}
    ${resp}=    GET On Session    banking    /health
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()["status"]}    ok

Create Transaction With Valid Data
    [Documentation]    Create a new transaction and verify response status, location, and DB entry
    Create Session    banking    ${API_URL}
    ${payload}=    Create Dictionary    user_id=${VALID_USER}    amount=${VALID_AMOUNT}    currency=${VALID_CURRENCY}
    ${resp}=    POST On Session    banking    /transactions    json=${payload}
    Should Be Equal As Strings    ${resp.status_code}    201
    Should Be True    ${resp.json()['status']} == 'pending'
    ${tid}=    Set Variable    ${resp.json()['id']}
    ${db_count}=    Get Transaction Count From DB    ${tid}
    Should Be Equal As Integers    ${db_count}    1
    ${db_data}=    Get Transaction From DB    ${tid}
    Should Be Equal As Strings    ${db_data['user_id']}    ${VALID_USER}
    Should Be Equal As Strings    ${db_data['amount']}    ${VALID_AMOUNT}
    Should Be Equal As Strings    ${db_data['currency']}    ${VALID_CURRENCY}
    Should Be Equal As Strings    ${db_data['status']}    pending

Get Transaction By ID Successful
    [Documentation]    Retrieve a transaction by ID and validate all fields
    Create Session    banking    ${API_URL}
    ${tid}=    Create Transaction With Payload    ${VALID_USER}    200.00    GBP
    ${resp}=    GET On Session    banking    /transactions/${tid}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()["id"]}    ${tid}
    Should Be Equal As Strings    ${resp.json()["user_id"]}    ${VALID_USER}
    Should Be Equal As Strings    ${resp.json()["amount"]}    200.00
    Should Be Equal As Strings    ${resp.json()["currency"]}    GBP
    Should Be Equal As Strings    ${resp.json()["status"]}    pending

Get Transaction Not Found Returns 404
    [Documentation]    Verify that a non-existent transaction returns 404
    Create Session    banking    ${API_URL}
    ${resp}=    GET On Session    banking    /transactions/999999
    Should Be Equal As Strings    ${resp.status_code}    404
    Should Contain    ${resp.json()["error"]}    not found

Negative Test: Create Transaction Missing Fields
    [Documentation]    Ensure missing fields return 400
    Create Session    banking    ${API_URL}
    ${payload}=    Create Dictionary    user_id=${VALID_USER}
    ${resp}=    POST On Session    banking    /transactions    json=${payload}
    Should Be Equal As Strings    ${resp.status_code}    400
    Should Contain    ${resp.json()["error"]}    missing required fields

Get User Transactions
    [Documentation]    Create multiple transactions and fetch all for a user
    Create Session    banking    ${API_URL}
    ${t1}=    Create Transaction With Payload    ${VALID_USER}    50.00    USD
    ${t2}=    Create Transaction With Payload    ${VALID_USER}    75.00    CAD
    ${resp}=    GET On Session    banking    /transactions/user/${VALID_USER}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${trans}=    Set Variable    ${resp.json()}
    Should Be Equal As Integers    Length    ${trans}    2

*** Keywords ***
Create Transaction With Payload
    [Arguments]    ${user}    ${amount}    ${currency}
    ${payload}=    Create Dictionary    user_id=${user}    amount=${amount}    currency=${currency}
    ${resp}=    POST On Session    banking    /transactions    json=${payload}
    [Return]    ${resp.json()['id']}

*** Keywords ***
Start API Server
    [Arguments]    ${server}
    Log    Starting Flask API server on port 5000
    Log    Use 'C-c' to manually stop the server when done
    Run Process    python3    api_server.py    cwd=${DB_PATH}/..
    Sleep    2s

Stop API Server
    [Arguments]    ${server}
    Log    Shutting down API server
    Run Process    pkill    -f    api_server.py