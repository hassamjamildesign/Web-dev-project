
-- -----------------------------------------------------
-- Photography Services Database (3 Tables + Sample Data + 5 CRUD Queries)
-- -----------------------------------------------------

-- Drop tables if they already exist (to avoid errors on re-run)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS packages;

-- -----------------------------------------------------
-- Table: clients
-- Stores customer info
-- -----------------------------------------------------
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: packages
-- Service offerings (e.g., Wedding, Portrait, Event)
-- -----------------------------------------------------
CREATE TABLE packages (
    package_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_hours INT DEFAULT 2,
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table: bookings
-- Links a client to a package on a specific date
-- -----------------------------------------------------
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    package_id INT NOT NULL,
    shoot_date DATE NOT NULL,
    notes TEXT,
    status ENUM('confirmed', 'pending', 'completed', 'canceled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (package_id) REFERENCES packages(package_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Sample Data (INSERT)
-- -----------------------------------------------------
INSERT INTO clients (name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '+923001234567'),
('Bob Smith', 'bob@example.com', '+923009876543'),
('Cathy Lee', 'cathy@example.com', '+923005555555');

INSERT INTO packages (title, description, price, duration_hours) VALUES
('Wedding Package', 'Full-day wedding coverage, 10 edited photos', 999.00, 8),
('Family Portrait', '1-hour session, 5 high-res photos', 199.00, 1),
('Event Coverage', '3-hour corporate event, 20 edited photos', 499.00, 3);

INSERT INTO bookings (client_id, package_id, shoot_date, notes, status) VALUES
(1, 1, '2026-06-15', 'Golden hour preferred', 'confirmed'),
(2, 3, '2026-07-01', 'Corporate event in Lahore', 'pending'),
(3, 2, '2026-05-20', 'Outdoor family shoot', 'completed');

-- -----------------------------------------------------
-- 5 Required SQL Queries 
-- -----------------------------------------------------

-- 1. CREATE TABLE (already above — clients shown as example)

-- 2. INSERT — Add one more client
INSERT INTO clients (name, email, phone) VALUES 
    ('Zara Khan', 'zara@example.com', '+923002222222');

-- 3. SELECT — Show affordable packages
SELECT * FROM packages WHERE price < 500;  -- All affordable packages

-- 4. UPDATE — Confirm a booking
UPDATE bookings 
SET status = 'confirmed', notes = 'Client confirmed via WhatsApp' 
WHERE booking_id = 1;

-- 5. DELETE — Remove a package only if unused
DELETE FROM packages 
WHERE package_id = 2 
  AND NOT EXISTS (SELECT 1 FROM bookings WHERE package_id = 2); 
-- (Note: This may fail if bookings exist — safe guard clause)
