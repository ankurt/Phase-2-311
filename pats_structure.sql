-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by atoshniw & klouie
--
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(2) NOT NULL,
  zip VARCHAR(15) NOT NULL,
  phone VARCHAR(10),
  email VARCHAR(100),
  active BOOLEAN NOT NULL
);

CREATE TABLE pets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  animal_id INT NOT NULL,
  owner_id INT NOT NULL,
  female BOOLEAN NOT NULL,
  date_of_birth DATE,
  active BOOLEAN NOT NULL
);

CREATE TABLE visits (
  id SERIAL PRIMARY KEY,
  pet_id INT NOT NULL,
  date DATE NOT NULL,
  weight INT,
  overnight_stay BOOLEAN NOT NULL,
  total_charge INT NOT NULL
);

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN NOT NULL
  );

CREATE TABLE medicines (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  stock_amount INT NOT NULL,
  method VARCHAR(100) NOT NULL,
  unit VARCHAR(100) NOT NULL,
  vaccine BOOLEAN NOT NULL
);

CREATE TABLE medicine_costs(
  id SERIAL PRIMARY KEY,
  medicine_id INT NOT NULL,
  cost_per_unit INT NOT NULL,
  start_date DATE NOT NULL, 
  end_date DATE
);

CREATE TABLE animal_medicines(
  id SERIAL PRIMARY KEY,
  animal_id INT NOT NULL,
  medicine_id INT NOT NULL,
  recommended_num_of_units INT
);

CREATE TABLE visit_medicines(
  id SERIAL PRIMARY KEY,
  visit_id INT NOT NULL,
  medicine_id INT NOT NULL,
  units_given INT NOT NULL,
  discount NUMERIC(3, 2) NOT NULL
);

CREATE TABLE procedures(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  length_of_time INT NOT NULL,
  active BOOLEAN NOT NULL
);

CREATE TABLE treatments(
  id SERIAL PRIMARY KEY,
  visit_id INT NOT NULL,
  procedure_id INT NOT NULL,
  successful BOOLEAN,
  discount NUMERIC(3, 2) NOT NULL
);

CREATE TABLE procedure_costs(
  id SERIAL PRIMARY KEY,
  procedure_id INT NOT NULL,
  cost INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE
);

CREATE TABLE notes(
  id SERIAL PRIMARY KEY,
  notable_type VARCHAR(100) NOT NULL,
  notable_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  user_id INT NOT NULL,
  date DATE
);

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  role VARCHAR(50) NOT NULL,
  username VARCHAR(50) NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL
);