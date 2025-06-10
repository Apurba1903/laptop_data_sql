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


# Add the index column
ALTER TABLE laptops AUTO_INCREMENT = 0;

ALTER TABLE laptops ADD `index` INT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`index`);

SELECT * FROM laptops;


# Drop Non Important Columns
ALTER TABLE laptops
DROP COLUMN `Unnamed: 0`;

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
SET Inches = NULL
WHERE `index` = 453;

ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,2);


# Fixing Ram Column
UPDATE laptops
SET Ram =  REPLACE(Ram, 'GB', '') ;

ALTER TABLE laptops MODIFY COLUMN Ram INTEGER;

SELECT * FROM laptops;


# Check Memory Consumption
SELECT DATA_LENGTH/1024
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptopdb' AND TABLE_NAME = 'laptops';


# Fixing Weight Column
UPDATE laptops
SET Weight =  REPLACE(Weight, 'kg', '') ;

SELECT `index`, Weight 
FROM laptops 
WHERE Weight NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' OR Weight IS NULL;

UPDATE laptops
SET Weight = NULL
WHERE `index` = 178;

ALTER TABLE laptops MODIFY COLUMN Weight DECIMAL(10,2);

SELECT * FROM laptops;


# Fixing Price Column
UPDATE laptops
SET Price = ROUND(Price);

ALTER TABLE laptops MODIFY COLUMN Price INTEGER;

SELECT * FROM laptops;


# Check Distinct values
SELECT DISTINCT OpSys FROM laptops;


# Fixing OpSys Columns (Mac, Windows, Linux, No OS, Others
SELECT OpSys,
CASE
			WHEN OpSys LIKE '%mac%' THEN 'Mac'
            WHEN OpSys LIKE '%windows%' THEN 'Windows'
            WHEN OpSys LIKE '%linux%' THEN 'Linux'
            WHEN OpSys = 'No OS' THEN 'N/A'
            ELSE 'Other'
END AS 'os_brand'
FROM laptops;

UPDATE laptops
SET OpSys = CASE
									WHEN OpSys LIKE '%mac%' THEN 'Mac'
									WHEN OpSys LIKE '%windows%' THEN 'Windows'
									WHEN OpSys LIKE '%linux%' THEN 'Linux'
									WHEN OpSys = 'No OS' THEN 'N/A'
									ELSE 'Other'
						END;

SELECT DISTINCT OpSys
FROM laptops;

SELECT * FROM laptops;


# Fixing Gpu Columns
ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptops
SET gpu_brand =  SUBSTRING_INDEX(Gpu, ' ', 1);

UPDATE laptops
SET gpu_name =  REPLACE(Gpu, gpu_brand, '');

ALTER TABLE laptops
DROP COLUMN Gpu;

SELECT * FROM laptops;


# Fixing Cpu Column
ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10, 2) AFTER cpu_name;

UPDATE laptops
SET cpu_brand =  SUBSTRING_INDEX(Cpu, ' ', 1);

UPDATE laptops
SET cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10, 2));

UPDATE laptops
SET cpu_name = REPLACE(REPLACE(Cpu, cpu_brand, ''), SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1), '');

ALTER TABLE laptops
DROP COLUMN Cpu;

SELECT * FROM laptops;
















































