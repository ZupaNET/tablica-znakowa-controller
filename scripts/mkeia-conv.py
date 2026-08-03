import sqlite3
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import os


class HymnConverter:

    def __init__(self, old_db, new_db, log_callback, progress_callback):
        self.old_db = old_db
        self.new_db = new_db
        self.log = log_callback
        self.progress = progress_callback

        self.category_map = {}
        self.hymn_map = {}

    def convert(self):

        old = None
        new = None

        try:
            old = sqlite3.connect(self.old_db)
            new = sqlite3.connect(self.new_db)

            old.row_factory = sqlite3.Row
            new.row_factory = sqlite3.Row

            old_cur = old.cursor()
            new_cur = new.cursor()

            self.log("Rozpoczynam migrację...")
            new.execute("BEGIN")

            #
            # Kategorie
            #
            self.log("Import kategorii...")

            old_categories = old_cur.execute("""
                SELECT id, nazwa
                FROM piesni
                WHERE parent_id IS NULL
                ORDER BY id
            """).fetchall()

            for row in old_categories:
                new_cur.execute("""
                    INSERT INTO categories(Name)
                    VALUES (?)
                """, (row["nazwa"],))

                self.category_map[row["id"]] = new_cur.lastrowid

            self.log(
                f"Kategorie utworzone: {len(self.category_map)}"
            )


            #
            # Hymny
            #
            self.log("Import hymnów...")

            old_hymns = old_cur.execute("""
                SELECT id, parent_id, nazwa, font
                FROM piesni
                WHERE parent_id IS NOT NULL
                ORDER BY id
            """).fetchall()


            for row in old_hymns:

                category_id = self.category_map.get(
                    row["parent_id"]
                )

                new_cur.execute("""
                    INSERT INTO hymns(Name, CategoryId)
                    VALUES (?, ?)
                """, (
                    row["nazwa"],
                    category_id
                ))

                self.hymn_map[row["id"]] = {
                    "id": new_cur.lastrowid,
                    "font": row["font"] or 0
                }


            self.log(
                f"Hymny utworzone: {len(self.hymn_map)}"
            )


            #
            # Osierocone zwrotki
            #
            orphan_rows = old_cur.execute("""
                SELECT DISTINCT z.piesni_id
                FROM zwrotki z
                LEFT JOIN piesni p
                    ON p.id = z.piesni_id
                WHERE p.id IS NULL
            """).fetchall()


            orphan_ids = [
                r["piesni_id"]
                for r in orphan_rows
            ]


            orphan_hymn_id = None

            if orphan_ids:

                self.log(
                    "Wykryto osierocone zwrotki."
                )

                new_cur.execute("""
                    INSERT INTO hymns(Name, CategoryId)
                    VALUES (?, NULL)
                """,
                ("-- OSIEROCONE --",))

                orphan_hymn_id = new_cur.lastrowid

            #
            # Screens
            #
            self.log("Import ekranów...")


            total_screens = 0

            hymn_ids = list(self.hymn_map.keys())

            for old_hymn_id in hymn_ids:

                new_hymn_id = self.hymn_map[old_hymn_id]["id"]
                font = self.hymn_map[old_hymn_id]["font"]


                verses = old_cur.execute("""
                    SELECT
                        z.id,
                        z.lp,
                        t.tekst
                    FROM zwrotki z
                    LEFT JOIN tresc t
                        ON t.zwrotka_id = z.id
                    WHERE z.piesni_id = ?
                    ORDER BY z.lp
                """,
                (old_hymn_id,)).fetchall()


                orders = [
                    v["lp"]
                    for v in verses
                ]

                needs_fix = False

                if orders:

                    expected = list(
                        range(
                            min(orders),
                            min(orders) + len(orders)
                        )
                    )

                    if orders != expected:
                        needs_fix = True


                for index, verse in enumerate(verses):

                    if needs_fix:
                        display_order = index
                    else:
                        display_order = (
                            verse["lp"] -
                            min(orders)
                        )


                    new_cur.execute("""
                        INSERT INTO screens(
                            HymnId,
                            Text,
                            DisplayOrder,
                            Font
                        )
                        VALUES (?, ?, ?, ?)
                    """,
                    (
                        new_hymn_id,
                        verse["tekst"],
                        display_order,
                        font
                    ))

                    total_screens += 1


            #
            # Osierocone screens
            #
            if orphan_hymn_id:

                orphan_verses = old_cur.execute("""
                    SELECT
                        z.id,
                        z.lp,
                        t.tekst
                    FROM zwrotki z
                    LEFT JOIN piesni p
                        ON p.id = z.piesni_id
                    LEFT JOIN tresc t
                        ON t.zwrotka_id=z.id
                    WHERE p.id IS NULL
                    ORDER BY z.lp
                """).fetchall()


                for index, verse in enumerate(orphan_verses):

                    new_cur.execute("""
                        INSERT INTO screens(
                            HymnId,
                            Text,
                            DisplayOrder,
                            Font
                        )
                        VALUES (?, ?, ?, ?)
                    """,
                    (
                        orphan_hymn_id,
                        verse["tekst"],
                        index,
                        0
                    ))

                    total_screens += 1


                self.log(
                    f"Osierocone zwrotki: {len(orphan_verses)}"
                )


            new.commit()

            self.log("----------------------------")
            self.log("MIGRACJA ZAKOŃCZONA")
            self.log(
                f"Utworzonych ekranów: {total_screens}"
            )

            messagebox.showinfo(
                "Gotowe",
                "Migracja zakończona pomyślnie."
            )


        except Exception as e:

            if new:
                new.rollback()

            self.log("BŁĄD:")
            self.log(str(e))

            messagebox.showerror(
                "Błąd",
                str(e)
            )

        finally:

            if old:
                old.close()

            if new:
                new.close()



