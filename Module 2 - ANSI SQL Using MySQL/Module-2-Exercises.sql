-- ==============================
-- Module 2 - ANSI SQL Using MySQL
-- ==============================

-- ------------------------------
-- TABLES
-- ------------------------------

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    city VARCHAR(100) NOT NULL,
    start_at DATETIME NOT NULL,
    end_at DATETIME NOT NULL,
    status ENUM('upcoming','completed','cancelled') NOT NULL,
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

CREATE TABLE Sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    session_title VARCHAR(200) NOT NULL,
    speaker VARCHAR(100) NOT NULL,
    start_at DATETIME NOT NULL,
    end_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Registrations (
    reg_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    reg_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    resource_type ENUM('pdf','image','link') NOT NULL,
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- ==============================
-- 1. User Upcoming Events
-- ==============================
SELECT e.event_id, e.title, e.city, e.start_at, e.end_at, e.status
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
JOIN Users u ON u.user_id = r.user_id
WHERE u.user_id = ?
  AND e.city = u.city
  AND e.status = 'upcoming'
ORDER BY e.start_at;

-- ==============================
-- 2. Top Rated Events
-- ==============================
SELECT e.event_id, e.title,
       AVG(f.rating) AS avg_rating,
       COUNT(f.feedback_id) AS feedback_count
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;

-- ==============================
-- 3. Inactive Users
-- ==============================
SELECT u.*
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Registrations r
    WHERE r.user_id = u.user_id
      AND r.reg_date >= CURDATE() - INTERVAL 90 DAY
);

-- ==============================
-- 4. Peak Session Hours
-- ==============================
SELECT e.event_id, e.title,
       COUNT(*) AS sessions_10_12
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
WHERE TIME(s.start_at) BETWEEN '10:00:00' AND '11:59:59'
GROUP BY e.event_id, e.title;

-- ==============================
-- 5. Most Active Cities
-- ==============================
SELECT u.city,
       COUNT(DISTINCT r.user_id) AS active_users
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
GROUP BY u.city
ORDER BY active_users DESC
LIMIT 5;

-- ==============================
-- 6. Event Resource Summary
-- ==============================
SELECT e.event_id, e.title,
       SUM(r.resource_type = 'pdf') AS pdf_count,
       SUM(r.resource_type = 'image') AS image_count,
       SUM(r.resource_type = 'link') AS link_count,
       COUNT(r.resource_id) AS total_resources
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title;

-- ==============================
-- 7. Low Feedback Alerts
-- ==============================
SELECT u.user_id, u.full_name,
       e.event_id, e.title,
       f.rating, f.comments
FROM Feedback f
JOIN Users u ON f.user_id = u.user_id
JOIN Events e ON f.event_id = e.event_id
WHERE f.rating < 3;

-- ==============================
-- 8. Sessions per Upcoming Event
-- ==============================
SELECT e.event_id, e.title,
       COUNT(s.session_id) AS session_count
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id, e.title;

-- ==============================
-- 9. Organizer Event Summary
-- ==============================
SELECT u.user_id, u.full_name,
       COUNT(e.event_id) AS total_events,
       SUM(e.status='upcoming') AS upcoming_count,
       SUM(e.status='completed') AS completed_count,
       SUM(e.status='cancelled') AS cancelled_count
FROM Users u
JOIN Events e ON u.user_id = e.organizer_id
GROUP BY u.user_id, u.full_name;

-- ==============================
-- 10. Feedback Gap Events
-- ==============================
SELECT e.event_id, e.title
FROM Events e
WHERE EXISTS (
    SELECT 1 FROM Registrations r
    WHERE r.event_id = e.event_id
)
AND NOT EXISTS (
    SELECT 1 FROM Feedback f
    WHERE f.event_id = e.event_id
);

-- ==============================
-- 11. Daily New Users
-- ==============================
SELECT registration_date,
       COUNT(*) AS new_user_count
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 6 DAY
GROUP BY registration_date
ORDER BY registration_date;

-- ==============================
-- 12. Event with Maximum Sessions
-- ==============================
SELECT e.event_id, e.title,
       COUNT(s.session_id) AS session_count
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(s.session_id) = (
    SELECT MAX(session_total)
    FROM (
        SELECT COUNT(*) AS session_total
        FROM Sessions
        GROUP BY event_id
    ) AS temp
);

-- ==============================
-- 13. Average Rating per City
-- ==============================
SELECT e.city,
       AVG(f.rating) AS avg_rating
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.city;

-- ==============================
-- 14. Most Registered Events
-- ==============================
SELECT e.event_id, e.title,
       COUNT(r.reg_id) AS registrations
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title
ORDER BY registrations DESC
LIMIT 3;

-- ==============================
-- 15. Session Time Conflicts
-- ==============================
SELECT s1.event_id,
       e.title,
       s1.session_id AS session1,
       s1.session_title AS title1,
       s2.session_id AS session2,
       s2.session_title AS title2
FROM Sessions s1
JOIN Sessions s2
  ON s1.event_id = s2.event_id
 AND s1.session_id < s2.session_id
 AND s1.start_at < s2.end_at
 AND s2.start_at < s1.end_at
JOIN Events e ON e.event_id = s1.event_id;

-- ==============================
-- 16. Unregistered Active Users
-- ==============================
SELECT u.*
FROM Users u
WHERE u.registration_date >= CURDATE() - INTERVAL 30 DAY
AND NOT EXISTS (
    SELECT 1 FROM Registrations r
    WHERE r.user_id = u.user_id
);

-- ==============================
-- 17. Multi-Session Speakers
-- ==============================
SELECT speaker,
       COUNT(*) AS session_count
FROM Sessions
GROUP BY speaker
HAVING COUNT(*) > 1;

-- ==============================
-- 18. Events Without Resources
-- ==============================
SELECT e.event_id, e.title
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;

-- ==============================
-- 19. Completed Event Summary
-- ==============================
SELECT e.event_id, e.title,
       COUNT(DISTINCT r.reg_id) AS total_registrations,
       AVG(f.rating) AS avg_rating
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE e.status = 'completed'
GROUP BY e.event_id, e.title;

-- ==============================
-- 20. User Engagement Index
-- ==============================
SELECT u.user_id, u.full_name,
       COUNT(DISTINCT r.event_id) AS events_attended,
       COUNT(f.feedback_id) AS feedback_count
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id
LEFT JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name;

-- ==============================
-- 21. Top Feedback Providers
-- ==============================
SELECT u.user_id, u.full_name,
       COUNT(f.feedback_id) AS feedback_count
FROM Users u
JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name
ORDER BY feedback_count DESC
LIMIT 5;

-- ==============================
-- 22. Duplicate Registrations
-- ==============================
SELECT user_id, event_id,
       COUNT(*) AS duplicate_count
FROM Registrations
GROUP BY user_id, event_id
HAVING COUNT(*) > 1;

-- ==============================
-- 23. Registration Trends
-- ==============================
SELECT DATE_FORMAT(reg_date, '%Y-%m') AS month,
       COUNT(*) AS total_registrations
FROM Registrations
WHERE reg_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

-- ==============================
-- 24. Average Session Duration
-- ==============================
SELECT e.event_id, e.title,
       AVG(TIMESTAMPDIFF(MINUTE, s.start_at, s.end_at)) AS avg_duration
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title;

-- ==============================
-- 25. Events Without Sessions
-- ==============================
SELECT e.event_id, e.title
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE s.session_id IS NULL;