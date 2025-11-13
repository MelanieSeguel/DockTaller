-- Crear tabla de items (idempotente)
CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Inserta productos de forma idempotente (no duplican filas si ya existen)
INSERT INTO items (name, price)
SELECT 'Coca Cola 3L', 2600
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Coca Cola 3L');

INSERT INTO items (name, price)
SELECT 'Pack Cerveza Cristal', 6500
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Pack Cerveza Cristal');

INSERT INTO items (name, price)
SELECT 'Pisco Alto del Carmen', 8500
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Pisco Alto del Carmen');

INSERT INTO items (name, price)
SELECT 'Papas Fritas Lays Grande 250g', 3000
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Papas Fritas Lays Grande 250g');

INSERT INTO items (name, price)
SELECT 'Ramitas Evercrisp Original 270g', 2200
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Ramitas Evercrisp Original 270g');

INSERT INTO items (name, price)
SELECT 'Leche Colún Entera 1L', 1300
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Leche Colún Entera 1L');

INSERT INTO items (name, price)
SELECT 'Pan Hallulla Jumbo 1Kg', 2000
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Pan Hallulla Jumbo 1Kg');

INSERT INTO items (name, price)
SELECT 'Chocolate Trencito 150g', 1900
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Chocolate Trencito 150g');

INSERT INTO items (name, price)
SELECT 'Café Nescafé Tradición 170g', 5000
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Café Nescafé Tradición 170g');