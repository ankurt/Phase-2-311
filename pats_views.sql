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