from diet_builder.genai_tools import suggest_meal_plan
import json
import tkinter as tk
from tkinter import messagebox
import ast

args = {
    "preferences": 'high protein',  # default is 'No preferences'
    "day_time": 'breakfast',  # default is 'anytime of the day'
    "medical_conditions": 'No conditions',  # default is 'No conditions'
}
suggestion = suggest_meal_plan(**args)
print("Suggested meals", suggestion)

