# tcc_bd

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
    data_cadastro timestamp default current_timestamp,
    CepCli numeric(8),  
	NumEnd smallint not null, 
	CompEnd varchar(50),
    unique key (email),
    foreign key (CepCli) references tbEndereco(CEP)  
);

create table categorias (
    id_categoria int primary key,
    descricao varchar(50) not null
);

insert into categorias (id_categoria, descricao) values 
(1, 'Híbridos'),
(2, 'Elétricos');

create table carros (
    id_carro int primary key,
    modelo varchar(50) not null,
    marca varchar(50) not null,
    ano int not null,
    preco decimal(10,2) not null,
    id_categoria int not null,
    carregador varchar(50) not null,
    descricao varchar(300) not null,
    imagem varchar(200) null,
    cor varchar(20) not null,
    foreign key (id_categoria) references categorias(id_categoria)
);

INSERT INTO carros (id_carro, modelo, marca, ano, preco, id_categoria, carregador, descricao, imagem, cor) VALUES
(1, 'Prius', 'Toyota', 2022, 80000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/prius.jpg', 'preto'),
(2, 'Civic Hybrid', 'Honda', 2021, 70000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/civic_hybrid.jpg', 'prata'),
(3, 'Corolla Hybrid', 'Toyota', 2020, 65000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/corolla_hybrid.jpg', 'branco'),
(4, 'Insight Hybrid', 'Honda', 2019, 60000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/insight_hybrid.jpg', 'azul'),
(5, 'Auris Hybrid', 'Toyota', 2018, 55000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/auris_hybrid.jpg', 'prata'),
(6, 'Leaf', 'Nissan', 2022, 90000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/leaf.jpg', 'vermelho'),
(7, 'e-Golf', 'Volkswagen', 2021, 85000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/e_golf.jpg', 'preto'),
(8, 'Model 3', 'Tesla', 2019, 100000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/model3.jpg', 'branco'),
(9, 'i3', 'BMW', 2018, 80000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro..', 'imagens/i3.jpg', 'azul'); 


create table pedidos (
    id_pedido int primary key,
    id_cliente int not null,
    data_pedido date not null,
    valor_total decimal(10,2) not null,
    status_pedido varchar(50) not null,
    foreign key (id_cliente) references clientes(id_cliente)
);

create table itens_pedidos (
    id_item_pedido int primary key,
    id_pedido int not null,
    id_carro int,
    quantidade int not null,
    preco_unitario decimal(10,2) not null,
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_carro) references carros(id_carro)
);

create table test_drive (
    cod int auto_increment primary key,
    id_cliente int,
    id_carro int,
    data_test datetime not null,
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
    forma_pagamento enum('boleto', 'pix', 'debito_online') not null, 
    id_cartao int,
    valor_pago decimal(10,2) not null,
    primary key(id_pedido),
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_cartao) references cartoes(id_cartao)
);

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

-- fim das tabelas

-- procedures - endereco
delimiter &&
create procedure spinsertBairro(vBairro varchar (200))
begin

IF NOT EXISTS  (select Bairro from tbBairro WHERE Bairro = vBairro) then
    insert into tbBairro(BairroID, Bairro)
        values(default,vBairro);
        end if;
end &&

call spinsertBairro('Aclimação'); 
call spinsertBairro('Capão Redondo');
call spinsertBairro('Pirituba');
call spinsertBairro('Liberdade');

delimiter &&
create procedure spinsertEstado(vUF char (2))
begin

IF NOT EXISTS  (select UF from tbEstado where UF = vUF) then
    insert into tbEstado(UFID, UF)
        values(default,vUF);
        end if;
end &&

call spinsertEstado('SP'); 
call spinsertEstado('RJ');
call spinsertEstado('RS');

delimiter &&
create procedure spinsertCidade(vCidade varchar (200))
begin
	
    IF NOT EXISTS  (select Cidade from tbCidade where Cidade = vCidade) then
    insert into tbCidade(CidadeID, Cidade)
        values(default,vCidade);
        end if;
end &&

call spinsertCidade('Rio de Janeiro'); 
call spinsertCidade('São Carlos');
call spinsertCidade('Campinas');
call spinsertCidade('Franco da Rocha');
call spinsertCidade('Osasco');
call spinsertCidade('Pirituba');     
call spinsertCidade('Lapa');
call spinsertCidade('Ponta Grossa');  

select * from tbCidade;
select * from tbEstado;
select * from tbBairro;

delimiter && 
create procedure spinsertendereco(vCEP numeric(8), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2)) 
begin

IF NOT EXISTS  (select UF from tbEstado where UF = vUF) then
insert into tbEstado(UFID, UF)
values(default, vUF);
end if;
	IF NOT EXISTS (select Cidade from tbCidade where Cidade = vCidade) then
	insert into tbCidade(CidadeID, Cidade)
	values(default, vCidade);
	end if;
		IF NOT EXISTS (select Bairro from tbBairro where Bairro = vBairro) then
		insert into tbBairro(BairroID, Bairro)
		values(default, vBairro);
		end if;

	IF NOT EXISTS  (select CEP from tbEndereco where CEP = vCEP) then
		insert into tbEndereco(CEP, Logradouro, BairroID, CidadeID, UFID)
    values (vCEP, vLogradouro, (select BairroID from tbBairro where Bairro = vBairro), (select CidadeID from tbCidade where Cidade = vCidade), (select UFID from tbEstado where UF = vUF));
	end if;
end &&

call spinsertendereco(12345050, 'rua da federal', 'Lapa', 'São Paulo', 'SP'); 
call spinsertendereco(12345051, 'Av Brasil', 'Lapa', 'Campinas', 'SP'); 
call spinsertendereco(12345052, 'rua liberdade', 'Consolação', 'São Paulo', 'SP'); 
call spinsertendereco(12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ'); 
call spinsertendereco(12345054, 'rua ximbú', 'Penha', 'Rio de Janeiro', 'RJ'); 
call spinsertendereco(12345055, 'rua piu XI', 'Penha', 'Campinas', 'SP');
call spinsertendereco(12345056, 'rua chocolate', 'Aclimação', 'Barra Mansa', 'RJ');
call spinsertendereco(12345057, 'rua pão na chapa', 'Barra Funda', 'Ponta Grossa', 'RS');

select * from tbEndereco;


-- procedure inserir cliente
drop procedure spInsertCliente;

delimiter &&
create procedure spinsertCliente(
    vNome varchar(100),
    vSobrenome varchar(100),
    vEmail varchar(150),
    vSenha varchar(255),
    vTelefone decimal(11,0),
    vTipoCliente enum('pf', 'pj'),
    vCepCli numeric(8),
    vNumEnd smallint,
    vCompEnd varchar(50),
    vLogradouro varchar(200),
    vBairro varchar(200),
    vCidade varchar(200),
    vUF char(2)
) 
begin
    -- existe estado
    IF NOT EXISTS (select UF from tbEstado where UF = vUF) then
        insert into tbEstado(UFID, UF) values (default, vUF);
    end if;
    
    -- existe cidade
    IF NOT EXISTS (select Cidade from tbCidade where Cidade = vCidade) then
        insert into tbCidade(CidadeID, Cidade) values (default, vCidade);
    end if;
    
    -- existe bairro
    IF NOT EXISTS (select Bairro from tbBairro where Bairro = vBairro) then
        insert into tbBairro(BairroID, Bairro) values (default, vBairro);
    end if;
    
    -- existe endereço
    IF NOT EXISTS (select CEP from tbEndereco where CEP = vCepCli) then
        insert into tbEndereco (CEP, Logradouro, BairroID, CidadeID, UFID)
        values (
            vCepCli, 
            vLogradouro, 
            (select BairroID from tbBairro where Bairro = vBairro),
            (select CidadeID from tbCidade where Cidade = vCidade),
            (select UFID from tbEstado where UF = vUF)
        );
    end if;
    
    -- inserir cliente
    IF NOT EXISTS (select email from clientes where email = vEmail) then
        insert into clientes (
            nome, 
            sobrenome, 
            email, 
            senha, 
            telefone, 
            tipo_cliente, 
            CepCli, 
            NumEnd, 
            CompEnd
        ) values (
            vNome, 
            vSobrenome, 
            vEmail, 
            vSenha, 
            vTelefone, 
            vTipoCliente, 
            vCepCli, 
            vNumEnd, 
            vCompEnd
        );
    end if;
    
    -- login do cliente
    INSERT IGNORE INTO login (id_cliente, email, senha)
    VALUES (
        (select id_cliente from clientes where email = vEmail),
        vEmail,
        vSenha
    );
end &&

-- teste inserção cliente
call spinsertCliente(
    'geralt', 
    'rivia', 
    'geraltofrivia@gmail.com', 
    'jaskier', 
    999888777, 
    'pf', 
    98756723, 
    234, 
    'kaer morhen',
    'montanha da neve', 
    'centro', 
    'polonia', 
    'PL'
);

call spinsertCliente(
    'peter', 
    'parker', 
    'peterparker@gmail.com', 
    'spiderman', 
    998877665, 
    'pf', 
    63290518, 
    678, 
    'Apto 89',
    'rua do queens', 
    'Queens', 
    'Nova York', 
    'NY'
);

-- olhar
select * from tbEstado;
select * from tbCidade;
select * from tbBairro;
select * from tbEndereco;
select * from clientes;
select * from login;

DELIMITER $$

CREATE PROCEDURE ExibirCarros()
BEGIN
    SELECT c.id_carro, c.modelo, c.marca, c.ano, c.preco, cat.descricao AS categoria
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria;
END $$
call ExibirCarros();

DELIMITER $$

CREATE PROCEDURE ExibirDetalhesCarro(IN p_id_carro INT)
BEGIN
    SELECT c.id_carro, c.modelo, c.marca, c.ano, c.preco, cat.descricao AS categoria, c.descricao, c.imagem, c.cor
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria
    WHERE c.id_carro = p_id_carro;
END $$

call ExibirDetalhesCarro(1);

select * from carros;
select * from clientes;
select * from login;
call spUpdateCliente(
	1,
	'peter', 
    'palker', 
    'peterpalker@gmail.com', 
    'spiderman', 
    998877665, 
    'pf', 
    63290518, 
    678, 
    'Apto 89',
    'rua do queens', 
    'Queens2', 
    'Nova York2', 
    'N2'
);

delimiter &&
create procedure spUpdateCliente(
    vIdCliente int,
    vNome varchar(100),
    vSobrenome varchar(100),
    vEmail varchar(150),
    vSenha varchar(255),
    vTelefone decimal(11,0),
    vTipoCliente enum('pf', 'pj'),
    vCepCli numeric(8),
    vNumEnd smallint,
    vCompEnd varchar(50),
    vLogradouro varchar(200),
    vBairro varchar(200),
    vCidade varchar(200),
    vUF char(2)
) 
begin

    IF NOT EXISTS (select UF from tbEstado where UF = vUF) then
        insert into tbEstado(UFID, UF) values (default, vUF);
    end if;
    
    IF NOT EXISTS (select Cidade from tbCidade where Cidade = vCidade) then
        insert into tbCidade(CidadeID, Cidade) values (default, vCidade);
    end if;
    
    IF NOT EXISTS (select Bairro from tbBairro where Bairro = vBairro) then
        insert into tbBairro(BairroID, Bairro) values (default, vBairro);
    end if;

    IF NOT EXISTS (select CEP from tbEndereco where CEP = vCepCli) then
        insert into tbEndereco (CEP, Logradouro, BairroID, CidadeID, UFID)
        values (
            vCepCli, 
            vLogradouro, 
            (select BairroID from tbBairro where Bairro = vBairro),
            (select CidadeID from tbCidade where Cidade = vCidade),
            (select UFID from tbEstado where UF = vUF)
        );
    else
        update tbEndereco
        set Logradouro = vLogradouro,
            BairroID = (select BairroID from tbBairro where Bairro = vBairro),
            CidadeID = (select CidadeID from tbCidade where Cidade = vCidade),
            UFID = (select UFID from tbEstado where UF = vUF)
        where CEP = vCepCli;
    end if;

    update clientes
    set nome = vNome,
        sobrenome = vSobrenome,
        email = vEmail,
        senha = vSenha,
        telefone = vTelefone,
        tipo_cliente = vTipoCliente,
        CepCli = vCepCli,
        NumEnd = vNumEnd,
        CompEnd = vCompEnd
    where id_cliente = vIdCliente;

    update login
    set email = vEmail,
        senha = vSenha
    where id_cliente = vIdCliente;
end &&

call spObterClienteID(1);
delimiter &&
create procedure spObterClienteID(
    vIdCliente int
)
begin
    select 
        clientes.id_cliente as Codigo,
        clientes.nome,
        clientes.sobrenome,
        clientes.email,
        clientes.telefone,
        clientes.tipo_cliente,
        clientes.data_cadastro,
        tbEndereco.CEP as CepCli,
        clientes.NumEnd,
        clientes.CompEnd,
        tbEndereco.Logradouro,
        tbBairro.Bairro,
        tbCidade.Cidade,
        tbEstado.UF
    from clientes
    inner join tbEndereco on clientes.CepCli = tbEndereco.CEP
    inner join tbBairro on tbEndereco.BairroID = tbBairro.BairroID
    inner join tbCidade on tbEndereco.CidadeID = tbCidade.CidadeID
    inner join tbEstado on tbEndereco.UFID = tbEstado.UFID
    where clientes.id_cliente = vIdCliente;
end &&

call spExcluirCliente(3);
delimiter &&
create procedure spExcluirCliente(
    vIdCliente int
)
begin
    -- tblogin tem fk e pk em cliente entao excluir primeiro
    delete from login 
    where id_cliente = vIdCliente;

    delete from clientes 
    where id_cliente = vIdCliente;
end &&
