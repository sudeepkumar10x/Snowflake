-- Create roles
CREATE ROLE data_analyst;
CREATE ROLE data_engineer;

-- Create users
CREATE USER alice PASSWORD='StrongPassword123';
CREATE USER bob PASSWORD='AnotherStrongPassword456';
CREATE USER sid PASSWORD='AnotherStrongPassword';

-- Assign roles to users
GRANT ROLE data_analyst TO USER alice;
GRANT ROLE data_engineer TO USER bob;

-- Granting privileges to roles
GRANT USAGE ON DATABASE TRAINING TO ROLE data_analyst;
GRANT MODIFY ON DATABASE TRAINING TO ROLE data_engineer;


-- Create a parent role
CREATE ROLE data_team;

-- Grant child roles to the parent role
GRANT ROLE data_analyst TO ROLE data_team;
GRANT ROLE data_engineer TO ROLE data_team;

-- Assign parent role to a user
GRANT ROLE data_team TO USER sid;

-- Grant child roles to the SYSADMIN role
GRANT ROLE data_team TO ROLE SYSADMIN;
