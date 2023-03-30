-- create table to set up colors list
CREATE TABLE IF NOT EXISTS colors(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	color VARCHAR(50)												
)

-- fill colors table with unique values from color1 and color2 columns
INSERT INTO colors(color)
SELECT DISTINCT * FROM (
	SELECT DISTINCT color1
	FROM animals
	WHERE color1 IS NOT NULL 
	UNION ALL 
	SELECT DISTINCT color2
	FROM animals 
	WHERE color2 IS NOT NULL 
)

-- create table to make many-to-many relation between animals and colors
CREATE TABLE IF NOT EXISTS animal_colors(
	animal_id INTEGER,
	color_id INTEGER,
	FOREIGN KEY (animal_id) REFERENCES animals ("index"),
	FOREIGN KEY (color_id) REFERENCES colors (id)
)

-- fill table with all animal-color combinations based on the values
INSERT INTO animal_colors
SELECT DISTINCT animals."index", colors.id
FROM animals
JOIN colors
	ON animals.color1 = colors.color
UNION ALL
SELECT DISTINCT animals."index", colors.id
FROM animals
JOIN colors
	ON animals.color2 = colors.color
	
-- create table for outcome information
CREATE TABLE IF NOT EXISTS outcome(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	outcome_type VARCHAR(50),
	outcome_subtype VARCHAR(50),
	outcome_month INTEGER,
	outcome_year INTEGER
)

-- fill the outcome table with values
INSERT INTO outcome(outcome_type, outcome_subtype, outcome_month, outcome_year)
SELECT DISTINCT animals.outcome_type, animals.outcome_subtype, animals.outcome_month, animals.outcome_year 
FROM animals 
		
-- create table for breed values
CREATE TABLE breed(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	breed VARCHAR(100)
)

-- fill the breed table with unique values
INSERT INTO breed(breed)
SELECT DISTINCT breed 
FROM animals

-- create table for animal types
CREATE TABLE animal_type(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	animal_type VARCHAR(50)
)

-- fill the animal type table with unique values
INSERT INTO animal_type(animal_type)
SELECT DISTINCT animal_type
FROM animals

 
-- create new table for animals with relations to separate animal type, breed and outcome tables
CREATE TABLE animals_new(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	age_upon_outcome VARCHAR(50),
	animal_id VARCHAR(50),
	animal_type_id INTEGER,
	name VARCHAR(50),
	breed_id INTEGER,
	date_of_birth DATE,
	outcome_id INTEGER,	
	FOREIGN KEY (animal_type_id) REFERENCES animal_type(id),
	FOREIGN KEY (breed_id) REFERENCES breed(id),
	FOREIGN KEY (outcome_id) REFERENCES outcome(id)
)

-- fill the animals new table with values
INSERT INTO animals_new (age_upon_outcome, animal_id, animal_type_id, name, breed_id, date_of_birth, outcome_id)
SELECT animals.age_upon_outcome, animals.animal_id, animal_type.id, animals.name, breed.id, animals.date_of_birth, outcome.id
FROM animals
LEFT JOIN outcome
	ON outcome.outcome_subtype = animals.outcome_subtype 
	AND outcome.outcome_type = animals.outcome_type
	AND outcome.outcome_month = animals.outcome_month 
	AND outcome.outcome_year = animals.outcome_year
JOIN animal_type
	ON animals.animal_type = animal_type.animal_type
JOIN breed
	ON animals.breed = breed.breed


-- create new table for animals-colors relation based on animals new table
CREATE TABLE animals_colors_new(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	animal_id INTEGER,
	color_id INTEGER,
	FOREIGN KEY (animal_id) REFERENCES animals_new(id),
	FOREIGN KEY (color_id) REFERENCES colors(id)
)

-- fill the animals colors new table
INSERT INTO animals_colors_new(animal_id, color_id)
SELECT DISTINCT animals_new.id, colors.id
FROM animals
JOIN colors
	ON colors.color = animals.color1 
JOIN animals_new
	ON animals.animal_id = animals_new.animal_id 
UNION ALL
SELECT DISTINCT animals_new.id, colors.id
FROM animals
JOIN colors
	ON colors.color = animals.color2
JOIN animals_new
	ON animals.animal_id = animals_new.animal_id 
	
-- delete inital animals table and animal_colors table
--DROP TABLE colors 
--DROP TABLE animal_colors