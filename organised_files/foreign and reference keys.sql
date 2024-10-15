use  exp;
SELECT 
    ku.TABLE_NAME, 
    ku.COLUMN_NAME, 
    ku.CONSTRAINT_NAME, 
    ku.REFERENCED_TABLE_NAME, 
    ku.REFERENCED_COLUMN_NAME,
    fk_column.DATA_TYPE AS fk_column_data_type,   -- Data type of the foreign key column
    ref_column.DATA_TYPE AS ref_column_data_type  -- Data type of the referenced column
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE ku
JOIN 
    INFORMATION_SCHEMA.COLUMNS fk_column 
    ON ku.TABLE_NAME = fk_column.TABLE_NAME 
    AND ku.COLUMN_NAME = fk_column.COLUMN_NAME
JOIN 
    INFORMATION_SCHEMA.COLUMNS ref_column 
    ON ku.REFERENCED_TABLE_NAME = ref_column.TABLE_NAME 
    AND ku.REFERENCED_COLUMN_NAME = ref_column.COLUMN_NAME
WHERE 
    ku.REFERENCED_TABLE_NAME IS NOT NULL
    AND ku.TABLE_SCHEMA = 'exp'
ORDER BY 
    ku.REFERENCED_TABLE_NAME DESC;
    
   DESCRIBE users;
   CREATE TABLE user_related AS
SELECT 
    u.id AS user_id, 
    u.full_name AS user_name,  -- Using 'full_name' as the user's name
    ah.description AS action_description,
    ah.created_at AS action_created_at
FROM 
    users u
JOIN 
    action_histories ah 
ON 
    u.id = ah.creator_id;

describe feedbacks;
describe login_histories;
describe action_histories;
 

CREATE TABLE user_related AS
SELECT 
    u.id AS user_id, 
    u.full_name, 
    f.description AS feedback_description,  -- Feedback description from 'feedbacks' table
    ah.description AS action_description,    -- Action history description
    lh.created_at AS login_time              -- 'created_at' as login time from 'login_histories'
FROM 
    users u
LEFT JOIN 
    feedbacks f ON u.id = f.creator_id
LEFT JOIN 
    action_histories ah ON u.id = ah.creator_id
LEFT JOIN 
    login_histories lh ON u.id = lh.user_id;

select * from user_related;
Drop table if exists project_management_data;
CREATE TABLE project_management_data AS
SELECT 
    p.id AS project_id, 
    p.name AS project_name, 
    ah.description AS action_description,   -- Action history description
    ah.status AS action_status,             -- Status from 'action_histories'
    ah.gyr AS action_gyr,                   -- GYR (Green, Yellow, Red) status from 'action_histories'
    r.statement AS risk_description,        -- Risk description from 'risks'
    m.description AS milestone_description, -- Milestone description from 'milestones'
    gc.constraint AS gyr_constraint,        -- Constraint from 'gyr_constraints'
    gc.status AS gyr_status,                -- GYR status from 'gyr_constraints'
    gc.previous_status AS previous_gyr_status, -- Previous GYR status from 'gyr_constraints'
    gc.comments AS gyr_comments,            -- Comments on GYR status from 'gyr_constraints'
    p.created_at AS project_created_at      -- Project creation timestamp
FROM 
    projects p
LEFT JOIN 
    action_histories ah ON p.creator_id = ah.creator_id   -- Join on creator_id
LEFT JOIN 
    risks r ON p.id = r.project_id
LEFT JOIN 
    milestones m ON p.id = m.project_id
LEFT JOIN 
    gyr_constraints gc ON p.id = gc.project_id;           -- Join on project_id for GYR constraints

select * from project_management_data;
describe gyr_constraints;
describe financial_histories;

CREATE TABLE financial_data AS
SELECT 
    i.id AS invoice_id,                     -- Invoice ID
    i.number AS invoice_number,             -- Invoice number from 'invoices'
    i.total AS invoice_total_amount,        -- Total amount (invoice total)
    i.raw_amount AS raw_amount,             -- Raw amount (before discounts and taxes)
    i.tax AS tax_amount,                    -- Tax charged on the invoice
    i.discount AS discount_amount,          -- Discount applied to the invoice
    i.date AS invoice_date,                 -- Date the invoice was issued
    i.status AS invoice_status,             -- Invoice status (e.g., paid, pending)
    i.customer_email AS customer_email,     -- Customer's email address
    fh.total_billed,                        -- Total billed amount from 'financial_histories'
    fh.monthly_payments,                    -- Monthly payments from 'financial_histories'
    fh.yearly_payments,                     -- Yearly payments from 'financial_histories'
    proj.name AS project_name,              -- Project name from 'projects'
    proj.created_at AS project_created_at   -- Project creation date
FROM 
    invoices i
LEFT JOIN 
    financial_histories fh ON fh.id = i.id  -- Join based on matching ID
LEFT JOIN 
    projects proj ON i.id = proj.id;        -- Join project data on project_id

select * from financial_data;
show tables;
CREATE VIEW risk_and_contingency_management AS
SELECT 
    r.id AS risk_id, 
    r.project_id, 
    p.name AS project_name, 
    r.risk_identifier, 
    r.statement AS risk_statement, 
    r.impact AS risk_impact, 
    r.probability AS risk_probability, 
    r.status AS risk_status, 
    m.description AS mitigation_description, 
    gc.constraint AS gyr_constraint, 
    gc.status AS gyr_status, 
    c.description AS contingency_description
FROM 
    risks r
LEFT JOIN 
    projects p ON r.project_id = p.id
