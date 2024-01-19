# from flask_sqlalchemy import SQLAlchemy

# db = SQLAlchemy()


# def init_app(app):
#     db.init_app(app)


import cx_Oracle

def connection_oracle(query):
    conn = cx_Oracle.connect('MVCUSTOM/mvcustomcomgbh#*1912*#@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=1912db.cloudmv.com.br)(PORT=1522))(CONNECT_DATA=(SERVICE_NAME=tst11912.db1912.mv1912vcn.oraclevcn.com)))')
    cur = conn.cursor()
    cur.execute(query)
    results = cur.fetchall()
    cur.close()
    conn.close()
    print("Successfully connected to Oracle Database")
    return results
    

query = connection_oracle("select * from atendime where cd_atendimento = 1")   

# Now query the rows back
for row in query:
    print(row)