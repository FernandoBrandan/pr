
```sql
-- https://publicapis.dev/search?q=hotel
-- https://www.booking.com/index.es.html
-- https://www.edrawmax.com/templates/1000527/
-- https://www.edrawmax.com/templates/hotel-management-system-design-1058117/
-- TABLAS PRINCIPALES --
-----------------------
CREATE TABLE Hotel (
    HotelID INT PRIMARY KEY AUTO_INCREMENT,
    HotelName VARCHAR(100) NOT NULL,
    HotelType VARCHAR(50),
    HotelDesc TEXT,
    HotelRent DECIMAL(10,2),
    Location VARCHAR(200) NOT NULL,
    Rating DECIMAL(3,1) CHECK (Rating BETWEEN 0 AND 5),
    Total_Rooms INT NOT NULL,
    INDEX idx_hotel_name (Hot_Name)
) ENGINE=InnoDB;
INSERT INTO Hotel (HotelName, HotelType, HotelDesc, Price, Location, Rating, Total_Rooms)
VALUES ('Ocean Paradise Resort', 'Resort', 'Resort todo incluido con spa, piscinas infinitas y acceso directo a la playa.', 350.00, 'Cancún, Quintana Roo, México', 4.8, 200);
INSERT INTO Hotel (HotelName, HotelType, HotelDesc,      HotelRent, Location,                                Rating, Total_Rooms)
VALUES ('Casa Colonial Boutique', 'Boutique', 'Edificio restaurado del siglo XIX, ambiente íntimo y desayuno gourmet incluido.', 120.50, 'Cartagena de Indias, Colombia', 4.5, 45);
INSERT INTO Hotel (HotelName, HotelType, HotelDesc, HotelRent, Location, Rating, Total_Rooms) 
VALUES ('CityBudget Inn', 'Económico', 'Habitaciones sencillas, Wifi gratuito y desayuno continental básico.', 45.00, 'Buenos Aires, Argentina', 3.9,  80);
INSERT INTO Hotel (HotelName, HotelType, HotelDesc, HotelRent, Location, Rating, Total_Rooms)
VALUES ('Family Suites Apartahotel', 'Apartahotel', 'Suites con cocina equipada y sala de estar, ideal para familias y estancias largas.', 85.75, 'Barcelona, España', 4.2,  120);
INSERT INTO Hotel (HotelName, HotelType, HotelDesc, HotelRent, Location, Rating, Total_Rooms)
VALUES ('Highland Cabins Retreat', 'Cabañas', 'Cabañas rústicas con chimenea y vistas panorámicas a la montaña.', 150.00, 'Bariloche, Río Negro, Argentina', 4.7,  30);

CREATE TABLE Client (
    Cus_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(100) NOT NULL,
    Mobile VARCHAR(20) NOT NULL CHECK (Mobile REGEXP '^[0-9]{8,15}$'),
    Email VARCHAR(100) UNIQUE NOT NULL CHECK (Email LIKE '%@%.%'),
    Address TEXT,
    INDEX idx_client_email (Email)
) ENGINE=InnoDB;

CREATE TABLE Role (
    Role_ID INT PRIMARY KEY AUTO_INCREMENT,
    Role_Name VARCHAR(50) UNIQUE NOT NULL,
    Role_Desc TEXT
) ENGINE=InnoDB;

CREATE TABLE Permission (
    Per_ID INT PRIMARY KEY AUTO_INCREMENT,
    Module VARCHAR(50) NOT NULL,
    Per_Name VARCHAR(100) NOT NULL,
    Description TEXT,
    UNIQUE (Module, Per_Name)
) ENGINE=InnoDB;

-- TABLAS DE RELACIÓN --
------------------------
CREATE TABLE Role_Permission (
    Role_ID INT,
    Per_ID INT,
    PRIMARY KEY (Role_ID, Per_ID),
    FOREIGN KEY (Role_ID) REFERENCES Role(Role_ID) ON DELETE CASCADE,
    FOREIGN KEY (Per_ID) REFERENCES Permission(Per_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- TABLAS OPERATIVAS --
-----------------------
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY AUTO_INCREMENT,
    Dept_Name VARCHAR(50) NOT NULL,
    D_Head_ID INT,
    Hot_ID INT NOT NULL,
    FOREIGN KEY (Hot_ID) REFERENCES Hotel(Hot_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Staff (
    Staff_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(100) NOT NULL,
    Gender ENUM('M','F','Otro'),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Phone_No VARCHAR(20) CHECK (Phone_No REGEXP '^[0-9]{8,15}$'),
    Role_ID INT NOT NULL,
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE SET NULL,
    FOREIGN KEY (Role_ID) REFERENCES Role(Role_ID) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE User (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL COMMENT 'Debe almacenarse encriptada',
    Cus_ID INT UNIQUE,
    Staff_ID INT UNIQUE,
    Last_Login DATETIME,
    CONSTRAINT FK_User_Client FOREIGN KEY (Cus_ID) REFERENCES Client(Cus_ID) ON DELETE CASCADE,
    CONSTRAINT FK_User_Staff FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE,
    CONSTRAINT CHK_UserType CHECK (Cus_ID IS NOT NULL XOR Staff_ID IS NOT NULL)
) ENGINE=InnoDB;

CREATE TABLE Room (
    Room_ID INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(50) NOT NULL,
    Status ENUM('Disponible','Ocupada','Mantenimiento') DEFAULT 'Disponible',
    Hot_ID INT NOT NULL,
    FOREIGN KEY (Hot_ID) REFERENCES Hotel(Hot_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Reservation (
    R_ID INT PRIMARY KEY AUTO_INCREMENT,
    Cus_ID INT NOT NULL,
    Room_ID INT NOT NULL,
    Book_Type VARCHAR(50),
    Description TEXT,
    Check_In DATE NOT NULL,
    Check_Out DATE NOT NULL,
    Status ENUM('Confirmada','Cancelada','Finalizada') DEFAULT 'Confirmada',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Cus_ID) REFERENCES Client(Cus_ID) ON UPDATE CASCADE,
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Payment (
    Pay_ID INT PRIMARY KEY AUTO_INCREMENT,
    Cus_ID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    Pay_Date DATE NOT NULL,
    Method ENUM('Tarjeta','Efectivo','Transferencia') NOT NULL,
    Description TEXT,
    Reservation_ID INT NOT NULL,
    FOREIGN KEY (Cus_ID) REFERENCES Client(Cus_ID) ON UPDATE CASCADE,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservation(R_ID) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- SISTEMA DE AUDITORÍA --
--------------------------
CREATE TABLE Audit_Reservation (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    R_ID INT NOT NULL,
    Old_Status ENUM('Confirmada','Cancelada','Finalizada'),
    New_Status ENUM('Confirmada','Cancelada','Finalizada'),
    Changed_By INT,
    Change_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (R_ID) REFERENCES Reservation(R_ID),
    FOREIGN KEY (Changed_By) REFERENCES User(User_ID)
) ENGINE=InnoDB;

-- TRIGGERS DE AUDITORÍA --
---------------------------
DELIMITER $$
CREATE TRIGGER trg_reservation_status
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    IF OLD.Status != NEW.Status THEN
        INSERT INTO Audit_Reservation (R_ID, Old_Status, New_Status, Changed_By)
        VALUES (OLD.R_ID, OLD.Status, NEW.Status, CURRENT_USER());
    END IF;
END$$
DELIMITER ;

-- DATOS INICIALES --
---------------------
INSERT INTO Permission (Module, Per_Name, Description) VALUES
('Reservas', 'Crear', 'Permite crear nuevas reservaciones'),
('Pagos', 'Aprobar', 'Permite autorizar pagos'),
('Usuarios', 'Administrar', 'Gestión completa de usuarios');

INSERT INTO Role (Role_Name, Role_Desc) VALUES
('Recepcionista', 'Gestión de reservas y check-in'),
('Administrador', 'Control total del sistema');
```