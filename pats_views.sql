-- VIEWS FOR PATS DATABASE
--
-- by (klouie) & (atoshniw)
--
--
--owners view--
create view owners_view as
	select o.first_name, o.last_name, o.street, o.city, o.state,
		o.zip, o.phone, o.email, o.active AS "owner active", p.name, p.female, p.date_of_birth, p.active,
		v.date, v.weight, v.overnight_stay, v.total_charge
	from owners o 
    join pets p ON o.id = p.owner_id
    join visits v ON p.id = v.pet_id;

CREATE VIEW medicine_views AS 
	SELECT m.name, m.description, m.stock_amount, m.method, m.unit, 
		m.vaccine, mc.cost_per_unit AS "Current Cost", mc.end_date AS "Last Changed",
		a.name AS "Animal Name", a.active
	FROM medicines m
    JOIN medicine_costs mc ON mc.medicine_id = m.id
    JOIN animal_medicines am ON am.medicine_id = m.id
    JOIN animals a ON am.animal_id = a.id;
