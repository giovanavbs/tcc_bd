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

-- teste carro novo
CALL spInserirCarro(
    'Model S',          
    'Tesla',           
    2023,              
    75000.00,           
    2,                 
    'Supercharger',     
    'Sedan elétrico de alta performance', 
    'models.png',     
    'Preto'            
);

select * from clientes;

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


-- teste inserção admin
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
select * from clientes;


DELIMITER $$
CREATE PROCEDURE ExcluirCarro(IN p_id_carro INT)
BEGIN
    UPDATE carros
    SET status_carro = 'excluido'
    WHERE id_carro = p_id_carro;
END $$
DELIMITER ;

select * from carros;
-- call ExcluirCarro(4);

-- (9, 'i3', 'BMW', 2018, 80000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro..', 'imagens/i3.jpg', 'azul'); 
-- call spUpdateCarro (9, 'i3', 'BMW', 2018, 80000.00, 2, 'carregador', 'Praticidade e sustentabilidade em um só carro..', 'imagens/i3.jpg', 'vermelho');
select * from carros;

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
