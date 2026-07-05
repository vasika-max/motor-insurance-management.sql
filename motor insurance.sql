create database motors;
use motors;

 
-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(30) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
 
-- 2. Branch Table
CREATE TABLE branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);
 
-- 3. Technician Table
CREATE TABLE technician (
    technician_id INT AUTO_INCREMENT PRIMARY KEY,
    technician_name VARCHAR(100) NOT NULL,
    branch_id INT NOT NULL,
    experience_years INT DEFAULT 0,
    incentive_balance DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id)
);
 
-- 4. Customer Table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender VARCHAR(10)
        CHECK(gender IN ('Male','Female')),
    dob DATE NOT NULL,
    phone BIGINT UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_date DATE DEFAULT (CURRENT_DATE)
);
 
-- 5. Address Table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    door_no VARCHAR(20),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode INT,
    FOREIGN KEY(customer_id)
        REFERENCES customer(customer_id)
);
 
-- 6. Vehicle Type Table
CREATE TABLE vehicle_type (
    vehicle_type_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_type_name VARCHAR(50) UNIQUE NOT NULL
);
 
-- 7. Vehicle Table
CREATE TABLE vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_type_id INT NOT NULL,
    vehicle_number VARCHAR(20) UNIQUE NOT NULL,
    company_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50),
    manufacture_year INT CHECK(manufacture_year >= 2000),
    odometer_reading INT DEFAULT 0,
    FOREIGN KEY(customer_id)
        REFERENCES customer(customer_id),
    FOREIGN KEY(vehicle_type_id)
        REFERENCES vehicle_type(vehicle_type_id)
);
 
-- 8. Service Request Table (enquiry stage, like a quote)
CREATE TABLE service_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    request_date DATE DEFAULT (CURRENT_DATE),
    request_status VARCHAR(20)
        DEFAULT 'PENDING',
    FOREIGN KEY(customer_id)
        REFERENCES customer(customer_id),
    FOREIGN KEY(vehicle_id)
        REFERENCES vehicle(vehicle_id)
);
 
-- 9. Service Type Table
CREATE TABLE service_type (
    service_type_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(50) UNIQUE NOT NULL,
    base_cost DECIMAL(12,2)
        CHECK(base_cost > 0)
);
 
-- 10. Service Booking Table
CREATE TABLE service_booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_number VARCHAR(30) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    technician_id INT,
    service_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status VARCHAR(20)
        DEFAULT 'ACTIVE',
    FOREIGN KEY(customer_id)
        REFERENCES customer(customer_id),
    FOREIGN KEY(vehicle_id)
        REFERENCES vehicle(vehicle_id),
    FOREIGN KEY(technician_id)
        REFERENCES technician(technician_id),
    FOREIGN KEY(service_type_id)
        REFERENCES service_type(service_type_id)
);
 
-- 11. Service Charge Table
CREATE TABLE service_charge (
    charge_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    labour_amount DECIMAL(12,2)
        CHECK(labour_amount > 0),
    tax_amount DECIMAL(12,2)
        DEFAULT 0,
    total_amount DECIMAL(12,2)
        CHECK(total_amount > 0),
    due_date DATE,
    FOREIGN KEY(booking_id)
        REFERENCES service_booking(booking_id)
);
 
-- 12. Payment Table
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    payment_date DATE,
    payment_mode VARCHAR(30),
    currency VARCHAR(10)
        DEFAULT 'INR',
    amount DECIMAL(12,2)
        CHECK(amount > 0),
    payment_status VARCHAR(20)
        DEFAULT 'SUCCESS',
    FOREIGN KEY(booking_id)
        REFERENCES service_booking(booking_id)
);
 
-- 13. Complaint Table
CREATE TABLE complaint_details (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    complaint_date DATE,
    refund_amount DECIMAL(12,2)
        CHECK(refund_amount > 0),
    complaint_status VARCHAR(20)
        DEFAULT 'PENDING',
    remarks VARCHAR(200),
    FOREIGN KEY(booking_id)
        REFERENCES service_booking(booking_id)
);
 
