-- relatorio 1
SELECT 
    CONCAT(e.nome, ' (CPF: ', e.cpf, ')') AS Nome_CPF_Empregado,
    DATE_FORMAT(e.dataAdm, '%d/%m/%Y') AS Data_Admissao,
    FORMAT(e.salario, 2, 'pt_BR') AS Salario,
    d.nome AS Departamento,
    e.ctps AS Numero_Telefone
FROM Empregado e
INNER JOIN Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
WHERE e.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
ORDER BY e.dataAdm DESC;

-- relatorio 2
SELECT 
    CONCAT(e.nome, ' (CPF: ', e.cpf, ')') AS Nome_CPF_Empregado,
    DATE_FORMAT(e.dataAdm, '%d/%m/%Y') AS Data_Admissao,
    FORMAT(e.salario, 2, 'pt_BR') AS Salario,
    d.nome AS Departamento,
    e.ctps AS Numero_Telefone
FROM Empregado e
INNER JOIN Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
WHERE e.salario < (SELECT AVG(salario) FROM Empregado)
ORDER BY e.nome;

-- relatorio 3
SELECT 
    d.nome AS Departamento,
    COUNT(e.cpf) AS Quantidade_Empregados,
    FORMAT(AVG(e.salario), 2, 'pt_BR') AS Media_Salarial,
    FORMAT(AVG(e.comissao), 2, 'pt_BR') AS Media_Comissao
FROM Departamento d
LEFT JOIN Empregado e ON d.idDepartamento = e.Departamento_idDepartamento
GROUP BY d.nome
ORDER BY d.nome;

-- relatorio 4
SELECT 
    CONCAT(e.nome, ' (CPF: ', e.cpf, ')') AS Nome_CPF_Empregado,
    e.sexo AS Sexo,
    FORMAT(e.salario, 2, 'pt_BR') AS Salario,
    COUNT(v.idVenda) AS Quantidade_Vendas,
    FORMAT(SUM(v.valor), 2, 'pt_BR') AS Total_Valor_Vendido,
    FORMAT(SUM(v.valor * e.comissao / 100), 2, 'pt_BR') AS Total_Comissao
FROM Empregado e
LEFT JOIN Venda v ON e.cpf = v.Empregado_cpf
GROUP BY e.cpf
ORDER BY Quantidade_Vendas DESC;


-- relatorio 5
SELECT 
    e.nome AS "Nome Empregado",
    e.cpf AS "CPF Empregado",
    e.sexo AS "Sexo",
    FORMAT(e.salario, 2, 'pt_BR') AS "Salário",
    COUNT(DISTINCT iv.Venda_idVenda) AS "Quantidade Vendas com Serviço",
    FORMAT(SUM(iv.valor), 2, 'pt_BR') AS "Total Valor Vendido com Serviço",
    FORMAT(SUM(v.comissao), 2, 'pt_BR') AS "Total Comissão das Vendas com Serviço"
FROM Empregado e
LEFT JOIN itensServico iv ON e.cpf = iv.Empregado_cpf
LEFT JOIN Venda v ON iv.Venda_idVenda = v.idVenda
WHERE iv.Empregado_cpf IS NOT NULL
GROUP BY e.cpf, e.nome, e.sexo, e.salario
ORDER BY 
    COUNT(DISTINCT iv.Venda_idVenda) DESC;

-- relatorio 6
SELECT 
    c.nome AS "Nome do Cliente",
    c.cpf AS "CPF",
    CONCAT(c.numTelefone, IFNULL(CONCAT(' / ', c.numTelefone2), '')) AS "Telefone(s)",
    COUNT(DISTINCT v.idVenda) AS "Quantidade de Compras Realizadas",
    FORMAT(SUM(v.valor), 2, 'pt_BR') AS "Valor Total Gasto em Compras"
FROM Cliente c
LEFT JOIN Venda v ON c.cpf = v.Cliente_cpf
WHERE v.Cliente_cpf IS NOT NULL
GROUP BY c.cpf, c.nome, c.numTelefone, c.numTelefone2
ORDER BY 
    SUM(v.valor) DESC;

-- relatorio 7
SELECT 
    DATE_FORMAT(v.data, '%d/%m/%Y') AS Data_Venda,
    FORMAT(v.valor, 2, 'pt_BR') AS Valor,
    FORMAT(v.desconto, 2, 'pt_BR') AS Desconto,
    FORMAT(v.valor - v.desconto, 2, 'pt_BR') AS Valor_Final,
    CONCAT(e.nome, ' (CPF: ', e.cpf, ')') AS Empregado_Responsavel
FROM Venda v
INNER JOIN Cliente c ON v.Cliente_cpf = c.cpf
INNER JOIN Empregado e ON v.Empregado_cpf = e.cpf
ORDER BY v.data DESC;

-- relatorio 8
SELECT 
    s.nome AS Nome_Servico,
    COUNT(*) AS Quantidade_Vendas,
    FORMAT(SUM(s.valorVenda), 2, 'pt_BR') AS Total_Valor_Vendido
FROM Servico s
GROUP BY s.nome
ORDER BY Quantidade_Vendas DESC
LIMIT 10;

-- relatorio 9
SELECT 
    fp.tipo AS "Tipo Forma Pagamento",
    FORMAT(COUNT(v.idVenda), 0) AS "Quantidade Vendas",
    FORMAT(SUM(v.valor), 2, 'pt_BR') AS "Total Valor Vendido"
FROM 
    FormaPgVenda fp
INNER JOIN 
    Venda v ON fp.Venda_idVenda = v.idVenda
GROUP BY 
    fp.tipo
ORDER BY 
    COUNT(v.idVenda) DESC;

-- relatorio 10
SELECT 
    DATE_FORMAT(v.data, '%d/%m/%Y') AS Data_Venda,
    COUNT(v.idVenda) AS Quantidade_Vendas,
    FORMAT(SUM(v.valor), 2, 'pt_BR') AS Valor_Total_Venda
FROM Venda v
GROUP BY v.data
ORDER BY v.data DESC;

-- relatorio 11
SELECT 
    pr.nome AS "Nome Produto",
    FORMAT(pr.valorVenda, 2, 'pt_BR') AS "Valor Produto",
    'Produto' AS "Categoria do Produto", -- Categoria do produto não foi definida, então substituí por 'Produto'
    f.nome AS "Nome Fornecedor",
    f.email AS "Email Fornecedor",
    t.numero AS "Telefone Fornecedor"
FROM 
    Produtos pr
INNER JOIN 
    ItensCompra ic ON pr.idProduto = ic.Produtos_idProduto
INNER JOIN 
    Compras c ON ic.Compras_idCompra = c.idCompra
INNER JOIN 
    Fornecedor f ON c.Fornecedor_cpf_cnpj = f.cpf_cnpj
LEFT JOIN 
    Telefone t ON t.Fornecedor_cpf_cnpj = f.cpf_cnpj
ORDER BY 
    pr.nome;


-- relatorio 12
SELECT 
    p.nome AS "Nome Produto",
    SUM(ivp.quantidade) AS "Quantidade (Total) Vendas",
    FORMAT(SUM(ivp.valor), 2, 'pt_BR') AS "Valor Total Recebido pela Venda do Produto"
FROM 
    Produtos p
INNER JOIN 
    ItensVendaProd ivp ON p.idProduto = ivp.Produto_idProduto
INNER JOIN 
    Venda v ON ivp.Venda_idVenda = v.idVenda
GROUP BY 
    p.idProduto, p.nome
ORDER BY 
    "Quantidade (Total) Vendas" DESC;
