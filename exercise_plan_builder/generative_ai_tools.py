from openai import OpenAI
import os 
import logging
from exercise_plan_builder.utils import convert_substitute_exerice_to_json
import os 
from dotenv import load_dotenv

load_dotenv()
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

def replace_current_exercise(content):
    client = OpenAI(api_key=OPENAI_API_KEY)
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
            "role": "system",
            "content": """
            Format your answer as python dictionary: 
            'name' : Name of the chosen exercise, should be string 
            'reps' : number of repetitions, should be integer
            'sets' : number of sets, should be integer
            'pros' : advantages compared to the original exercise in bullet points format, should be list
            'cons' : disadvantages compared to the original exercise in bullet points format, should be list
            """
            },
            {
                "role": "user",
                "content": content
            }
        ]
    )
    new_exercise = response.choices[0].message.content
    return convert_substitute_exerice_to_json(new_exercise)


def replace_current_exercise_double_try(content):
    for attempt in range(2):  # Попробуем два раза
        try:
            return replace_current_exercise(content)
        except Exception as e:
            logging.warning(f"Attempt {attempt + 1} failed: {e}")
            if attempt == 1:  # Если вторая попытка тоже не удалась
                raise ValueError(f"Failed to convert response to JSON format after 2 attempts")
        finally:
            logging.info('Response has been processed')