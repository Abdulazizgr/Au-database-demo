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


DELIMITER //
CREATE TRIGGER after_insert_subscription
AFTER INSERT ON subscriptions
FOR EACH ROW
BEGIN
  INSERT INTO subscription_data (UserID, subscription_name, price, created_at)
  VALUES (NEW.UserID, NEW.subscription_name, NEW.price, CURRENT_TIMESTAMP);
END//
DELIMITER ;






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


DELIMITER //

CREATE EVENT checkSubscriptionExpiry
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        UPDATE subscriptions
        SET subscription_status = 'inactive'
        WHERE end_date <= CURDATE();
    END //

DELIMITER ;

SET GLOBAL event_scheduler = ON;


DELIMITER //

CREATE EVENT GenerateAdminReportByRole
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        -- Delete previous report data
        DELETE FROM AdminReport;

        -- Insert new report data
        INSERT INTO AdminReport (TotalAdmins, ManagerAdmins, UserAdmins, ItemAdmins)
        SELECT
            COUNT(*) AS TotalAdmins,
            SUM(CASE WHEN Role = 'manager' THEN 1 ELSE 0 END) AS ManagerAdmins,
            SUM(CASE WHEN Role = 'userAdmin' THEN 1 ELSE 0 END) AS UserAdmins,
            SUM(CASE WHEN Role = 'itemAdmin' THEN 1 ELSE 0 END) AS ItemAdmins
        FROM Admins;
    END //

DELIMITER ;


DELIMITER //

CREATE EVENT GenerateBidReport
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        -- Delete previous report data
        DELETE FROM BidReport;

        -- Insert new report data
        INSERT INTO BidReport (UserID, ItemID, ItemTitle, Category, MinBid, MaxBid)
        SELECT
            b.UserID,
            b.ItemID,
            i.Title AS ItemTitle,
            i.Category,
            MIN(b.BidAmount) AS MinBid,
            MAX(b.BidAmount) AS MaxBid
        FROM Bid b
        INNER JOIN Item i ON b.ItemID = i.ItemID
        GROUP BY b.UserID, b.ItemID;
    END //

DELIMITER ;


DELIMITER //

CREATE EVENT GenerateItemReport
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        -- Delete previous report data
        DELETE FROM ItemReport;

        -- Insert new report data
        INSERT INTO ItemReport (UserID, ItemID, ItemTitle, Category, ItemStatePending, ItemStateApproved, ItemStateRejected, AuctionStatusActive, AuctionStatusSold, AuctionStatusExpired, AuctionStatusPending)
        SELECT
            UserID,
            ItemID,
            Title AS ItemTitle,
            Category,
            SUM(CASE WHEN ItemState = 'pending' THEN 1 ELSE 0 END) AS ItemStatePending,
            SUM(CASE WHEN ItemState = 'approved' THEN 1 ELSE 0 END) AS ItemStateApproved,
            SUM(CASE WHEN ItemState = 'rejected' THEN 1 ELSE 0 END) AS ItemStateRejected,
            SUM(CASE WHEN AuctionStatus = 'Active' THEN 1 ELSE 0 END) AS AuctionStatusActive,
            SUM(CASE WHEN AuctionStatus = 'Sold' THEN 1 ELSE 0 END) AS AuctionStatusSold,
            SUM(CASE WHEN AuctionStatus = 'Expired' THEN 1 ELSE 0 END) AS AuctionStatusExpired,
            SUM(CASE WHEN AuctionStatus = 'pending' THEN 1 ELSE 0 END) AS AuctionStatusPending
        FROM Item
        GROUP BY UserID, ItemID;
    END //

DELIMITER ;


DELIMITER //

CREATE EVENT GenerateSubscriptionReport
    ON SCHEDULE EVERY 2 MINUTE
    DO
    BEGIN
        -- Delete previous report data
        DELETE FROM SubscriptionReport;

        -- Insert new report data
        INSERT INTO SubscriptionReport (SubscriptionName, UserCount, TotalPrice)
        SELECT
            subscription_name,
            COUNT(*) AS UserCount,
            SUM(price) AS TotalPrice
        FROM subscriptions
        GROUP BY subscription_name;
    END //

DELIMITER ;
