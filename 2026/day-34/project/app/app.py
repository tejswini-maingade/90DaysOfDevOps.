from flask import Flask, render_template, jsonify
import mysql.connector
import redis
import os
import socket
import time

app = Flask(__name__)

START_TIME = time.time()


# -----------------------------
# Database Connection
# -----------------------------
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "db"),
        user=os.getenv("DB_USER", "devuser"),
        password=os.getenv("DB_PASSWORD", "devpass"),
        database=os.getenv("DB_NAME", "devtask")
    )


# -----------------------------
# Redis Connection
# -----------------------------
def get_redis_connection():
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "redis"),
        port=6379,
        decode_responses=True
    )


# -----------------------------
# Initialize Database
# -----------------------------
def initialize_database():

    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS visits (
            id INT AUTO_INCREMENT PRIMARY KEY,
            visited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)

    connection.commit()

    cursor.close()
    connection.close()


# -----------------------------
# Get Database Statistics
# -----------------------------
def get_database_stats():

    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT COUNT(*) FROM visits")

    total_visits = cursor.fetchone()[0]

    cursor.close()
    connection.close()

    return total_visits


# -----------------------------
# Home Dashboard
# -----------------------------
@app.route("/")
def dashboard():

    db_status = "Connected"
    redis_status = "Active"

    # Record visit in MySQL
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("INSERT INTO visits () VALUES ()")
        connection.commit()

        cursor.close()
        connection.close()

        total_visits = get_database_stats()

    except Exception as e:
        db_status = "Unavailable"
        total_visits = 0
        print("Database error:", e)

    # Redis
    try:

        redis_client = get_redis_connection()

        cached_value = redis_client.get("page_visits")

        if cached_value is None:
            cached_value = str(total_visits)
            redis_client.set("page_visits", cached_value)
        else:
            cached_value = str(total_visits)
            redis_client.set("page_visits", cached_value)

    except Exception as e:

        redis_status = "Unavailable"
        cached_value = "N/A"

        print("Redis error:", e)

    uptime = int(time.time() - START_TIME)

    container_name = socket.gethostname()

    return render_template(
        "index.html",
        db_status=db_status,
        redis_status=redis_status,
        total_visits=total_visits,
        cached_value=cached_value,
        uptime=uptime,
        container_name=container_name
    )


# -----------------------------
# Health API
# -----------------------------
@app.route("/health")
def health():

    database = "healthy"
    redis_status = "healthy"

    try:
        connection = get_db_connection()
        connection.close()
    except Exception:
        database = "unhealthy"

    try:
        redis_client = get_redis_connection()
        redis_client.ping()
    except Exception:
        redis_status = "unhealthy"

    status = "healthy"

    if database != "healthy" or redis_status != "healthy":
        status = "degraded"

    return jsonify({
        "status": status,
        "database": database,
        "redis": redis_status
    })


# -----------------------------
# API Statistics
# -----------------------------
@app.route("/api/stats")
def stats():

    try:
        visits = get_database_stats()
    except Exception:
        visits = 0

    return jsonify({
        "page_visits": visits,
        "uptime": int(time.time() - START_TIME),
        "container": socket.gethostname()
    })


# -----------------------------
# Application Start
# -----------------------------
if __name__ == "__main__":

    # Wait for MySQL to become available
    for attempt in range(10):

        try:

            initialize_database()

            print("MySQL database initialized successfully.")

            break

        except Exception as e:

            print(
                f"MySQL not ready. "
                f"Attempt {attempt + 1}/10"
            )

            time.sleep(3)

    app.run(
        host="0.0.0.0",
        port=5000
    )
