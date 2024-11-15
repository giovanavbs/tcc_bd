-- drop procedure spObterClientePorEmail;
-- call spObterClientePorEmail("geraltofrivia@gmail.com");

select * from clientes;

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


select * from clientes;
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


select * from histClientes;

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
DELIMITER ;
