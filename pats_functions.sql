-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (klouie) & (atoshniw)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

CREATE OR REPLACE function calculate_total_costs(visit SERIAL) RETURNS VOID AS $$
    DECLARE
        total INT;
        medicines_cost INT;
        procedures_cost INT;
    BEGIN
            procedures_cost = (SELECT SUM(pc.cost * (1 - t.discount)) FROM procedure_costs pc JOIN procedures p ON pc.procedure_id = p.id 
                                JOIN treatments t ON p.id = t.procedure_id JOIN visits v ON t.visit_id = v.id WHERE visit.id = visit);
            medicines_cost = (SELECT SUM(mc.cost_per_unit * vm.units_given * (1- t.discount))) FROM medicine_costs mc JOIN medicine m ON 
                                mc.medicine_id = m.id JOIN visit_medicines vm ON m.id = vm.medicine_id JOIN visits v ON vm.visit_id = v.id
                                WHERE v.id = visit);
            total = procedures_cost + medicines_cost;
            UPDATE visits SET total_charge = total WHERE visits.id = visit;
        RETURN VOID;
    END;

$$ language 'plpgsql';

CREATE TRIGGER update_total_costs_for_medicines_changes
AFTER UPDATE ON visit_medicines
EXECUTE PROCEDURE calculate_total_costs(NEW.visit_id);

CREATE TRIGGER update_total_costs_for_treatments_changes
AFTER UPDATE ON treatments
EXECUTE PROCEDURE calculate_total_costs(NEW.visits_id);

-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)

CREATE OR REPLACE function calculate_overnight_stay(id SERIAL) RETURNS TRIGGER AS $$
	DECLARE
		procedure_time INT;
	BEGIN 
		procedure_time = (SELECT SUM(procedures.length_of_time) FROM procedures 
			JOIN treatments ON procedures.id = treatments.procedure_id 
			JOIN visits ON treatments.visit_id = visits.id
			WHERE visits.id = id);
		IF procedure_time > 720 THEN
			UPDATE visits SET overnight_stay = true;
		ELSE
			UPDATE visits SET overnight_stay = false;
		END IF;
		RETURN NULL;
	END;
$$ language 'plpgsql';

CREATE TRIGGER update_overnight_stay_flag
AFTER UPDATE ON treatments
EXECUTE PROCEDURE calculate_overnight_stay(visits.id);

-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)

CREATE OR REPLACE function set_end_date_for_previous_medicine_cost() RETURNS DATE AS $$
    DECLARE
        previous_ed DATE;
    BEGIN
        previous_ed = SELECT();
        previous_ed.end_date = current_date;
        RETURN previous_ed;
    END;

$$ language 'plpgsql';

CREATE TRIGGER set_end_date_for_previous_procedure_cost
AFTER 
EXECUTE PROCEDURE set_end_date_for_previous_medicine_cost();


-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)


-- decrease_stock_amount_after_dosage
-- (associated with a trigger: update_stock_amount_for_medicines)




-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)
CREATE OR REPLACE verify_that_medicine_requested_in_stock(medicine_id SERIAL, units_needed INT) RETURNS BOOLEAN AS $$
	DECLARE
		current_stock INT;
	BEGIN
		current_stock = (SELECT stock_amount FROM medicines WHERE medicines.id = medicine_id;
	IF current_stock >= units_needed THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;
END;

$$ language 'plpgsql';

-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)
CREATE OR REPLACE verify_that_medicine_is_appropriate_for_pet(medicine_id SERIAL, pet_id SERIAL) RETURNS BOOLEAN AS $$
	DECLARE
		medicine_animal VARCHAR(255);
		pet_animal VARCHAR(255);
	BEGIN
		medicine_animal = (SELECT animal_medicines.animal_id 
			FROM medicines JOIN animal_medicine ON medicines.id = animal_medicines.medicine_id
			WHERE animal_medicines.medicine_id = medicine_id);
		pet_animal = (SELECT pets.animal_id 
			FROM animals JOIN pets on animals.id = pets.animal_id
			WHERE pets.animal_id = pet_id);
		IF medicine_animal == pet_animal THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
END;

$$ language 'plpgsql';		
