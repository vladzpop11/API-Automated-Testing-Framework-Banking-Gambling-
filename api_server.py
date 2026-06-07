from flask import Flask, request, jsonify
import sqlite3
import os
import random
from datetime import datetime

app = Flask(__name__)
DB_PATH = "/Users/vladpop/Desktop/TestClaude/api_test_suite/transactions.db"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    # Transactions table (existing - banking)
    c.execute('''CREATE TABLE IF NOT EXISTS transactions
                 (id INTEGER PRIMARY KEY, user_id TEXT, amount REAL,
                  currency TEXT, status TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)''')
    # Bets table (new - gambling)
    c.execute('''CREATE TABLE IF NOT EXISTS bets
                 (id INTEGER PRIMARY KEY, user_id TEXT, game TEXT, amount REAL,
                  odds REAL, result TEXT, payout REAL, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)''')
    conn.commit()
    conn.close()

@app.route('/health', methods=['GET'])
def health():
    return jsonify(status="ok")

@app.route('/transactions', methods=['POST'])
def create_transaction():
    data = request.get_json()
    if not data or 'user_id' not in data or 'amount' not in data:
        return jsonify(error="missing required fields"), 400
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("INSERT INTO transactions (user_id, amount, currency, status) VALUES (?, ?, ?, ?)",
              (data['user_id'], data['amount'], data.get('currency', 'EUR'), 'pending'))
    conn.commit()
    tid = c.lastrowid
    conn.close()
    return jsonify(id=tid, status='pending'), 201

@app.route('/transactions/<int:tid>', methods=['GET'])
def get_transaction(tid):
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT * FROM transactions WHERE id=?", (tid,))
    row = c.fetchone()
    conn.close()
    if not row:
        return jsonify(error="not found"), 404
    return jsonify(id=row[0], user_id=row[1], amount=row[2], currency=row[3], status=row[4], timestamp=row[5])

@app.route('/transactions/user/<user_id>', methods=['GET'])
def get_user_transactions(user_id):
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT * FROM transactions WHERE user_id=?", (user_id,))
    rows = c.fetchall()
    conn.close()
    return jsonify([{"id":r[0],"user_id":r[1],"amount":r[2],"currency":r[3],"status":r[4],"timestamp":r[5]} for r in rows])

# === GAMBLING ENDPOINTS ===
@app.route('/bets', methods=['POST'])
def place_bet():
    '''Place a new bet - gambling endpoint'''
    data = request.get_json()
    required = ['user_id', 'game', 'amount', 'odds']
    if not data or not all(k in data for k in required):
        return jsonify(error="missing required fields (user_id, game, amount, odds)"), 400
    if data['odds'] <= 1.0:
        return jsonify(error="odds must be > 1.0"), 400
    if data['amount'] <= 0:
        return jsonify(error="amount must be > 0"), 400

    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("INSERT INTO bets (user_id, game, amount, odds, result, payout) VALUES (?, ?, ?, ?, ?, ?)",
              (data['user_id'], data['game'], data['amount'], data['odds'], 'pending', 0.0))
    conn.commit()
    bid = c.lastrowid
    conn.close()
    return jsonify(id=bid, status='pending', message='bet placed'), 201

@app.route('/bets/<int:bid>', methods=['GET'])
def get_bet(bid):
    '''Get bet details by ID'''
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT * FROM bets WHERE id=?", (bid,))
    row = c.fetchone()
    conn.close()
    if not row:
        return jsonify(error="bet not found"), 404
    return jsonify(id=row[0], user_id=row[1], game=row[2], amount=row[3], odds=row[4], result=row[5], payout=row[6], timestamp=row[7])

@app.route('/bets/user/<user_id>', methods=['GET'])
def get_user_bets(user_id):
    '''Get all bets for a user'''
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT * FROM bets WHERE user_id=? ORDER BY timestamp DESC", (user_id,))
    rows = c.fetchall()
    conn.close()
    bets = [{"id":r[0],"user_id":r[1],"game":r[2],"amount":r[3],"odds":r[4],"result":r[5],"payout":r[6],"timestamp":r[7]} for r in rows]
    return jsonify(bets)

@app.route('/bets/odds/<game>', methods=['GET'])
def get_game_odds(game):
    '''Get live odds for a specific game'''
    valid_games = ['Blackjack', 'Roulette', 'Slots', 'Baccarat', 'Sports']
    if game not in valid_games:
        return jsonify(error="invalid game, use: " + str(valid_games)), 400

    # Simulate live odds fluctuation
    base_odds = {'Blackjack': 1.95, 'Roulette': 2.0, 'Slots': 1.8, 'Baccarat': 1.9, 'Sports': 2.1}
    fluctuation = random.uniform(0.95, 1.05)
    current_odds = round(base_odds[game] * fluctuation, 2)

    return jsonify(game=game, odds=current_odds, min_bet=1.0, max_bet=1000.0, timestamp=datetime.now().isoformat())

@app.route('/bets/odds', methods=['GET'])
def get_all_odds():
    '''Get all available game odds'''
    valid_games = ['Blackjack', 'Roulette', 'Slots', 'Baccarat', 'Sports']

    base_odds = {'Blackjack': 1.95, 'Roulette': 2.0, 'Slots': 1.8, 'Baccarat': 1.9, 'Sports': 2.1}
    odds = {}
    for game in valid_games:
        fluctuation = random.uniform(0.95, 1.05)
        odds[game] = round(base_odds[game] * fluctuation, 2)

    return jsonify(odds=odds, timestamp=datetime.now().isoformat())