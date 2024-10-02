Tablas Principales:


hotels: Información general del hotel (opcional si la PWA soporta múltiples hoteles).
rooms: Información de las habitaciones (tipo, precio, disponibilidad, capacidad).
reservations: Detalles de las reservas realizadas por los huéspedes.
guests: Información de los huéspedes que realizan las reservas.
services: Servicios que ofrece el hotel (piscina, spa, restaurante, etc.).
Relación entre las Tablas:
Cada reserva (reservations) está vinculada a una habitación (rooms).
Cada huésped (guests) puede tener una o más reservas (reservations).
Cada habitación (rooms) puede tener uno o más servicios (services).



Creación de las Tablas en SQL

-- 1. Tabla 'hotels': Información básica del hotel
CREATE TABLE hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(100),
    description TEXT
);

-- 2. Tabla 'rooms': Información de las habitaciones
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    room_type VARCHAR(50), -- Tipo de habitación (Suite, Doble, Familiar, etc.)
    price DECIMAL(10, 2),  -- Precio por noche
    capacity INT,          -- Capacidad máxima de personas
    description TEXT,      -- Descripción de la habitación
    image_url VARCHAR(255),-- URL de la imagen de la habitación
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- 3. Tabla 'guests': Información de los huéspedes
CREATE TABLE guests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(50),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla 'reservations': Detalles de las reservas
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in_date DATE,     -- Fecha de entrada
    check_out_date DATE,    -- Fecha de salida
    number_of_guests INT,   -- Cantidad de huéspedes
    total_price DECIMAL(10, 2), -- Precio total de la estancia
    status VARCHAR(50),     -- Estado de la reserva (Pendiente, Confirmada, Cancelada)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- 5. Tabla 'services': Información de los servicios disponibles en el hotel
CREATE TABLE services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    name VARCHAR(100),  -- Nombre del servicio (Piscina, Restaurante, etc.)
    description TEXT,   -- Descripción del servicio
    price DECIMAL(10, 2), -- Precio del servicio (si aplica)
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- 6. Tabla intermedia 'room_services': Relación entre habitaciones y servicios ofrecidos
CREATE TABLE room_services (
    room_id INT,
    service_id INT,
    PRIMARY KEY (room_id, service_id),
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);



Explicación de las Tablas

hotels: Guarda la información básica de cada hotel. Si tienes solo un hotel en la PWA, esta tabla puede omitirse y simplemente gestionar las habitaciones y servicios.

rooms: Almacena todos los detalles de las habitaciones, como tipo de habitación, precio, capacidad, descripción y la imagen.

guests: Contiene información personal de los huéspedes que han hecho una reserva. Se utiliza para gestionar las reservas y enviar información de confirmación.

reservations: Registra las reservas realizadas por los huéspedes, indicando la habitación reservada, la fecha de entrada y salida, el número de huéspedes y el precio total de la estancia.

services: Lista de todos los servicios ofrecidos por el hotel (por ejemplo, piscina, spa, bar).

room_services: Tabla intermedia que vincula habitaciones con servicios, indicando qué servicios están asociados a cada tipo de habitación.
