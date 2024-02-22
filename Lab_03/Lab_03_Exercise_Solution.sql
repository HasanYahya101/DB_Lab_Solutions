--Lab 03 Exercise Solution
--To use a Database and return table values

USE [ATM];
SELECT * FROM [Card];
SELECT * FROM [CardType];
SELECT * FROM [Transaction];
SELECT * FROM [User];
SELECT * FROM [UserCard];

--Q1:
SELECT CardTypeId, Count(distinct userId) 
from usercard join card on userCard.CardNum = Card.CardNum
GROUP BY CardTypeId;

--Q2:
SELECT [User].[name], [Card].cardNum
FROM [User]
JOIN UserCard ON [User].userId = UserCard.userID
JOIN [Card] ON UserCard.cardNum = [Card].cardNum
WHERE [Card].balance BETWEEN 2000 AND 4000;

--Q3: <------>
--Q3.(a) Using SET Operation:
SELECT [name] FROM [User]
WHERE [userId] NOT IN (SELECT [userID] FROM UserCard);

--Q3.(b) Using JOIN Operation:
SELECT [User].[name] 
FROM [User]
LEFT JOIN UserCard ON [User].[userId] = UserCard.[userID]
WHERE UserCard.cardNum IS NULL;

--Q4: <------>
--Q4.(a) Using SET Operation:
SELECT Card.cardNum, CardType.name, [User].name
FROM Card, CardType, [User], UserCard
WHERE Card.cardTypeID = CardType.cardTypeID
AND Card.cardNum = UserCard.cardNum
AND UserCard.userID = [User].userId
AND Card.cardNum NOT IN (SELECT [Transaction].cardNum FROM [Transaction]
WHERE YEAR([Transaction].transDate) >= YEAR(GETDATE()) - 1);

--Q4.(b) Using JOIN Operation:
SELECT Card.cardNum, CardType.name, [User].name 
FROM Card
INNER JOIN CardType ON Card.cardTypeID = CardType.cardTypeID
INNER JOIN UserCard ON Card.cardNum = UserCard.cardNum
INNER JOIN [User] ON UserCard.userID = [User].userId
LEFT JOIN [Transaction] ON Card.cardNum = [Transaction].cardNum
WHERE [Transaction].cardNum IS NULL OR YEAR([Transaction].transDate) < YEAR(GETDATE()) - 1;

--Q5:
SELECT CardType.[name], 
COUNT(DISTINCT [Transaction].cardNum) as NumberOfCards
FROM [Transaction]
JOIN [Card] ON [Transaction].cardNum = [Card].cardNum
JOIN CardType ON [Card].cardTypeID = CardType.cardTypeID
WHERE YEAR([Transaction].transDate) BETWEEN 2015 AND 2017
GROUP BY CardType.[name]
HAVING SUM([Transaction].amount) > 6000;

--Q6:
SELECT [User].userId, [User].[name], 
[User].phoneNum, [User].city, 
[Card].cardNum, CardType.[name] as cardTypeName FROM [User]
JOIN UserCard ON [User].userId = UserCard.userID
JOIN [Card] ON UserCard.cardNum = [Card].cardNum
JOIN CardType ON [Card].cardTypeID = CardType.cardTypeID
WHERE [Card].expireDate BETWEEN GETDATE() AND DATEADD(MONTH, 3, GETDATE());

--Q7:
SELECT [User].userId, [User].[name]
FROM [User]
JOIN UserCard ON [User].userId = UserCard.userID
JOIN [Card] ON UserCard.cardNum = [Card].cardNum
GROUP BY [User].userId, [User].[name]
HAVING SUM([Card].balance) >= 5000;

--Q8:
SELECT Card1.cardNum AS Card1, 
Card2.cardNum AS Card2, 
YEAR(Card1.expireDate) AS ExpiryYear
FROM [Card] as Card1
JOIN [Card] as Card2 ON YEAR(Card1.expireDate) = YEAR(Card2.expireDate)
WHERE Card1.cardNum <> Card2.cardNum;

--Q9:
SELECT User1.userId AS User1ID, User1.[name] AS User1Name, 
User2.userId AS User2ID, User2.[name] AS User2Name
FROM [User] as User1
JOIN [User] as User2 ON LEFT(User1.[name], 1) = LEFT(User2.[name], 1)
WHERE User1.userId <> User2.userId;

--Q10:
SELECT [User].userId, [User].[name]
FROM [User]
JOIN UserCard ON [User].userId = UserCard.userID
JOIN [Card] ON UserCard.cardNum = [Card].cardNum
JOIN CardType ON [Card].cardTypeID = CardType.cardTypeID
GROUP BY [User].userId, [User].[name]
HAVING COUNT(DISTINCT CardType.[name]) = 2;

--Q11:
SELECT [User].city, COUNT(DISTINCT [User].userId) as NumberOfUsers, 
SUM([Card].balance) as TotalBalance
FROM [User]
JOIN UserCard ON [User].userId = UserCard.userID
JOIN [Card] ON UserCard.cardNum = [Card].cardNum
GROUP BY [User].city;