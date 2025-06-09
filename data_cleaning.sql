USE laptopdb;

SELECT * FROM laptops;

# Create Backup
CREATE TABLE laptops_backup LIKE laptops;

INSERT INTO  laptops_backup
SELECT *
FROM laptops;

SELECT * 
FROM laptops_backup;


# Check Rows
SELECT COUNT(*)
FROM laptops;


# Check Memory Consumption
SELECT DATA_LENGTH/1024
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptopdb' AND TABLE_NAME = 'laptops';


# Drop Non Important Columns
ALTER TABLE laptops
CHANGE `Unnamed: 0` `index` INT;

SELECT * FROM laptops;


# Drop NULL Values
DELETE FROM laptops
WHERE 	Company IS NULL AND
				TypeName IS NULL AND
				Inches IS NULL AND
				ScreenResolution IS NULL AND
				Cpu IS NULL AND
				Ram IS NULL AND
				Memory IS NULL AND
				Gpu IS NULL AND
				OpSys IS NULL AND
				Weight IS NULL AND
				Price IS NULL;

SELECT * FROM laptops;


# Drop Duplicates
DELETE FROM laptops
WHERE `index` IN (
    SELECT `index` FROM (
        SELECT `index`,
               ROW_NUMBER() OVER (
                   PARTITION BY Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price
                   ORDER BY `index`
               ) as row_num
        FROM laptops
    ) t
    WHERE t.row_num > 1
);

SELECT * FROM laptops;


# Check Distinct values
SELECT DISTINCT Company FROM laptops;

SELECT DISTINCT TypeName FROM laptops;


# Change Inches DataType
SELECT `index`, Inches 
FROM laptops 
WHERE Inches NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' OR Inches IS NULL;

UPDATE laptops
SET Inches = 0
WHERE `index` = 476;

ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);


# Fixing Ram Column
UPDATE laptops
SET Ram =  REPLACE(Ram, 'GB', '') ;

SELECT * FROM laptops;

















































