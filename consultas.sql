-- Consultas SQL baseadas no diagrama ERD
-- Sistema de Vendas e Produção

-- 1. Listar todos Clientes que não tenham realizado uma compra
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 2. Listar os Produtos que não tenham sido comprados
SELECT 
    p.product_id,
    p.product_name,
    p.model_year,
    p.list_price,
    b.brand_name,
    cat.category_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE oi.product_id IS NULL;

-- 3. Listar os Produtos sem Estoque
SELECT 
    p.product_id,
    p.product_name,
    p.model_year,
    p.list_price,
    b.brand_name,
    cat.category_name
FROM products p
LEFT JOIN stocks s ON p.product_id = s.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE s.product_id IS NULL OR s.quantity = 0;

-- 4. Agrupar a quantidade de vendas que uma determinada Marca por Loja
SELECT 
    b.brand_name,
    st.store_name,
    st.city,
    st.state,
    SUM(oi.quantity) as total_vendas,
    COUNT(DISTINCT o.order_id) as total_pedidos,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as valor_total_vendas
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN stores st ON o.store_id = st.store_id
GROUP BY b.brand_id, b.brand_name, st.store_id, st.store_name, st.city, st.state
ORDER BY b.brand_name, st.store_name;

-- 5. Listar os Funcionários que não estejam relacionados a um Pedido
SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    s.active,
    st.store_name,
    s.manager_id
FROM staffs s
LEFT JOIN orders o ON s.staff_id = o.staff_id
LEFT JOIN stores st ON s.store_id = st.store_id
WHERE o.staff_id IS NULL;
