from tkinter import *
from PIL import Image, ImageTk
import HobbyistGUI
import RoleViews

# --- Demo Users Database ---
users_db = {}

class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Interface")
        self.root.geometry("1000x500+80+80")
        # Παροχή πρόσβασης στους καταχωρημένους χρήστες για admin views
        self.get_users = lambda: [(u, users_db[u]["role"] if isinstance(users_db[u], dict) else None) for u in users_db]

        # --- Background Image ---
        bg_image = Image.open("background.jpg")
        bg_image = bg_image.resize((1000, 500))
        self.bg_photo = ImageTk.PhotoImage(bg_image)

        self.canvas = Canvas(root, width=1000, height=500, highlightthickness=0)
        self.canvas.pack(fill="both", expand=True)
        self.canvas.create_image(0, 0, image=self.bg_photo, anchor="nw")
        self.canvas.create_text(500, 30, text="Μενού επιλογών", fill="white", font=("Arial", 16, "bold"))

        # --- Login Frame (αρχικά κρυφό) ---
        self.login_frame = Frame(root, bg="#000000")
        self.login_label = Label(self.login_frame, text="", fg="white", font=("Arial", 14, "bold"), bg="#000000")
        self.login_label.pack(pady=5)

        self.username_entry = Entry(self.login_frame)
        self.password_entry = Entry(self.login_frame, show="*")
        self.message_label = Label(self.login_frame, text="", fg="red", bg="#000000")

        self.login_button = Button(self.login_frame, text="Login")
        self.signup_button = Button(self.login_frame, text="Sign Up")
        self.back_button = Button(self.login_frame, text="Back")

        for widget in [self.username_entry, self.password_entry, self.message_label,
                       self.login_button, self.signup_button, self.back_button]:
            widget.pack(pady=2)

        # --- User Buttons ---
        self.button_texts = ["Researcher", "Administrator", "Hobbyist", "Verified-user"]
        self.create_user_buttons()

    def create_user_buttons(self):
        for i, text in enumerate(self.button_texts):
            y = 100 + i*60
            text_item = self.canvas.create_text(300, y, text=text, fill="white", font=("Arial", 14, "bold"))

            self.canvas.tag_bind(text_item, "<Button-1>", lambda e, t=text, y_pos=y: self.show_login(t, y_pos))
            self.canvas.tag_bind(text_item, "<Enter>", lambda e, item=text_item: self.on_enter(e, item))
            self.canvas.tag_bind(text_item, "<Leave>", lambda e, item=text_item: self.on_leave(e, item))

    def on_enter(self, event, text_item):
        self.canvas.itemconfig(text_item, fill="yellow")
        self.canvas.config(cursor="hand2")

    def on_leave(self, event, text_item):
        self.canvas.itemconfig(text_item, fill="white")
        self.canvas.config(cursor="")

    def show_login(self, user_type, y_pos):
        self.login_label.config(text=f"{user_type} Login / Sign Up")
        self.username_entry.delete(0, END)
        self.password_entry.delete(0, END)
        self.message_label.config(text="")
        self.login_frame.place(x=500, y=y_pos-20)

        self.login_button.config(command=lambda: self.login(user_type))
        self.signup_button.config(command=lambda: self.sign_up(user_type))
        self.back_button.config(command=self.hide_login)

    def hide_login(self):
        self.login_frame.place_forget()

    def login(self, user_type):
        username = self.username_entry.get()
        password = self.password_entry.get()
        if username in users_db:
            stored = users_db[username]
            if isinstance(stored, dict):
                ok = (stored.get("password") == password)
                role = stored.get("role", user_type.lower())
            else:
                ok = (stored == password)
                role = user_type.lower()
            if ok:
                # Αποθήκευση τρέχοντος χρήστη/ρόλου για χρήση σε views
                self.current_username = username
                self.current_role = role
                self.message_label.config(text=f"Login successful as {role}!", fg="green")
                # Μετά το login, εμφάνιση σελίδας οντοτήτων ανά ρόλο (από αποθηκευμένο ρόλο)
                
                if role == "hobbyist":
                    HobbyistGUI.render_hobbyist_page(self, on_back=self.render_home)
                elif role == "administrator":
                    RoleViews.AdministratorView(self).render_entities(on_back=self.render_home)
                elif role == "verified-user":
                    RoleViews.VerifiedUserView(self).render_entities(on_back=self.render_home)
                elif role == "researcher":
                    RoleViews.ResearcherView(self).render_entities(on_back=self.render_home)
                else:
                    self.canvas.delete("all")
                    self.canvas.create_image(0, 0, image=self.bg_photo, anchor="nw")
                    self.canvas.create_text(500, 250, text=f"Welcome {username}!", fill="white", font=("Arial", 24, "bold"))
            else:
                self.message_label.config(text="Wrong password.", fg="red")
        else:
            self.message_label.config(text="User not found. Please Sign Up.", fg="red")

    def sign_up(self, user_type):
        username = self.username_entry.get()
        password = self.password_entry.get()
        if username in users_db:
            self.message_label.config(text="User already exists!", fg="red")
        else:
            users_db[username] = {"password": password, "role": user_type.lower()}
            self.message_label.config(text="Sign Up successful! You can now Login.", fg="green")

    def render_home(self):
        # Επαναφέρει την αρχική οθόνη (background, τίτλος, κουμπιά χρηστών)
        self.hide_login()
        self.canvas.delete("all")
        self.canvas.create_image(0, 0, image=self.bg_photo, anchor="nw")
        self.canvas.create_text(500, 30, text="Μενού επιλογών", fill="white", font=("Arial", 16, "bold"))
        self.create_user_buttons()
