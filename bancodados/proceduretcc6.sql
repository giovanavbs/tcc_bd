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

create table carros (
    id_carro int primary key auto_increment,
    modelo varchar(50) not null,
    marca varchar(50) not null,
    ano int not null,
    preco decimal(10,2) not null,
    id_categoria int not null,
    carregador varchar(50) not null,
    descricao varchar(300) not null,
    imagem varchar(200) null,
    cor varchar(20) not null,
    status_carro ENUM('sob demanda', 'excluido') DEFAULT 'sob demanda',
    foreign key (id_categoria) references categorias(id_categoria)
);


call spObterPedidosEItensCliente(4);

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

CREATE TABLE tbEntrega (
	id_cliente int not null,
    IdPedido INT PRIMARY KEY,
    Logradouro VARCHAR(200) NOT NULL,
    CEP NUMERIC(8) NOT NULL,
    BairroID INT NOT NULL,
    CidadeID INT NOT NULL,
    UFID INT NOT NULL, 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (IdPedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (BairroID) REFERENCES tbBairro(BairroID),
    FOREIGN KEY (CidadeID) REFERENCES tbCidade(CidadeID),
    FOREIGN KEY (UFID) REFERENCES tbEstado(UFID)
);

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

drop procedure spObterDetalhesPedidoPorID;
call spObterDetalhesPedidoPorID(1);
select * from tbEntrega;
select * from itens_pedidos;
select * from formapagamento;


drop procedure spObterDetalhesPedidoPorID;
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

