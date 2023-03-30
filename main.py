from flask import Flask
from functions import get_animal

app = Flask(__name__)


@app.route("/<animal_id>")
def main_page(animal_id):
    return get_animal(animal_id)


if __name__ == "__main__":
    app.run()
