/* ANALISI AVANZATA PORTAFOGLIO
   Obiettivo: Calcolare il Loss Ratio per Regione e identificare i clienti più profittevoli.
   Tecniche usate: CTEs, Left Joins, Aggregazioni, Window Functions.
*/

-- 1. CTE (Common Table Expression): Tabella temporanea per aggregare i sinistri
WITH Claims_Summary AS (
    SELECT 
        policy_id, 
        SUM(claim_amount) as totale_sinistri
    FROM claims
    WHERE status = 'Pagato'
    GROUP BY policy_id
),

-- 2. CTE: Uniamo Clienti, Polizze e Sinistri
Portfolio_Data AS (
    SELECT 
        c.region,
        c.name,
        p.policy_type,
        p.premium_amount,
        COALESCE(cs.totale_sinistri, 0) as sinistri_pagati -- Se NULL diventa 0
    FROM customers c
    JOIN policies p ON c.customer_id = p.customer_id
    LEFT JOIN Claims_Summary cs ON p.policy_id = cs.policy_id
)

-- 3. QUERY FINALE: Calcolo KPIs
SELECT 
    region,
    COUNT(*) as numero_polizze,
    SUM(premium_amount) as totale_premi_incassati,
    SUM(sinistri_pagati) as totale_sinistri_pagati,
    
    -- Calcolo del LOSS RATIO % (Sinistri / Premi)
    ROUND((SUM(sinistri_pagati) / SUM(premium_amount)) * 100, 2) as loss_ratio_perc,

    -- Window Function: Classifica le regioni per fatturato
    RANK() OVER (ORDER BY SUM(premium_amount) DESC) as classifica_fatturato

FROM Portfolio_Data
GROUP BY region
ORDER BY loss_ratio_perc DESC;
