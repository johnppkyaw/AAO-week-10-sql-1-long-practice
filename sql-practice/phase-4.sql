DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS performances;
DROP TABLE IF EXISTS relationships;
DROP TABLE IF EXISTS parties;


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
  score INTEGER CHECK (score >= 0 and score <= 10),
  date_reviewed DATE DEFAULT GETDATE
);

CREATE TABLE relationships (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER REFERENCES employees(id),
  "with" INTEGER REFERENCES employees(id),
  date_reported DATE DEFAULT GETDATE
);

CREATE TABLE parties (
  id INTEGER PRIMARY KEY,
  party_name TEXT NOT NULL,
  in_door BOOLEAN NOT NULL DEFAULT 0,
  budget INTEGER CHECK (budget >= 0),
  scheduled DATETIME NOT NULL
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
