/*
call spInserirEnderecoAtualNaEntrega(8, 1);

DELIMITER //

CREATE PROCEDURE spInserirEnderecoAtualNaEntrega(
    IN vIdPedido INT,
    IN vIdCliente INT
)
BEGIN
    DECLARE vCEP NUMERIC(8);
    DECLARE vLogradouro VARCHAR(200);
    DECLARE vBairro VARCHAR(200);
    DECLARE vCidade VARCHAR(200);
    DECLARE vUF CHAR(2);

    SELECT e.CEP, e.logradouro, b.Bairro, c.Cidade, uf.UF
    INTO vCEP, vLogradouro, vBairro, vCidade, vUF
    FROM clientes cli
    JOIN tbEndereco e ON cli.CepCli = e.CEP
    JOIN tbBairro b ON e.BairroID = b.BairroID
    JOIN tbCidade c ON e.CidadeID = c.CidadeID
    JOIN tbEstado uf ON e.UFID = uf.UFID
    WHERE cli.id_cliente = vIdCliente;

    CALL spInsertEntrega(vIdPedido, vIdCliente, vCEP, vLogradouro, vBairro, vCidade, vUF);
END //

DELIMITER ;
*/

-- call InserirEnderecoRetirada(1, 12);
select * from tbEntrega;
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

