-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (klouie) & (ankurt)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

CREATE OR REPLACE function calculate_total_costs(visit INT) RETURNS INT AS $$
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
            UPDATE visits SET total_charge = total;
        RETURN total;
    END;

$$ language 'plpgsql';



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
AFTER UPDATE ON visits
EXECUTE PROCEDURE calculate_overnight_stay(visits.id);





-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)




-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)




-- decrease_stock_amount_after_dosage
-- (associated with a trigger: update_stock_amount_for_medicines)




-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)




-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)

