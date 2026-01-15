from tkinter import *
from tkinter import ttk
from PIL import Image, ImageTk
import mysql.connector


class BaseEntitiesView:
    def __init__(self, app, title_prefix="Οντότητες της βάσης"):
        self.app = app
        self.title_prefix = title_prefix

    def render_entities(self, on_back=None):
        # Καθαρισμός και σχεδίαση υπόβαθρου
        self.app.hide_login()
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(450, 30, text=self.title_prefix, fill="white", font=("Arial", 18, "bold"))

        tables, err = _get_entities_from_db()
        if err:
            c.create_text(450, 80, text=err, fill="red", font=("Arial", 12, "bold"))
            back_btn = Button(self.app.root, text="Πίσω", command=(on_back if on_back else self.app.render_home))
            c.create_window(410, 480, window=back_btn)
            return

        list_frame = Frame(self.app.root, bg="#000000")
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
            self.render_table_preview(tbl, on_back_entities=lambda: self.render_entities(on_back=on_back))

        listbox.bind("<Double-Button-1>", _open_selected)

        back_btn = Button(self.app.root, text="Πίσω", command=(on_back if on_back else self.app.render_home))
        c.create_window(410, 480, window=back_btn)

    def render_table_preview(self, table_name, on_back_entities):
        # Καθαρισμός και υπόβαθρο
        self.app.hide_login()
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(450, 30, text=f"Παραδείγματα: {table_name}", fill="white", font=("Arial", 18, "bold"))

        cols, rows, err = _get_table_preview(table_name)
        if err:
            c.create_text(450, 80, text=err, fill="red", font=("Arial", 12, "bold"))
            back_btn = Button(self.app.root, text="Πίσω", command=on_back_entities)
            c.create_window(410, 480, window=back_btn)
            return

        if not cols:
            c.create_text(450, 80, text="Δεν βρέθηκαν στήλες/δεδομένα", fill="white", font=("Arial", 12, "bold"))
            back_btn = Button(self.app.root, text="Πίσω", command=on_back_entities)
            c.create_window(410, 480, window=back_btn)
            return

        table_frame = Frame(self.app.root, bg="#000000")
        c.create_window(450, 270, window=table_frame, width=700, height=380)

        yscroll = Scrollbar(table_frame, orient=VERTICAL)
        xscroll = Scrollbar(table_frame, orient=HORIZONTAL)
        tree = ttk.Treeview(table_frame, columns=cols, show="headings",
                            yscrollcommand=yscroll.set, xscrollcommand=xscroll.set)
        yscroll.config(command=tree.yview)
        xscroll.config(command=tree.xview)

        for col in cols:
            tree.heading(col, text=col)
            tree.column(col, width=120, stretch=True)

        for r in rows:
            tree.insert("", END, values=r)

        tree.pack(fill=BOTH, expand=True)
        xscroll.pack(fill=X)
        yscroll.pack(side=RIGHT, fill=Y)

        # Store references for subclasses (selection, updates)
        self._current_tree = tree
        self._current_cols = cols
        self._current_table = table_name

        back_btn = Button(self.app.root, text="Πίσω", command=on_back_entities)
        c.create_window(410, 480, window=back_btn)