-- 14. Next Service Reminder Table
CREATE TABLE service_reminder (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    reminder_date DATE,
    estimated_amount DECIMAL(12,2)
        CHECK(estimated_amount > 0),
    status VARCHAR(20)
        DEFAULT 'PENDING',
    FOREIGN KEY(booking_id)
        REFERENCES service_booking(booking_id)
);
 
-- 15. Report Table
CREATE TABLE report_details (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    report_name VARCHAR(100),
    generated_date DATETIME
        DEFAULT CURRENT_TIMESTAMP,
    report_type VARCHAR(50),
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
);
 
-- ===================== DATA =====================
 
-- USERS
INSERT INTO users(username,password,role,status) VALUES
('admin1','admin123','ADMIN','ACTIVE'),
('manager1','manager123','MANAGER','ACTIVE'),
('techlead1','tech123','TECH_LEAD','ACTIVE'),
('frontdesk1','front123','FRONT_DESK','ACTIVE'),
('frontdesk2','front123','FRONT_DESK','ACTIVE'),
('complaints1','comp123','COMPLAINT_OFFICER','ACTIVE'),
('reminder1','rem123','REMINDER_OFFICER','ACTIVE'),
('finance1','finance123','FINANCE','ACTIVE'),
('support1','support123','SUPPORT','ACTIVE'),
('viewer1','viewer123','VIEWER','ACTIVE');
 
-- BRANCH
INSERT INTO branch(branch_name,status) VALUES
('Chennai Branch','ACTIVE'),
('Coimbatore Branch','ACTIVE'),
('Madurai Branch','ACTIVE'),
('Salem Branch','ACTIVE'),
('Trichy Branch','ACTIVE'),
('Tirunelveli Branch','ACTIVE'),
('Erode Branch','ACTIVE'),
('Vellore Branch','ACTIVE'),
('Thanjavur Branch','ACTIVE'),
('Kanchipuram Branch','ACTIVE');
 
-- TECHNICIAN
INSERT INTO technician(technician_name,branch_id,experience_years,incentive_balance,status) VALUES
('Ganesh Motors',1,8,5000,'ACTIVE'),
('Speedy Care',2,5,3200,'ACTIVE'),
('Auto Fix',3,10,4800,'ACTIVE'),
('QuickServ',4,3,2000,'ACTIVE'),
('Prime Garage',5,6,3600,'ACTIVE'),
('Trust Mechanics',6,7,4000,'ACTIVE'),
('Elite Auto Care',7,4,2500,'ACTIVE'),
('Royal Service',8,9,5200,'ACTIVE'),
('Max Auto Works',9,5,3400,'ACTIVE'),
('City Garage',10,2,1800,'ACTIVE');
 
-- CUSTOMER
INSERT INTO customer(first_name,last_name,gender,dob,phone,email) VALUES
('Anitha','V','Female','2001-04-12',9123456780,'anitha@gmail.com'),
('Bala','M','Male','1997-09-23',9123456781,'bala@gmail.com'),
('Charan','R','Male','1996-03-17',9123456782,'charan@gmail.com'),
('Deepa','S','Female','2000-11-05',9123456783,'deepa@gmail.com'),
('Elango','T','Male','1994-06-28',9123456784,'elango@gmail.com'),
('Fathima','K','Female','1999-01-19',9123456785,'fathima@gmail.com'),
('Gopal','N','Male','1993-08-08',9123456786,'gopal@gmail.com'),
('Haritha','P','Female','2002-02-14',9123456787,'haritha@gmail.com'),
('Iniyan','J','Male','1998-12-30',9123456788,'iniyan@gmail.com'),
('Jyothi','L','Female','2003-05-21',9123456789,'jyothi@gmail.com');
 
-- ADDRESS
INSERT INTO address(customer_id,door_no,street,city,state,pincode) VALUES
(1,'22B','Park Street','Chennai','Tamil Nadu',600041),
(2,'34','Race Course Road','Coimbatore','Tamil Nadu',641018),
(3,'9','Tallakulam','Madurai','Tamil Nadu',625002),
(4,'56','Fort Road','Salem','Tamil Nadu',636003),
(5,'12','Srirangam','Trichy','Tamil Nadu',620006),
(6,'67','Perundurai Road','Erode','Tamil Nadu',638011),
(7,'19','Katpadi Road','Vellore','Tamil Nadu',632006),
(8,'8','East Main Street','Thanjavur','Tamil Nadu',613009),
(9,'31','Adyar','Chennai','Tamil Nadu',600020),
(10,'44','Gandhi Road','Kanchipuram','Tamil Nadu',631502);
 
