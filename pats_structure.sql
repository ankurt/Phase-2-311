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
  phone VARCHAR(20),
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