class VerifiedUserView(BaseEntitiesView):
    def __init__(self, app):
        super().__init__(app, title_prefix="Verified-user | Οντότητες")
    
    def render_entities(self, on_back=None):
        # Main menu για VerifiedUser
        self.app.hide_login()
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(450, 50, text="Verified-user | Μενού", fill="white", font=("Arial", 18, "bold"))

        menu_frame = LabelFrame(self.app.root, text="Επιλογές", bg="#000000", fg="white")
        c.create_window(450, 250, window=menu_frame, width=500, height=250)

        Label(menu_frame, text="Τι θέλεις να κάνεις;", bg="#000000", fg="white", font=("Arial", 12, "bold")).pack(pady=(20, 20))

        Button(menu_frame, text="Προβολή Δεδομένων", command=self._show_data_view, width=30, height=2).pack(pady=10, padx=20, fill='x')
        Button(menu_frame, text="Νέα Παρατήρηση", command=self._show_submission_form, width=30, height=2).pack(pady=10, padx=20, fill='x')

        back_btn = Button(self.app.root, text="Πίσω", command=(on_back if on_back else self.app.render_home))
        c.create_window(410, 480, window=back_btn)

    def _show_data_view(self):
        """Προβολή δεδομένων από όλους τους πίνακες"""
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(200, 30, text="Verified-user | Προβολή Δεδομένων", fill="white", font=("Arial", 16, "bold"))

        tables, err = _get_entities_from_db()
        if err:
            c.create_text(450, 80, text=err, fill="red", font=("Arial", 12, "bold"))
            back_btn = Button(self.app.root, text="Πίσω", command=lambda: self.render_entities())
            c.create_window(410, 480, window=back_btn)
            return

        list_frame = Frame(self.app.root, bg="#000000")
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
            self.render_table_preview(tbl, on_back_entities=lambda: self._show_data_view())

        listbox.bind("<Double-Button-1>", _open_selected)

        back_btn = Button(self.app.root, text="Πίσω", command=lambda: self.render_entities())
        c.create_window(410, 480, window=back_btn)

    def render_table_preview(self, table_name, on_back_entities):
        """Προβολή δεδομένων για verified user"""
        super().render_table_preview(table_name, on_back_entities)
        c = self.app.canvas

        actions = LabelFrame(self.app.root, text="Ενέργειες", bg="#000000", fg="white")
        c.create_window(830, 270, window=actions, width=250, height=200)

        Button(actions, text="Πίσω", command=on_back_entities).pack(fill='x', padx=6, pady=(6, 4))

    def _show_submission_form(self):
        """Μενού επιλογής πίνακα για υποβολή νέων δεδομένων"""
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(200, 30, text="Νέα Δεδομένα - Επιλογή Πίνακα", fill="white", font=("Arial", 16, "bold"))

        tables, err = _get_entities_from_db()
        if err:
            c.create_text(450, 80, text=err, fill="red", font=("Arial", 12, "bold"))
            back_btn = Button(self.app.root, text="Πίσω", command=lambda: self.render_entities())
            c.create_window(410, 480, window=back_btn)
            return

        list_frame = Frame(self.app.root, bg="#000000")
        c.create_window(450, 270, window=list_frame, width=500, height=380)

        Label(list_frame, text="Επέλεξε πίνακα για υποβολή δεδομένων", bg="#000000", fg="white", font=("Arial", 12, "bold")).pack(fill="x", pady=(10, 4))

        listbox = Listbox(list_frame, bg="#111111", fg="white", font=("Arial", 11), activestyle="none")
        listbox.pack(fill="both", expand=True, padx=10, pady=(0, 10))

        for tbl in tables:
            listbox.insert(END, tbl)

        def _submit_for_table(event=None):
            sel = listbox.curselection()
            if not sel:
                return
            tbl = listbox.get(sel[0])
            self._show_table_submission_form(tbl)

        listbox.bind("<Double-Button-1>", _submit_for_table)

        back_btn = Button(self.app.root, text="Πίσω", command=lambda: self.render_entities())
        c.create_window(410, 480, window=back_btn)

    def _show_table_submission_form(self, table_name):
        """Φόρμα υποβολής δεδομένων για οποιονδήποτε πίνακα"""
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(200, 30, text=f"Νέα Δεδομένα - {table_name}", fill="white", font=("Arial", 16, "bold"))

        cols_meta = _get_table_columns(table_name)
        pk_cols = _get_pk_columns(table_name)
        form_cols = [cm for cm in cols_meta if 'auto_increment' not in (cm.get('extra', '').lower())]

        form_frame = LabelFrame(self.app.root, text="Δεδομένα", bg="#000000", fg="white")
        c.create_window(450, 250, window=form_frame, width=700, height=300)

        entries = {}
        user_col = _find_user_column(cols_meta)

        for i, cm in enumerate(form_cols[:15]):
            if i % 2 == 0:
                row_frame = Frame(form_frame, bg="#000000")
                row_frame.pack(fill='x', padx=10, pady=4)
            
            Label(row_frame, text=cm['name'] + ":", bg="#000000", fg="white", width=15).pack(side='left', padx=4)
            e = Entry(row_frame, width=25, bg="#111111", fg="white")
            if user_col and cm['name'] == user_col and hasattr(self.app, 'current_username'):
                e.insert(0, self.app.current_username)
            e.pack(side='left', padx=4)
            entries[cm['name']] = e

        def submit():
            if not hasattr(self.app, 'current_username'):
                _toast(self.app, "Δεν βρέθηκε ο χρήστης.", False)
                return
            
            values = {}
            for col_name, entry in entries.items():
                values[col_name] = entry.get().strip()
            
            try:
                # Υπολογισμός pending table name
                if table_name.endswith('s'):
                    pending_table = table_name[:-1] + '_pending'
                else:
                    pending_table = table_name + '_pending'
                
                conn = mysql.connector.connect(
                    host="127.0.0.1",
                    user="root",
                    password="Bb1044287588!!",
                    database="milkyway",
                )
                cursor = conn.cursor()
                
                cols = list(values.keys()) + ['submitted_by', 'status']
                vals = list(values.values()) + [self.app.current_username, 'pending']
                placeholders = ', '.join(['%s'] * len(cols))
                sql = f"INSERT INTO `{pending_table}` ({', '.join([f'`{c}`' for c in cols])}) VALUES ({placeholders})"
                cursor.execute(sql, vals)
                conn.commit()
                cursor.close()
                conn.close()
                _toast(self.app, "Δεδομένα υποβλήθηκαν για έγκριση!", True)
                self.render_entities()
            except mysql.connector.Error as err:
                _toast(self.app, f"Σφάλμα: {err}", False)

        btns = Frame(form_frame, bg="#000000")
        btns.pack(fill='x', padx=10, pady=10)
        Button(btns, text="Υποβολή", command=submit).pack(side='left', padx=4)
        Button(btns, text="Πίσω", command=lambda: self._show_submission_form()).pack(side='right', padx=4)



