from tkinter import *
from tkinter import ttk
from PIL import Image, ImageTk
import mysql.connector


def render_hobbyist_page(app, on_back=None):
    # Καθαρισμός και σχεδίαση υπόβαθρου μέσα στο ίδιο παράθυρο
    app.hide_login()
    c = app.canvas
    c.delete("all")
    c.create_image(0, 0, image=app.bg_photo, anchor="nw")
    # Τοποθέτηση τίτλου όπως στο προηγούμενο popup (x=450, y=30)
    c.create_text(450, 30, text="Οντότητες της βάσης", fill="white", font=("Arial", 18, "bold"))

    tables, err = _get_entities_from_db()
    if err:
        c.create_text(500, 80, text=err, fill="red", font=("Arial", 12, "bold"))
        back_btn = Button(app.root, text="Πίσω", command=(on_back if on_back else app.render_home))
        # Κουμπί πίσω όπως πριν (x≈410, y=480)
        c.create_window(410, 480, window=back_btn)
        return

    if not tables:
        c.create_text(500, 80, text="Δεν βρέθηκαν οντότητες", fill="white", font=("Arial", 12, "bold"))
        back_btn = Button(app.root, text="Πίσω", command=(on_back if on_back else app.render_home))
        c.create_window(410, 480, window=back_btn)
        return

    # Frame μέσα στο Canvas ώστε να καθαρίζεται αυτόματα με c.delete("all")
    list_frame = Frame(app.root, bg="#000000")
    # Κέντρο λίστας όπως στο popup: frame από x=200..700, y=80..460 => κέντρο (450, 270)
    c.create_window(450, 270, window=list_frame, width=500, height=380)

    Label(list_frame, text="Όνομα Οντότητας", bg="#000000", fg="white", font=("Arial", 12, "bold")).pack(fill="x", pady=(10, 4))

    listbox = Listbox(list_frame, bg="#111111", fg="white", font=("Arial", 11), activestyle="none")
    listbox.pack(fill="both", expand=True, padx=10, pady=(0, 10))

    for tbl in tables:
        listbox.insert(END, tbl)

    def _open_selected(event=None):
        sel = listbox.curselection()
        if not sel:
            return
        tbl = listbox.get(sel[0])
        render_table_preview(app, tbl, on_back_entities=lambda: render_hobbyist_page(app, on_back=on_back))

    # Διπλό κλικ για άνοιγμα προεπισκόπησης πίνακα
    listbox.bind("<Double-Button-1>", _open_selected)

    back_btn = Button(app.root, text="Πίσω", command=(on_back if on_back else app.render_home))
    c.create_window(410, 480, window=back_btn)


def render_table_preview(app, table_name, on_back_entities):
    # Καθαρισμός και υπόβαθρο
    app.hide_login()
    c = app.canvas
    c.delete("all")
    c.create_image(0, 0, image=app.bg_photo, anchor="nw")
    c.create_text(450, 30, text=f"Παραδείγματα: {table_name}", fill="white", font=("Arial", 18, "bold"))

    cols, rows, err = _get_table_preview(table_name)
    if err:
        c.create_text(450, 80, text=err, fill="red", font=("Arial", 12, "bold"))
        back_btn = Button(app.root, text="Πίσω", command=on_back_entities)
        c.create_window(410, 480, window=back_btn)
        return

    if not cols:
        c.create_text(450, 80, text="Δεν βρέθηκαν στήλες/δεδομένα", fill="white", font=("Arial", 12, "bold"))
        back_btn = Button(app.root, text="Πίσω", command=on_back_entities)
        c.create_window(410, 480, window=back_btn)
        return

    # Πλαίσιο πίνακα (Treeview) στο κέντρο όπως πριν
    table_frame = Frame(app.root, bg="#000000")
    c.create_window(450, 270, window=table_frame, width=700, height=380)

    # Scrollbars
    yscroll = Scrollbar(table_frame, orient=VERTICAL)
    xscroll = Scrollbar(table_frame, orient=HORIZONTAL)
    tree = ttk.Treeview(table_frame, columns=cols, show="headings",
                        yscrollcommand=yscroll.set, xscrollcommand=xscroll.set)
    yscroll.config(command=tree.yview)
    xscroll.config(command=tree.xview)

    # Ορισμός επικεφαλίδων
    for col in cols:
        tree.heading(col, text=col)
        tree.column(col, width=120, stretch=True)

    # Εισαγωγή γραμμών
    for r in rows:
        tree.insert("", END, values=r)

    # Διάταξη
    tree.pack(fill=BOTH, expand=True)
    xscroll.pack(fill=X)
    yscroll.pack(side=RIGHT, fill=Y)

    # Πίσω στα entities
    back_btn = Button(app.root, text="Πίσω", command=on_back_entities)
    c.create_window(410, 480, window=back_btn)


def _get_entities_from_db():
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES")
        tables = [row[0] for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return tables, ""
    except mysql.connector.Error as err:
        return [], f"Σφάλμα βάσης: {err}"


def _get_table_preview(table_name, limit=10):
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        # Προεπισκόπηση στήλες + δεδομένα
        query = f"SELECT * FROM `{table_name}` LIMIT {int(limit)}"
        cursor.execute(query)
        rows = cursor.fetchall()
        cols = [desc[0] for desc in cursor.description] if cursor.description else []
        cursor.close()
        conn.close()
        return cols, rows, ""
    except mysql.connector.Error as err:
        return [], [], f"Σφάλμα βάσης: {err}"
