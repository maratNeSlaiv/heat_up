from exercise_plan_builder.list_of_exercises import full_list_of_exercises

def get_exercise_substitution(changed, muscle_group, current_workout, has_been_recommended, exercises_list = None):
    if not exercises_list:
        exercises_list = full_list_of_exercises[muscle_group]
        
    options = [x for x in exercises_list if x not in has_been_recommended]

    content = f"""
    What is the best substitution of {changed} in this {muscle_group} exercise list ?:
    {current_workout}
    Choose one from here:
        {options}
        , how many reps and sets should be done, what are pros and cons of this substitution?
    """
    return content