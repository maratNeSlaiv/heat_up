import json

def convert_substitute_exerice_to_json(new_exercise):
    new_exercise = new_exercise.replace("'", '"')
    data = json.loads(new_exercise)
    # pretty_data = json.dumps(data, indent=4)
    return data

def display_workout(workout):
    for index, exercise in enumerate(workout):
        print(f"{index + 1}. {exercise['exercise']} - {exercise['sets']} sets, {exercise['reps']} reps")
