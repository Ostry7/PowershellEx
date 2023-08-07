import tkinter as tk
import psycopg2
import db_conn

def login():
    username = entry_username.get()
    password = entry_password.get()

    if username == "admin" and password == "admin123":
        message = "Login successful!"
    else:
        message = "Invalid username or password."

    label_result.config(text=message)

def register():
    register_window = tk.Toplevel(window)
    register_window.title("Rejestracja")

    label_register = tk.Label(register_window, text="Formularz rejestracji")
    label_register.pack()

    label_username = tk.Label(register_window, text="Nazwa użytkownika:")
    label_username.pack()
    entry_username = tk.Entry(register_window)
    entry_username.pack()

    label_password = tk.Label(register_window, text="Hasło:")
    label_password.pack()
    entry_password = tk.Entry(register_window, show="*")
    entry_password.pack()

    label_first_name = tk.Label(register_window, text="Imię:")
    label_first_name.pack()
    entry_first_name = tk.Entry(register_window)
    entry_first_name.pack()

    label_last_name = tk.Label(register_window, text="Nazwisko:")
    label_last_name.pack()
    entry_last_name = tk.Entry(register_window)
    entry_last_name.pack()

    button_submit = tk.Button(register_window, text="Zarejestruj", command=register_user)
    button_submit.pack()

    label_result_register = tk.Label(register_window, text="")
    label_result_register.pack()

def register_user():
    username = entry_username.get()
    password = entry_password.get()
    first_name = entry_first_name.get()
    last_name = entry_last_name.get()

    try:
        db_conn.dbconnect()

        cursor = conn.cursor()

        query = "INSERT INTO catchup.users (id, username, password, email, first_name, last_name, age, sex, created_at) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (id, username, password, email, first_name, last_name, age, sex, created_at))

        conn.commit()

        cursor.close()
        conn.close()

        message = "Rejestracja zakończona sukcesem!"
    except (Exception, psycopg2.Error) as error:
        print("Błąd podczas rejestracji:", error)
        message = "Błąd podczas rejestracji."

    label_result_register.config(text=message)

# Główne okno
window = tk.Tk()
window.title("Logowanie i rejestracja")

# TextBoxy logowania
label_username = tk.Label(window, text="Username:")
label_username.pack()
entry_username = tk.Entry(window)
entry_username.pack()

label_password = tk.Label(window, text="Password:")
label_password.pack()
entry_password = tk.Entry(window, show="*")
entry_password.pack()

# Przycisk logowania
button_login = tk.Button(window, text="Login", command=login)
button_login.pack()

# Przycisk rejestracji
button_register = tk.Button(window, text="Zarejestruj teraz", command=register)
button_register.pack()

# Wynik logowania
label_result = tk.Label(window, text="")
label_result.pack()

# Uruchomienie pętli głównego okna
window.mainloop()
