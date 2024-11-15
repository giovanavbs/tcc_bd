call MostrarTodosTestDrives();
drop procedure MostrarTodosTestDrives;
/*
DELIMITER $$
CREATE PROCEDURE MostrarTodosTestDrives()
BEGIN
    SELECT 
        td.id_test,
        c.nome AS cliente_nome,
        c.cpf_cnpj AS cliente_cpf,
        car.modelo AS carro_modelo,
        car.marca AS carro_marca,
        car.ano AS carro_ano,
        td.data_test
    FROM 
        test_drive td
    INNER JOIN 
        clientes c ON td.id_cliente = c.id_cliente
    INNER JOIN 
        carros car ON td.id_carro = car.id_carro;
END $$

DELIMITER ;
*/
call MostrarTodosTestDrives();
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
select * from test_drive;

describe test_drive;
describe clientes;