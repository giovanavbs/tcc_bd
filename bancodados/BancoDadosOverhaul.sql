-- drop database ecommerce_carros;
create database ecommerce_carros;
use ecommerce_carros;

create table tbEstado (
    UFID int primary key auto_increment,
    UF char(2) not null
);

create table tbCidade (
    CidadeID int primary key auto_increment,
    Cidade varchar(200) not null
);

create table tbBairro (
    BairroID int primary key auto_increment,
    Bairro varchar(200) not null
);

create table tbEndereco (
    logradouro varchar(200) not null,
    CEP numeric(8) primary key,
    BairroID int not null,
    CidadeID int not null,
    UFID int not null,
    foreign key (BairroID) references tbBairro(BairroID),
    foreign key (CidadeID) references tbCidade(CidadeID),
    foreign key (UFID) references tbEstado(UFID)
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


UPDATE clientes 
SET nome = 'peter',
    sobrenome = 'parker',
    email = 'peterparker@hotmail.com',
    senha = 'spiderman',
    telefone = '987456754',
    tipo_cliente = 'PF',
    cpf_cnpj = 87654398756
WHERE id_cliente = 2;
select * from clientes;

create table categorias (
    id_categoria int primary key,
    descricao varchar(50) not null
);

insert into categorias (id_categoria, descricao) values 
(1, 'Híbridos'),
(2, 'Elétricos');

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

-- carros pra inserir e testar o sistema // vou adicionar mais 3 atributos pra outras imagens no futuro
INSERT INTO carros (id_carro, modelo, marca, ano, preco, id_categoria, carregador, descricao, imagem, cor) VALUES
(1, 'Prius', 'Toyota', 2022, 80000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro1.png', 'preto'),
(2, 'Civic Hybrid', 'Honda', 2021, 70000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro2.png', 'prata'),
(3, 'Corolla Hybrid', 'Toyota', 2020, 65000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro2.png', 'branco'),
(4, 'Insight Hybrid', 'Honda', 2019, 60000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro3.png', 'azul'),
(5, 'Auris Hybrid', 'Toyota', 2018, 55000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro4.png', 'prata'),
(6, 'Leaf', 'Nissan', 2022, 90000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro5.png', 'vermelho'),
(7, 'e-Golf', 'Volkswagen', 2021, 85000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro6.png', 'preto'),
(8, 'Model 3', 'Tesla', 2019, 100000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'carro7.png', 'branco'),
(9, 'i3', 'BMW', 2018, 80000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro..', 'carro8.png', 'azul'); 

select * from carros;
update carros set imagem = 'carro10.png' where id_carro = 3;

create table CarrinhoCompra (
	id_cliente int not null,
    id_carro int,
    modelo varchar(50) not null,
    marca varchar(50) not null,
    ano int not null,
    preco decimal(10,2) not null,
    id_categoria int not null,
    carregador varchar(50) not null,
    descricao varchar(300) not null,
    imagem varchar(200) null,
    cor varchar(20) not null,
	QuantidadeProd int,
    primary key(id_cliente, id_carro),
	foreign key (id_cliente) references clientes(id_cliente),
    foreign key (id_categoria) references categorias(id_categoria)
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

select * from carros;
delete from carros where id_carro = 13;

create table test_drive (
    id_test int auto_increment primary key,
    id_cliente int,
    id_carro int,
    data_test datetime not null,
    status_test ENUM('concluido', 'cancelado', 'em andamento') DEFAULT 'em andamento',
    foreign key (id_cliente) references clientes(id_cliente),
    foreign key (id_carro) references carros(id_carro)
); 

create table cartoes (
    id_cartao int auto_increment primary key,
    id_cliente int not null,
    numero_cartao varchar(19) not null,
    nome_titular varchar(100) not null,
    validade varchar(5) not null,
    cvv varchar(4) not null,
    bandeira varchar(20),
    foreign key (id_cliente) references clientes(id_cliente)
);

-- -- formato pix=1234567 no atributo forma_pagamento (para evitar repetições criando um atributo cod_pix, pois ja tem repetição no id_cartao q nao pode ser eliminado)
create table FormaPagamento (
    id_pedido int not null,
    forma_pagamento varchar(200) not null, 
    id_cartao int,
    valor_pago decimal(10,2) not null,
    primary key(id_pedido),
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_cartao) references cartoes(id_cartao)
);

-- describe FormaPagamento;
ALTER TABLE FormaPagamento MODIFY forma_pagamento varchar(200);
-- IMPORTANTE!! alterar o varchar pra 100 pq coloquei pra gerar codigo pix direitinho e só 50 nao cabe

create table NotaFiscal (
    id_nota_fiscal int auto_increment primary key,
    id_pagamento int not null,
    numero_nota varchar(50) not null,
    data_emissao date not null,
    valor_total decimal(10,2) not null,
    foreign key (id_pagamento) references FormaPagamento(id_pedido)
);

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

create table login (
    id_cliente int not null,
    email varchar(150) not null,
    senha varchar(255) not null,
    primary key (id_cliente),
    foreign key (id_cliente) references clientes(id_cliente)
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

select * from tbEntrega;
-- fim das tabelas