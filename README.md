-- tabelas
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

create table FormaPagamento (
    id_pedido int not null,
    forma_pagamento varchar(200) not null, 
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

-- fim das tabelas

-- começo das procedures
-- procedures do cliente 
DELIMITER &&
CREATE PROCEDURE spinsertCliente(
    vNome VARCHAR(100),
    vSobrenome VARCHAR(100),
    vEmail VARCHAR(150),
    vSenha VARCHAR(255),
    vTelefone DECIMAL(11, 0),
    vTipoCliente ENUM('pf', 'pj'),
    vCpfCnpj DECIMAL(19,0),
    vCepCli NUMERIC(8),
    vNumEnd SMALLINT,
    vCompEnd VARCHAR(50),
    vLogradouro VARCHAR(200),
    vBairro VARCHAR(200),
    vCidade VARCHAR(200),
    vUF CHAR(2)
) 
BEGIN
    DECLARE vNivelAcesso TINYINT DEFAULT 1; 
    DECLARE vStatusConta ENUM('ativa', 'excluida') DEFAULT 'ativa'; 

    
    IF NOT EXISTS (SELECT UF FROM tbEstado WHERE UF = vUF) THEN
        INSERT INTO tbEstado(UFID, UF) VALUES (DEFAULT, vUF);
    END IF;
    
   
    IF NOT EXISTS (SELECT Cidade FROM tbCidade WHERE Cidade = vCidade) THEN
        INSERT INTO tbCidade(CidadeID, Cidade) VALUES (DEFAULT, vCidade);
    END IF;
    
    
    IF NOT EXISTS (SELECT Bairro FROM tbBairro WHERE Bairro = vBairro) THEN
        INSERT INTO tbBairro(BairroID, Bairro) VALUES (DEFAULT, vBairro);
    END IF;
    
    
    IF NOT EXISTS (SELECT CEP FROM tbEndereco WHERE CEP = vCepCli) THEN
        INSERT INTO tbEndereco (CEP, Logradouro, BairroID, CidadeID, UFID)
        VALUES (
            vCepCli, 
            vLogradouro, 
            (SELECT BairroID FROM tbBairro WHERE Bairro = vBairro),
            (SELECT CidadeID FROM tbCidade WHERE Cidade = vCidade),
            (SELECT UFID FROM tbEstado WHERE UF = vUF)
        );
    END IF;
    
   
    IF NOT EXISTS (SELECT email FROM clientes WHERE email = vEmail) THEN
        INSERT INTO clientes (
            nome, 
            sobrenome, 
            email, 
            senha, 
            telefone, 
            tipo_cliente, 
            cpf_cnpj,  
            CepCli, 
            NumEnd, 
            CompEnd,
            nivel_acesso,  
            status_conta  
        ) VALUES (
            vNome, 
            vSobrenome, 
            vEmail, 
            vSenha, 
            vTelefone, 
            vTipoCliente, 
            vCpfCnpj,  
            vCepCli, 
            vNumEnd, 
            vCompEnd,
            vNivelAcesso,  
            vStatusConta  
        );
    END IF;
    
 
    INSERT IGNORE INTO login (id_cliente, email, senha)
    VALUES (
        (SELECT id_cliente FROM clientes WHERE email = vEmail),
        vEmail,
        vSenha
    );
END &&
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spUpdateCliente(
    vIdCliente INT,
    vNome VARCHAR(100),
    vSobrenome VARCHAR(100),
    vEmail VARCHAR(150),
    vSenha VARCHAR(255),
    vTelefone DECIMAL(11,0),
    vTipoCliente ENUM('pf', 'pj'),
    vCepCli NUMERIC(8),
    vNumEnd SMALLINT,
    vCompEnd VARCHAR(50),
    vLogradouro VARCHAR(200),
    vBairro VARCHAR(200),
    vCidade VARCHAR(200),
    vUF CHAR(2),
    vCpfCnpj DECIMAL(19,0)  
) 
BEGIN
    DECLARE vNivelAcesso TINYINT DEFAULT 1;  
    DECLARE vStatusConta ENUM('ativa', 'excluida') DEFAULT 'ativa';  

    IF NOT EXISTS (SELECT UF FROM tbEstado WHERE UF = vUF) THEN
        INSERT INTO tbEstado(UFID, UF) VALUES (DEFAULT, vUF);
    END IF;
    
    IF NOT EXISTS (SELECT Cidade FROM tbCidade WHERE Cidade = vCidade) THEN
        INSERT INTO tbCidade(CidadeID, Cidade) VALUES (DEFAULT, vCidade);
    END IF;
    
    IF NOT EXISTS (SELECT Bairro FROM tbBairro WHERE Bairro = vBairro) THEN
        INSERT INTO tbBairro(BairroID, Bairro) VALUES (DEFAULT, vBairro);
    END IF;

    IF NOT EXISTS (SELECT CEP FROM tbEndereco WHERE CEP = vCepCli) THEN
        INSERT INTO tbEndereco (CEP, Logradouro, BairroID, CidadeID, UFID)
        VALUES (
            vCepCli, 
            vLogradouro, 
            (SELECT BairroID FROM tbBairro WHERE Bairro = vBairro),
            (SELECT CidadeID FROM tbCidade WHERE Cidade = vCidade),
            (SELECT UFID FROM tbEstado WHERE UF = vUF)
        );
    ELSE
        UPDATE tbEndereco
        SET Logradouro = vLogradouro,
            BairroID = (SELECT BairroID FROM tbBairro WHERE Bairro = vBairro),
            CidadeID = (SELECT CidadeID FROM tbCidade WHERE Cidade = vCidade),
            UFID = (SELECT UFID FROM tbEstado WHERE UF = vUF)
        WHERE CEP = vCepCli;
    END IF;

    UPDATE clientes
    SET nome = vNome,
        sobrenome = vSobrenome,
        email = vEmail,
        senha = vSenha,
        telefone = vTelefone,
        tipo_cliente = vTipoCliente,
        CepCli = vCepCli,
        NumEnd = vNumEnd,
        CompEnd = vCompEnd,
        cpf_cnpj = vCpfCnpj,  
        nivel_acesso = vNivelAcesso,
        status_conta = vStatusConta  
    WHERE id_cliente = vIdCliente;

    UPDATE login
    SET email = vEmail,
        senha = vSenha
    WHERE id_cliente = vIdCliente;
END &&
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spObterClienteID(
    vIdCliente INT
)
BEGIN
    SELECT 
        clientes.id_cliente AS Codigo,
        clientes.nome,
        clientes.sobrenome,
        clientes.email,
        clientes.telefone,
        clientes.tipo_cliente,
        clientes.cpf_cnpj,  
        clientes.data_cadastro,
        tbEndereco.CEP AS CepCli,
        clientes.NumEnd,
        clientes.CompEnd,
        tbEndereco.Logradouro,
        tbBairro.Bairro,
        tbCidade.Cidade,
        tbEstado.UF,
        clientes.nivel_acesso 
    FROM clientes
    INNER JOIN tbEndereco ON clientes.CepCli = tbEndereco.CEP
    INNER JOIN tbBairro ON tbEndereco.BairroID = tbBairro.BairroID
    INNER JOIN tbCidade ON tbEndereco.CidadeID = tbCidade.CidadeID
    INNER JOIN tbEstado ON tbEndereco.UFID = tbEstado.UFID
    WHERE clientes.id_cliente = vIdCliente;
END &&
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spExcluirCliente(
    vIdCliente INT
)
BEGIN

    DELETE FROM login 
    WHERE id_cliente = vIdCliente;

    DELETE FROM cartoes 
    WHERE id_cliente = vIdCliente;


    UPDATE clientes 
    SET status_conta = 'excluida'
    WHERE id_cliente = vIdCliente;
END && 
DELIMITER ;

-- procedures de pedido

DELIMITER &&
CREATE PROCEDURE RegistrarPedido(IN p_id_cliente INT)
BEGIN
    DECLARE v_valor_total DECIMAL(10,2);
    DECLARE v_id_pedido INT;
    
    -- valor total dos carros no carrinho
    SELECT SUM(preco * QuantidadeProd)
    INTO v_valor_total
    FROM CarrinhoCompra
    WHERE id_cliente = p_id_cliente;
    
    -- verifica se tem carros no carrinho
    IF v_valor_total IS NOT NULL THEN
        -- insere na tabela pedidos
        INSERT INTO pedidos (id_cliente, valor_total, data_pedido, status_pedido)
        VALUES (p_id_cliente, v_valor_total, NOW(), 'aguardando pagamento');
        
        -- id do ultimo pedido inserido
        SET v_id_pedido = LAST_INSERT_ID();
        
        -- insere na tabela itens pedido
        INSERT INTO itens_pedidos (id_pedido, id_carro, quantidade, preco_unitario)
        SELECT v_id_pedido, id_carro, QuantidadeProd, preco
        FROM CarrinhoCompra
        WHERE id_cliente = p_id_cliente;

        -- limpa o carrinho
        DELETE FROM CarrinhoCompra
        WHERE id_cliente = p_id_cliente;
    END IF;
END &&
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spObterPedidoRecentePorID(IN p_id_cliente INT)
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_valor_total DECIMAL(10,2);

    SELECT id_pedido, valor_total 
    INTO v_id_pedido, v_valor_total
    FROM pedidos 
    WHERE id_cliente = p_id_cliente
    ORDER BY id_pedido DESC -- ordem decrescente pra pegar o maior id_pedido(mmais recente pedido e exibir)
    LIMIT 1; 

    -- se exisitr o pedido pra nao dar erro
    IF v_id_pedido IS NOT NULL THEN
        SELECT ip.*, v_valor_total AS ValorTotal
        FROM itens_pedidos ip
        INNER JOIN pedidos p ON ip.id_pedido = p.id_pedido
        WHERE ip.id_pedido = v_id_pedido;
    ELSE
        SELECT NULL; -- só de precaução
    END IF;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spObterItensPedidoPorID(IN p_id_cliente INT)
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_valor_total DECIMAL(10,2);
    DECLARE v_status_pedido VARCHAR(50);

    -- pegar o id_pedido, valor_total e status_pedido do pedido mais recente
    SELECT id_pedido, valor_total, status_pedido 
    INTO v_id_pedido, v_valor_total, v_status_pedido
    FROM pedidos 
    WHERE id_cliente = p_id_cliente
    ORDER BY id_pedido DESC -- ordem decrescente para pegar o pedido mais recente
    LIMIT 1; 

    -- se existir o pedido retorna os itens e detalhes do carro
    IF v_id_pedido IS NOT NULL THEN
        SELECT p.id_pedido, p.id_cliente, p.data_pedido, v_valor_total AS ValorTotal, v_status_pedido AS StatusPedido,
               ip.id_item_pedido, ip.id_carro, ip.quantidade, ip.preco_unitario,
               c.modelo, c.marca, c.ano, c.preco AS preco_carro, c.imagem, c.cor
        FROM pedidos p
        INNER JOIN itens_pedidos ip ON p.id_pedido = ip.id_pedido
        INNER JOIN carros c ON ip.id_carro = c.id_carro
        WHERE p.id_pedido = v_id_pedido;
    ELSE
        SELECT NULL; -- null se nao tiver pedido
    END IF;

END //
delimiter ;

-- procedures do cartao
DELIMITER &&
CREATE PROCEDURE spInsertCartao(
    IN p_id_cliente INT,
    IN p_numero_cartao VARCHAR(19),
    IN p_nome_titular VARCHAR(100),
    IN p_validade VARCHAR(5),
    IN p_cvv VARCHAR(4),
    IN p_bandeira VARCHAR(20)
)
BEGIN
    -- verifica se o cartão ja existe para o cliente especifico
    IF NOT EXISTS (
        SELECT 1 FROM cartoes 
        WHERE id_cliente = p_id_cliente AND numero_cartao = p_numero_cartao
    ) THEN
        -- insere o cartao na tabela
        INSERT INTO cartoes (
            id_cliente, 
            numero_cartao, 
            nome_titular, 
            validade, 
            cvv, 
            bandeira
        )
        VALUES (
            p_id_cliente, 
            p_numero_cartao, 
            p_nome_titular, 
            p_validade, 
            p_cvv, 
            p_bandeira
        );
    END IF;
END &&
DELIMITER ;

-- procedures endereco
delimiter &&
create procedure spinsertBairro(vBairro varchar (200))
begin

IF NOT EXISTS  (select Bairro from tbBairro WHERE Bairro = vBairro) then
    insert into tbBairro(BairroID, Bairro)
        values(default,vBairro);
        end if;
end &&

delimiter &&
create procedure spinsertEstado(vUF char (2))
begin

IF NOT EXISTS  (select UF from tbEstado where UF = vUF) then
    insert into tbEstado(UFID, UF)
        values(default,vUF);
        end if;
end &&

delimiter &&
create procedure spinsertCidade(vCidade varchar (200))
begin
	
    IF NOT EXISTS  (select Cidade from tbCidade where Cidade = vCidade) then
    insert into tbCidade(CidadeID, Cidade)
        values(default,vCidade);
        end if;
end &&

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

DELIMITER $$
CREATE PROCEDURE ExibirCarros()
BEGIN
    SELECT c.id_carro, c.modelo, c.marca, c.ano, c.preco, cat.descricao AS categoria, c.carregador, c.imagem
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria
    WHERE c.status_carro = 'sob demanda';
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ExibirDetalhesCarro(IN p_id_carro INT)
BEGIN
    SELECT c.id_carro, 
           c.modelo, 
           c.marca, 
           c.ano, 
           c.preco, 
           cat.descricao AS categoria, 
           c.descricao, 
           c.imagem, 
           c.cor,
           c.carregador,
           c.status_carro
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria
    WHERE c.id_carro = p_id_carro;
END $$

-- procedures de entrega
DELIMITER //
CREATE PROCEDURE spInsertEntrega(
    IN vIdPedido INT,
    IN vIdCliente INT,
    IN vCEP NUMERIC(8),
    IN vLogradouro VARCHAR(200),
    IN vBairro VARCHAR(200),
    IN vCidade VARCHAR(200),
    IN vUF CHAR(2)
)
BEGIN
    DECLARE vBairroID INT;
    DECLARE vCidadeID INT;
    DECLARE vUFID INT;

    -- verifica e insere a uf se nao existir
    IF NOT EXISTS (SELECT UF FROM tbEstado WHERE UF = vUF) THEN
        INSERT INTO tbEstado (UFID, UF) VALUES (DEFAULT, vUF);
    END IF;

    --  pega o id da uf
    SELECT UFID INTO vUFID FROM tbEstado WHERE UF = vUF;

    IF NOT EXISTS (SELECT Cidade FROM tbCidade WHERE Cidade = vCidade) THEN
        INSERT INTO tbCidade (CidadeID, Cidade) VALUES (DEFAULT, vCidade);
    END IF;

    SELECT CidadeID INTO vCidadeID FROM tbCidade WHERE Cidade = vCidade;

    IF NOT EXISTS (SELECT Bairro FROM tbBairro WHERE Bairro = vBairro) THEN
        INSERT INTO tbBairro (BairroID, Bairro) VALUES (DEFAULT, vBairro);
    END IF;

    SELECT BairroID INTO vBairroID FROM tbBairro WHERE Bairro = vBairro;

    -- olha se o cep existe na tabela entrega
    IF NOT EXISTS (SELECT CEP FROM tbEntrega WHERE CEP = vCEP AND IdPedido = vIdPedido) THEN
        -- Insere na tabela entrega
        INSERT INTO tbEntrega (IdPedido, id_cliente, Logradouro, CEP, BairroID, CidadeID, UFID)
        VALUES (vIdPedido, vIdCliente, vLogradouro, vCEP, vBairroID, vCidadeID, vUFID);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spObterEnderecoEntregaPorPedido(IN p_id_pedido INT)
BEGIN
    SELECT 
        e.logradouro,
        e.CEP,
        b.Bairro AS BairroNome,          
        c.Cidade AS CidadeNome,          
        uf.UF AS UFNome,                 
        e.id_cliente                     
    FROM tbEntrega e
    INNER JOIN tbBairro b ON e.BairroID = b.BairroID
    INNER JOIN tbCidade c ON e.CidadeID = c.CidadeID
    INNER JOIN tbEstado uf ON e.UFID = uf.UFID
    WHERE e.IdPedido = p_id_pedido;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InserirTestDrive(
    IN p_id_cliente INT,
    IN p_id_carro INT,
    IN p_data_test DATETIME
)
BEGIN
    DECLARE mensagemErro VARCHAR(255);

    -- verifica se a data é no passado
    IF p_data_test < NOW() THEN
        SET mensagemErro = 'a data do test drive não pode ser no passado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensagemErro;
    END IF;

    -- verifica se o horário está dentro do permitido (10h a 18h)
    IF HOUR(p_data_test) < 10 OR HOUR(p_data_test) >= 18 THEN
        SET mensagemErro = 'o horario do test drive deve ser entre 10h e 18h';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensagemErro;
    END IF;

    -- Verifica se já existe um test drive agendado para a mesma data e horário
    IF EXISTS (
        SELECT 1 FROM test_drive 
        WHERE id_carro = p_id_carro 
          AND DATE(data_test) = DATE(p_data_test)
          AND HOUR(data_test) = HOUR(p_data_test)
    ) THEN
        SET mensagemErro = 'já existe um test drive agendado para esse carro na mesma data e horario, escolha outro.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensagemErro;
    END IF;

    -- insere na tabela test drive
    INSERT INTO test_drive (id_cliente, id_carro, data_test) 
    VALUES (p_id_cliente, p_id_carro, p_data_test);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spExibirTestDrive(IN p_id_cliente INT, IN p_id_test INT)
BEGIN
    SELECT 
        td.id_test,
        td.id_cliente,
        td.id_carro,
        td.data_test,
        c.modelo AS modelo_carro,
        c.marca AS marca_carro,
        c.cor AS cor_carro,
        c.preco AS preco_carro,
        c.imagem AS imagem_carro
    FROM 
        test_drive td
    INNER JOIN 
        carros c ON td.id_carro = c.id_carro
    WHERE 
        td.id_cliente = p_id_cliente 
        AND td.id_test = p_id_test;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE spObterItensPedidoPorID2(IN p_id_pedido INT)
BEGIN
    DECLARE v_valor_total DECIMAL(10,2);
    DECLARE v_status_pedido VARCHAR(50);

    -- pegar o valor_total e status_pedido do pedido especifico
    SELECT valor_total, status_pedido 
    INTO v_valor_total, v_status_pedido
    FROM pedidos 
    WHERE id_pedido = p_id_pedido; 

    -- se existir o pedido retorna os itens e detalhes do carro
    IF v_valor_total IS NOT NULL THEN
        SELECT p.id_pedido, p.id_cliente, p.data_pedido, v_valor_total AS ValorTotal, v_status_pedido AS StatusPedido,
               ip.id_item_pedido, ip.id_carro, ip.quantidade, ip.preco_unitario,
               c.modelo, c.marca, c.ano, c.preco AS preco_carro, c.imagem, c.cor
        FROM pedidos p
        INNER JOIN itens_pedidos ip ON p.id_pedido = ip.id_pedido
        INNER JOIN carros c ON ip.id_carro = c.id_carro
        WHERE p.id_pedido = p_id_pedido;
    ELSE
        SELECT NULL; -- null se nao tiver pedido
    END IF;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InserirEnderecoRetirada (
    IN vIdCliente INT,
    IN vIdPedido INT
)
BEGIN
    DECLARE vBairroID INT;
    DECLARE vCidadeID INT;
    DECLARE vUFID INT;

    SET @vBairro = 'Morumbi';
    SET @vCidade = 'São Paulo'; 
    SET @vUF = 'SP'; 
    SET @vCEP = 05651002;
    SET @vLogradouro = 'Overhaul Concessionária';

    -- insere o uf se nao existir
    IF NOT EXISTS (SELECT UF FROM tbEstado WHERE UF = @vUF) THEN
        INSERT INTO tbEstado (UFID, UF) VALUES (DEFAULT, @vUF);
    END IF;

    -- pegar o id da uf
    SELECT UFID INTO vUFID FROM tbEstado WHERE UF = @vUF;

    IF NOT EXISTS (SELECT Cidade FROM tbCidade WHERE Cidade = @vCidade) THEN
        INSERT INTO tbCidade (CidadeID, Cidade) VALUES (DEFAULT, @vCidade);
    END IF;

    SELECT CidadeID INTO vCidadeID FROM tbCidade WHERE Cidade = @vCidade;

    IF NOT EXISTS (SELECT Bairro FROM tbBairro WHERE Bairro = @vBairro) THEN
        INSERT INTO tbBairro (BairroID, Bairro) VALUES (DEFAULT, @vBairro);
    END IF;

    SELECT BairroID INTO vBairroID FROM tbBairro WHERE Bairro = @vBairro;

    IF NOT EXISTS (SELECT CEP FROM tbEntrega WHERE CEP = @vCEP AND IdPedido = vIdPedido) THEN
        -- Insere na tabela entrega
        INSERT INTO tbEntrega (IdPedido, id_cliente, Logradouro, CEP, BairroID, CidadeID, UFID)
        VALUES (vIdPedido, vIdCliente, @vLogradouro, @vCEP, vBairroID, vCidadeID, vUFID);
    END IF;
END //
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spObterClientePorEmail(
    vEmail VARCHAR(150)
)
BEGIN
    SELECT 
        clientes.id_cliente AS Codigo,
        clientes.nome,
        clientes.sobrenome,
        clientes.email,
        clientes.telefone,
        clientes.tipo_cliente,
        clientes.data_cadastro,
        tbEndereco.CEP AS CepCli,
        clientes.NumEnd,
        clientes.CompEnd,
        tbEndereco.Logradouro,
        tbBairro.Bairro,
        tbCidade.Cidade,
        tbEstado.UF,
        clientes.nivel_acesso, 
        clientes.cpf_cnpj  
    FROM clientes
    INNER JOIN tbEndereco ON clientes.CepCli = tbEndereco.CEP
    INNER JOIN tbBairro ON tbEndereco.BairroID = tbBairro.BairroID
    INNER JOIN tbCidade ON tbEndereco.CidadeID = tbCidade.CidadeID
    INNER JOIN tbEstado ON tbEndereco.UFID = tbEstado.UFID
    WHERE clientes.email = vEmail;
END &&
DELIMITER ;

-- criação da tabela de historico dos clientes
CREATE TABLE histClientes (
    id_cliente INT,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone DECIMAL(11,0),
    tipo_cliente ENUM('pf', 'pj') DEFAULT 'pf',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CepCli NUMERIC(8),
    NumEnd SMALLINT NOT NULL,
    CompEnd VARCHAR(50),
    cpf_cnpj DECIMAL(19, 0) NOT NULL,
    nivel_acesso TINYINT DEFAULT 1 CHECK (nivel_acesso IN (1, 2, 3)),
    statusConta ENUM('atualizado', 'excluido') DEFAULT 'atualizado',
    FOREIGN KEY (CepCli) REFERENCES tbEndereco(CEP)
);

DELIMITER //
CREATE PROCEDURE spInserirCarro(
    IN vModelo VARCHAR(50),
    IN vMarca VARCHAR(50),
    IN vAno INT,
    IN vPreco DECIMAL(10,2),
    IN vIdCategoria INT,
    IN vCarregador VARCHAR(50),
    IN vDescricao VARCHAR(300),
    IN vImagem VARCHAR(200),
    IN vCor VARCHAR(20)
)
BEGIN
    -- carro ja existe?
    IF NOT EXISTS (
        SELECT 1 FROM carros 
        WHERE modelo = vModelo AND marca = vMarca
    ) THEN

        INSERT INTO carros (modelo, marca, ano, preco, id_categoria, carregador, descricao, imagem, cor)
        VALUES (vModelo, vMarca, vAno, vPreco, vIdCategoria, vCarregador, vDescricao, vImagem, vCor);
    ELSE
        -- caso o carro exista 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'carro já existe';
    END IF;
END //
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spinsertAdmin(
    vNome VARCHAR(100),
    vSobrenome VARCHAR(100),
    vEmail VARCHAR(150),
    vSenha VARCHAR(255),
    vTelefone DECIMAL(11, 0),
    vTipoCliente ENUM('pf', 'pj'),
    vCpfCnpj DECIMAL(19,0),
    vCepCli NUMERIC(8),
    vNumEnd SMALLINT,
    vCompEnd VARCHAR(50),
    vLogradouro VARCHAR(200),
    vBairro VARCHAR(200),
    vCidade VARCHAR(200),
    vUF CHAR(2)
) 
BEGIN
    DECLARE vStatusConta ENUM('ativa', 'excluida') DEFAULT 'ativa';  

    IF NOT EXISTS (SELECT UF FROM tbEstado WHERE UF = vUF) THEN
        INSERT INTO tbEstado(UFID, UF) VALUES (DEFAULT, vUF);
    END IF;
    
    IF NOT EXISTS (SELECT Cidade FROM tbCidade WHERE Cidade = vCidade) THEN
        INSERT INTO tbCidade(CidadeID, Cidade) VALUES (DEFAULT, vCidade);
    END IF;
    
    IF NOT EXISTS (SELECT Bairro FROM tbBairro WHERE Bairro = vBairro) THEN
        INSERT INTO tbBairro(BairroID, Bairro) VALUES (DEFAULT, vBairro);
    END IF;
    
    IF NOT EXISTS (SELECT CEP FROM tbEndereco WHERE CEP = vCepCli) THEN
        INSERT INTO tbEndereco (CEP, Logradouro, BairroID, CidadeID, UFID)
        VALUES (
            vCepCli, 
            vLogradouro, 
            (SELECT BairroID FROM tbBairro WHERE Bairro = vBairro),
            (SELECT CidadeID FROM tbCidade WHERE Cidade = vCidade),
            (SELECT UFID FROM tbEstado WHERE UF = vUF)
        );
    END IF;
    
    -- inserindo com nivel de acesso 2 
    IF NOT EXISTS (SELECT email FROM clientes WHERE email = vEmail) THEN
        INSERT INTO clientes (
            nome, 
            sobrenome, 
            email, 
            senha, 
            telefone, 
            tipo_cliente, 
            cpf_cnpj,  
            CepCli, 
            NumEnd, 
            CompEnd,
            nivel_acesso, 
            status_conta  
        ) VALUES (
            vNome, 
            vSobrenome, 
            vEmail, 
            vSenha, 
            vTelefone, 
            vTipoCliente, 
            vCpfCnpj,  
            vCepCli, 
            vNumEnd, 
            vCompEnd,
            2,  
            vStatusConta  
        );
    END IF;

    INSERT IGNORE INTO login (id_cliente, email, senha)
    VALUES (
        (SELECT id_cliente FROM clientes WHERE email = vEmail),
        vEmail,
        vSenha
    );
END &&
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ExcluirCarro(IN p_id_carro INT)
BEGIN
    UPDATE carros
    SET status_carro = 'excluido'
    WHERE id_carro = p_id_carro;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spUpdateCarro(
    IN p_id_carro INT,
    IN p_modelo VARCHAR(50),
    IN p_marca VARCHAR(50),
    IN p_ano INT,
    IN p_preco DECIMAL(10,2),
    IN p_id_categoria INT,
    IN p_carregador VARCHAR(50),
    IN p_descricao VARCHAR(300),
    IN p_imagem VARCHAR(200),
    IN p_cor VARCHAR(20)
)
BEGIN
    UPDATE carros
    SET 
        modelo = p_modelo,
        marca = p_marca,
        ano = p_ano,
        preco = p_preco,
        id_categoria = p_id_categoria,
        carregador = p_carregador,
        descricao = p_descricao,
        imagem = p_imagem,
        cor = p_cor
    WHERE id_carro = p_id_carro;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE MostrarTodosTestDrives()
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
        carros car ON td.id_carro = car.id_carro;
END $$

DELIMITER ;

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

-- test drive procedures
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

-- avaliacao procedures
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

DELIMITER //
CREATE PROCEDURE spObterFormaPagamentoPorPedido(
    IN pedido_id INT
)
BEGIN
    SELECT id_pedido AS id_pagamento, forma_pagamento
    FROM FormaPagamento
    WHERE id_pedido = pedido_id;
END;
delimiter ;


DELIMITER //
CREATE PROCEDURE spObterFormaPagamentoPorPedido(
    IN pedido_id INT
)
BEGIN
    SELECT id_pedido AS id_pagamento, forma_pagamento
    FROM FormaPagamento
    WHERE id_pedido = pedido_id;
END;
delimiter ;

DELIMITER //
CREATE PROCEDURE spObterFormaPagamento(
    IN pedido_id INT
)
BEGIN
    SELECT id_pedido AS id_pagamento, forma_pagamento
    FROM FormaPagamento
    WHERE id_pedido = pedido_id;
END;
delimiter ;

-- triggers!!

DELIMITER //
CREATE TRIGGER trgAlterarStatusPedido
AFTER INSERT ON FormaPagamento
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET status_pedido = 'pagamento concluido'
    WHERE id_pedido = NEW.id_pedido; 
END; //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spCancelarPedido(IN p_id_pedido INT, IN p_id_cliente INT)
BEGIN
    UPDATE pedidos
    SET status_pedido = 'cancelado'
    WHERE id_pedido = p_id_pedido AND id_cliente = p_id_cliente;
END //
DELIMITER ;

-- call spCancelarPedido(2, 1);

DELIMITER $$
CREATE PROCEDURE spAlterarStatusCarro(IN p_id_carro INT)
BEGIN
    UPDATE carros
    SET status_carro = 'sob demanda'
    WHERE id_carro = p_id_carro;
END $$
DELIMITER ;


select * from carros;


DELIMITER //
CREATE TRIGGER trgRegistrarExclusaoCliente
AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    IF OLD.status_conta <> 'excluida' AND NEW.status_conta = 'excluida' THEN
        INSERT INTO histClientes (
            id_cliente, 
            nome, 
            sobrenome, 
            email, 
            senha, 
            telefone, 
            tipo_cliente, 
            data_cadastro, 
            CepCli, 
            NumEnd, 
            CompEnd, 
            nivel_acesso, 
            statusConta,
            cpf_cnpj 
        )
        VALUES (
            OLD.id_cliente, 
            OLD.nome, 
            OLD.sobrenome, 
            OLD.email, 
            OLD.senha, 
            OLD.telefone, 
            OLD.tipo_cliente, 
            OLD.data_cadastro, 
            OLD.CepCli, 
            OLD.NumEnd, 
            OLD.CompEnd, 
            OLD.nivel_acesso, 
            'excluído', 
            OLD.cpf_cnpj  
        );
    END IF;
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trgRegistrarAtualizacaoCliente
AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO histClientes (
        id_cliente, 
        nome, 
        sobrenome, 
        email, 
        senha, 
        telefone, 
        tipo_cliente, 
        data_cadastro, 
        CepCli, 
        NumEnd, 
        CompEnd, 
        nivel_acesso, 
        statusConta,
        cpf_cnpj  
    )
    VALUES (
        OLD.id_cliente, 
        OLD.nome, 
        OLD.sobrenome, 
        OLD.email, 
        OLD.senha, 
        OLD.telefone, 
        OLD.tipo_cliente, 
        OLD.data_cadastro, 
        OLD.CepCli, 
        OLD.NumEnd, 
        OLD.CompEnd, 
        OLD.nivel_acesso, 
        'atualizado',  
        OLD.cpf_cnpj  
    );
END; //
DELIMITER ; -- essa trigger nao é mais utilizada!! 

-- inserção de 1 adm para testes (unica inserção no codigo)
CALL spinsertAdmin(
    'ADM', 
    'administrador', 
    'adm@overhaul.com', 
    'adm', 
    36765436, 
    'pj', 
    42505789000182,
    98756723, 
    2967, 
    'concessionaria',
    'Overhaul Concessionaria',
    'Morumbi', 
    'São Paulo', 
    'SP'
);