-- VEHICLE TYPE
INSERT INTO vehicle_type(vehicle_type_name) VALUES
('Bike'),('Car'),('SUV'),('Truck'),('Bus'),
('Van'),('Auto'),('Electric Bike'),('Electric Car'),('Mini Truck');
 
-- VEHICLE
INSERT INTO vehicle(customer_id,vehicle_type_id,vehicle_number,
company_name,model_name,manufacture_year,odometer_reading)
VALUES
(1,2,'TN22AB5001','Hyundai','Venue',2021,32000),
(2,1,'TN23CD5002','Bajaj','Pulsar',2020,18000),
(3,3,'TN24EF5003','Kia','Seltos',2022,15000),
(4,2,'TN25GH5004','Maruti','Baleno',2019,54000),
(5,2,'TN26IJ5005','Tata','Altroz',2021,27000),
(6,1,'TN27KL5006','Honda','Activa',2022,9000),
(7,6,'TN28MN5007','Maruti','Ertiga',2020,41000),
(8,5,'TN29OP5008','Ashok Leyland','Bus',2019,80000),
(9,9,'TN30QR5009','Tata','Tigor EV',2023,6000),
(10,4,'TN31ST5010','Eicher','Truck',2021,60000);
 
-- SERVICE REQUEST
INSERT INTO service_request(customer_id,vehicle_id,request_status) VALUES
(1,1,'APPROVED'),(2,2,'PENDING'),(3,3,'APPROVED'),(4,4,'REJECTED'),
(5,5,'PENDING'),(6,6,'APPROVED'),(7,7,'APPROVED'),(8,8,'PENDING'),
(9,9,'APPROVED'),(10,10,'PENDING');
 
-- SERVICE TYPE
INSERT INTO service_type(service_name,base_cost) VALUES
('General Checkup',1000),
('Full Service',5000),
('Engine Overhaul',12000),
('AC Repair',3500),
('Tyre Replacement',6000),
('Battery Replacement',4000),
('Denting & Painting',9000),
('Basic Bike Service',600),
('Basic Car Service',2500),
('Commercial Vehicle Service',15000);
 
-- SERVICE BOOKING
INSERT INTO service_booking(booking_number,customer_id,vehicle_id,technician_id,
service_type_id,start_date,end_date,booking_status)
VALUES
('SVC2001',1,1,1,2,'2026-01-02','2026-01-03','ACTIVE'),
('SVC2002',2,2,2,1,'2026-01-11','2026-01-11','ACTIVE'),
('SVC2003',3,3,3,3,'2026-02-02','2026-02-05','ACTIVE'),
('SVC2004',4,4,4,4,'2026-02-16','2026-02-17','ACTIVE'),
('SVC2005',5,5,5,5,'2026-03-02','2026-03-03','ACTIVE'),
('SVC2006',6,6,6,8,'2026-03-11','2026-03-11','ACTIVE'),
('SVC2007',7,7,7,9,'2026-04-02','2026-04-02','ACTIVE'),
('SVC2008',8,8,8,10,'2026-04-21','2026-04-24','ACTIVE'),
('SVC2009',9,9,9,6,'2026-05-02','2026-05-02','ACTIVE'),
('SVC2010',10,10,10,7,'2026-05-16','2026-05-19','ACTIVE');
 
-- SERVICE CHARGE
INSERT INTO service_charge(booking_id,labour_amount,tax_amount,total_amount,due_date)
VALUES
(1,4500,810,5310,'2026-01-06'),
(2,900,162,1062,'2026-01-16'),
(3,11000,1980,12980,'2026-02-06'),
(4,3200,576,3776,'2026-02-21'),
(5,5500,990,6490,'2026-03-06'),
(6,550,99,649,'2026-03-16'),
(7,2300,414,2714,'2026-04-06'),
(8,14000,2520,16520,'2026-04-26'),
(9,3800,684,4484,'2026-05-06'),
(10,8500,1530,10030,'2026-05-21');
 
