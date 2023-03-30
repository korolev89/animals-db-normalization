import sqlite3


def query_to_db(query: str, param: str) -> list:
    with sqlite3.connect("animal.db") as connection:
        cursor = connection.cursor()
        cursor.execute(query, (param,))
        return cursor.fetchall()


def proces_response(response: list) -> {}:
    colors = []
    if len(response) > 1:
        for response_item in response:
            colors.append(response_item[10])
    elif len(response) == 1:
        colors.append(response[0][10])
    else:
        return {}

    return {
        "animal_id": response[0][0],
        "name": response[0][1],
        "animal_type": response[0][2],
        "breed": response[0][3],
        "data_of_birth": response[0][4],
        "age_upon_outcome": response[0][5],
        "outcome_type": response[0][6],
        "outcome_subtype": response[0][7],
        "outcome_month": response[0][8],
        "outcome_year": response[0][9],
        "color": colors
    }


def get_animal(animal_id: str) -> {}:
    query = f"""
        SELECT animals_new.animal_id, name, animal_type.animal_type, breed.breed, date_of_birth, 
            age_upon_outcome, outcome.outcome_type, outcome.outcome_subtype, outcome.outcome_month, outcome.outcome_year,
            colors.color 
        FROM animals_new
        JOIN animal_type
            ON animal_type.id = animals_new.animal_type_id 
        JOIN breed
            ON breed.id = animals_new.breed_id 
        JOIN outcome
            ON outcome.id = animals_new.outcome_id
        JOIN animals_colors_new
            ON animals_colors_new.animal_id = animals_new.id
        JOIN colors
            ON colors.id = animals_colors_new.color_id 
        WHERE animals_new.id = ?
    """
    db_response = query_to_db(query, animal_id)
    return proces_response(db_response)
