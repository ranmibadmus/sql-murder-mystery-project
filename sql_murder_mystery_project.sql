-- This is a sql learning sample as seen on https://mystery.knightlab.com/ --

/* TASK: You vaguely remember that the crine was a murder that occured sometime on Jan. 15, 2018 and 
that it took place in SQL City. Start by retrieving the corresponding crine scene report from the 
Police department's database */

SELECT * FROM Crime_scene_report

-- Filter the crime scene report to identify crimes on Jan. 15 in SQL City --

SELECT * FROM Crime_scene_report
WHERE DATE = 20180115 AND City = 'SQL City'

/* The Description of the murder case reads: Security footage shows that there were 2 witnesses. The 
first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives 
somewhere on "Franklin Ave". */

/* From the description in the crime scene report table, our witnesses details are:
1. First witness lives at the last house on Northwestern Dr
2. The second witness is Annabel who lives on Franklin Ave. */


-- Find witness one who lives on Northwestern Dr. --
SELECT * FROM person

-- Locate Address for Witness 1 --
SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'

-- Locate Witness by house number --
SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC

--Witness 1 is 'Morty Schapiro'. id: 14887, license_id: 118009, address no.: 4919, ssn: 111564949--

-- TASK TWO: Find witness 2 - Annabel, she lives on Franklin Ave. --

SELECT * FROM person
WHERE name LIKE 'Annabel%'
AND address_street_name = 'Franklin Ave'

-- Witness 2 is Annabel Miller, id: 16371, loicense_id: 490173, address no: 103, ssn: 318771143 --

-- Now, look into the interview table to get both witnesses report --
SELECT * FROM Interview

-- Show Id's 14887 and 16371  for 2 witnesses --

SELECT * FROM interview
WHERE person_id IN (14887, 16371)

/* Morty's report: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". Only gold members have those bags. The man 
got into a car with a plate that included "H42W".

Annabel's report: I saw the murder happen, and I recognized the killer from my gym when I was 
working out last week on January the 9th.*/

-- Filter get fit gym membership table to see suspect according to Morty's report --
SELECT * FROM get_fit_now_member
WHERE id LIKE '48Z%'
AND membership_status = 'gold'

/* From Morty's witness, thxere are 2 suspects:
- Joe Germuska, id: 48Z7A, person id: 28819, start date: 20160305, gold member
- Jeremy Bowers, id: 48Z55, person id: 67318, start date: 20160101, gold member */

-- filter gym check in table to highlight suspect according to Annabel's witnes --

SELECT * FROM get_fit_now_check_in
WHERE check_in_date = '20180109'
AND Membership_id IN ('48Z7A', '48Z55')

-- both suspects where at the gym on January 9th --

-- Filter drivers license table to find the murderer by the plate number from Morty's report --
SELECT * FROM drivers_license

-- Join drivers license table with person table, and query it to find murderer's name --
SELECT * FROM person

SELECT dl.age, dl.height, dl.hair_color, dl.gender, dl.plate_number, dl.car_make, dl.car_model, p.name, p.ssn,
p.address_street_name, p.id
FROM drivers_license AS dl
LEFT JOIN person AS p
ON dl.id = p.license_id
WHERE plate_number LIKE '%H42W%'


-- THE MURDERER IS 'Jeremy Bowers' according to our query --

/* If you think you're up for a challenge, try querying the interview transcript of the murderer to 
find the real villian behind the crime. */
-- Jeremy Bower's person_id: 67318

SELECT * FROM interview
WHERE person_id = 67318

/* Murderer's transcript: I was hired by a woman with a lot of money. I don't know her name but I know s
he's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she 
attended the SQL Symphony Concert 3 times in December 2017. */

-- Query drivers license table to discover the real villian with the features described by Jeremy Bowers --

SELECT * FROM drivers_license
WHERE height BETWEEN 65 AND 67
AND hair_color = 'red'
AND gender = 'female'
AND car_make = 'Tesla'
AND car_model = 'Model S'

-- The ID's of the suspected villians are: 202298, 291182, 918773 --

-- CREATE table containing the details of the three suspects --
CREATE TABLE Suspect AS (SELECT * FROM drivers_license
WHERE height BETWEEN 65 AND 67
AND hair_color = 'red'
AND gender = 'female'
AND car_make = 'Tesla'
AND car_model = 'Model S'
)

SELECT * FROM suspect

-- query facebook event check in table to see who was at SQL Symphony Concert 3 times in December 2017 --

SELECT * FROM Facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231


-- TO get person_id of the suspects, join the suspects table with the person table --

SELECT s.id, s.age, s.height, p.id AS person_id, p.name, p.ssn, p.address_street_name
FROM Suspect AS s
RIGHT JOIN person AS P
ON s.id = p.license_id

/* The person_ids of the three suspects are:
- Miranda Priestly, person id: 99716
- Regina George, person id: 90700
- Red Korb, person id: 78881 */

SELECT * FROM Facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
AND Person_id IN (99716, 90700, 78881)


-- Person id, 99716, was at SQL Symphony Concert 3 times in December. --

-- THEREFORE, 'Miranda Priestly' is the real villian in this --