class AdministratorView(BaseEntitiesView):
    def __init__(self, app):
        super().__init__(app, title_prefix="Administrator | Οντότητες")
    
    def render_table_preview(self, table_name, on_back_entities):
        super().render_table_preview(table_name, on_back_entities)
        c = self.app.canvas
        cols_meta = _get_table_columns(table_name)
        pk_cols = _get_pk_columns(table_name)
        status_col = _find_status_column(cols_meta)

        actions = LabelFrame(self.app.root, text="Ενέργειες", bg="#000000", fg="white")
        c.create_window(830, 270, window=actions, width=250, height=380)

        # Επιλογή στήλης κατάστασης
        status_choice = StringVar(value=(status_col or (self._current_cols[0] if self._current_cols else "")))
        row_status = Frame(actions, bg="#000000")
        row_status.pack(fill='x', padx=6, pady=(6, 4))
        Label(row_status, text="Στήλη κατάστασης:", bg="#000000", fg="white", font=("Arial", 9)).pack(side='left')
        status_combo = ttk.Combobox(row_status, values=self._current_cols, textvariable=status_choice, width=14, state="readonly")
        status_combo.pack(side='right')

        def delete_selected():
            tree = self._current_tree
            sel = tree.selection()
            if not sel:
                _toast(self.app, "Επέλεξε μία γραμμή πρώτα.", False)
                return
            values = tree.item(sel[0], 'values')
            cols = self._current_cols
            row = {c: values[i] for i, c in enumerate(cols)}
            pk_vals = {c: row.get(c) for c in pk_cols if c in row}
            if not pk_vals:
                _toast(self.app, "Δεν βρέθηκε PK για διαγραφή.", False)
                return
            ok, msg = _delete_row_by_pk(table_name, pk_vals)
            _toast(self.app, msg, ok)
            self.render_table_preview(table_name, on_back_entities)

        def approve_selected():
            chosen_status = status_choice.get()
            if not chosen_status:
                _toast(self.app, "Επίλεξε στήλη κατάστασης.", False)
                return
            tree = self._current_tree
            sel = tree.selection()
            if not sel:
                _toast(self.app, "Επέλεξε μία γραμμή πρώτα.", False)
                return
            values = tree.item(sel[0], 'values')
            cols = self._current_cols
            row = {c: values[i] for i, c in enumerate(cols)}
            pk_vals = {c: row.get(c) for c in pk_cols if c in row}
            ok, msg = _update_row_by_pk(table_name, pk_vals, {chosen_status: 'approved'})
            _toast(self.app, msg, ok)
            self.render_table_preview(table_name, on_back_entities)

        def reject_selected():
            chosen_status = status_choice.get()
            if not chosen_status:
                _toast(self.app, "Επίλεξε στήλη κατάστασης.", False)
                return
            tree = self._current_tree
            sel = tree.selection()
            if not sel:
                _toast(self.app, "Επέλεξε μία γραμμή πρώτα.", False)
                return
            values = tree.item(sel[0], 'values')
            cols = self._current_cols
            row = {c: values[i] for i, c in enumerate(cols)}
            pk_vals = {c: row.get(c) for c in pk_cols if c in row}
            ok, msg = _update_row_by_pk(table_name, pk_vals, {chosen_status: 'rejected'})
            _toast(self.app, msg, ok)
            self.render_table_preview(table_name, on_back_entities)

        def show_users():
            # Προβολή καταχωρημένων χρηστών στο actions panel
            for w in actions.winfo_children():
                w.destroy()
            Label(actions, text="Χρήστες", bg="#000000", fg="white", font=("Arial", 11, "bold")).pack(anchor='w', padx=6, pady=(6, 4))
            users_list = Listbox(actions, bg="#111111", fg="white")
            users_list.pack(fill='both', expand=True, padx=6, pady=6)
            users = []
            if hasattr(self.app, 'get_users') and callable(self.app.get_users):
                users = self.app.get_users()
            for u, role in users:
                users_list.insert(END, f"{u}  ({role or 'unknown'})")
            Button(actions, text="Κλείσιμο", command=lambda: self.render_table_preview(table_name, on_back_entities)).pack(fill='x', padx=6, pady=6)

        # Επιπλέον κουμπιά έγκρισης/απόρριψης, προβολής χρηστών και εκκρεμών παρατηρήσεων
        Button(actions, text="Διαγραφή", command=delete_selected).pack(fill='x', padx=6, pady=(6, 4))
        Button(actions, text="Έγκριση", command=approve_selected).pack(fill='x', padx=6, pady=(0, 4))
        Button(actions, text="Απόρριψη", command=reject_selected).pack(fill='x', padx=6, pady=(0, 6))
        Button(actions, text="Προβολή χρηστών", command=show_users).pack(fill='x', padx=6, pady=(0, 6))
        Button(actions, text="Εκκρεμείς Παρατηρήσεις", command=lambda: self.show_pending_observations(on_back_entities)).pack(fill='x', padx=6, pady=(0, 6))

    def show_pending_observations(self, on_back):
        """Εμφανίζει προτάσεις παρατηρήσεων για έγκριση/απόρριψη"""
        c = self.app.canvas
        c.delete("all")
        c.create_image(0, 0, image=self.app.bg_photo, anchor="nw")
        c.create_text(200, 30, text="Προτάσεις Παρατηρήσεων", fill="white", font=("Arial", 18, "bold"))
        
        try:
            conn = mysql.connector.connect(host='127.0.0.1', user='root', password='Bb1044287588!!', db='milkyway')
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM `pending_observations` WHERE `status`='pending'")
            pending = cursor.fetchall()
            
            cols_meta = _get_table_columns('observations')
            cols = list(cols_meta)
            cursor.close()
            conn.close()
        except Exception as e:
            _toast(self.app, f"Σφάλμα φόρτωσης: {str(e)}", False)
            back_btn = Button(c, text="Πίσω", command=on_back)
            c.create_window(410, 480, window=back_btn)
            return

        # Αριστερό πάνελ: Λίστα προτάσεων
        list_frame = Frame(self.app.root, bg="#000000")
        c.create_window(150, 250, window=list_frame, width=250, height=380)
        
        Label(list_frame, text="Προτάσεις", bg="#000000", fg="white", font=("Arial", 11, "bold")).pack(fill="x", pady=(10, 4))
        listbox = Listbox(list_frame, bg="#111111", fg="white", font=("Arial", 9), activestyle="none")
        listbox.pack(fill="both", expand=True, padx=10, pady=(0, 10))
        
        for i, obs in enumerate(pending):
            user = obs.get('submitted_by', 'Unknown')
            listbox.insert(END, f"#{obs['id']} - {user}")
        
        # Δεξί πάνελ: Προβολή λεπτομερειών προτάσης
        detail_frame = LabelFrame(self.app.root, text="Λεπτομέρειες", bg="#000000", fg="white")
        c.create_window(550, 250, window=detail_frame, width=700, height=380)

        detail_text = Text(detail_frame, width=85, height=18, bg="#111111", fg="white", font=("Arial", 9))
        detail_text.pack(padx=10, pady=10, fill='both', expand=True)

        scrollbar = Scrollbar(detail_text)
        scrollbar.pack(side='right', fill='y')
        detail_text.config(yscrollcommand=scrollbar.set)
        scrollbar.config(command=detail_text.yview)

        selected_obs = [None]

        def show_details(event=None):
            sel = listbox.curselection()
            if not sel:
                return
            idx = sel[0]
            obs = pending[idx]
            selected_obs[0] = obs
            
            detail_text.config(state='normal')
            detail_text.delete("1.0", END)
            
            detail_text.insert(END, f"ID: {obs['id']}\n")
            detail_text.insert(END, f"Υπέβαλε: {obs.get('submitted_by', 'Unknown')}\n")
            detail_text.insert(END, "─" * 80 + "\n\n")
            
            for col_name, val in obs.items():
                if col_name not in ['id', 'status', 'submitted_by']:
                    detail_text.insert(END, f"{col_name}: {val}\n")
            
            detail_text.config(state='disabled')

        listbox.bind("<Double-Button-1>", show_details)
        listbox.bind("<Button-1>", show_details)
        
        # Actions panel
        actions = LabelFrame(self.app.root, text="Ενέργειες", bg="#000000", fg="white")
        c.create_window(830, 270, window=actions, width=250, height=250)
        
        def approve_selected():
            if not selected_obs[0]:
                _toast(self.app, "Επέλεξε πρόταση πρώτα.", False)
                return
            
            obs = selected_obs[0]
            obs_id = obs['id']
            
            try:
                conn = mysql.connector.connect(host='127.0.0.1', user='root', password='Bb1044287588!!', db='milkyway')
                cursor = conn.cursor()
                
                # Προετοιμασία δεδομένων για εισαγωγή
                cols = _get_table_columns('observations')
                col_names = [c['name'] for c in cols if 'auto_increment' not in c.get('extra', '')]
                insert_cols = [c for c in col_names if c not in ['status', 'submitted_by', 'id']]
                
                # Δημιουργία ερωτήματος εισαγωγής
                placeholders = ', '.join(['%s'] * len(insert_cols))
                insert_vals = [obs.get(c) for c in insert_cols]
                sql = f"INSERT INTO `observations` ({', '.join([f'`{c}`' for c in insert_cols])}) VALUES ({placeholders})"
                cursor.execute(sql, insert_vals)
                
                # Διαγραφή από pending
                cursor.execute("DELETE FROM `pending_observations` WHERE `id`=%s", (obs_id,))
                conn.commit()
                cursor.close()
                conn.close()
                
                _toast(self.app, "Πρόταση εγκρίθηκε!", True)
                self.show_pending_observations(on_back)
            except Exception as e:
                _toast(self.app, f"Σφάλμα: {str(e)}", False)
        
        def reject_selected():
            if not selected_obs[0]:
                _toast(self.app, "Επέλεξε πρόταση πρώτα.", False)
                return
            
            obs = selected_obs[0]
            obs_id = obs['id']
            
            try:
                conn = mysql.connector.connect(host='127.0.0.1', user='root', password='Bb1044287588!!', db='milkyway')
                cursor = conn.cursor()
                cursor.execute("DELETE FROM `pending_observations` WHERE `id`=%s", (obs_id,))
                conn.commit()
                cursor.close()
                conn.close()
                
                _toast(self.app, "Πρόταση απορρίφθηκε.", True)
                self.show_pending_observations(on_back)
            except Exception as e:
                _toast(self.app, f"Σφάλμα: {str(e)}", False)
        
        Button(actions, text="Έγκριση", command=approve_selected).pack(fill='x', padx=6, pady=(6, 4))
        Button(actions, text="Απόρριψη", command=reject_selected).pack(fill='x', padx=6, pady=(0, 6))
        Button(actions, text="Πίσω", command=on_back).pack(fill='x', padx=6, pady=(0, 6))