-- PAYMENT
INSERT INTO payment(booking_id,payment_date,payment_mode,amount,payment_status)
VALUES
(1,'2026-01-04','UPI',5310,'SUCCESS'),
(2,'2026-01-13','CARD',1062,'SUCCESS'),
(3,'2026-02-04','NET BANKING',12980,'SUCCESS'),
(4,'2026-02-19','UPI',3776,'SUCCESS'),
(5,'2026-03-04','CARD',6490,'SUCCESS'),
(6,'2026-03-13','UPI',649,'SUCCESS'),
(7,'2026-04-04','CASH',2714,'SUCCESS'),
(8,'2026-04-24','CARD',16520,'SUCCESS'),
(9,'2026-05-04','UPI',4484,'SUCCESS'),
(10,'2026-05-19','NET BANKING',10030,'SUCCESS');
 
-- COMPLAINT DETAILS
INSERT INTO complaint_details(booking_id,complaint_date,refund_amount,complaint_status,remarks)
VALUES
(1,'2026-06-01',500,'APPROVED','Noise after service'),
(2,'2026-06-02',200,'PENDING','Late delivery'),
(3,'2026-06-03',1500,'APPROVED','Part not replaced'),
(4,'2026-06-04',300,'REJECTED','Invalid claim'),
(5,'2026-06-05',700,'PENDING','AC not cooling'),
(6,'2026-06-06',150,'APPROVED','Minor issue'),
(7,'2026-06-07',400,'APPROVED','Delay in delivery'),
(8,'2026-06-08',2000,'PENDING','Paint mismatch'),
(9,'2026-06-09',600,'APPROVED','Battery issue'),
(10,'2026-06-10',1200,'PENDING','Brake noise');
 
-- SERVICE REMINDER
INSERT INTO service_reminder(booking_id,reminder_date,estimated_amount,status)
VALUES
(1,'2026-07-02',5500,'PENDING'),
(2,'2026-07-11',1100,'PENDING'),
(3,'2026-08-02',13500,'PENDING'),
(4,'2026-08-16',4000,'PENDING'),
(5,'2026-09-02',6800,'PENDING'),
(6,'2026-09-11',700,'PENDING'),
(7,'2026-10-02',2900,'PENDING'),
(8,'2026-10-21',17000,'PENDING'),
(9,'2026-11-02',4700,'PENDING'),
(10,'2026-11-16',10500,'PENDING');
 
-- REPORT TABLE
INSERT INTO report_details(user_id,report_name,report_type)
VALUES
(1,'Customer Report','PDF'),
(2,'Booking Report','PDF'),
(3,'Charge Report','EXCEL'),
(4,'Complaint Report','PDF'),
(5,'Payment Report','EXCEL'),
(6,'Technician Report','PDF'),
(7,'Reminder Report','EXCEL'),
(8,'Vehicle Report','PDF'),
(9,'Branch Report','PDF'),
(10,'Annual Report','EXCEL');
 
-- ===================== VERIFICATION SELECTS =====================
select * from users;
select * from branch;
select * from technician;
select * from customer;
select * from address;
select * from vehicle_type;
select * from vehicle;
select * from service_request;
select * from service_type;
select * from service_charge;
select * from payment;
select * from complaint_details;
select * from service_reminder;
select * from report_details;
 
-- ===================== COMPLEX QUERY (JOIN + AGGREGATE + CASE) =====================
SELECT
    c.customer_id,
    c.first_name,
    a.city,
    v.vehicle_number,
    b.booking_number,
    sc.total_amount,
    COUNT(b.booking_id) AS total_bookings,
    AVG(sc.total_amount) AS avg_charge,
    MAX(sc.total_amount) AS highest_charge,
    MIN(sc.total_amount) AS lowest_charge,
    SUM(sc.total_amount) AS total_charge,
    CASE
        WHEN sc.total_amount >= 10000 THEN 'HIGH VALUE SERVICE'
        WHEN sc.total_amount >= 5000 THEN 'MEDIUM VALUE SERVICE'
        ELSE 'LOW VALUE SERVICE'
    END AS service_category
FROM customer c
INNER JOIN address a ON c.customer_id = a.customer_id
INNER JOIN vehicle v ON c.customer_id = v.customer_id
INNER JOIN service_booking b ON c.customer_id = b.customer_id
INNER JOIN service_charge sc ON b.booking_id = sc.booking_id
WHERE c.gender = 'Female'
  AND sc.total_amount > 1000
