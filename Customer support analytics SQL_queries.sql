CREATE DATABASE support_analytics;
USE support_analytics;

-- Creating Tbale
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    issue_type VARCHAR(50),
    status VARCHAR(50),
    agent_name VARCHAR(50),
    created_date DATE,
    resolved_date DATE,
    resolution_time_days INT,
    customer_satisfaction INT,
    priority VARCHAR(20),
    channel VARCHAR(20),
    region VARCHAR(20)
     );
	
-- 1. TICKETS BY PRIORITY
SELECT priority , COUNT(*) As total_tickets
FROM tickets
GROUP BY priority
ORDER BY total_tickets DESC;

-- 2. TICKETS BY CHANNEL
SELECT channel , COUNT(*) As total_tickets
FROM tickets
GROUP BY channel;

-- 3. REGION-WISE TICKET DISTRIBUTION
SELECT region, COUNT(*) As total_tickets
FROM tickets
GROUP BY region
ORDER BY total_tickets DESC;

-- 4. AVG RESOLUTION TIME BY PRIORITY
SELECT priority, 
       Avg(resolution_time_days) As Avg_resolution_time
FROM tickets
GROUP BY  priority;

-- 5. AGENT PERFORMANCE BY CHANNEL
SELECT agent_name, channel,
       COUNT(*) As tickets_handled,
       Avg(resolution_time_days) As Avg_resolution_time
FROM tickets
GROUP BY agent_name, channel
ORDER BY agent_name;

-- 6. CUSTOMER SATISFACTION BY CHANNEL
SELECT channel,
       Avg(customer_satisfaction) As avg_rating
FROM tickets
GROUP BY channel;

-- 7. ESCALATION RATE BY PRIORITY
SELECT priority,
       COUNT(CASE WHEN status = 'Escalated' THEN 1 END) * 100.0 / COUNT(*) AS escalation_rate
FROM tickets
GROUP BY priority;
       
-- 8. MONTHLY TREND BY REGION
SELECT region,
       MONTH(created_date) AS month,
       COUNT(*) AS total_tickets
FROM tickets
GROUP BY region, month
ORDER BY region, month;

-- 9. HIGH PRIORITY ISSUES WITH LOW SATISFCATION
SELECT issue_type,
       AVG(customer_satisfaction) AS avg_rating
FROM tickets
WHERE priority = 'High'
GROUP BY issue_type
ORDER BY avg_rating ASC;

-- 10. SLA BREACH ANALYSIS
SELECT 
    COUNT(*) AS breached_cases,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tickets) AS breach_percentage
FROM tickets
WHERE resolution_time_days > 3;

