import pymysql
from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()


# MySQL Connection

def mysql_connection():
    return pymysql.connect(
        host=os.getenv("MYSQL_HOST"),
        user=os.getenv("MYSQL_USER"),
        password=os.getenv("MYSQL_PASSWORD"),
        database=os.getenv("MYSQL_DB"),
        cursorclass=pymysql.cursors.DictCursor
    )


# MongoDB Connection

def mongo_connection():
    client = MongoClient(os.getenv("MONGO_URI"))
    return client[os.getenv("MONGO_DB")]


# Insert Data into MySQL

def insert_into_mysql(table, data):
    conn = mysql_connection()
    cursor = conn.cursor()

    placeholders = ", ".join(["%s"] * len(data))
    columns = ", ".join(data.keys())

    sql = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"

    cursor.execute(sql, list(data.values()))
    conn.commit()
    conn.close()

    print(f"Inserted into MySQL: {table}")


# Insert Data into MongoDB

def insert_into_mongo(collection, data):
    db = mongo_connection()
    db[collection].insert_one(data)
    print(f"Inserted into MongoDB: {collection}")


# Copy Unique Data (MySQL → Mongo)

def mysql_to_mongo(table, collection, unique_key):
    conn = mysql_connection()
    cursor = conn.cursor()
    db = mongo_connection()

    cursor.execute(f"SELECT * FROM {table}")
    rows = cursor.fetchall()

    for row in rows:
        existing = db[collection].find_one({unique_key: row[unique_key]})
        if not existing:
            db[collection].insert_one(row)
            print(f"Copied to MongoDB: {row}")
        else:
            print("Duplicate skipped:", row)

    conn.close()


# Copy Unique Data (Mongo → MySQL)

def mongo_to_mysql(collection, table, unique_key):
    db = mongo_connection()
    conn = mysql_connection()
    cursor = conn.cursor()

    mongo_docs = list(db[collection].find({}, {"_id": 0}))

    for doc in mongo_docs:

        cursor.execute(f"SELECT * FROM {table} WHERE {unique_key} = %s", 
                       (doc[unique_key],))
        exists = cursor.fetchone()

        if not exists:
            columns = ", ".join(doc.keys())
            placeholders = ", ".join(["%s"] * len(doc))

            sql = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
            cursor.execute(sql, list(doc.values()))
            conn.commit()
            print("Copied to MySQL:", doc)
        else:
            print("Duplicate skipped:", doc)

    conn.close()


# -----------------------------
# Example Usage

if __name__ == "__main__":

    # 1. Insert into MySQL
    insert_into_mysql("Patients", {
        "Name": "Ali Khan",
        "Age": 32,
        "Gender": "Male",
        "ContactInfo": "03001234567"
    })

    # 2. Insert into MongoDB
    insert_into_mongo("Patients", {
        "PatientID": 102,
        "Name": "Owen Mark",
        "Age": 33,
        "Gender": "Male",
        "ContactInfo": "9713347865443"
    })

    # 3. Copy unique data MySQL → Mongo
    mysql_to_mongo("Patients", "Patients", "PatientID")

    # 4. Copy unique data Mongo → MySQL
    mongo_to_mysql("Patients", "Patients", "PatientID")
