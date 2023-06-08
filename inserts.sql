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
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (1, "chocouser", "pablo123", NOW());
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (2, "chocoempleado", "pablo123", NOW());
INSERT INTO chocolateriadb.usuarios (idRol, usuario, contrasenia, fechaAlta) values (3, "chocoadmin", "pablo123", NOW());


-- Empleados
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (2, 'Empleado', 'Juan', '3525509890', 'juan@hotmail.com', 345123, NOW(), NULL);
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (3, 'Admin', 'Chocolateria', '3512548963', 'admin@hotmail.com', 40698325, NOW(), NULL);
INSERT into chocolateriadb.empleados (idUsuario, nombre, apellido, telefono, email, dni, fechaAlta, fechaBaja)
values (2, 'Empleado', 'Pablo', '345214321', 'pablo@hotmail.com', 421345, NOW(), NULL);

-- Puntos de venta
INSERT INTO chocolateriadb.puntosventa (nombre) values ('Sucursal Olbap-Chocolates');
INSERT INTO chocolateriadb.puntosventa (nombre) values ('Web');

-- Socios
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (1,'Pablo','Montícoli','Int Cespdes 245','pablo@hotmail.com','42162165','352550323',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Eduardo','Montícoli','ovidio lagos','eduardo@hotmail.com','16542147','3525508233',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Lionel','Messi','Barceclona 123','messi@hotmail.com','32506567','3525181222',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Juan','Oller','Olmos 555','juan@hotmail.com','42423443','035344566',NOW(),NULL);

INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Rodrigo','De Pual','Madrid 255','rodrigo@hotmail.com','38000874','0351546987',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Javier','Montícoli','Olmos 234','javier@hotmail.com','4443332','0351567890',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Valentina','Montiícoli','24 septiembre','vmonticoli@hotmail.com','44608424','03525531123',NOW(),NULL);
INSERT INTO chocolateriadb.socios (idUsuario,nombre,apellido,domicilio,email,dni,telefono,fechaAlta,fechaBaja) 
values (null,'Angel','Di Maria','Italia 123','angelito@hotmail.com','32045456','0351852459',NOW(),NULL);


-- Estados de pedido
INSERT INTO chocolateriadb.estadospedido (nombre) values('Creado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Pagado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Entregado');
INSERT INTO chocolateriadb.estadospedido (nombre) values('Cancelado');

-- Productos
INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de bombones surtidos', 4000.00, 'Bombones de chocolate blanco y negro', null, true, true, 400, './uploads/cajaBombones.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de chocolates mix', 4000.00, 'Caja de chocolates varios', null, true, true, 400, './uploads/cajaChocolates.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de chocolates en rama', 4200.00, 'Chocolate en rama blanco y negro.', null, true, true, 420, './uploads/chocolateRama.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de San Valentin', 3800.00, 'Chocolate con forma de corazón', null, true, true, 380, './uploads/cajaRegalo.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Alfajores chocolate negro', 1800.00, 'Alfajores chocolate negro 6 unidades', null, true, true, 180, './uploads/alfajoresNegro.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Alfajores chocolate blanco', 1800.00, 'Alfajores chocolate blanco 6 unidades', null, true, true, 180, './uploads/alfajoresBlanco.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Caja de golosinas surtida', 1300.00, 'Golosinas surtidas', null, true, true, 130, './uploads/cajaGolosinas.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Tazas', 1300.00, 'Taza de cerámica con frase y diseño', null, true, true, 130, './uploads/tazas.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Tableta de chocolate amargo', 850.00, '80g de chocolate con 65% cacao y 0% azúcar.Libre de gluten, sin TACC. Apto celiacos.', null, true, true, 85, './uploads/tabletaChocolate.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Tejas 70% cacao', 850.00, 'Láminas de chocolate amargo 70%. Caja de 60g.Sin ingredientes de origen animal. Apto veganos.', null, true, true, 800, './uploads/tejas.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Tableta puro chocolate con leche', 850.00, 'Tableta es de puro chocolate con leche. Caja de 80g Producto sin TACC. Apto celíacos.', null, true, true, 85, './uploads/tabletaChocolateLeche.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Bombones con licor', 850.00, 'Bombones rellenos con licor.Caja de 6 unidades. Libre de gluten. Producto sin TACC.Apto celiacos.', null, true, true, 85, './uploads/bombonesLicor.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Almendras Bañadas en Chocolate', 1200.00, 'Paila de almendras con chocolate con leche. Libre de gluten. Producto sin TACC. Apto celiacos.', null, true, true, 120, './uploads/almendras.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Bombones y Trufas', 2300.00, 'Lata rellena con una selección de bombones y trufas, contiene 120g.', null, true, true, 85, './uploads/lataBombones.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Turron chocolate con almendra', 850.00, 'Turron de chocolate relleno con almendras. Contiene 250g.Libre de gluten. Sin TACC. Apto celiacos.', null, true, true, 85, './uploads/chocolateAlmendra.jpg');

INSERT INTO chocolateriadb.productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
values ('Crema de mani y cacao', 850.00, 'Crema de marroc con mani y cacao artesanal', null, true, true, 85, './uploads/cremaMani.jpg');


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
(null, 2, 1, 900);

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
(null, 3, 2, 450);

-- Cobros
INSERT INTO cobros(idPedido,idTipoPago,idEmpleado,fechaCobro,codigoAutorizacion,montoCobrado) values(1,1,null,NOW(),455,760);