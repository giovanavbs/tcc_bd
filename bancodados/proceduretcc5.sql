
create table clientes ( 
    id_cliente int auto_increment primary key,
    nome varchar(100) not null,
    sobrenome varchar(100) not null,
    email varchar(150) not null,
    senha varchar(255) not null,
    telefone decimal(11,0),
    tipo_cliente enum('pf', 'pj') default 'pf',
    cpf_cnpj decimal(19,0) not null,
    data_cadastro timestamp default current_timestamp,
    CepCli numeric(8),  
	NumEnd smallint not null, 
	CompEnd varchar(50),
    nivel_acesso TINYINT DEFAULT 1 CHECK (nivel_acesso IN (1, 2, 3)),
    status_conta ENUM('ativa', 'excluida') DEFAULT 'ativa',
    unique key (email),
    foreign key (CepCli) references tbEndereco(CEP)  
);


create table pedidos (
    id_pedido int primary key auto_increment,
    id_cliente int not null,
    data_pedido date not null,
    valor_total decimal(10,2) not null,
    status_pedido varchar(50) not null,
    foreign key (id_cliente) references clientes(id_cliente)
);

create table itens_pedidos (
    id_item_pedido int primary key auto_increment,
    id_pedido int not null,
    id_carro int,
    quantidade int not null,
    preco_unitario decimal(10,2) not null,
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_carro) references carros(id_carro)
);

/*
DELIMITER //

CREATE PROCEDURE ObterTodosPedidosEItens ()
BEGIN
    SELECT 
        p.id_pedido,
        p.data_pedido,
        p.valor_total,
        p.status_pedido,
        c.nome,
        c.sobrenome,
        c.cpf_cnpj,
        ip.id_item_pedido,
        ip.id_carro,
        ip.quantidade,
        ip.preco_unitario
    FROM 
        pedidos p
    INNER JOIN 
        clientes c ON p.id_cliente = c.id_cliente
    LEFT JOIN 
        itens_pedidos ip ON p.id_pedido = ip.id_pedido
    ORDER BY 
        p.id_pedido;
END //

DELIMITER ; */

CALL ObterTodosPedidosEItens();
-- drop procedure ObterTodosPedidosEItens;

DELIMITER //
CREATE PROCEDURE ObterTodosPedidosEItens ()
BEGIN
    SELECT 
        p.id_pedido,
        p.data_pedido,
        p.valor_total,
        p.status_pedido,
        c.nome,
        c.sobrenome,
        c.cpf_cnpj,
        ip.id_item_pedido,
        ca.marca,         
        ca.modelo,       
        ip.quantidade,
        ip.preco_unitario
    FROM 
        pedidos p
    INNER JOIN 
        clientes c ON p.id_cliente = c.id_cliente
    LEFT JOIN 
        itens_pedidos ip ON p.id_pedido = ip.id_pedido
    LEFT JOIN 
        carros ca ON ip.id_carro = ca.id_carro  
    ORDER BY 
        p.id_pedido;
END //

DELIMITER ;