class ResearcherView(BaseEntitiesView):
    def __init__(self, app):
        super().__init__(app, title_prefix="Researcher | Οντότητες")

    def render_table_preview(self, table_name, on_back_entities):
        super().render_table_preview(table_name, on_back_entities)
        c = self.app.canvas
        cols_meta = _get_table_columns(table_name)
        pk_cols = _get_pk_columns(table_name)
        user_col = _find_user_column(cols_meta)

        actions = LabelFrame(self.app.root, text="Ενέργειες", bg="#000000", fg="white")
        c.create_window(830, 270, window=actions, width=250, height=380)

        # Επιλογή στήλης χρήστη/ιδιοκτήτη
        user_choice = StringVar(value=(user_col or (self._current_cols[0] if self._current_cols else "")))
        row_user = Frame(actions, bg="#000000")
        row_user.pack(fill='x', padx=6, pady=(6, 4))
        Label(row_user, text="Στήλη χρήστη:", bg="#000000", fg="white", font=("Arial", 9)).pack(side='left')
        user_combo = ttk.Combobox(row_user, values=self._current_cols, textvariable=user_choice, width=14, state="readonly")
        user_combo.pack(side='right')

        def add_new():
            for w in actions.winfo_children():
                w.destroy()
            Label(actions, text="Νέα καταχώρηση", bg="#000000", fg="white", font=("Arial", 11, "bold")).pack(anchor='w', padx=6, pady=(6, 4))
            form_cols = [cm for cm in cols_meta if 'auto_increment' not in (cm.get('extra','').lower())]
            entries = {}
            chosen_user = user_choice.get() or user_col
            
            # Εμφάνιση όλων των πεδίων
            for i, cm in enumerate(form_cols):
                rowf = Frame(actions, bg="#000000")
                rowf.pack(fill='x', padx=6, pady=2)
                Label(rowf, text=cm['name'], bg="#000000", fg="white").pack(side='left')
                
                # Έλεγχος αν είναι foreign key
                is_fk = False
                fk_values = []
                if 'referenced_table' in cm and cm['referenced_table']:
                    is_fk = True
                    # Λήψη διαθέσιμων τιμών από τον referenced table
                    try:
                        conn = mysql.connector.connect(
                            host="127.0.0.1",
                            user="root",
                            password="Bb1044287588!!",
                            database="milkyway",
                        )
                        cursor = conn.cursor()
                        ref_col = cm.get('referenced_column', 'id')
                        cursor.execute(f"SELECT DISTINCT `{ref_col}` FROM `{cm['referenced_table']}` ORDER BY `{ref_col}`")
                        fk_values = [str(row[0]) for row in cursor.fetchall()]
                        cursor.close()
                        conn.close()
                    except:
                        pass
                
                if is_fk and fk_values:
                    # Combobox για foreign key
                    e = ttk.Combobox(rowf, values=fk_values, width=16, state="readonly")
                    e.pack(side='right')
                else:
                    # Entry για άλλα πεδία
                    e = Entry(rowf, width=18)
                    if chosen_user and cm['name'] == chosen_user and hasattr(self.app, 'current_username'):
                        e.insert(0, self.app.current_username)
                    e.pack(side='right')
                
                entries[cm['name']] = e

            def save_new_entry():
                values = {k: v.get().strip() if isinstance(v.get(), str) else str(v.get()) for k, v in entries.items()}

                # Αν υπάρχει στήλη χρήστη ΠΡΑΓΜΑΤΙΚΗ (όχι FK), συμπλήρωσέ την με τον τρέχοντα χρήστη αν είναι κενή
                effective_user_col = chosen_user or user_col
                if effective_user_col and hasattr(self.app, 'current_username'):
                    # Βρες το metadata της στήλης
                    col_meta = next((cm for cm in cols_meta if cm['name'] == effective_user_col), None)
                    # Μόνο αν ΔΕΝ είναι FK και το πεδίο είναι κενό
                    if col_meta and 'referenced_table' not in col_meta and not values.get(effective_user_col):
                        values[effective_user_col] = self.app.current_username

                # Έλεγχος για κενά πεδία
                if all(not v for v in values.values()):
                    _toast(self.app, "Όλα τα πεδία είναι κενά.", False)
                    return
                try:
                    conn = mysql.connector.connect(
                        host="127.0.0.1",
                        user="root",
                        password="Bb1044287588!!",
                        database="milkyway",
                    )
                    cursor = conn.cursor()
                    cols = ", ".join([f"`{k}`" for k in values.keys()])
                    placeholders = ", ".join(["%s"] * len(values))
                    sql = f"INSERT INTO `{table_name}` ({cols}) VALUES ({placeholders})"
                    cursor.execute(sql, tuple(values.values()))
                    conn.commit()
                    cursor.close()
                    conn.close()
                    _toast(self.app, "Η καταχώρηση προστέθηκε με επιτυχία!", True)
                    # Ανανέωση του πίνακα για εμφάνιση του νέου παραδείγματος
                    self.render_table_preview(table_name, on_back_entities)
                except mysql.connector.Error as err:
                    _toast(self.app, f"Σφάλμα: {str(err)}", False)

            btns = Frame(actions, bg="#000000")
            btns.pack(fill='x', padx=6, pady=6)
            Button(btns, text="Αποθήκευση", command=save_new_entry).pack(side='left')
            Button(btns, text="Άκυρο", command=lambda: self.render_table_preview(table_name, on_back_entities)).pack(side='right')

        def edit_mine():
            chosen_user = user_choice.get() or user_col
            
            # Έλεγχος αν η επιλεγμένη στήλη είναι ΠΡΑΓΜΑΤΙΚΑ στήλη χρήστη (όχι FK)
            col_meta = next((cm for cm in cols_meta if cm['name'] == chosen_user), None) if chosen_user else None
            is_real_user_column = col_meta and 'referenced_table' not in col_meta
            
            if not is_real_user_column:
                # Αν δεν υπάρχει πραγματική στήλη χρήστη, επιτρέπουμε edit σε όλα τα δεδομένα
                _toast(self.app, "Προσοχή: Δεν υπάρχει στήλη χρήστη - επιτρέπεται επεξεργασία όλων.", True)
            elif not hasattr(self.app, 'current_username'):
                _toast(self.app, "Δεν βρέθηκε ο τρέχων χρήστης.", False)
                return
            
            tree = self._current_tree
            sel = tree.selection()
            if not sel:
                _toast(self.app, "Επέλεξε μία γραμμή πρώτα.", False)
                return
            values = tree.item(sel[0], 'values')
            cols = self._current_cols
            row = {c: values[i] for i, c in enumerate(cols)}
            row_user_val = row.get(chosen_user, "")
            
            # Έλεγχος ownership ΜΟΝΟ αν υπάρχει πραγματική στήλη χρήστη
            if is_real_user_column and chosen_user in row and row_user_val not in ("", None):
                if str(row_user_val) != str(getattr(self.app, 'current_username', "")):
                    _toast(self.app, "Μπορείς να τροποποιήσεις μόνο δικά σου δεδομένα.", False)
                    return
            
            pk_vals = {c: row.get(c) for c in pk_cols if c in row}
            editable_cols = [cm['name'] for cm in cols_meta if cm['name'] not in pk_cols]
            # Μην επιτρέπεις αλλαγή του user_col αν είναι πραγματική στήλη χρήστη
            if is_real_user_column:
                editable_cols = [name for name in editable_cols if name != chosen_user]

            for w in actions.winfo_children():
                w.destroy()
            Label(actions, text="Επεξεργασία (δικά μου)", bg="#000000", fg="white", font=("Arial", 11, "bold")).pack(anchor='w', padx=6, pady=(6, 4))
            entries = {}
            for name in editable_cols[:8]:
                rowf = Frame(actions, bg="#000000")
                rowf.pack(fill='x', padx=6, pady=2)
                Label(rowf, text=name, bg="#000000", fg="white").pack(side='left')
                e = Entry(rowf, width=18)
                e.insert(0, str(row.get(name, "")))
                e.pack(side='right')
                entries[name] = e

            extra_updates = {}
            if is_real_user_column and row_user_val in ("", None):
                extra_updates[chosen_user] = getattr(self.app, 'current_username', "")

            btns = Frame(actions, bg="#000000")
            btns.pack(fill='x', padx=6, pady=6)
            Button(btns, text="Αποθήκευση", command=lambda: _save_update(self, table_name, pk_vals, entries, on_back_entities, extra_updates)).pack(side='left')
            Button(btns, text="Άκυρο", command=lambda: self.render_table_preview(table_name, on_back_entities)).pack(side='right')

        Button(actions, text="Νέα καταχώρηση", command=add_new).pack(fill='x', padx=6, pady=(6, 4))
        Button(actions, text="Τροποποίηση (δικά μου)", command=edit_mine).pack(fill='x', padx=6, pady=(0, 6))


