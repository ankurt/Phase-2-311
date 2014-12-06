-- VIEWS FOR PATS DATABASE
--
-- by (klouie) & (ankurt)
--
--
--owners view--
create view owners_view as
	select owners.first_name, owners.last_name, owners.street, owners.city, owners.state,
		owners.zip, owners.phone, owners.email, owners.active, pets.name, pets.female, pets.date_of_birth, pets.active,
		visits.date, visits.weight, visits.overnight_stay, visits.total_charge
	from owners join pets using (owner_id) join visits using (pet_id);

create view medicine_views as 
	select medicines.name, medicines.description, medicines.stock_amount, medicines.method, medicines.unit, 
		medicines.vaccine, medicine_costs.cost_per_unit AS "Current Cost", medicine_costs.end_date AS "Last Changed",
		animals.name, animals.active
	from medicines join medicine_costs using (medicine_id) join animal_medicines using (medicine_id)
		join animals using (animal_id);

--The second view is to be called 'medicine_views' and connects information from the medicine, 
--animal and cost tables together. This view should also replace animal_id with the animal name. 
--In terms of costs, the only costs that need to appear are the current cost_per_unit for the medicine 
--(column should be called 'current cost') as well as the date the medicine's cost last changed.