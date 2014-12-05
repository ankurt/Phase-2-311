-- CONSTRAINTS FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
----FOREIGN KEYS--
ALTER TABLE pets ADD CONSTRAINT pet_animal_fkey FOREIGN KEY(animal_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE pets ADD CONSTRAINT pet_owner_fkey FOREIGN KEY(owner_id) REFERENCES owners (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE medicine_costs ADD CONSTRAINT medicine_cost_id_fkey FOREIGN KEY(medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_aid_fkey FOREIGN KEY(animal_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_mid_fkey FOREIGN KEY(medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_vid_fkey FOREIGN KEY(visit_id) REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_mid_fkey FOREIGN KEY(medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE treatments ADD CONSTRAINT treatment_visit_fkey FOREIGN KEY(visit_id) REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE treatments ADD CONSTRAINT treatment_procedure_fkey FOREIGN KEY(procedure_id) REFERENCES procedures (id) ON DELETE RESTRICT ON UPDATE CASCADE; 

ALTER TABLE procedure_costs ADD CONSTRAINT procedure_costs_pid_fkey FOREIGN KEY(procedure_id) REFERENCES procedures (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE notes ADD CONSTRAINT note_user_fkey FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE;

--DOMAIN CONSTRAINTS--

ALTER TABLE owners ADD CONSTRAINT validate_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

ALTER TABLE owners ADD CONSTRAINT validate_phone CHECK (phone)

ALTER TABLE visits ADD CONSTRAINT validate_weight CHECK (weight > 0);

ALTER TABLE 


--NULL VALUES--

ALTER TABLE medicine_costs ALTER DOMAIN end_date SET DEFAULT NULL;

ALTER TABLE procedure_costs ALTER DOMAIN end_date SET DEFAULT NULL;