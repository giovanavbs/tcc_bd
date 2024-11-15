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

-- testes de usuarios pra usar
CALL spinsertCliente(
    'geralt', 
    'rivia', 
    'geraltofrivia@gmail.com', 
    'jaskier', 
    999888777, 
    'pf', 
    12345678901,
    98756723, 
    234, 
    'kaer morhen',
    'montanha da neve', 
    'centro', 
    'polonia', 
    'PL'
);

CALL spinsertCliente(
    'peter', 
    'parker', 
    'peterparker@gmail.com', 
    'spiderman', 
    998877665, 
    'pf', 
    98765432100,
    63290518, 
    678, 
    'Apto 89',
    'rua do queens', 
    'Queens', 
    'Nova York', 
    'NY'
);

CALL spinsertCliente(
    'park', 
    'jimin', 
    'parkjimin@gmail.com', 
    'bts', 
    998877665, 
    'pf', 
    12312312345,
    63290518, 
    678, 
    'Apto 89',
    'rua do smeraldo', 
    'Seoul', 
    'South Korea', 
    'SK'
);


select * from clientes;
select * from login;

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


select * from clientes;

CALL spUpdateCliente(
    3,  
    'park',  
    'jimin', 
    'parkjimin@gmail.com', 
    'ilovebts',  
    998877665, 
    'pf',  
    12312312,  
    678,  
    'Apto 49',  
    'rua do smeraldo',  
    'Seoul',  
    'South Korea',  
    'SK', 
    12312312345
);


call spObterClienteID(1);
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


call spExcluirCliente(3);
select * from clientes;

-- drop procedure spExcluirCliente;

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

-- CALL RegistrarPedido(1);
select * from pedidos;

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

-- SET SQL_SAFE_UPDATES = 0; / para permitir que delete tudo de uma tabela

