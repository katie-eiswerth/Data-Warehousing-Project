-- Create the data mart 

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'PetStoreDM')
	CREATE DATABASE PetStoreDM
GO
USE PetStoreDM

-- Delete existing tables

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactSale'
	 )
	DROP TABLE FactSale;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactOrder'
	 )
	DROP TABLE FactOrder;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimSupplier'
	 )
	DROP TABLE DimSupplier;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEmployee'
	 )
	DROP TABLE DimEmployee;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCustomer'
	 )
	DROP TABLE DimCustomer;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProduct'
	 )
	DROP TABLE DimProduct;


IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;


-- Create the tables 

CREATE TABLE DimDate
	(
		Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);


CREATE TABLE DimProduct
	(
	Product_SK						INT IDENTITY CONSTRAINT pk_product_key PRIMARY KEY,         -- uniquely identifying values will be autogenerated
	Product_BK					INT NOT NULL,
	ProductName					VARCHAR(55) NOT NULL,
	Category							VARCHAR(55) NOT NULL,
	Rating								INT NOT NULL
	);


CREATE TABLE DimCustomer
	(
	Customer_SK					INT IDENTITY CONSTRAINT pk_customer_key PRIMARY KEY,         -- uniquely identifying values will be autogenerated
	Customer_BK					INT NOT NULL,
	FirstName						VARCHAR(55) NOT NULL,
	LastName						VARCHAR(55) NOT NULL,
	Birthdate							DATE NOT NULL,
	Age									INT NOT NULL,
	AgeGroup						VARCHAR(55) NOT NULL,
	Gender								VARCHAR(55) NOT NULL,
	Email								VARCHAR(55) NOT NULL,
	Telephone						VARCHAR(12) NOT NULL,
	[Address]							VARCHAR(255) NOT NULL,
	City									VARCHAR(55) NOT NULL,
	[State]								VARCHAR(55) NOT NULL,
	ZipCode							VARCHAR(7) NOT NULL
	);


CREATE TABLE DimEmployee
	(
	Employee_SK					INT IDENTITY CONSTRAINT pk_employee_key PRIMARY KEY,         -- uniquely identifying values will be autogenerated
	Employee_BK 				INT NOT NULL,
	FirstName						VARCHAR(55) NOT NULL,
	LastName						VARCHAR(55) NOT NULL,
	HireDate							DATE NOT NULL,
	DepartmentName			VARCHAR(55) NOT NULL,
	PositionName					VARCHAR(55) NOT NULL,
	Salary								DECIMAL(10,2) NOT NULL
	);



CREATE TABLE DimSupplier
	(
	Supplier_SK					INT IDENTITY CONSTRAINT pk_supplier_key PRIMARY KEY,         -- uniquely identifying values will be autogenerated
	Supplier_BK					INT NOT NULL,
	Company							VARCHAR(55) NOT NULL,
	ContactFirstName			VARCHAR(55) NOT NULL,
	ContactLastName			VARCHAR(55) NOT NULL,
	Email								VARCHAR(55) NOT NULL,
	Telephone						VARCHAR(12) NOT NULL
	);


CREATE TABLE FactSale
	(
	OrderID							INT NOT NULL,
	OrderItemID						INT NOT NULL,
	OrderDate						INT CONSTRAINT fk_order_date_key FOREIGN KEY REFERENCES DimDate(Date_SK),
	Product_SK						INT CONSTRAINT fk_product_key FOREIGN KEY REFERENCES DimProduct(Product_SK),
	Customer_SK						INT CONSTRAINT fk_customer_key FOREIGN KEY REFERENCES DimCustomer(Customer_SK),
	Employee_SK						INT CONSTRAINT fk_employee_key FOREIGN KEY REFERENCES DimEmployee(Employee_SK),
	Supplier_SK						INT CONSTRAINT fk_supplier_key FOREIGN KEY REFERENCES DimSupplier(Supplier_SK),
	UnitPrice						INT NOT NULL,
	UnitCost						INT NOT NULL,
	Quantity						INT NOT NULL,
	CONSTRAINT pk_fact_sale PRIMARY KEY(OrderID, OrderItemID, OrderDate, Supplier_SK, Product_SK, Employee_SK, Customer_SK)
	);