# DB helpers

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
        query = f"SELECT * FROM `{table_name}` LIMIT {int(limit)}"
        cursor.execute(query)
        rows = cursor.fetchall()
        cols = [desc[0] for desc in cursor.description] if cursor.description else []
        cursor.close()
        conn.close()
        return cols, rows, ""
    except mysql.connector.Error as err:
        return [], [], f"Σφάλμα βάσης: {err}"


def _get_table_preview_filtered(table_name, where_col, where_value, limit=50):
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        query = f"SELECT * FROM `{table_name}` WHERE `{where_col}` = %s LIMIT {int(limit)}"
        cursor.execute(query, (where_value,))
        rows = cursor.fetchall()
        cols = [desc[0] for desc in cursor.description] if cursor.description else []
        cursor.close()
        conn.close()
        return cols, rows, ""
    except mysql.connector.Error as err:
        return [], [], f"Σφάλμα βάσης: {err}"


def _get_table_columns(table_name):
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        cursor.execute(
            "SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, EXTRA "
            "FROM information_schema.columns WHERE TABLE_SCHEMA=%s AND TABLE_NAME=%s ORDER BY ORDINAL_POSITION",
            ("milkyway", table_name),
        )
        meta = []
        for name, ctype, is_null, key, extra in cursor.fetchall():
            col_info = {"name": name, "type": ctype, "nullable": is_null, "key": key, "extra": extra}
            
            # Λήψη foreign key πληροφοριών
            cursor.execute(
                "SELECT REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME "
                "FROM information_schema.KEY_COLUMN_USAGE "
                "WHERE TABLE_SCHEMA=%s AND TABLE_NAME=%s AND COLUMN_NAME=%s AND REFERENCED_TABLE_NAME IS NOT NULL",
                ("milkyway", table_name, name),
            )
            fk_result = cursor.fetchone()
            if fk_result:
                col_info['referenced_table'] = fk_result[0]
                col_info['referenced_column'] = fk_result[1]
            
            meta.append(col_info)
        
        cursor.close()
        conn.close()
        return meta
    except mysql.connector.Error:
        return []


