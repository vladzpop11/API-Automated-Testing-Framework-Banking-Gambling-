*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources.robot

Suite Setup    Create Session    gambling    ${API_URL}

*** Variables ***
${VALID_GAME}      Blackjack
${INVALID_GAME}    Ludo
${VALID_ODDS}       2.10
${INVALID_ODDS}     0.95
${MIN_BET}          1.0
${MAX_BET}          1000.0

*** Test Cases ***

Place Valid Bet
    [Documentation]    Place a new bet with valid data
    ${payload}=    Create Dictionary    user_id=${VALID_USER}    game=${VALID_GAME}    amount=${VALID_AMOUNT}    odds=${VALID_ODDS}
    ${resp}=    POST On Session    gambling    /bets    json=${payload}
    Should Be Equal As Strings    ${resp.status_code}    201
    Should Be Equal As Strings    ${resp.json()['status']}    pending
    Set Test Variable    ${BET_ID}    ${resp.json()['id']}

Get Bet Details
    [Documentation]    Retrieve bet by ID
    ${payload}=    Create Dictionary    user_id=${VALID_USER}    game=Roulette    amount=25.00    odds=1.95
    ${resp}=    POST On Session    gambling    /bets    json=${payload}
    ${bid}=    Set Variable    ${resp.json()['id']}
    ${details}=    GET On Session    gambling    /bets/${bid}
    Should Be Equal As Strings    ${details.status_code}    200
    Should Be Equal As Strings    ${details.json()['game']}    Roulette

Check Odds Range
    [Documentation]    Verify odds are within legal limits
    ${odds_resp}=    GET On Session    gambling    /bets/odds/${VALID_GAME}
    Should Be Equal As Strings    ${odds_resp.status_code}    200
    ${odds}=    Set Variable    ${odds_resp.json()['odds']}
    Should Be True    ${odds} >= 1.90
    Should Be True    ${odds} <= 2.30

Invalid Odds Test
    [Documentation]    Reject bets with odds <=1.0
    ${payload}=    Create Dictionary    user_id=${VALID_USER}    game=Slots    amount=20.00    odds=${INVALID_ODDS}
    ${resp}=    POST On Session    gambling    /bets    json=${payload}
    Should Be Equal As Strings    ${resp.status_code}    400
    Should Contain    ${resp.json()['error']}    odds must be > 1.0

Invalid Game Test
    [Documentation]    Reject invalid game names
    ${resp}=    GET On Session    gambling    /bets/odds/${INVALID_GAME}
    Should Be Equal As Strings    ${resp.status_code}    400

Max Bet Test
    [Documentation]    Place bet at maximum limit
    ${payload}=    Create Dictionary    user_id=${VALID_USER}    game=Baccarat    amount=${MAX_BET}    odds=${VALID_ODDS}
    ${resp}=    POST On Session    gambling    /bets    json=${payload}
    Should Be Equal As Strings    ${resp.status_code}    201

Get All Odds
    [Documentation]    Retrieve all available game odds
    ${resp}=    GET On Session    gambling    /bets/odds
    Should Be Equal As Strings    ${resp.status_code}    200
    ${odds}=    Set Variable    ${resp.json()['odds']}
    Dictionary Should Contain Key    ${odds}    Blackjack
    Dictionary Should Contain Key    ${odds}    Roulette