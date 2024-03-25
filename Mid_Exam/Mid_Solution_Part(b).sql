USE master;
GO
CREATE DATABASE MID_Q2;
GO
Use [MID_Q2];

-- Create Tables
CREATE TABLE Readers (
    readerId INT PRIMARY KEY,
    email NVARCHAR(255),
    name NVARCHAR(255),
    joinDate DATE
);

CREATE TABLE Authors (
    authorId INT PRIMARY KEY,
    name NVARCHAR(255),
    nationality NVARCHAR(255)
);

CREATE TABLE Books (
    bookId INT PRIMARY KEY,
    title NVARCHAR(255),
    publicationYear INT,
    authorId INT,
    FOREIGN KEY (authorId) REFERENCES Authors(authorId)
);

CREATE TABLE Reviews (
    reviewId INT PRIMARY KEY,
    bookId INT,
    readerId INT,
    rating INT,
    reviewDate DATE,
    content NVARCHAR(MAX),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (readerId) REFERENCES Readers(readerId)
);

CREATE TABLE Favorites (
    readerId INT,
    bookId INT,
    dateAdded DATE,
    FOREIGN KEY (readerId) REFERENCES Readers(readerId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId)
);

INSERT INTO Authors (authorId, name, nationality) VALUES
(1, 'John Green', 'American'),
(2, 'J.K. Rowling', 'British'),
(3, 'George R.R. Martin', 'American'),
(4, 'Haruki Murakami', 'Japanese'),
(5, 'Agatha Christie', 'British');

INSERT INTO Books (bookId, title, publicationYear, authorId) VALUES
(1, 'The Fault in Our Stars', 2012, 1),
(2, 'Harry Potter and the Philosopher''s Stone', 1997, 2),
(3, 'A Game of Thrones', 1996, 3),
(4, 'Norwegian Wood', 1987, 4),
(5, 'Murder on the Orient Express', 1934, 5),
(6, 'Looking for Alaska', 2005, 1),
(7, 'Harry Potter and the Chamber of Secrets', 1998, 2),
(8, 'Harry Potter and the Prisoner of Azkaban', 1999, 2),
(9, 'The Wind-Up Bird Chronicle', 1994, 4),
(10, 'And Then There Were None', 1939, 5);

INSERT INTO Readers (readerId, email, name, joinDate) VALUES
(1, 'reader1@example.com', 'Alice Johnson', '2018-05-15'),
(2, 'reader2@example.com', 'Bob Smith', '2019-08-20'),
(3, 'reader3@example.com', 'Charlie Brown', '2020-01-10'),
(4, 'reader4@example.com', 'Diana Williams', '2021-03-25'),
(5, 'reader5@example.com', 'Eva Garcia', '2022-07-12');

INSERT INTO Reviews (reviewId, bookId, readerId, rating, reviewDate, content) VALUES
(1, 1, 1, 4, '2018-06-01', 'Touching story.'),
(2, 2, 1, 5, '2018-07-10', 'A magical journey!'),
(3, 3, 2, 4, '2019-09-05', 'Epic fantasy.'),
(4, 4, 3, 4, '2020-02-20', 'Beautifully written.'),
(5, 5, 4, 5, '2021-04-30', 'Classic mystery.'),
(6, 6, 2, 3, '2019-10-20', 'Decent read.'),
(7, 7, 3, 5, '2020-05-15', 'Loved it!'),
(8, 8, 4, 4, '2021-06-12', 'Another great book in the series.'),
(9, 9, 5, 5, '2022-08-03', 'Mind-bending.'),
(10, 10, 1, 5, '2018-10-10', 'One of her best!');

INSERT INTO Favorites (readerId, bookId, dateAdded) VALUES
(1, 1, '2018-06-01'),
(1, 2, '2018-07-10'),
(2, 3, '2019-09-05'),
(3, 4, '2020-02-20'),
(4, 5, '2021-04-30'),
(2, 6, '2019-10-20'),
(3, 7, '2020-05-15'),
(4, 8, '2021-06-12'),
(5, 9, '2022-08-03'),
(1, 10, '2018-10-10');

-- selecting all tables
SELECT * FROM [Readers];
SELECT * FROM [Authors];
SELECT * FROM [Books];
SELECT * FROM [Reviews];
SELECT * FROM [Favorites];

--1: Retrieve the authors who have not received any reviews:
SELECT * from [Authors]
WHERE authorId NOT IN
(SELECT DISTINCT authorId from Books
WHERE bookId IN
(SELECT bookId from Reviews));

--2:Find the reades who has given the lowest rating among all the reviews
SELECT * FROM [Readers]
WHERE readerId in
(SELECT readerId from [Reviews]
WHERE rating =
((SELECT MIN(rating) FROM [Reviews])));

--3: Identify the authors who have the highest average rating for their books, considering only books with at least 5 reviews:
SELECT authorId, name, AVG(rating) as avg_rating
FROM [Authors] a
JOIN [Books] b
ON a.authorId = b.authorId
JOIN [Reviews] r
ON b.bookId = r.bookId
GROUP BY authorId, name
HAVING COUNT(r.bookId) >= 5
ORDER BY AVG(rating) DESC;

--4: Write a query to find the book with the highest number of reviews and display the book title, author's name, and the count of reviews.
SELECT TOP 1 b.title, a.name as author_name, COUNT(r.reviewId) as review_count
FROM [Books] b
JOIN [Authors] a
ON b.authorId = a.authorId
JOIN [Reviews] r
ON b.bookId = r.bookId
GROUP BY b.title, a.name
ORDER BY COUNT(r.reviewId) DESC;

--5: Show the top 3 authors with the most prolific output in terms of the number of books published, along with the count of books they have published since the year 2000.
SELECT TOP 3 a.authorId, a.name, COUNT(b.bookId) as book_count
FROM [Authors] a
JOIN [Books] b
ON a.authorId = b.authorId
WHERE b.publicationYear >= 2000
GROUP BY a.authorId, a.name
ORDER BY COUNT(b.bookId) DESC;

-- DROP DATABASE
USE master;
GO
DROP DATABASE MID_Q2;