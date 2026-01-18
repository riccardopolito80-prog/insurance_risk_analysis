import sqlite3
import pandas as pd

# Funzione per leggere i file SQL
def read_sql_file(filename):
    with open(filename, 'r') as file:
        return file.read()

# 1. Connessione al DB (In memoria)
conn = sqlite3.connect(':memory:')
cursor = conn.cursor()

# 2. Setup del Database (Esegue il primo file SQL)
print("--- Creazione Database e Inserimento Dati ---")
setup_script = read_sql_file('sql_scripts/1_setup_database.sql')
cursor.executescript(setup_script)
conn.commit()

# 3. Esecuzione Analisi Avanzata (Esegue il secondo file SQL)
print("--- Esecuzione Analisi KPI Assicurativi (Loss Ratio) ---")
analysis_script = read_sql_file('sql_scripts/2_advanced_analysis.sql')

# Leggiamo il risultato direttamente in un DataFrame Pandas per vederlo bene
df_kpi = pd.read_sql_query(analysis_script, conn)

# 4. Mostra Report
print("\nREPORT FINANZIARIO REGIONALE:")
print(df_kpi.to_string(index=False))

# 5. Export per Excel (Molto apprezzato dagli economisti)
df_kpi.to_excel("report_loss_ratio.xlsx", index=False)
print("\nFile Excel generato con successo.")

conn.close()
