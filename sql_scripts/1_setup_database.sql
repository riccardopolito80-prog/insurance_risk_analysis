-- 1. Tabella Clienti (Anagrafica)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(20),
    age INT,
    segment VARCHAR(20) -- Es. VIP, Standard
);

-- 2. Tabella Polizze (Prodotti venduti)
CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    customer_id INT,
    policy_type VARCHAR(20), -- Auto, Vita, Casa
    start_date DATE,
    premium_amount DECIMAL(10, 2), -- Quanto paga il cliente
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Tabella Sinistri (Soldi persi dall'azienda)
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    claim_amount DECIMAL(10, 2), -- Quanto paga l'assicurazione
    status VARCHAR(20), -- Pagato, In revisione
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- POPOLAMENTO DATI (DML)
INSERT INTO customers VALUES 
(1, 'Mario Rossi', 'Lazio', 34, 'Standard'),
(2, 'Luca Bianchi', 'Lombardia', 45, 'VIP'),
(3, 'Giulia Verdi', 'Lazio', 28, 'Standard'),
(4, 'Anna Neri', 'Campania', 60, 'VIP');

INSERT INTO policies VALUES 
(101, 1, 'Auto', '2023-01-01', 600.00),
(102, 2, 'Vita', '2023-02-15', 2500.00),
(103, 2, 'Auto', '2023-03-01', 800.00),
(104, 3, 'Casa', '2023-05-10', 300.00),
(105, 4, 'Vita', '2023-06-20', 1200.00);

INSERT INTO claims VALUES 
(1, 101, '2023-06-01', 1500.00, 'Pagato'), -- Mario ha fatto un incidente (Loss!)
(2, 104, '2023-07-01', 100.00, 'Pagato');