LEFT JOIN 
    mitigations m ON r.id = m.risk_id
LEFT JOIN 
    gyr_constraints gc ON gc.project_id = r.project_id
LEFT JOIN 
    contingencies c ON r.id = c.risk_id;
select * from risk_and_contingency_management;
DESCRIBE decisions;
DESCRIBE changes;

CREATE VIEW action_and_decision_tracking AS
SELECT 
    a.id AS action_id, 
    a.project_id, 
    p.name AS project_name, 
    a.description AS action_description, 
    ah.status AS action_status, 
    ah.gyr AS action_gyr_status, 
    d.date AS decision_date,  -- Decision date from 'decisions'
    ch.change_identifier AS change_identifier,  -- Change identifier from 'changes'
    ch.status AS change_status,  -- Change status from 'changes'
    ch.reason AS change_reason  -- Change reason from 'changes'
FROM 
    actions a
LEFT JOIN 
    projects p ON a.project_id = p.id
LEFT JOIN 
    action_histories ah ON a.id = ah.action_id
LEFT JOIN 
    decisions d ON a.id = d.action_id
LEFT JOIN 
    changes ch ON a.project_id = ch.project_id;  -- Join on project_id

select * from action_and_decision_tracking;
describe risks;
drop table if exists risk_and_contingency_management;
CREATE VIEW risk_and_contingency_management AS
SELECT 
    r.id AS risk_id, 
    r.project_id, 
    p.name AS project_name, 
    r.risk_identifier,                -- Unique identifier for the risk
    r.statement AS risk_statement,     -- Risk description
    r.impact AS risk_impact,           -- Risk impact score
    r.probability AS risk_probability, -- Probability score of the risk
    r.status AS risk_status,           -- Status of the risk
    m.description AS mitigation_description,   -- Description of mitigation actions from 'mitigations'
    gc.constraint AS gyr_constraint,   -- GYR constraint for the risk
    gc.status AS gyr_status,           -- GYR status (Green, Yellow, Red)
    c.description AS contingency_description  -- Contingency plans for the risk
FROM 
    risks r
LEFT JOIN 
    projects p ON r.project_id = p.id   -- Join on project_id
LEFT JOIN 
    mitigations m ON r.id = m.risk_id   -- Join mitigations table on risk_id
LEFT JOIN 
    gyr_constraints gc ON r.project_id = gc.project_id   -- Join GYR constraints on project_id
LEFT JOIN 
    contingencies c ON r.id = c.risk_id;   -- Join contingencies on risk_id
select * from risk_and_contingency_management;
describe contingencies;

CREATE VIEW meetings_and_communications AS
SELECT 
    m.id AS meeting_id, 
    m.project_id, 
    p.name AS project_name, 
    m.meeting_type_id, 
    mt.name AS meeting_type,            -- Meeting type (from meeting_types)
    m.created_at AS meeting_date,       -- Meeting date
    mm.comments AS meeting_minutes,     -- Comments or minutes from the meeting
    ma.contact_id AS attendee_contact_id,  -- Attendee contact ID
    c.full_name AS attendee_name,       -- Attendee's full name
    mm.meeting_time AS meeting_time     -- Meeting time from 'meeting_minutes'
FROM 
    meetings m
LEFT JOIN 
    projects p ON m.project_id = p.id    -- Join projects on project_id
LEFT JOIN 
    meeting_minutes mm ON m.id = mm.meeting_id   -- Join minutes on meeting_id
LEFT JOIN 
    meeting_attendees ma ON m.id = ma.meeting_id  -- Join attendees on meeting_id
LEFT JOIN 
    contacts c ON ma.contact_id = c.id   -- Join contacts to get attendee name
LEFT JOIN 
    meeting_types mt ON m.meeting_type_id = mt.id;  -- Join to get meeting type
select * from meetings_and_communications;
describe meeting_minutes;
CREATE VIEW feedback_and_evaluation AS
SELECT 
    f.id AS feedback_id, 
    f.creator_id AS user_id, 
    u.full_name AS user_name,                     -- Name of the user providing feedback
    f.description AS feedback_description,        -- Feedback description
    f.created_at AS feedback_date,                -- Date the feedback was given
    p.name AS project_name,                       -- Name of the project related to the feedback (from learnings)
    ka.description AS key_accomplishment,         -- Description of key accomplishments
    kd.description AS key_deliverable,            -- Description of key deliverables
    hlkd.description AS high_level_deliverable,   -- Description of high-level deliverables
    l.learn_description AS learning,              -- Lessons learned during the project (from learnings)
    nks.description AS next_key_steps             -- Next steps for the project
FROM 
    feedbacks f
LEFT JOIN 
    users u ON f.creator_id = u.id                -- Join to get user name (who provided the feedback)
LEFT JOIN 
    learnings l ON f.creator_id = l.creator_id    -- Join to link feedback creator to learnings
LEFT JOIN 
    projects p ON l.project_id = p.id             -- Link projects based on learnings' project_id
LEFT JOIN 
    key_accomplishments ka ON l.project_id = ka.project_id -- Join to get key accomplishments for the project
LEFT JOIN 
    key_deliverables kd ON l.project_id = kd.project_id   -- Join to get key deliverables for the project
LEFT JOIN 
    high_level_key_deliverables hlkd ON l.project_id = hlkd.project_id  -- Join to get high-level key deliverables
LEFT JOIN 
    next_key_steps nks ON l.project_id = nks.project_id;  -- Join to get next steps for the project

select * from feedback_and_evaluation ;
DESCRIBE learnings;
describe feedbacks;