GROUP BY
    c.customer_id, c.first_name, a.city, v.vehicle_number, b.booking_number, sc.total_amount
HAVING AVG(sc.total_amount) > 1000
ORDER BY sc.total_amount DESC
LIMIT 5;
 
-- ===================== FUNCTION =====================
DELIMITER //
 
CREATE FUNCTION get_service_gst(amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount * 0.18;
END //
 
DELIMITER ;
 
-- ===================== PROCEDURE =====================
DELIMITER //
 
CREATE PROCEDURE get_customer_bookings()
BEGIN
    SELECT c.first_name,
           b.booking_number,
           sc.total_amount
    FROM customer c
    JOIN service_booking b ON c.customer_id = b.customer_id
    JOIN service_charge sc ON b.booking_id = sc.booking_id;
END //
 
DELIMITER ;
 
-- ===================== TRIGGER =====================
DELIMITER //
 
CREATE TRIGGER before_service_payment_insert
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    SET NEW.payment_date = CURDATE();
END //
 
DELIMITER ;
 
-- ===================== QUERY USING FUNCTION + SUBQUERY =====================
SELECT
    c.customer_id,
    c.first_name,
    a.city,
    v.vehicle_number,
    b.booking_number,
    sc.total_amount,
    get_service_gst(sc.total_amount) AS gst_amount,
    COUNT(*) AS total_bookings,
    AVG(sc.total_amount) AS avg_charge,
    MAX(sc.total_amount) AS highest_charge,
    MIN(sc.total_amount) AS lowest_charge,
    SUM(sc.total_amount) AS total_charge,
    CASE
        WHEN sc.total_amount >= 10000 THEN 'HIGH VALUE SERVICE'
        WHEN sc.total_amount >= 5000 THEN 'MEDIUM VALUE SERVICE'
        ELSE 'LOW VALUE SERVICE'
    END AS service_category
FROM customer c
JOIN address a ON c.customer_id = a.customer_id
JOIN vehicle v ON c.customer_id = v.customer_id
JOIN service_booking b ON c.customer_id = b.customer_id
JOIN service_charge sc ON b.booking_id = sc.booking_id
WHERE sc.total_amount > (SELECT AVG(total_amount) FROM service_charge)
GROUP BY
    c.customer_id, c.first_name, a.city, v.vehicle_number, b.booking_number, sc.total_amount
HAVING SUM(sc.total_amount) > 1000
ORDER BY sc.total_amount DESC
LIMIT 5;
 
-- ===================== INDEXES =====================
CREATE INDEX idx_booking_number ON service_booking(booking_number);
 
SELECT booking_id, booking_number, customer_id, booking_status
FROM service_booking
WHERE booking_number = 'SVC2005';
 
CREATE INDEX idx_booking_customer_id ON service_booking(customer_id);
 
SELECT c.first_name, b.booking_number, b.booking_status
FROM customer c
JOIN service_booking b ON c.customer_id = b.customer_id
WHERE b.customer_id = 5;
 
-- ===================== VIEW =====================
CREATE VIEW customer_booking_view AS
SELECT c.customer_id,
       c.first_name,
       b.booking_number,
       b.booking_status
FROM customer c
JOIN service_booking b ON c.customer_id = b.customer_id;
 
-- ===================== TRANSACTION WITH ROLLBACK =====================
START TRANSACTION;
 
UPDATE service_charge
SET total_amount = total_amount + 500
WHERE booking_id = 2;
 
INSERT INTO payment
(booking_id, payment_date, payment_mode, amount, payment_status)
VALUES
(2, CURDATE(), 'UPI', 1562, 'SUCCESS');
 
ROLLBACK;
 
-- ===================== TRANSACTION WITH COMMIT =====================
START TRANSACTION;
 
UPDATE service_charge
SET total_amount = total_amount + 200
WHERE booking_id = 1;
 
INSERT INTO payment
(booking_id, payment_date, payment_mode, amount, payment_status)
VALUES
(1, CURDATE(), 'UPI', 5510, 'SUCCESS');
 
COMMIT;
 