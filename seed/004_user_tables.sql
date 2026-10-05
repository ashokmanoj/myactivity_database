-- Seed data for ddl/004_user_tables.sql — 2 dummy test users for local dev
-- login testing (not real people).
SET search_path TO myactivity;

INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality)
VALUES
('EMP101', 'John Doe', '1990-05-15', 'Male', '9876543210', 'john.doe@example.com', 'Indian'),
('EMP102', 'Jane Smith', '1992-08-20', 'Female', '9876543211', 'jane.smith@example.com', 'Indian')
ON CONFLICT (emp_code) DO NOTHING;

INSERT INTO user_information (user_id, title, aadhar_number, aadhar_document, pan_number, pan_document, qualification, total_experience)
VALUES
(1, 'Mr', '123456789012', '/uploads/docs/john_aadhar.pdf', 'ABCDE1234F', '/uploads/docs/john_pan.jpg', 'Bachelor''s Degree (UG)', '5 years'),
(2, 'Ms', '987654321098', '/uploads/docs/jane_aadhar.pdf', 'XYZW9876G', '/uploads/docs/jane_pan.jpg', 'MBA', 'Fresher (0 years)')
ON CONFLICT (user_id) DO NOTHING;