def _get_pk_columns(table_name):
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        cursor.execute(
            "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE "
            "WHERE TABLE_SCHEMA=%s AND TABLE_NAME=%s AND CONSTRAINT_NAME='PRIMARY' ORDER BY ORDINAL_POSITION",
            ("milkyway", table_name),
        )
        cols = [row[0] for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return cols
    except mysql.connector.Error:
        return []


def _delete_row_by_pk(table_name, pk_values):
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        where = " AND ".join([f"`{k}`=%s" for k in pk_values.keys()])
        sql = f"DELETE FROM `{table_name}` WHERE {where}"
        cursor.execute(sql, tuple(pk_values.values()))
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return True, f"Διαγράφηκαν {affected} γραμμές."
    except mysql.connector.Error as err:
        return False, f"Σφάλμα διαγραφής: {err}"


def _update_row_by_pk(table_name, pk_values, updates):
    try:
        if not updates:
            return False, "Δεν υπάρχουν αλλαγές."
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        set_clause = ", ".join([f"`{k}`=%s" for k in updates.keys()])
        where = " AND ".join([f"`{k}`=%s" for k in pk_values.keys()])
        sql = f"UPDATE `{table_name}` SET {set_clause} WHERE {where}"
        params = tuple(updates.values()) + tuple(pk_values.values())
        cursor.execute(sql, params)
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return True, f"Τροποποιήθηκαν {affected} γραμμές."
    except mysql.connector.Error as err:
        return False, f"Σφάλμα ενημέρωσης: {err}"


def _insert_row(table_name, values):
    try:
        if not values:
            return False, "Κενή καταχώρηση."
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="Bb1044287588!!",
            database="milkyway",
        )
        cursor = conn.cursor()
        cols = ", ".join([f"`{k}`" for k in values.keys()])
        placeholders = ", ".join(["%s"] * len(values))
        sql = f"INSERT INTO `{table_name}` ({cols}) VALUES ({placeholders})"
        cursor.execute(sql, tuple(values.values()))
        conn.commit()
        cursor.close()
        conn.close()
        return True, "Η καταχώρηση προστέθηκε."
    except mysql.connector.Error as err:
        return False, f"Σφάλμα εισαγωγής: {err}"


