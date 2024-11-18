import tkinter as tk
from tkinter import messagebox
from exercise_plan_builder.list_of_exercises import universal_workout
from exercise_plan_builder.prompt_builder import get_exercise_substitution
from exercise_plan_builder.generative_ai_tools import replace_current_exercise_double_try

class WorkoutApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Тренировочный план")
        self.has_been_recommended = []
        self.workout = []
        self.create_muscle_group_selection()

    def create_muscle_group_selection(self):
        # Очистка окна
        for widget in self.root.winfo_children():
            widget.destroy()
        
        # Заголовок
        label = tk.Label(self.root, text="Какую группу мышц будем качать сегодня?")
        label.pack(pady=10)

        # Кнопки для выбора группы мышц
        for muscle_group in universal_workout.keys():
            button = tk.Button(self.root, text=muscle_group, command=lambda mg=muscle_group: self.select_muscle_group(mg))
            button.pack(pady=5)

    def select_muscle_group(self, muscle_group):
        self.workout = universal_workout[muscle_group]
        self.display_exercises(muscle_group)

    def display_exercises(self, muscle_group):
        # Очистка окна
        for widget in self.root.winfo_children():
            widget.destroy()
        
        # Заголовок
        label = tk.Label(self.root, text=f"Упражнения для {muscle_group}:")
        label.pack(pady=10)
        
        # Отображение упражнений
        for i, exercise in enumerate(self.workout, 1):
            button = tk.Button(self.root, text=f"{i}. {exercise['exercise']} (Подходы: {exercise['sets']}, Повторы: {exercise['reps']})", 
                               command=lambda idx=i-1: self.substitute_exercise(muscle_group, idx))
            button.pack(pady=5)
        
        # Кнопка для завершения
        done_button = tk.Button(self.root, text="Как есть", command=self.show_final_workout)
        done_button.pack(pady=10)

    def substitute_exercise(self, muscle_group, exercise_index):
        changed = self.workout[exercise_index]['exercise']
        current_workout = [exercise['exercise'] for exercise in self.workout]
        content = get_exercise_substitution(changed=changed, muscle_group=muscle_group, current_workout=current_workout, 
                                            has_been_recommended=self.has_been_recommended, exercises_list=None)
        new_exercise = replace_current_exercise_double_try(content=content)
        
        # Подтверждение замены упражнения
        if messagebox.askyesno(
                "Замена упражнения",
                f"Заменить {changed} на {new_exercise['name']}?\n\n"
                f"Повторы: {new_exercise['reps']}\n"
                f"Подходы: {new_exercise['sets']}\n"
                f"Преимущества: {new_exercise.get('pros', 'Нет данных')}\n"
                f"Недостатки: {new_exercise.get('cons', 'Нет данных')}"
            ):
            self.workout[exercise_index] = {
                'exercise': new_exercise['name'],
                'sets': new_exercise['sets'],
                'reps': new_exercise['reps']
            }
            self.has_been_recommended.append(new_exercise['name'])
        
        self.display_exercises(muscle_group)

    def show_final_workout(self):
        # Отображение финального плана тренировки
        final_workout = "\n".join([f"{exercise['exercise']} - Подходы: {exercise['sets']}, Повторы: {exercise['reps']}" for exercise in self.workout])
        messagebox.showinfo("Ваш план тренировки", final_workout)

# Создание главного окна приложения
if __name__ == '__main__':
    root = tk.Tk()
    app = WorkoutApp(root)
    root.mainloop()
