update carros set imagem = 'carro11.png' where id_carro = 10;
UPDATE clientes set CepCli = 01310930 where id_cliente = 7;

call spinsertendereco(01310930, 'Avenida Paulista', 'Bela Vista', 'São Paulo', 'SP');

select * from clientes;
select * from carros;

select * from pedidos;
select * from formapagamento;
delete from pedidos where id_pedido = 1;
select * from avaliacoes;
select * from itens_pedidos;
delete from itens_pedidos where id_pedido = 4;
select * from tbEntrega;
delete from tbEntrega where id_cliente = 1;
update carros set imagem = 'carro10.png' where id_carro = 3;

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


use ecommerce_carros;