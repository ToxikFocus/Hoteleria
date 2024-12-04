-- Creación de la base de datos
CREATE DATABASE hoteleria;
USE hoteleria;

-- Tabla 'hotels'
CREATE TABLE hotels (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
address VARCHAR(255),
phone VARCHAR(20),
email VARCHAR(100),
description TEXT
);

-- Tabla 'rooms'
CREATE TABLE rooms (
id INT PRIMARY KEY AUTO_INCREMENT,
hotel_id INT,
room_type VARCHAR(50) NOT NULL,
price DECIMAL(10, 2) NOT NULL,
capacity INT NOT NULL,
description TEXT,
image_url VARCHAR(255),
FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- Tabla 'guests'
CREATE TABLE guests (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100),
phone VARCHAR(20),
address VARCHAR(255)
);

-- Tabla 'reservations'
CREATE TABLE reservations (
id INT PRIMARY KEY AUTO_INCREMENT,
guest_id INT,
room_id INT,
check_in_date DATE NOT NULL,
check_out_date DATE NOT NULL,
number_of_guests INT NOT NULL,
total_price DECIMAL(10, 2) NOT NULL,
status ENUM('Confirmada', 'Pendiente', 'Cancelada') DEFAULT 'Pendiente',
FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE,
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- Tabla 'services'
CREATE TABLE services (
id INT PRIMARY KEY AUTO_INCREMENT,
hotel_id INT,
name VARCHAR(50) NOT NULL,
description TEXT,
price DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- Tabla 'room_services'
CREATE TABLE room_services (
id INT PRIMARY KEY AUTO_INCREMENT,
room_id INT,
service_id INT,
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Insertar datos en la tabla 'hotels'
INSERT INTO hotels (name, address, phone, email, description) VALUES
('Hotel Paraíso', 'Av. Playa 123, Ciudad Sol', '123-456-7890', 'contacto@hotelparaiso.com', 'Un lugar perfecto para relajarse y disfrutar.'),
('Montaña Resort', 'Calle Bosque 456, Ciudad Montaña', '987-654-3210', 'reservas@montanaresort.com', 'Ideal para unas vacaciones en la naturaleza.');

-- Insertar datos en la tabla 'rooms'
INSERT INTO rooms (hotel_id, room_type, price, capacity, description, image_url) VALUES
(1, 'Suite', 150.00, 4, 'Suite de lujo con vista al mar y terraza privada.', 'https://example.com/suite1.jpg'),
(1, 'Doble', 100.00, 2, 'Habitación doble con vista a la ciudad.', 'https://example.com/double1.jpg'),
(2, 'Familiar', 120.00, 5, 'Habitación familiar con dos camas dobles y sofá cama.', 'https://example.com/family1.jpg'),
(2, 'Individual', 80.00, 1, 'Habitación individual ideal para una persona.', 'https://example.com/single1.jpg');

-- Insertar datos en la tabla 'guests'
INSERT INTO guests (first_name, last_name, email, phone, address) VALUES
('Carlos', 'Martínez', 'carlos.martinez@example.com', '555-1234', 'Calle Principal 789, Ciudad Sol'),
('Ana', 'Gómez', 'ana.gomez@example.com', '555-5678', 'Avenida Central 456, Ciudad Montaña');

-- Insertar datos en la tabla 'reservations'
INSERT INTO reservations (guest_id, room_id, check_in_date, check_out_date, number_of_guests, total_price, status) VALUES
(1, 1, '2024-12-01', '2024-12-05', 2, 600.00, 'Confirmada'),
(2, 3, '2024-12-10', '2024-12-15', 4, 600.00, 'Pendiente');

-- Insertar datos en la tabla 'services'
INSERT INTO services (hotel_id, name, description, price) VALUES
(1, 'Spa', 'Acceso al spa con masajes relajantes.', 50.00),
(1, 'Gimnasio', 'Acceso al gimnasio del hotel.', 0.00),
(2, 'Piscina', 'Acceso a la piscina climatizada.', 30.00),
(2, 'Desayuno', 'Desayuno buffet incluido.', 15.00);

-- Insertar datos en la tabla 'room_services' para asignar servicios a las habitaciones
INSERT INTO room_services (room_id, service_id) VALUES
(1, 1),  -- La Suite del Hotel Paraíso incluye el servicio de Spa
(1, 2),  -- La Suite del Hotel Paraíso incluye el acceso al Gimnasio
(2, 2),  -- La habitación Doble del Hotel Paraíso incluye el acceso al Gimnasio
(3, 3),  -- La habitación Familiar del Montaña Resort incluye acceso a la Piscina
(4, 4);  -- La habitación Individual del Montaña Resort incluye Desayuno
