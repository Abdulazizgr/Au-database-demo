create database try1 ;
use try1;



CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL UNIQUE,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    Phone_no INT,
    Telegram_userName VARCHAR(50),
    passport VARCHAR(255),
    userState ENUM('Active', 'suspended', 'banned') NOT NULL DEFAULT 'Active',
    RegistrationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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
    AuctionStatus ENUM('Active', 'Sold', 'Expired') NOT NULL,
    StartDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    soldDate DATETIME DEFAULT NULL,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);


-- Sellers Table
CREATE TABLE Sellers (
    SellerID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each seller
    UserID INT NOT NULL, -- Foreign key referencing the UserID in the Users table
    ItemID INT, -- Foreign key referencing the ItemID in the Item table
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Constraint to ensure the user exists
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE SET NULL -- Constraint to ensure the item exists (can be null if item is removed)
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

-- Buyer Table
CREATE TABLE Buyer (
    BuyerID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each buyer
    UserID INT NOT NULL, -- Foreign key referencing the UserID in the Users table
    ItemID INT NOT NULL, -- Foreign key referencing the ItemID in the Items table
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Constraint to ensure the user exists
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE CASCADE -- Constraint to ensure the item exists
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
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL

);

create table  comments(

commentID int auto_increment primary key,
comment_message text,
commentTime timestamp ,
UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
);




CREATE TABLE ReportTable (
    ReportId INT AUTO_INCREMENT,
    ReportDate DATETIME,
    ReportText VARCHAR(1000),
    PRIMARY KEY (ReportId)
);






DROP TABLE IF EXISTS UserReport;

CREATE TABLE UserReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    Country VARCHAR(50),
    ActiveUsers INT,
    SuspendedUsers INT,
    BannedUsers INT,
    TotalUsers INT,
    ReportTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


