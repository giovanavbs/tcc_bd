DELIMITER //
CREATE PROCEDURE spObterPedidosEItensCliente(
    IN cliente_id INT
)
BEGIN
    SELECT 
        p.id_pedido,
        p.data_pedido,
        p.valor_total,
        p.status_pedido,
        i.id_item_pedido,
        i.id_carro,
        i.quantidade,
        i.preco_unitario,
        c.modelo AS modelo_carro,
        c.marca AS marca_carro,
        c.ano AS ano_carro,
        c.cor AS cor_carro,
        c.status_carro
    FROM 
        pedidos p
    INNER JOIN 
        itens_pedidos i ON p.id_pedido = i.id_pedido
    INNER JOIN 
        carros c ON i.id_carro = c.id_carro
    WHERE 
        p.id_cliente = cliente_id
    ORDER BY 
        p.data_pedido DESC;
    
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE spObterDetalhesPedidoPorID(IN p_idPedido INT)
BEGIN
    SELECT 
        p.id_pedido, 
        p.data_pedido, 
        p.valor_total, 
        p.status_pedido,
        c.nome AS NomeCliente, 
        c.sobrenome AS SobrenomeCliente,
        c.email,
        c.telefone,
        ip.id_item_pedido, 
        ip.id_carro, 
        ip.quantidade, 
        ip.preco_unitario, 
        car.modelo, 
        car.marca,
        car.ano,
        car.cor,
        car.imagem,
        e.logradouro, 
        e.cep, 
        b.bairro AS BairroNome, 
        ci.cidade AS CidadeNome, 
        uf.uf AS UFNome
    FROM 
        pedidos AS p
    JOIN 
        clientes AS c ON p.id_cliente = c.id_cliente
    LEFT JOIN 
        itens_pedidos AS ip ON p.id_pedido = ip.id_pedido
    LEFT JOIN 
        carros AS car ON ip.id_carro = car.id_carro
    LEFT JOIN 
        tbEntrega AS e ON p.id_pedido = e.IdPedido
    LEFT JOIN 
        tbBairro AS b ON e.BairroID = b.BairroID
    LEFT JOIN 
        tbCidade AS ci ON e.CidadeID = ci.CidadeID
    LEFT JOIN 
        tbEstado AS uf ON e.UFID = uf.UFID
    WHERE 
        p.id_pedido = p_idPedido;
END //

DELIMITER ;

-- test drive
call spMostrarTestDrivesPorCliente(4);
DELIMITER $$
CREATE PROCEDURE spMostrarTestDrivesPorCliente(IN cliente_id INT)
BEGIN
    SELECT 
        td.id_test,
        CONCAT(c.nome, ' ', c.sobrenome) AS cliente_nome,
        c.cpf_cnpj AS cliente_cpf,
        car.modelo AS carro_modelo,
        car.marca AS carro_marca,
        car.ano AS carro_ano,
        td.data_test,
        td.status_test
    FROM 
        test_drive td
    INNER JOIN 
        clientes c ON td.id_cliente = c.id_cliente
    INNER JOIN 
        carros car ON td.id_carro = car.id_carro
    WHERE 
        td.id_cliente = cliente_id;
END $$

DELIMITER ;

create table avaliacoes (
    id_avaliacao int auto_increment primary key,
    id_cliente int not null,
    id_pedido int not null,
    avaliacao_escrita varchar(300),
    avaliacao_nota decimal(3,2) default 0.0,
    data_avaliacao datetime default current_timestamp,
    foreign key (id_cliente) references clientes(id_cliente),
    foreign key (id_pedido) references pedidos(id_pedido)
);

DELIMITER //
CREATE PROCEDURE spInserirAvaliacao(
    IN p_id_pedido INT,
    IN p_id_cliente INT,
    IN p_avaliacao_escrita VARCHAR(300),
    IN p_avaliacao_nota DECIMAL(3,2)
)
BEGIN
    INSERT INTO avaliacoes (id_cliente, id_pedido, avaliacao_escrita, avaliacao_nota, data_avaliacao)
    VALUES (p_id_cliente, p_id_pedido, p_avaliacao_escrita, p_avaliacao_nota, NOW());
END //
DELIMITER ;

use ecommerce_carros;
call spObterAvaliacaoPorPedido(129);
DELIMITER //
CREATE PROCEDURE spObterAvaliacaoPorPedido(IN p_id_pedido INT)
BEGIN
    SELECT 
        a.id_avaliacao,
        c.nome,
        c.sobrenome,
        a.avaliacao_escrita,
        a.avaliacao_nota,
        a.data_avaliacao,
        i.quantidade,
        car.marca,
        car.modelo,
        car.ano
    FROM 
        avaliacoes a
    JOIN 
        clientes c ON a.id_cliente = c.id_cliente
    JOIN 
        pedidos p ON a.id_pedido = p.id_pedido
    JOIN 
        itens_pedidos i ON p.id_pedido = i.id_pedido
    JOIN 
        carros car ON i.id_carro = car.id_carro
    WHERE 
        p.id_pedido = p_id_pedido;
END //
DELIMITER ;


use ecommerce_carros;
delete from formapagamento where id_pedido = 22;
TRUNCATE TABLE formapagamento;