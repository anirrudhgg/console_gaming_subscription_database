-- ============================================================
-- Console Gaming Subscription Packages
-- Part A.1: Database and Table Creation
-- Tables created in foreign-key-safe order
-- ============================================================

DROP DATABASE IF EXISTS ConsoleGamingSubscriptions;
CREATE DATABASE ConsoleGamingSubscriptions;
USE ConsoleGamingSubscriptions;

-- ------------------------------------------------------------
-- 1. Player
-- ------------------------------------------------------------
CREATE TABLE Player (
    PlayerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PaymentMethod VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------
-- 2. Console
-- ------------------------------------------------------------
CREATE TABLE Console (
    ConsoleID INT AUTO_INCREMENT PRIMARY KEY,
    ConsoleModel VARCHAR(50) NOT NULL,
    PurchaseDate DATE NOT NULL
);

-- ------------------------------------------------------------
-- 3. SubscriptionTier
-- ------------------------------------------------------------
CREATE TABLE SubscriptionTier (
    TierID INT AUTO_INCREMENT PRIMARY KEY,
    TierName VARCHAR(20) NOT NULL UNIQUE,
    MonthlyPrice DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_tier_price CHECK (MonthlyPrice >= 0)
);

-- ------------------------------------------------------------
-- 4. Publisher
-- ------------------------------------------------------------
CREATE TABLE Publisher (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------
-- 5. Game
-- ------------------------------------------------------------
CREATE TABLE Game (
    GameID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    Price DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    PublisherID INT NOT NULL,
    CONSTRAINT fk_game_publisher
        FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID),
    CONSTRAINT chk_game_price CHECK (Price >= 0)
);

-- ------------------------------------------------------------
-- 6. Account
-- ------------------------------------------------------------
CREATE TABLE Account (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    AccountName VARCHAR(100) NOT NULL,
    PlayerID INT NOT NULL,
    ConsoleID INT NOT NULL,
    SubscriptionTierID INT NOT NULL,
    CONSTRAINT fk_account_player
        FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT fk_account_console
        FOREIGN KEY (ConsoleID) REFERENCES Console(ConsoleID),
    CONSTRAINT fk_account_tier
        FOREIGN KEY (SubscriptionTierID) REFERENCES SubscriptionTier(TierID)
);

-- ------------------------------------------------------------
-- 7. Account_Games (junction table)
--    Enforces "max one license per game per account"
-- ------------------------------------------------------------
CREATE TABLE Account_Games (
    AccountID INT NOT NULL,
    GameID INT NOT NULL,
    PurchaseDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (AccountID, GameID),
    CONSTRAINT fk_accgames_account
        FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    CONSTRAINT fk_accgames_game
        FOREIGN KEY (GameID) REFERENCES Game(GameID)
);

-- ------------------------------------------------------------
-- 8. Transaction
-- ------------------------------------------------------------
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    Amount DECIMAL(8,2) NOT NULL,
    Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) NOT NULL,
    CONSTRAINT fk_transaction_account
        FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    CONSTRAINT chk_transaction_amount CHECK (Amount >= 0)
);

