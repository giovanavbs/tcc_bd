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

