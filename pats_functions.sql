-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

----6----
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