-- ------------------------------------------------------------
-- 9. SupportAgent
-- ------------------------------------------------------------
CREATE TABLE SupportAgent (
    AgentID INT AUTO_INCREMENT PRIMARY KEY,
    AgentName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- 10. SupportTicket
-- ------------------------------------------------------------
CREATE TABLE SupportTicket (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    AgentID INT NOT NULL,
    Issue VARCHAR(255) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Open',
    DateOpened DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket_account
        FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    CONSTRAINT fk_ticket_agent
        FOREIGN KEY (AgentID) REFERENCES SupportAgent(AgentID),
    CONSTRAINT chk_ticket_status
        CHECK (Status IN ('Open', 'In Progress', 'Resolved', 'Closed'))
);

-- ============================================================
-- Console Gaming Subscription Packages
-- Part A.2: Sample Data (INSERT statements)
-- ============================================================

USE ConsoleGamingSubscriptions;

-- ------------------------------------------------------------
-- 1. Player (6 rows)
-- ------------------------------------------------------------
INSERT INTO Player (Name, Email, Username, PaymentMethod) VALUES
('Liam Fischer',   'liam.fischer@gmail.com',   'liamf',    'Visa'),
('Mia Schneider',  'mia.schneider@gmail.com',  'mia_s',    'PayPal'),
('Noah Becker',    'noah.becker@outlook.com',  'noahb',    'Mastercard'),
('Emma Hoffmann',  'emma.hoffmann@gmail.com',  'emmah',    'Visa'),
('Lucas Wagner',   'lucas.wagner@yahoo.com',   'lucasw',   'PayPal'),
('Sophie Klein',   'sophie.klein@gmail.com',   'sophiek',  'Mastercard');

-- ------------------------------------------------------------
-- 2. Console (5 rows)
-- ------------------------------------------------------------
INSERT INTO Console (ConsoleModel, PurchaseDate) VALUES
('PlayStation 5',   '2023-11-10'),
('Xbox Series X',   '2023-08-22'),
('Nintendo Switch',  '2022-03-15'),
('PlayStation 5',   '2024-01-05'),
('Xbox Series S',   '2023-12-19');

-- ------------------------------------------------------------
-- 3. SubscriptionTier (5 rows)
-- ------------------------------------------------------------
INSERT INTO SubscriptionTier (TierName, MonthlyPrice) VALUES
('Regular', 4.99),
('Premium', 9.99),
('Pro',     14.99),
('Student', 2.99),
('Family',  20.99);

-- ------------------------------------------------------------
-- 4. Publisher (5 rows)
-- ------------------------------------------------------------
INSERT INTO Publisher (PublisherName, Country) VALUES
('Electronic Arts', 'USA'),
('Ubisoft',         'France'),
('CD Projekt',      'Poland'),
('Nintendo',        'Japan'),
('FromSoftware',    'Japan');

-- ------------------------------------------------------------
-- 5. Game (8 rows)
-- ------------------------------------------------------------
INSERT INTO Game (Title, Genre, Price, PublisherID) VALUES
('FIFA 26',                     'Sports',    69.99, 1),
('Assassin''s Creed Shadows',   'Action',    59.99, 2),
('Cyberpunk 2077',              'RPG',       39.99, 3),
('The Witcher 3',               'RPG',       29.99, 3),
('Mario Kart 9',                'Racing',    49.99, 4),
('Elden Ring',                  'RPG',       59.99, 5),
('Rainbow Six Siege',           'Shooter',   19.99, 2),
('Zelda: Echoes of Wisdom',     'Adventure', 54.99, 4);

-- ------------------------------------------------------------
-- 6. Account (6 rows)
-- ------------------------------------------------------------
INSERT INTO Account (AccountName, PlayerID, ConsoleID, SubscriptionTierID) VALUES
('LiamF_Main',   1, 1, 2),
('MiaS_Main',    2, 2, 1),
('NoahB_Main',   3, 3, 1),
('EmmaH_Main',   4, 4, 3),
('LucasW_Main',  5, 5, 2),
('SophieK_Main', 6, 1, 3);

-- ------------------------------------------------------------
-- 7. Account_Games (10 rows)
--    Each (AccountID, GameID) pair is unique -- enforces the
--    "one license per game per account" business rule
-- ------------------------------------------------------------
INSERT INTO Account_Games (AccountID, GameID, PurchaseDate) VALUES
(1, 1, '2024-01-15'),
(1, 3, '2024-02-10'),
(2, 2, '2024-01-20'),
(2, 5, '2024-03-01'),
(3, 4, '2024-02-14'),
(3, 7, '2024-04-05'),
(4, 6, '2024-01-30'),
(4, 8, '2024-05-12'),
(5, 1, '2024-03-22'),
(6, 2, '2024-06-01');

-- ------------------------------------------------------------
-- 8. Transaction (8 rows)
-- ------------------------------------------------------------
INSERT INTO Transaction (AccountID, Amount, Date, PaymentMethod) VALUES
(1, 69.99, '2024-01-15 10:30:00', 'Visa'),
(1, 39.99, '2024-02-10 14:00:00', 'Visa'),
(2,  9.99, '2024-01-20 09:15:00', 'PayPal'),
(2, 49.99, '2024-03-01 16:45:00', 'PayPal'),
(3, 29.99, '2024-02-14 11:20:00', 'Mastercard'),
(4, 14.99, '2024-01-30 08:00:00', 'Visa'),
(5, 69.99, '2024-03-22 13:10:00', 'PayPal'),
(6,  9.99, '2024-06-01 17:30:00', 'Mastercard');

-- ------------------------------------------------------------
-- 9. SupportAgent (5 rows)
-- ------------------------------------------------------------
INSERT INTO SupportAgent (AgentName, Email) VALUES
('Anna Weber',    'anna.weber@company.de'),
('Jonas Meyer',   'jonas.meyer@company.de'),
('Laura Schmidt', 'laura.schmidt@company.de'),
('Felix Braun',   'felix.braun@company.de'),
('Ryan Lee',      'ryan.lee@company.de');

-- ------------------------------------------------------------
-- 10. SupportTicket (6 rows)
-- ------------------------------------------------------------
INSERT INTO SupportTicket (AccountID, AgentID, Issue, Status, DateOpened) VALUES
(1, 1, 'Charged twice for FIFA 26',                    'Resolved',    '2024-01-16 09:00:00'),
(2, 2, 'Cannot access Premium subscription features',   'Open',        '2024-03-05 10:15:00'),
(3, 1, 'Refund request for Rainbow Six Siege',          'In Progress', '2024-04-06 12:30:00'),
(4, 3, 'Account locked after password reset',           'Resolved',    '2024-02-01 08:45:00'),
(5, 4, 'Missing purchase confirmation email',           'Open',        '2024-03-23 15:00:00'),
(6, 2, 'Subscription tier downgrade not applied',       'Closed',      '2024-06-02 11:20:00');

-- ------------------------------------------------------------
-- Row count verification
-- ------------------------------------------------------------
SELECT 'Player' AS TableName, COUNT(*) AS RowCount FROM Player
UNION ALL SELECT 'Console', COUNT(*) FROM Console
UNION ALL SELECT 'SubscriptionTier', COUNT(*) FROM SubscriptionTier
UNION ALL SELECT 'Publisher', COUNT(*) FROM Publisher
UNION ALL SELECT 'Game', COUNT(*) FROM Game
UNION ALL SELECT 'Account', COUNT(*) FROM Account
UNION ALL SELECT 'Account_Games', COUNT(*) FROM Account_Games
UNION ALL SELECT 'Transaction', COUNT(*) FROM Transaction
UNION ALL SELECT 'SupportAgent', COUNT(*) FROM SupportAgent
UNION ALL SELECT 'SupportTicket', COUNT(*) FROM SupportTicket;

SELECT
    st.TierName,
    SUM(t.Amount) AS TotalRevenue
FROM SubscriptionTier st
INNER JOIN Account a ON st.TierID = a.SubscriptionTierID
INNER JOIN Transaction t ON a.AccountID = t.AccountID
WHERE t.Amount > 0
GROUP BY st.TierName
ORDER BY TotalRevenue DESC;

WITH GameOwnership AS (
    SELECT
        g.Genre,
        g.Title,
        COUNT(ag.AccountID) AS TotalOwners
    FROM Game g
    LEFT JOIN Account_Games ag ON g.GameID = ag.GameID
    GROUP BY g.Genre, g.Title
)
SELECT
    Genre,
    Title,
    TotalOwners,
    RANK() OVER (PARTITION BY Genre ORDER BY TotalOwners DESC) AS OwnershipRank
FROM GameOwnership;

SELECT
    a.AccountName,
    (SELECT SUM(t2.Amount) FROM Transaction t2 WHERE t2.AccountID = a.AccountID) AS TotalSpend
FROM Account a
WHERE (SELECT SUM(t2.Amount) FROM Transaction t2 WHERE t2.AccountID = a.AccountID)
        > (SELECT AVG(Amount) FROM Transaction)
  AND a.AccountID IN (
        SELECT t.AccountID
        FROM Transaction t
        WHERE t.Date BETWEEN '2024-01-01' AND '2024-01-31'
  );
  
  SELECT
    a.AccountName,
    COALESCE(SUM(t.Amount), 0) AS TotalBilled,
    MAX(t.Date) AS LastBillingDate,
    CASE
        WHEN MAX(t.Date) IS NULL THEN 'Never Billed'
        WHEN MAX(t.Date) < CURDATE() - INTERVAL 30 DAY THEN 'Overdue Review'
        ELSE 'Active'
    END AS BillingStatus
FROM Account a
LEFT JOIN Transaction t ON a.AccountID = t.AccountID
GROUP BY a.AccountName;

SELECT
    p.PublisherName,
    COUNT(g.GameID) AS GamesPublished,
    MIN(g.Price) AS CheapestGame,
    MAX(g.Price) AS MostExpensiveGame
FROM Publisher p
INNER JOIN Game g ON p.PublisherID = g.PublisherID
GROUP BY p.PublisherName
HAVING COUNT(g.GameID) > 1;

SELECT
    st.TicketID,
    st.Issue,
    st.Status,
    sa.AgentName,
    sa.Email
FROM SupportTicket st
INNER JOIN SupportAgent sa ON st.AgentID = sa.AgentID
WHERE st.Status LIKE '%Open%'
   OR sa.Email LIKE '%@company.de';
   
CREATE VIEW vw_ActiveAccountSummary AS
SELECT
    a.AccountID,
    a.AccountName,
    st.TierName,
    SUM(t.Amount) AS LifetimeSpend
FROM Account a
INNER JOIN SubscriptionTier st ON a.SubscriptionTierID = st.TierID
LEFT JOIN Transaction t ON a.AccountID = t.AccountID
GROUP BY a.AccountID, a.AccountName, st.TierName;
 
-- Run this separately right after creating the view, to see it work:
SELECT * FROM vw_ActiveAccountSummary;

DELIMITER //
CREATE PROCEDURE GetAccountOwnershipSummary (IN inputAccountID INT)
BEGIN
    SELECT
        a.AccountName,
        st.TierName,
        g.Title,
        ag.PurchaseDate
    FROM Account a
    INNER JOIN SubscriptionTier st ON a.SubscriptionTierID = st.TierID
    LEFT JOIN Account_Games ag ON a.AccountID = ag.AccountID
    LEFT JOIN Game g ON ag.GameID = g.GameID
    WHERE a.AccountID = inputAccountID;
END //
DELIMITER ;
 
-- Run this separately right after creating the procedure, to see it work:
CALL GetAccountOwnershipSummary(1);


DELIMITER //
CREATE TRIGGER trg_PreventDuplicateGamePurchase
BEFORE INSERT ON Account_Games
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Account_Games
        WHERE AccountID = NEW.AccountID AND GameID = NEW.GameID
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account already owns a license for this game';
    END IF;
END //
DELIMITER ;
 
-- Run this separately to PROVE the trigger works: Account 1 already owns
-- GameID 1 (see Account_Games sample data) -- this insert should FAIL
INSERT INTO Account_Games (AccountID, GameID, PurchaseDate) VALUES (1, 1, CURDATE());

SELECT
    t.TransactionID,
    a.AccountName,
    t.Date,
    t.Amount,
    SUM(t.Amount) OVER (
        PARTITION BY t.AccountID
        ORDER BY t.Date
    ) AS RunningTotalBilled
FROM Transaction t
INNER JOIN Account a ON t.AccountID = a.AccountID;