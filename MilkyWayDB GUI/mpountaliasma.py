from tkinter import *
from PIL import Image, ImageTk
import MainGUI
import mysql.connector

def connect_to_db():
    try:
        # Χρησιμοποίησε τα στοιχεία από το HeidiSQL/Workbench
        connection = mysql.connector.connect(
            host='127.0.0.1',
            user='root', # Ή τον περιορισμένο χρήστη που θα φτιάξεις
            password='Bb1044287588!!', # Ο κωδικός σου
            database='milkyway'
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

print("MySQL Connector module imported successfully.")

# Δοκιμή σύνδεσης
connection = connect_to_db()

if connection:
    print("Η σύνδεση με τη βάση δεδομένων ήταν επιτυχής!")
else:
    print("✗ Αποτυχία σύνδεσης με τη βάση δεδομένων.")

m = MainGUI.App

if __name__ == "__main__":
    root = Tk()
    app = m(root)
    root.mainloop()