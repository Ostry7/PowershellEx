/*Last modify: 2023-06-22*/

--CREATE CatchUP schema:
    CREATE SCHEMA IF NOT EXISTS catchup;

--CREATE USERS table:
    CREATE TABLE IF NOT EXISTS catchup.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age NUMERIC,
    sex VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )

--CREATE CONTACTS table:
    CREATE TABLE IF NOT EXISTS catchup.contacts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES catchup.users(id),
    contact_id INTEGER REFERENCES catchup.users(id)
);

--CREATE CHATROOM table:
    CREATE TABLE IF NOT EXISTS catchup.chatroom (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    creator_id INTEGER REFERENCES catchup.users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--CREATE CHATROOMROLES table:
    CREATE TABLE IF NOT EXISTS catchup.chatroomroles (
    id SERIAL PRIMARY KEY,
    chatroom_id INTEGER REFERENCES catchup.chatroom(id),
    user_id INTEGER REFERENCES catchup.users(id),
    role VARCHAR(50) NOT NULL
);

--CREATE MESSAGES table:
    CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    chatroom_id INTEGER REFERENCES catchup.chatroom(id),
    user_id INTEGER REFERENCES catchup.users(id),
    text TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);