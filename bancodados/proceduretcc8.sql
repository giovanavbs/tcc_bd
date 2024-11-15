create table NotaFiscal (
    id_nota_fiscal int auto_increment primary key,
    id_pagamento int not null,
    numero_nota varchar(50) not null,
    data_emissao date not null,
    valor_total decimal(10,2) not null,
    foreign key (id_pagamento) references FormaPagamento(id_pedido)
);
use ecommerce_carros;

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

call spObterFormaPagamentoPorPedido(5);
select * from pedidos;
select * from tbEntrega;

select * from NotaFiscal;

SELECT nf.id_nota_fiscal, nf.id_pagamento, nf.numero_nota, nf.data_emissao, nf.valor_total, fp.forma_pagamento 
FROM NotaFiscal nf
JOIN FormaPagamento fp ON nf.id_pagamento = fp.id_pedido
WHERE fp.id_pedido = 29;

SELECT c.id_cliente, c.nome, c.sobrenome, c.cpf_cnpj
FROM clientes c
WHERE c.id_cliente = 1;

UPDATE tbendereco
SET CEP = '06136020'
WHERE CEP = 0;



select * from tbendereco;
select * from clientes;

use ecommerce_carros;
select * from carros;
