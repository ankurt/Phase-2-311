-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (klouie) & (atoshniw)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

CREATE OR REPLACE function calculate_total_costs() RETURNS TRIGGER AS $$
    DECLARE
        total INT;
        medicines_cost INT;
        procedures_cost INT;
    BEGIN
            procedures_cost = (SELECT SUM(pc.cost * (1 - t.discount)) FROM procedure_costs pc JOIN procedures p ON pc.procedure_id = p.id 
                                JOIN treatments t ON p.id = t.procedure_id JOIN visits v ON t.visit_id = v.id WHERE visit.id = NEW.visit_id);
            medicines_cost = (SELECT SUM(mc.cost_per_unit * vm.units_given * (1 - t.discount)) FROM medicine_costs mc JOIN medicine m ON 
                                mc.medicine_id = m.id JOIN visit_medicines vm ON m.id = vm.medicine_id JOIN visits v ON vm.visit_id = v.id
                                WHERE v.id = NEW.visit_id);
            total = procedures_cost + medicines_cost;
            UPDATE visits SET total_charge = total WHERE visits.id = NEW.visit_id;
    END;
$$ language 'plpgsql';

CREATE TRIGGER update_total_costs_for_medicines_changes
AFTER UPDATE ON visit_medicines
EXECUTE PROCEDURE calculate_total_costs();

CREATE TRIGGER update_total_costs_for_treatments_changes
AFTER UPDATE ON treatments
EXECUTE PROCEDURE calculate_total_costs();

-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)

CREATE OR REPLACE function calculate_overnight_stay() RETURNS TRIGGER AS $$
	DECLARE
		procedure_time INT;
	BEGIN 
		procedure_time = (SELECT SUM(procedures.length_of_time) FROM procedures 
			JOIN treatments ON procedures.id = treatments.procedure_id 
			JOIN visits ON treatments.visit_id = visits.id
			WHERE visits.id = NEW.visit_id);
		IF procedure_time > 720 THEN
			UPDATE visits SET overnight_stay = true WHERE NEW.visit_id;
		ELSE
			UPDATE visits SET overnight_stay = false WHERE NEW.visit_id;
		END IF;
		RETURN NULL;
	END;
$$ language 'plpgsql';

CREATE TRIGGER update_overnight_stay_flag
BEFORE UPDATE ON treatments
EXECUTE PROCEDURE calculate_overnight_stay();

-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)

CREATE OR REPLACE function set_end_date_for_previous_medicine_cost() RETURNS TRIGGER AS $$
    BEGIN
        OLD.end_date = current_date;
    END;
$$ language 'plpgsql';

CREATE TRIGGER set_end_date_for_previous_procedure_cost
AFTER UPDATE ON medicine_costs
EXECUTE PROCEDURE set_end_date_for_previous_medicine_cost();


-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)

CREATE OR REPLACE function set_end_date_for_procedure_costs() RETURNS TRIGGER AS $$
    BEGIN
        OLD.end_date = current_date;
    END;
$$ language 'plpgsql';

CREATE TRIGGER set_end_date_for_previous_procedure_cost
AFTER UPDATE ON procedure_costs
EXECUTE PROCEDURE set_end_date_for_procedure_costs();


-- decrease_stock_amount_after_dosage
-- (associated with a trigger: update_stock_amount_for_medicines)
CREATE OR REPLACE function decrease_stock_amount_after_dosage() RETURNS TRIGGER AS $$
    DECLARE
        stock_amount INT;
        medicine RECORD;
    BEGIN
        stock_amount = (SELECT SUM(stock_amount) 
                        FROM visit_medicines vm JOIN medicine m ON vm.medicine_id = m.id
                        WHERE NEW.medicine_id = m.id);
        medicine = (SELECT stock_amount
                        FROM visit_medicines vm JOIN medicine m ON vm.medicine_id = m.id
                        WHERE NEW.medicine_id = m.id).first;
        IF NEW.stock_amount > 0 THEN
            medicine.stock_amount = stock_amount - OLD.units_given;
        END IF;
    END;
$$ language 'plpgsql';

CREATE TRIGGER update_stock_amount_for_medicines
AFTER UPDATE ON visit_medicines
EXECUTE PROCEDURE decrease_stock_amount_after_dosage();


-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)
CREATE OR REPLACE function verify_that_medicine_requested_in_stock(medid INT, units_needed INT) RETURNS BOOLEAN AS $$
	DECLARE
		current_stock INT;
	BEGIN
		current_stock = (SELECT stock_amount FROM medicines WHERE medicines.id = medicine_id);
	IF current_stock >= units_needed THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;
END;

$$ language 'plpgsql';

-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)
CREATE OR REPLACE function verify_that_medicine_is_appropriate_for_pet(medid INT, petid INT) RETURNS BOOLEAN AS $$
	DECLARE
		medicine_animal VARCHAR(255);
		pet_animal VARCHAR(255);
	BEGIN
		medicine_animal = (SELECT animal_medicines.animal_id 
			FROM medicines JOIN animal_medicines ON medicines.id = animal_medicines.medicine_id
			WHERE animal_medicines.medicine_id = medid);
		pet_animal = (SELECT pets.animal_id 
			FROM animals JOIN pets on animals.id = pets.animal_id
			WHERE pets.animal_id = petid);
		IF medicine_animal = pet_animal THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
    END;

$$ language 'plpgsql';	
