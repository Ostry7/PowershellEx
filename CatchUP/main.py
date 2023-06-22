import tkinter as tk

def login():
    username = entry_username.get()
    password = entry_password.get()

    if username == "admin" and password == "admin123":
        message = "Login successful!"
    else:
        message = "Invalid username or password."

    label_result.config(text=message)

# Main window
window = tk.Tk()
window.title("Login to CatchUP")

# TextBoxes
label_username = tk.Label(window, text="Username:")
label_username.pack()
entry_username = tk.Entry(window)
entry_username.pack()

label_password = tk.Label(window, text="Password:")
label_password.pack()
entry_password = tk.Entry(window, show="*")
entry_password.pack()

# Login button
button_login = tk.Button(window, text="Login", command=login)
button_login.pack()

# Login result
label_result = tk.Label(window, text="")
label_result.pack()

# Uruchomienie pętli głównego okna
window.mainloop()