def _save_insert(view, table_name, entries, on_back_entities):
    values = {k: v.get() for k, v in entries.items()}
    # Αν υπάρχει στήλη χρήστη, βεβαιώσου ότι αντιστοιχεί στον τρέχοντα χρήστη
    cols_meta = _get_table_columns(table_name)
    user_col = _find_user_column(cols_meta)
    if user_col and hasattr(view.app, 'current_username'):
        # Αν λείπει ή είναι κενό, όρισε το στον τρέχοντα χρήστη
        if not values.get(user_col):
            values[user_col] = view.app.current_username
    ok, msg = _insert_row(table_name, values)
    _toast(view.app, msg, ok)
    view.render_table_preview(table_name, on_back_entities)


def _save_update(view, table_name, pk_vals, entries, on_back_entities, extra_updates=None):
    updates = {k: v.get() for k, v in entries.items()}
    if extra_updates:
        updates.update(extra_updates)
    ok, msg = _update_row_by_pk(table_name, pk_vals, updates)
    _toast(view.app, msg, ok)
    view.render_table_preview(table_name, on_back_entities)


def _find_user_column(cols_meta):
    candidates = {"user", "username", "observer", "submitted_by", "verified_user", "owner", "author", "researcher", "user_id"}
    names = [cm['name'].lower() for cm in cols_meta]
    for cand in candidates:
        for cm in cols_meta:
            if cm['name'].lower() == cand:
                return cm['name']
    return None


def _find_status_column(cols_meta):
    candidates = {"status", "approval_status", "state"}
    for cm in cols_meta:
        if cm['name'].lower() in candidates:
            return cm['name']
    return None


def _toast(app, message, success=True):
    # Απλή ένδειξη μηνύματος επάνω από το back button
    c = app.canvas
    color = "green" if success else "red"
    c.create_text(750, 480, text=message, fill=color, font=("Arial", 10, "bold"))
