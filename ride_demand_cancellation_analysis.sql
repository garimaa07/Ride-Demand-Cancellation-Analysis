-- =====================================================
-- PROJECT: Ride Demand & Cancellation Analysis
-- OBJECTIVE: Identify patterns in ride outcomes,
--            cancellation drivers, and peak failure times
-- =====================================================

-- =========================
-- 1. DATA OVERVIEW
-- =========================

SELECT COUNT(*) AS total_rides
FROM rides2;


-- =========================
-- 2. CORE KPIs
-- =========================

-- Cancellation Rate (Primary KPI)
SELECT 
    COUNT(*) AS total_rides,
    SUM(CASE WHEN Ride_Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_rides,
    ROUND(SUM(CASE WHEN Ride_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate_percent
FROM rides2;

-- Completion Rate
SELECT 
    ROUND(SUM(CASE WHEN Ride_Status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_percent
FROM rides2;


-- =========================
-- 3. DEMAND ANALYSIS (WHEN)
-- =========================

-- Ride Demand by Hour
SELECT 
    HOUR(Request_Time) AS hour,
    COUNT(*) AS total_rides
FROM rides2
GROUP BY hour
ORDER BY total_rides DESC;


-- =========================
-- 4. FAILURE ANALYSIS (WHEN SYSTEM BREAKS)
-- =========================

-- Cancellations by Hour
SELECT 
    HOUR(Request_Time) AS hour,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN Ride_Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_rides,
    ROUND(SUM(CASE WHEN Ride_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM rides2
GROUP BY hour
ORDER BY cancellation_rate DESC;


-- =========================
-- 5. BEHAVIOR ANALYSIS (WHO CANCELS)
-- =========================

SELECT 
    Cancelled_By,
    COUNT(*) AS total_cancellations
FROM rides2
WHERE Ride_Status = 'Cancelled'
GROUP BY Cancelled_By
ORDER BY total_cancellations DESC;


-- =========================
-- 6. BUSINESS SEGMENTATION (INSIGHT LAYER)
-- =========================

SELECT 
    CASE 
        WHEN HOUR(Request_Time) BETWEEN 7 AND 10 THEN 'Morning Peak'
        WHEN HOUR(Request_Time) BETWEEN 17 AND 21 THEN 'Evening Peak'
        ELSE 'Off Peak'
    END AS time_slot,
    
    COUNT(*) AS total_rides,

    ROUND(SUM(CASE WHEN Ride_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate

FROM rides2
GROUP BY time_slot
ORDER BY cancellation_rate DESC;
