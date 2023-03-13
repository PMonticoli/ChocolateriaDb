-- Roles
INSERT INTO chocolateriadb.roles (nombre) values ('Socio');
INSERT INTO chocolateriadb.roles (nombre) values ('Empleado');
INSERT INTO chocolateriadb.roles (nombre) values ('Admin');

-- Tipos de Pago
INSERT INTO chocolateriadb.tipospago (nombre) values ('Efectivo');
INSERT INTO chocolateriadb.tipospago (nombre) values ('Tarjeta de Débito');
INSERT INTO chocolateriadb.tipospago (nombre) values ('Tarjeta de Crédito');
INSERT INTO chocolateriadb.tipospago (nombre) values ('Mercado Pago');

-- Usuarios
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (1, "chochouser", "pablo123", NOW());
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (2, "chocoempleado", "pablo123", NOW());
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (3, "chocoadmin", "pablo123", NOW());


-- Empleados
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (2, 'Empleado', 'Juan', '3525509890', 'juan@hotmail.com', 345123, NOW(), NULL);
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (3, 'Admin', 'Chocolateria', '3512548963', 'admin@hotmail.com', 40698325, NOW(), NULL);
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (5, 'Pablo', 'Empleado', '345214321', 'pablo@hotmail.com', 421345, NOW(), NULL);

-- Puntos de venta
INSERT INTO chocolateriadb.puntosventa (nombre) values ('Sucursal Chocolateria - Caja 1');
INSERT INTO chocolateriadb.puntosventa (nombre) values ('Web');

-- Socios
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (1,'Pablo','Montícoli','Int Cespdes 245','pablo@hotmail.com','423053','352550323',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (4,'Eduardo','Montícoli','ovidio lagos','eduardo@hotmail.com','423456','3525508233',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Lionel','Messi','Barceclona 123','messi@hotmail.com','32506567','3525181222',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Juan','Oller','Olmos 555','juan@hotmail.com','4442344','035344566',NOW(),NULL);

INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Rodrigo','De Pual','Madrid 255','rodrigo@hotmail.com','38000874','0351546987',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Pablo','Montícoli','Olmos 234','pablo@hotmail.com','444333','0351567890',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Eduardo','Montícoli','24 de septiembre 213','eduardo@hotmail.com','423045','3525508321',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Angel','Di Maria','Italia 123','angelito@hotmail.com','35025412','0351852459',NOW(),NULL);


-- Estados de pedido
INSERT INTO chocolateriadb.estadospedido (nombre) values('Creado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Pagado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Entregado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Cancelado');

-- Productos
INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de bombones surtidos', 7000.00, 'Bombones de chocolate blanco y negro', null, true, true, 600, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de chocolates mix', 5000.00, 'Caja de chocolates varios', null, true, true, 500, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de chocolates en rama', 4000.00, 'Chocolate en rama blanco y negro.', null, true, true, 450, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Corazón gigante', 3000.00, 'Chocolate con forma de corazón', null, true, true, 400, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de alfajores chocolate negro', 1800.00, 'Alfajores chocolate negro 6 unidades', null, true, true, 250, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de alfajores chocolate blanco', 1800.00, 'Alfajores chocolate blanco 6 unidades', null, true, true, 250, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de golosinas surtida', 1300.00, 'Golosinas surtidas', null, true, true, 150, '');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Tazas', 1300.00, 'Taza en caja para regalar', null, true, true, 150, '');


-- Promociones
INSERT INTO chocolateriadb.promociones (nombre, descripcion, precioPuntos, fechaDesde, fechaHasta) values
('Promo alfajores chocolate blanco', 'Llevate 2 cajas y te llevas un chocolate de regalo', 500, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY));
INSERT INTO chocolateriadb.promociones (nombre, descripcion, precioPuntos, fechaDesde, fechaHasta) values
('Promo chocolate en rama', 'Llevate 2 cajas de chocolate en rama y te llevas una taza a elección', 900, DATE_SUB(NOW(), INTERVAL 15 DAY), DATE_ADD(NOW(), INTERVAL 15 DAY));
INSERT INTO chocolateriadb.promociones (nombre, descripcion, precioPuntos, fechaDesde, fechaHasta) values
('Promo caja chocolates mix', 'Llevate 2 cajas y te llevas una taza a elección', 1000, DATE_SUB(NOW(), INTERVAL 18 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY));


-- Detalle promociones
INSERT INTO chocolateriadb.detallepromocion (idPromocion, idProducto, cantidad) values (1, 6, 2);
INSERT INTO chocolateriadb.detallepromocion (idPromocion, idProducto, cantidad) values (2, 3, 2);
INSERT INTO chocolateriadb.detallepromocion (idPromocion, idProducto, cantidad) values (3, 2, 2);


-- Pedidos y detalle pedidos
-- 1
INSERT INTO chocolateriadb.pedidos
(idPuntoVenta, idSocio, idEmpleado, idEstado, observaciones, fechaPedido) values
(2, 1, null, 3, 'Abono con efectivo al retirar', DATE_SUB(NOW(), INTERVAL 10 DAY));

INSERT INTO chocolateriaDB.detallespedido
(idPedido, idProducto, cantidad, precioUnitario, puntosGanados) values
(1, 6, 2, 1800, 300);

INSERT INTO chocolateriaDB.detallespedido
(idPedido, idProducto, cantidad, precioUnitario, puntosGanados) values
(1, 3, 2, 4000, 900);

INSERT INTO chocolateriaDB.movimientospuntos (idPromocion, idDetallePedido, idSocio, puntos) values
(null, 2, 1, 300);

INSERT INTO chocolateriaDB.movimientospuntos (idPromocion, idDetallePedido, idSocio, puntos) values
(null, 2, 2, 900);

-- 2
INSERT INTO chocolateriaDB.pedidos
(idPuntoVenta, idSocio, idEmpleado, idEstado, observaciones, fechaPedido) values
(2, null, null, 1, 'Retira Laura Castagna', DATE_SUB(NOW(), INTERVAL 35 MINUTE));

INSERT INTO chocolateriaDB.detallespedido
(idPedido, idProducto, cantidad, precioUnitario, puntosGanados, comentarios) values
(2, 2, 1, 5000, 500, '');

-- 3
INSERT INTO chocolateriaDB.pedidos
(idPuntoVenta, idSocio, idEmpleado, idEstado, observaciones, fechaPedido) values
(1, 2, 3, 2, 'Abonó con efectivo en caja', DATE_SUB(NOW(), INTERVAL 15 MINUTE));

INSERT INTO chocolateriaDB.detallespedido
(idPedido, idProducto, cantidad, precioUnitario, puntosGanados, comentarios) values
(3, 3, 1, 4000, 450, 'Chocolate en rama blanco y negro');

INSERT INTO chocolateriaDB.movimientospuntos (idPromocion, idDetallePedido, idSocio, puntos) values
(null, 5, 2, 450);

-- Cobros
INSERT INTO cobros(idPedido,idTipoPago,idEmpleado,fechaCobro,codigoAutorizacion,montoCobrado) values(1,1,null,NOW(),455,760);