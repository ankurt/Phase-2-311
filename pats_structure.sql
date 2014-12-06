-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
CREATE TABLE owners (
  id SERIAL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  street VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(2),
  zip VARCHAR(15),
  phone VARCHAR(10),
  email VARCHAR(100),
  active BOOLEAN
);

CREATE TABLE pets (
  id SERIAL,
  name VARCHAR(100),
  -- animal_id INT,
  -- owner_id INT,
  female BOOLEAN,
  date_of_birth DATE,
  active BOOLEAN
);

CREATE TABLE visits (
  id SERIAL,
  -- pet_id INT,
  date DATE,
  weight INT,
  overnight_stay BOOLEAN,
  total_charge INT
);

CREATE TABLE animals (
  id SERIAL,
  name VARCHAR(100),
  active BOOLEAN
  );

CREATE TABLE medicines (
  id SERIAL,
  name VARCHAR(100),
  description TEXT,
  stock_amount INT,
  method VARCHAR(100),
  unit VARCHAR(100),
  vaccine BOOLEAN
);

CREATE TABLE medicine_costs(
  id SERIAL,
  -- medicine_id INT
  cost_per_unit INT,
  start_date DATE,
  end_date DATE
);

CREATE TABLE animal_medicines(
  id SERIAL,
  -- animal_id INT,
  -- medicine_id INT,
  recommended_num_of_units INT
);

CREATE TABLE visit_medicines(
  id SERIAL,
  visit_id INT,
  medicine_id INT,
  units_given INT,
  discount NUMERIC(3, 2)
);

CREATE TABLE procedures(
  id SERIAL,
  name VARCHAR(100),
  description VARCHAR(255),
  length_of_time INT,
  active BOOLEAN
);

CREATE TABLE treatments(
  id SERIAL,
  visit_id INT
  -- procedure_id INT,
  successful BOOLEAN,
  discount NUMERIC(3, 2)
);

CREATE TABLE procedure_costs(
  id SERIAL,
  -- procedure_id INT,
  cost INT,
  start_date DATE,
  end_date DATE
);

CREATE TABLE notes(
id SERIAL,
notable_type,
-- notable_id INT,
title VARCHAR(100),
content TEXT,
-- user_id INT,
date DATE
);

CREATE TABLE users(
  id SERIAL
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role VARCHAR(50),
  username VARCHAR(50),
  password_digest VARCHAR(255),
  active BOOLEAN
);