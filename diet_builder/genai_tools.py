from openai import OpenAI
import os 
from dotenv import load_dotenv
import json
import ast

load_dotenv()
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

def suggest_meal_plan(preferences = 'No preferences', day_time = 'anytime of the day', medical_conditions = 'No conditions.'):

    client = OpenAI(api_key=OPENAI_API_KEY)
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": f"""Consider following when suggesting a diet plan: 
                medical conditions:{medical_conditions}, preferences:{preferences}.
                Give answer in a format of python list that contains only the names of meals.
                """
            },
            {
                "role": "user",
                "content": f"Give 7 meal names for the following day_time: {day_time}"
            }
        ]
    )
    answer = response.choices[0].message.content
    answer = ast.literal_eval(answer)
    return answer


# def replace_meal(preferences = 'No preferences', day_time = 'anytime of the day', medical_conditions = 'No conditions.'):

#     client = OpenAI(api_key=OPENAI_API_KEY)
#     response = client.chat.completions.create(
#         model="gpt-3.5-turbo",
#         messages=[
#             {
#                 "role": "system",
#                 "content": f"Consider following medical_conditions if any, when suggesting a diet plan: {medical_conditions}"
#             },
#             {
#                 "role": "system",
#                 "content": f"""Return answer in json format and nothing else: 
#                 1) 'name' : dish name, string
#                 2) 'ingredients' : list of ingredients
#                 3) 'macronutrients' : approximate macronutrients of a dish, dictionary with 3 keys: 'proteins', 'carbs', 'fats'
#                 """
#             },
#             {
#                 "role": "user",
#                 "content": f"Create 7 meal diet for the following day_time: {day_time}. Preferences: {preferences}"
#             }
#         ]
#     )
#     answer = response.choices[0].message.content
#     answer = json.loads(answer)
#     return answer