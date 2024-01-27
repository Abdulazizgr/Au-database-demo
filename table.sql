
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL ,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    Phone_no INT,
    Telegram_userName VARCHAR(50),
    passport VARCHAR(255),
    userState ENUM('Active', 'suspended', 'banned') NOT NULL DEFAULT 'Active',
    subscription_state ENUM('active', 'inactive') NOT NULL DEFAULT 'inactive',
    RegistrationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ProfileImagePath VARCHAR(255)
);


CREATE TABLE Item (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    ImagePath VARCHAR(255),
    ItemState ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    item_Status varchar(50),
    Category VARCHAR(50) NOT NULL,
    StartPrice DECIMAL(10, 2) NOT NULL,
    AuctionStatus ENUM('Active', 'Sold', 'Expired','pending') NOT NULL default 'Active',
    StartDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    soldDate DATETIME DEFAULT NULL,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);





-- Admins Table
CREATE TABLE Admins (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role ENUM('manager', 'userAdmin', 'itemAdmin'),
    Email VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL,
    RegistrationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



-- Bid Table
CREATE TABLE Bid (
    BidID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each bid
    ItemID INT NOT NULL, -- Foreign key referencing the ItemID in the Item table
    UserID INT NOT NULL, -- Foreign key referencing the BuyerID in the Buyer table
    BidAmount DECIMAL(10, 2) NOT NULL, -- Amount of the bid
    MinIncrement DECIMAL(10, 2)  NOT NULL DEFAULT 10.00,-- Minimum increment for the bid
    BidTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Date and time when the bid was placed
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE CASCADE, -- Constraint to ensure the item exists
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE -- Constraint to ensure the buyer exists
);


-- Notification Table
CREATE TABLE Notification (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each notification
	Message TEXT NOT NULL, -- Message content for the seller
    notificationTime Timestamp  NOT NULL, -- Date and time when the notification was sent
	UserID INT,
    adminID int,
      FOREIGN KEY (Adminid) REFERENCES Admins(AdminID) ON DELETE SET NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL

);



CREATE TABLE subscriptions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  UserID INT,
  subscription_name ENUM('weekly', '3 monthly', 'yearly') ,
  start_date DATE,
  end_date DATE,
  price DECIMAL(10, 2),
  subscription_status ENUM('active', 'inactive')DEFAULT 'inactive',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Buyer Table
CREATE TABLE Bider (
    BiderID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each buyer
    UserID INT NOT NULL, -- Foreign key referencing the UserID in the Users table
    ItemID INT NOT NULL, -- Foreign key referencing the ItemID in the Items table
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Constraint to ensure the user exists
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE CASCADE -- Constraint to ensure the item exists
);

CREATE TABLE buyer (
    BuyerID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each buyer
    UserID INT NOT NULL, -- Foreign key referencing the UserID in the Users table
    ItemID INT NOT NULL, -- Foreign key referencing the ItemID in the Items table
    BiderID int,
      FOREIGN KEY (BiderID) REFERENCES Bider(BiderID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Constraint to ensure the user exists
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE CASCADE -- Constraint to ensure the item exists
);


CREATE TABLE UserReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    Country VARCHAR(50),
    ActiveUsers INT,
    SuspendedUsers INT,
    BannedUsers INT,
    TotalUsers INT,
    ReportTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    AdminID int,
  FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);

CREATE TABLE BidReport (
	ReportID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ItemID INT,
    ItemTitle VARCHAR(50),
    Category VARCHAR(50),
    MinBid DECIMAL(10, 2),
    MaxBid DECIMAL(10, 2),
    AdminID int,
    FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);
CREATE TABLE AdminReport (
	 ReportID INT AUTO_INCREMENT PRIMARY KEY,
    TotalAdmins INT,
    ManagerAdmins INT,
    UserAdmins INT,
    ItemAdmins INT,
    AdminID int,
    FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);
CREATE TABLE ItemReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    UserID int,
    ItemID INT,
    ItemTitle VARCHAR(255),
    Category VARCHAR(50),
    ItemStatePending INT,
    ItemStateApproved INT,
    ItemStateRejected INT,
    AuctionStatusActive INT,
    AuctionStatusSold INT,
    AuctionStatusExpired INT,
    AuctionStatusPending INT,
    AdminID int,
    FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);

CREATE TABLE subscription_data (
  ReportID INT AUTO_INCREMENT PRIMARY KEY,
  UserID INT,
  subscription_name ENUM('weekly', '3 monthly', 'yearly'),
  price DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  AdminID int,
  FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);


CREATE TABLE SubscriptionReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionName ENUM('weekly', '3 monthly', 'yearly'),
    UserCount INT,
    TotalPrice DECIMAL(10, 2),
    AdminID int
    ,FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);


-- Insert into Users table
INSERT INTO Users (FirstName, LastName, Email, Password, country, Phone_no, Telegram_userName, passport)
VALUES ('John', 'Doe', 'johndoe1@example.com', 'password123', 'USA', 1237890, 'johndoe', 'ABCD1234');

INSERT INTO Users (FirstName, LastName, Email, Password, country, Phone_no, Telegram_userName, passport)
VALUES ('Jane', 'Smith', 'janesmith1@example.com', 'password456', 'Canada', 9543210, 'janesmith', 'EFGH5678');

-- Insert into Item table
INSERT INTO Item (Title, Description, ImagePath, item_Status, Category, StartPrice, UserID)
VALUES ('Item 12', 'Description of Item 1', 'image1.jpg', 'active', 'Electronics', 100.00, 1);

INSERT INTO Item (Title, Description, ImagePath, item_Status, Category, StartPrice, UserID)
VALUES ('Item 21', 'Description of Item 2', 'image2.jpg', 'active', 'Clothing', 50.00, 2);

-- Insert into Admins table
INSERT INTO Admins (FirstName, LastName, Role, Email, Password)
VALUES ('Admin 1', 'Manager', 'manager', 'admin13@example.com', 'admin123');

INSERT INTO Admins (FirstName, LastName, Role, Email, Password)
VALUES ('Admin 2', 'User Admin', 'userAdmin', 'admin23@example.com', 'admin456');

-- Insert into Bid table
INSERT INTO Bid (ItemID, UserID, BidAmount, MinIncrement)
VALUES (1, 1, 1200.00, 10.00);

INSERT INTO Bid (ItemID, UserID, BidAmount, MinIncrement)
VALUES (2, 2, 600.00, 10.00);

-- Insert into Notification table
INSERT INTO Notification (Message, notificationTime, UserID)
VALUES ('You have a new message.', '2024-01-23 10:00:00', 1);

INSERT INTO Notification (Message, notificationTime, UserID)
VALUES ('Your item has been sold.', '2024-01-23 11:00:00', 2);

-- Insert into subscriptions table
INSERT INTO subscriptions (UserID, subscription_name, start_date, end_date, price, subscription_status)
VALUES (1, 'weekly', '2024-01-01', '2024-01-07', 10.00, 'active');

INSERT INTO subscriptions (UserID, subscription_name, start_date, end_date, price, subscription_status)
VALUES (2, 'yearly', '2024-01-01', '2025-01-01', 100.00, 'inactive');
