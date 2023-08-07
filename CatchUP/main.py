import tkinter as tk

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

    # Dodaj odpowiednie pola formularza rejestracyjnego
    # ...

# Główne okno
window = tk.Tk()
window.title("Login to CatchUP")

# TextBoxy
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