import tkinter as tk
from tkinter import messagebox
from exercise_plan_builder.build_exerice_plan import WorkoutApp  # Импортируйте ваш класс для тренировки здесь

class MainApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Выбор")
        self.create_main_menu()

    def create_main_menu(self):
        label = tk.Label(self.root, text="Выберите действие:")
        label.pack(pady=10)

        workout_button = tk.Button(self.root, text="Тренировка", command=self.open_workout_window)
        workout_button.pack(pady=5)

        nutrition_button = tk.Button(self.root, text="Питание", command=self.nutrition_not_implemented)
        nutrition_button.pack(pady=5)

    def open_workout_window(self):
        self.root.destroy()
        workout_root = tk.Tk()
        workout_app = WorkoutApp(workout_root)
        workout_root.mainloop()

    def nutrition_not_implemented(self):
        messagebox.showinfo("Информация", "Раздел 'Питание' пока не реализован.")

# Создание главного окна приложения
if __name__ == "__main__":
    root = tk.Tk()
    app = MainApp(root)
    root.mainloop()