INSERT INTO CarrinhoCompra (id_cliente, id_carro, modelo, marca, ano, preco, id_categoria, carregador, descricao, imagem, cor, QuantidadeProd) VALUES
(1, 1, 'Prius', 'Toyota', 2022, 80000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/prius.jpg', 'preto', 1),
(1, 6, 'Leaf', 'Nissan', 2022, 90000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/leaf.jpg', 'vermelho', 2);

INSERT INTO CarrinhoCompra (id_cliente, id_carro, modelo, marca, ano, preco, id_categoria, carregador, descricao, imagem, cor, QuantidadeProd) VALUES
(2, 3, 'Corolla Hybrid', 'Toyota', 2020, 65000.00, 1, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/corolla_hybrid.jpg', 'branco', 1),
(2, 9, 'i3', 'BMW', 2018, 80000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro.', 'imagens/i3.jpg', 'azul', 1);

call spObterPedidoRecentePorID(1);

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

/* DELIMITER //
CREATE PROCEDURE spObterPedidoCompletoPorID(IN p_id_cliente INT)
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_valor_total DECIMAL(10,2);

    -- pegar o id_pedido e valor_total do pedido mais recente
    SELECT id_pedido, valor_total 
    INTO v_id_pedido, v_valor_total
    FROM pedidos 
    WHERE id_cliente = p_id_cliente
    ORDER BY id_pedido DESC -- ordem decrescente para pegar o maior id_pedido (mais recente)
    LIMIT 1; 

    -- se existir o pedido retorna os itens
    IF v_id_pedido IS NOT NULL THEN
        SELECT p.id_pedido, p.id_cliente, p.data_pedido, v_valor_total AS ValorTotal, 
               ip.id_item_pedido, ip.id_carro, ip.quantidade, ip.preco_unitario
        FROM pedidos p
        INNER JOIN itens_pedidos ip ON p.id_pedido = ip.id_pedido
        WHERE p.id_pedido = v_id_pedido;
    ELSE
        SELECT NULL; -- null se nao tuver pedido
    END IF;

END //
DELIMITER ; 

call spObterItensPedidoPorID(1);
DELIMITER //
CREATE PROCEDURE spObterItensPedidoPorID(IN p_id_cliente INT)
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_valor_total DECIMAL(10,2);

    -- pegar o id_pedido e valor_total do pedido mais recente
    SELECT id_pedido, valor_total 
    INTO v_id_pedido, v_valor_total
    FROM pedidos 
    WHERE id_cliente = p_id_cliente
    ORDER BY id_pedido DESC -- ordem decrescente para pegar o pedido mais recente
    LIMIT 1; 

    -- se existir o pedido retorna os itens e detalhes do carro
    IF v_id_pedido IS NOT NULL THEN
        SELECT p.id_pedido, p.id_cliente, p.data_pedido, v_valor_total AS ValorTotal, 
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
DELIMITER ; 

drop procedure spObterItensPedidoPorID; */
select * from pedidos;

call spObterItensPedidoPorID(1);
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

-- testes de inserir cartao
CALL spInsertCartao(
    1,                  
    '1234567812345678', 
    'Peter Parker',      
    '12/25',            
    '123',              
    'Visa'             
);

CALL spInsertCartao(
    2,                 
    '8765432187654321', 
    'Geralt of Rivia',      
    '11/26',            
    '456',              
    'MasterCard'        
);

-- procedures endereco
delimiter &&
create procedure spinsertBairro(vBairro varchar (200))
begin

IF NOT EXISTS  (select Bairro from tbBairro WHERE Bairro = vBairro) then
    insert into tbBairro(BairroID, Bairro)
        values(default,vBairro);
        end if;
end &&

-- call spinsertBairro('Morumbi');

delimiter &&
create procedure spinsertEstado(vUF char (2))
begin

IF NOT EXISTS  (select UF from tbEstado where UF = vUF) then
    insert into tbEstado(UFID, UF)
        values(default,vUF);
        end if;
end &&

-- call spinsertEstado('SP'); 

delimiter &&
create procedure spinsertCidade(vCidade varchar (200))
begin
	
    IF NOT EXISTS  (select Cidade from tbCidade where Cidade = vCidade) then
    insert into tbCidade(CidadeID, Cidade)
        values(default,vCidade);
        end if;
end &&

-- call spinsertCidade('São Paulo'); 

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

call spinsertendereco(01310930, 'Avenida Paulista', 'Bela Vista', 'São Paulo', 'SP');

select * from test_drive;
UPDATE clientes set CepCli = 01310930 where CepCli = 0;
select * from clientes;
-- procedures do carro
/*
DELIMITER $$
CREATE PROCEDURE ExibirCarros()
BEGIN
    SELECT c.id_carro, c.modelo, c.marca, c.ano, c.preco, cat.descricao AS categoria, c.carregador
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria;
END $$
*/

DELIMITER $$
CREATE PROCEDURE ExibirCarros()
BEGIN
    SELECT c.id_carro, c.modelo, c.marca, c.ano, c.preco, cat.descricao AS categoria, c.carregador, c.imagem
    FROM carros c
    JOIN categorias cat ON c.id_categoria = cat.id_categoria
    WHERE c.status_carro = 'sob demanda';
END $$
DELIMITER ;

CALL ExibirCarros();

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

-- call ExibirDetalhesCarro(1);

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

-- CALL spInsertEntrega(1, 1, 12385050, 'av kaer morhen', 'Lapa', 'São Paulo', 'SP');

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

call spObterEnderecoEntregaPorPedido(1);

-- procedures do test drive
-- CALL InserirTestDrive(1, 2, '2024-10-09 17:00:00');

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

call spExibirTestDrive(1, 1);
drop procedure spExibirTestDrive;
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

call spObterItensPedidoPorID2(1);
select * from carros;
update carros set imagem = 'carro2.png' where id_carro = 14;

DELIMITER //
CREATE PROCEDURE spObterItensPedidoPorID2(IN p_id_pedido INT)
BEGIN
    DECLARE v_valor_total DECIMAL(10,2);
    DECLARE v_status_pedido VARCHAR(50);

    -- Pegar o valor_total e status_pedido do pedido específico
    SELECT valor_total, status_pedido 
    INTO v_valor_total, v_status_pedido
    FROM pedidos 
    WHERE id_pedido = p_id_pedido; 

    -- Se existir o pedido, retorna os itens e detalhes do carro
    IF v_valor_total IS NOT NULL THEN
        SELECT p.id_pedido, p.id_cliente, p.data_pedido, v_valor_total AS ValorTotal, v_status_pedido AS StatusPedido,
               ip.id_item_pedido, ip.id_carro, ip.quantidade, ip.preco_unitario,
               c.modelo, c.marca, c.ano, c.preco AS preco_carro, c.imagem, c.cor
        FROM pedidos p
        INNER JOIN itens_pedidos ip ON p.id_pedido = ip.id_pedido
        INNER JOIN carros c ON ip.id_carro = c.id_carro
        WHERE p.id_pedido = p_id_pedido;
    ELSE
        SELECT NULL; -- null se não tiver pedido
    END IF;

END //
DELIMITER ;
