DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS relationships;
DROP TABLE IF EXISTS parties;
DROP TABLE IF EXISTS


CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  department TEXT,
  title TEXT
);

CREATE TABLE performances (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER REFERENCES employees(id) NOT NULL,
  score NUMBER(1,1) CHECK (score >= 0 and score <= 10),
  date_reviewed TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE relationships (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER REFERENCES employees(id),
  "with" INTEGER REFERENCES employees(id),
  date_reported TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parties (
  id INTEGER PRIMARY KEY,
  party_name TEXT NOT NULL,
  on_site BOOLEAN NOT NULL DEFAULT 1,
  budget INTEGER CHECK (budget >= 0),
  scheduled TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events 1-7 and 9
INSERT INTO employees(first_name, last_name, department, title) VALUES
('Michael', 'Scott', 'Management', 'Regional Manager'),
('Dwight', 'Schrute', 'Sales', 'Assistant Regional Manager'),
('Jim', 'Halpert', 'Sales', 'Sales Representative'),
('Pam', 'Beesly', 'Reception', 'Receptionist'),
('Kelly', 'Kapoor', 'Product Oversight', 'Customer Service Representative'),
('Angela', 'Martin', 'Accounting', 'Head of Accounting'),
('Roy', 'Anderson', 'Warehouse', 'Warehouse Staff'),
('Ryan', 'Howard', 'Reception', 'Temp');

-- Events 8
-- "Roy Anderson" and "Pam Beesly" are in a romantic relationship.
INSERT INTO relationships(employee_id, "with")
SELECT
  (SELECT id FROM employees WHERE first_name = 'Roy'),
  (SELECT id FROM employees WHERE first_name = 'Pam');

INSERT INTO parties(party_name, budget) VALUES ('Kevin Birthday', 100);

-- 11 to 15
INSERT INTO performances(employee_id, score)
SELECT id, 3.3 FROM employees WHERE first_name = 'Dwight'
UNION ALL
SELECT id, 4.2 FROM employees WHERE first_name = 'Jim';

UPDATE performances
SET score = 9.0
WHERE employee_id = (SELECT id FROM employees WHERE first_name = 'Dwight');

UPDATE performances
SET score = 9.3
WHERE employee_id = (SELECT id FROM employees WHERE first_name = 'Jim');

-- 15 and 16
UPDATE employees
SET title = 'Assistant Regional Manager'
WHERE first_name = 'Jim';

UPDATE employees
SET title = 'Sales Representative', department = 'Sales'
WHERE first_name = 'Ryan';

-- 17 to 20
INSERT INTO parties(party_name, budget) VALUES('Ryan Promotion', 200);

INSERT INTO relationships(employee_id, "with")
SELECT
(SELECT id FROM employees WHERE first_name = 'Angela'),
(SELECT id FROM employees WHERE first_name = 'Dwight');

INSERT INTO performances(employee_id, score)
SELECT id, 6.2 FROM employees WHERE first_name = 'Angela';

INSERT INTO relationships(employee_id, "with")
SELECT
  (SELECT id FROM employees WHERE first_name = "Ryan"),
  (SELECT id FROM employees WHERE first_name = "Kelly");

-- 21 to 25
INSERT INTO parties(party_name, budget) VALUES ('Jim last day', 50);

DELETE FROM performances WHERE employee_id = (SELECT id FROM employees WHERE first_name = 'Jim');
DELETE FROM relationships
WHERE employee_id =
  (SELECT id FROM employees WHERE first_name = 'Jim')
  OR "with" =
  (SELECT id FROM employees WHERE first_name = 'Jim');
DELETE FROM employees WHERE first_name = 'Jim';

DELETE FROM relationships
WHERE employee_id =
(
(SELECT id FROM employees WHERE first_name = 'Roy') AND "with" = (SELECT id FROM employees WHERE first_name = 'Pam')
)
OR (
(SELECT id FROM employees WHERE first_name = 'Pam') AND "with" = (SELECT id FROM employees WHERE first_name = 'Roy')
);

INSERT INTO performances(employee_id, score)
SELECT id, 7.6 FROM employees WHERE first_name = 'Pam';

INSERT INTO performances(employee_id, score)
SELECT id, 8.7 FROM employees WHERE first_name = 'Dwight';

-- 26 to 30
DELETE FROM performances
WHERE employee_id = (SELECT id FROM employees WHERE first_name = 'Ryan');
DELETE FROM relationships
WHERE employee_id = (SELECT id FROM employees WHERE first_name = 'Ryan') OR "with" = (SELECT id FROM employees WHERE first_name = 'Ryan');
DELETE FROM employees
WHERE first_name = 'Ryan';

INSERT INTO employees(first_name, last_name, department, title) VALUES ('Jim', 'Halpert', 'Sales', 'Sales Representative');

INSERT INTO employees(first_name, last_name, department, title) VALUES ('Karen', 'Filippelli', 'Sales', 'Sales Representative');

INSERT INTO relationships(employee_id, 'with')
SELECT
  (SELECT id FROM employees WHERE first_name = 'Jim'),
  (SELECT id FROM employees WHERE first_name = 'Karen');

INSERT INTO parties(party_name, budget)
VALUES('Welcome Party', 120);

DELETE FROM parties
WHERE id = (
  SELECT id FROM parties
    WHERE id < (SELECT MAX(id) FROM parties)
    ORDER BY id DESC
    LIMIT 1
    );

--31 to 33
INSERT INTO parties(party_name, budget, on_site)
VALUES('Christmas Party', 300, 0);

DELETE FROM relationships WHERE
(
employee_id = (SELECT id FROM employees WHERE first_name = 'Jim') AND "with" = (SELECT id FROM employees WHERE first_name = 'Karen')
)
OR
(
employee_id = (SELECT id FROM employees WHERE first_name = 'Karen') AND "with" = (SELECT id FROM employees WHERE first_name = 'Jim')
);

INSERT INTO relationships(employee_id, "with")
SELECT
  (SELECT id FROM employees WHERE first_name = 'Pam'),
  (SELECT id FROM employees WHERE first_name = 'Jim');

--How would you change your database schema to track the employees who attended an office party?
CREATE TABLE attendance {
  id INTEGER PRIMARY KEY,
  party_id INTEGER REFERENCES parties(id),
  attendee INTEGER REFERENCES employees(id)
  arrived_at TIMESTEMP DEFAULT CURRENT_TIMESTAMP;
}

--How would you change your database schema to track vacation days taken by employees?
CREATE TABLE vacations {
  id INTEGER PRIMARY KEY,
  employee_id INTEGER REFERENCES employees(id),
  days INTEGER,
  takenAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
