from flask import Flask
from datetime import datetime, timezone

app = Flask(__name__)

@app.route("/")
def get_current_time():
    current_time = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
    return f"The current time of the day is: {current_time} UTC"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)