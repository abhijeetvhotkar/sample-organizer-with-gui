import tkinter as tk
from tkinter import filedialog, messagebox
from organizer.mover import organize_samples

class SampleOrganizerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Sample Organizer")

        self.input_path = tk.StringVar()
        self.output_path = tk.StringVar()
        self.copy_files = tk.BooleanVar(value=False)

        # Configure column 1 to stretch
        root.columnconfigure(1, weight=1)

        # Title
        tk.Label(root, text="🎧 Sample Organizer", font=("Helvetica", 16, "bold")).grid(
            row=0, column=0, columnspan=3, pady=(10, 0))
        tk.Label(root, text="Organize your samples with style!", font=("Helvetica", 10)).grid(
            row=1, column=0, columnspan=3, pady=(0, 10))

        # Input Folder Row
        tk.Label(root, text="Input Folder").grid(row=2, column=0, sticky="w", padx=10)
        tk.Entry(root, textvariable=self.input_path).grid(row=2, column=1, sticky="ew", padx=10)
        tk.Button(root, text="Browse", command=self.select_input).grid(row=2, column=2, padx=10)

        # Output Folder Row
        tk.Label(root, text="Output Folder").grid(row=3, column=0, sticky="w", padx=10, pady=5)
        tk.Entry(root, textvariable=self.output_path).grid(row=3, column=1, sticky="ew", padx=10)
        tk.Button(root, text="Browse", command=self.select_output).grid(row=3, column=2, padx=10)

        # Copy checkbox
        tk.Checkbutton(root, text="Copy files instead of moving", variable=self.copy_files).grid(
            row=4, column=1, sticky="w", padx=10, pady=10)

        # Organize button
        tk.Button(root, text="Organize", command=self.organize).grid(
            row=5, column=1, pady=(0, 20))

    def select_input(self):
        path = filedialog.askdirectory()
        if path:
            self.input_path.set(path)

    def select_output(self):
        path = filedialog.askdirectory()
        if path:
            self.output_path.set(path)

    def organize(self):
        input_dir = self.input_path.get()
        output_dir = self.output_path.get()
        if not input_dir or not output_dir:
            messagebox.showerror("Error", "Both input and output directories must be selected.")
            return
        try:
            organize_samples(input_dir, output_dir, copy_files=self.copy_files.get())
            messagebox.showinfo("Success", "Samples organized successfully.")
        except Exception as e:
            messagebox.showerror("Error", str(e))

if __name__ == "__main__":
    root = tk.Tk()
    app = SampleOrganizerApp(root)
    root.mainloop()