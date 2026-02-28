#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera script SQL de INSERT a partir de item.csv
Uso: python3 generar_inserts.py
"""
import csv
import os

CSV_PATH = os.path.join(os.path.dirname(__file__), '..', 'item.csv')
OUT_PATH = os.path.join(os.path.dirname(__file__), 'catalogo_rodamientos_inserts.sql')
BATCH = 500  # filas por INSERT


def to_int(s):
    """Convierte '5,00' o '5.00' a 5."""
    if not s or not s.strip():
        return None
    s = s.strip().replace(',', '.')
    try:
        return int(round(float(s)))
    except ValueError:
        return None


def sql_escape(s):
    """Escapa comillas simples para SQL."""
    if s is None:
        return None
    return str(s).replace("\\", "\\\\").replace("'", "''")


def main():
    rows = []
    with open(CSV_PATH, 'r', encoding='utf-8', newline='') as f:
        reader = csv.reader(f, delimiter=';')
        header = next(reader, None)
        for row in reader:
            if len(row) < 4:
                continue
            codigo = (row[0] or '').strip()
            if not codigo:
                continue
            d_int = to_int(row[1] if len(row) > 1 else '')
            d_ext = to_int(row[2] if len(row) > 2 else '')
            espesor = to_int(row[3] if len(row) > 3 else '')
            descripcion = (row[4] if len(row) > 4 else '').strip()
            if d_int is None or d_ext is None or espesor is None:
                continue
            codigo = codigo[:20]  # VARCHAR(20)
            descripcion = (descripcion or '')[:255]
            rows.append((codigo, d_int, d_ext, espesor, descripcion))

    with open(OUT_PATH, 'w', encoding='utf-8') as out:
        out.write("-- Inserts generados desde item.csv\n")
        out.write("USE cim107841_IMPISI;\n\n")
        for i in range(0, len(rows), BATCH):
            batch = rows[i:i + BATCH]
            values = []
            for codigo, d_int, d_ext, esp, desc in batch:
                cod = sql_escape(codigo) or ''
                desc_sql = 'NULL' if not desc else "'" + sql_escape(desc) + "'"
                values.append(f"('{cod}', {d_int}, {d_ext}, {esp}, {desc_sql}, 1)")  # activo = 1 por defecto
            out.write("INSERT INTO catalogo_rodamientos (codigo, diametro_interior_mm, diametro_exterior_mm, espesor_mm, descripcion, activo) VALUES\n")
            out.write(",\n".join(values))
            out.write("""
ON DUPLICATE KEY UPDATE
    diametro_interior_mm = VALUES(diametro_interior_mm),
    diametro_exterior_mm = VALUES(diametro_exterior_mm),
    espesor_mm = VALUES(espesor_mm),
    descripcion = VALUES(descripcion),
    activo = VALUES(activo);

""")

    print(f"Generados {len(rows)} registros en {OUT_PATH}")


if __name__ == '__main__':
    main()
