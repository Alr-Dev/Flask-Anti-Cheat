from flask import Flask, request, jsonify
import datetime

app = Flask(__name__)

banned_users = {}


LOG_FILE = 'logs.txt'

@app.route('/') 
def index():
    return "Ban server is running", 200

@app.route('/favicon.ico')
def favicon():
    return "", 204  

@app.route('/ban', methods=['POST'])
def ban_user():
    user_id = request.json.get('user_id')
    reason = request.json.get('reason', 'No reason provided')

    if user_id:
        banned_users[user_id] = True
        
        
        log_ban(user_id, reason)
        
        return jsonify({"status": "success", "message": f"User {user_id} banned"}), 200
    return jsonify({"status": "fail", "message": "No user_id provided"}), 400

@app.route('/check_ban', methods=['POST'])
def check_ban():
    user_id = request.json.get('user_id')
    if user_id and banned_users.get(user_id):
        return jsonify({"status": "banned"}), 200
    return jsonify({"status": "not banned"}), 200

def log_ban(user_id, reason):
    """Log the ban details into the logs.txt file."""
    with open(LOG_FILE, 'a') as log_file:
        log_file.write(f"-- Ban Logs --\n")
        log_file.write(f"User Banned: {user_id}\n")
        log_file.write(f"Hours When He Got Banned: {datetime.datetime.now()}\n")
        log_file.write(f"Reason: {reason}\n\n")

if __name__ == '__main__':
    app.run(debug=True)
# read documentation for know more.
