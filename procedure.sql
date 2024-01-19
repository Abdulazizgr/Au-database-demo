DELIMITER //
CREATE TRIGGER trg_item_added AFTER INSERT ON Item
FOR EACH ROW
BEGIN
    INSERT INTO Sellers (UserID, ItemID)
    VALUES (NEW.UserID, NEW.ItemID);
END //
DELIMITER ;



DELIMITER //
CREATE TRIGGER trg_bid_added AFTER INSERT ON bid
FOR EACH ROW
BEGIN
    INSERT INTO buyer (UserID, ItemID)
    VALUES (NEW.UserID, NEW.ItemID);
END //
DELIMITER ;







drop procedure UpdateUserStateAndInsertNotification;

DELIMITER //

CREATE PROCEDURE UpdateUserStateAndInsertNotification(
    IN p_userID INT,
    IN p_userState ENUM('Active', 'suspended', 'banned')
)
BEGIN
    -- Update the user state
    UPDATE Users
    SET userState = p_userState
    WHERE UserID = p_userID;

    -- Insert notification into the Notification table
    INSERT INTO Notification (Message, notificationTime, UserID)
    VALUES (CONCAT('User state changed to ', p_userState), NOW(), p_userID);
END //

DELIMITER ;


CALL UpdateUserStateAndInsertNotification(1, 'suspended');


DELIMITER //

CREATE PROCEDURE UpdateItemStateAndInsertNotification(
    IN p_itemID INT,
    IN p_itemState ENUM('pending', 'approved', 'rejected')
)
BEGIN
    -- Update the item state
    UPDATE Item
    SET ItemState = p_itemState
    WHERE ItemID = p_itemID;

    -- Insert notification into the Notification table
    INSERT INTO Notification (Message, notificationTime, UserID)
    VALUES (CONCAT('Item state changed to ', p_itemState), NOW(), (SELECT UserID FROM Item WHERE ItemID = p_itemID));
END //

DELIMITER ;

CALL UpdateItemStateAndInsertNotification(1, 'approved');



drop event GenerateUserReport;
DELIMITER //

CREATE EVENT GenerateUserReport
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        -- Delete previous report data
        DELETE FROM UserReport;

        -- Insert new report data
        INSERT INTO UserReport (Country, TotalUsers, ActiveUsers, SuspendedUsers, BannedUsers)
        SELECT
            country,
            COUNT(*) AS TotalUsers,
            SUM(CASE WHEN userState = 'Active' THEN 1 ELSE 0 END) AS ActiveUsers,
            SUM(CASE WHEN userState = 'Suspended' THEN 1 ELSE 0 END) AS SuspendedUsers,
            SUM(CASE WHEN userState = 'Banned' THEN 1 ELSE 0 END) AS BannedUsers
        FROM Users
        GROUP BY country
        ORDER BY TotalUsers DESC;
    END //

DELIMITER ;

SET GLOBAL event_scheduler = ON;









