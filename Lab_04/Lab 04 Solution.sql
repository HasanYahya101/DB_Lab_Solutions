use twitter;
go
-- Select all Tables
SELECT * FROM Following;
SELECT * FROM Hashtags;
SELECT * FROM Interests;
SELECT * FROM Likes;
SELECT * FROM Tweets;
SELECT * FROM UserInterests;
SELECT * FROM Users;

-- 1. Find the tweets liked by users who are following 'ImranKhan'.
SELECT *
FROM Tweets
WHERE TweetID IN (
    SELECT TweetID
    FROM Likes
    WHERE LikeByUserName IN (
        SELECT FollowerUserName
        FROM Following
        WHERE FollowedUserName = 'ImranKhan'
    )
);

-- 2. List the usernames of users who have an interest in politics.
SELECT UserName
FROM Users
WHERE UserName IN (
    SELECT UI.UserName
    FROM UserInterests UI
    JOIN Interests I ON UI.InterestID = I.InterestID
    WHERE I.Description = 'Politics'
);

-- 3. Get the usernames of users who have liked tweets by 'DonaldTrump'.
SELECT DISTINCT LikeByUserName
FROM Likes
WHERE TweetID IN (
    SELECT TweetID
    FROM Tweets
    WHERE UserName = 'DonaldTrump'
);

-- 4. Find the tweets liked by users who have interests in both politics and sports.
SELECT *
FROM Tweets
WHERE TweetID IN (
    SELECT DISTINCT L.TweetID
    FROM Likes L
    JOIN UserInterests UI ON L.LikeByUserName = UI.UserName
    JOIN Interests I ON UI.InterestID = I.InterestID
    WHERE I.Description = 'Politics'
    AND L.LikeByUserName IN (
        SELECT UserName
        FROM UserInterests
        WHERE InterestID IN (
            SELECT InterestID
            FROM Interests
            WHERE Description = 'Sports'
        )
    )
);

-- 5. List the usernames of users who are not following anyone.
SELECT UserName
FROM Users
WHERE UserName NOT IN (
    SELECT DISTINCT FollowerUserName
    FROM Following
);

-- 6. Retrieve the usernames of users who have liked tweets containing the hashtag '#MasseCritique'.
SELECT DISTINCT L.LikeByUserName
FROM Likes L
WHERE L.TweetID IN (
    SELECT T.TweetID
    FROM Tweets T
    WHERE T.Text LIKE '%#MasseCritique%'
);

-- 7. Find the tweets liked by users who are from the USA.
SELECT T.TweetID, T.UserName, T.Text
FROM Tweets T
WHERE T.TweetID IN (
    SELECT L.TweetID
    FROM Likes L
    WHERE L.LikeByUserName IN (
        SELECT U.UserName
        FROM Users U
        WHERE U.Country = 'USA'
    )
);

-- 8. List the usernames of users who have an interest in movies and in sports.
SELECT UI.UserName
FROM UserInterests UI
WHERE UI.InterestID IN (
    SELECT I.InterestID
    FROM Interests I
    WHERE I.Description = 'Movies'
) AND UI.UserName IN (
    SELECT UI2.UserName
    FROM UserInterests UI2
    WHERE UI2.InterestID IN (
        SELECT I.InterestID
        FROM Interests I
        WHERE I.Description = 'Sports'
    )
);

-- 9. Retrieve the tweets liked by users who are following ‘Ali123’.
SELECT T.TweetID, T.UserName, T.Text
FROM Tweets T
WHERE T.TweetID IN (
    SELECT L.TweetID
    FROM Likes L
    WHERE L.LikeByUserName IN (
        SELECT F.FollowerUserName
        FROM Following F
        WHERE F.FollowedUserName = 'Ali123'
    )
);

-- 10. List the usernames of users who have not liked any tweet.
SELECT UserName
FROM Users
WHERE UserName NOT IN (SELECT DISTINCT LikeByUserName FROM Likes);

-- 11. Find the tweets liked by users who have interests in education.
SELECT *
FROM Tweets
WHERE TweetID IN (
    SELECT TweetID
    FROM Likes
    WHERE LikeByUserName IN (
        SELECT UserName
        FROM UserInterests
        WHERE InterestID = (
            SELECT InterestID
            FROM Interests
            WHERE [Description] = 'Education'
        )
    )
);

-- Finally Drop table twitter
use master;
go
DROP DATABASE IF EXISTS twitter;