class App:

    def __init__(self, root):

        self.root = root
        root.title(
            "MKEiA to Tablica Znakowa Migrator"
        )
        root.geometry(
            "700x550"
        )

        self.old_path = tk.StringVar()
        self.new_path = tk.StringVar()


        tk.Label(
            root,
            text="Stara baza:"
        ).pack()

        tk.Entry(
            root,
            textvariable=self.old_path,
            width=80
        ).pack()

        tk.Button(
            root,
            text="Wybierz",
            command=self.select_old
        ).pack()


        tk.Label(
            root,
            text="Nowa baza:"
        ).pack()

        tk.Entry(
            root,
            textvariable=self.new_path,
            width=80
        ).pack()

        tk.Button(
            root,
            text="Wybierz",
            command=self.select_new
        ).pack()


        tk.Button(
            root,
            text="KONWERTUJ",
            height=2,
            command=self.run
        ).pack(pady=10)


        self.log_box = scrolledtext.ScrolledText(
            root,
            height=20
        )

        self.log_box.pack(
            fill="both",
            expand=True
        )


    def select_old(self):

        path = filedialog.askopenfilename(
            filetypes=[
                ("SQLite", "*.db *.sqlite"),
                ("All", "*.*")
            ]
        )

        if path:
            self.old_path.set(path)


    def select_new(self):

        path = filedialog.askopenfilename(
            filetypes=[
                ("SQLite", "*.db *.sqlite"),
                ("All", "*.*")
            ]
        )

        if path:
            self.new_path.set(path)


    def log(self, text):

        self.log_box.insert(
            tk.END,
            text + "\n"
        )

        self.log_box.see(
            tk.END
        )

        self.root.update()


    def run(self):

        if not os.path.exists(
            self.old_path.get()
        ):
            messagebox.showerror(
                "Błąd",
                "Nie wybrano starej bazy."
            )
            return


        if not os.path.exists(
            self.new_path.get()
        ):
            messagebox.showerror(
                "Błąd",
                "Nie wybrano nowej bazy."
            )
            return


        converter = HymnConverter(
            self.old_path.get(),
            self.new_path.get(),
            self.log,
            None
        )

        converter.convert()



if __name__ == "__main__":

    root = tk.Tk()
    app = App(root)
    root.mainloop()