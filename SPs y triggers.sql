DELIMITER //
##################### USUARIOS #####################

-- Iniciar Sesion
CREATE PROCEDURE spIniciarSesion(
IN usuario1 varchar(30),
IN contrasenia1 varchar(32)
)
BEGIN
    declare role varchar(30);
    select r1.nombre into role from usuarios u1
    join roles r1 on r1.id = u1.idRol
    where u1.usuario=usuario1 and u1.contrasenia=contrasenia1;

	IF (role<>'Socio' AND role IS NOT NULL) THEN
		BEGIN
		SELECT u3.id,
        em.id as idEmpleado,
        r3.nombre as rol,
		u3.usuario, u3.fechaAlta,
        u3.fechaBaja FROM usuarios u3
		join roles r3 on r3.id = u3.idRol
        join empleados em on em.idUsuario = u3.id
		where u3.usuario=usuario1 and u3.contrasenia=contrasenia1;
		END;
    ELSE
		BEGIN
        SELECT u2.id,
        so.id as idSocio,
        r2.nombre as rol,
		u2.usuario, u2.fechaAlta,
        u2.fechaBaja FROM usuarios u2
		join roles r2 on r2.id = u2.idRol
        join socios so on so.idUsuario = u2.id
		where u2.usuario=usuario1 and u2.contrasenia=contrasenia1;
		END;
    END IF;
END //

-- Nuevo usuario socio
CREATE PROCEDURE spNuevoUsuarioSocio(
IN usuario1 varchar(30),
IN contrasenia1 varchar(32),
IN dniSocio1 int
)
BEGIN
	SELECT id into @idSoc from roles
    WHERE nombre = 'Socio';
	INSERT INTO usuarios(idRol, usuario, contrasenia, fechaAlta) values (@idSoc, usuario1, contrasenia1, NOW());
    UPDATE socios set idUsuario = last_insert_id() 
    WHERE dni = dniSocio1
    AND idUsuario is null;
END//

-- Nuevo Usuario Empleado
CREATE PROCEDURE spNuevoUsuarioEmpleado(
IN usuario1 varchar(30),
IN contrasenia1 varchar(32),
IN idRol1 int
)

BEGIN
	INSERT INTO usuarios(idRol, usuario, contrasenia, fechaAlta) values (idRol1, usuario1, contrasenia1, NOW());
END//

-- Nuevo Usuario Admin
CREATE PROCEDURE spNuevoUsuarioAdmin(
IN usuario1 varchar(30),
IN contrasenia1 varchar(32)
)
BEGIN
	select id into @idAdmin from roles
    where nombre = 'Admin';
    
	INSERT INTO usuarios(idRol, usuario, contrasenia, fechaAlta) values (@idAdmin, usuario1, contrasenia1, NOW());
END//

-- Dar de baja Usuario
CREATE PROCEDURE spDarDeBajaUsuario(
IN idUsuario1 int,
OUT status tinyint
)
BEGIN
	SELECT count(*) INTO @count FROM usuarios u where u.id = idUsuario1 and u.fechaBaja IS NULL;
    IF (@count = 1) THEN
	BEGIN
		UPDATE usuarios set fechaBaja = NOW() where id=idUsuario1;
		SET status = 1;
    END;
    ELSE SET status = 0;
    END IF;
END//

##################### PRODUCTOS #####################
-- GET ALL
CREATE PROCEDURE spObtenerProductos()
BEGIN
    SELECT id, nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen
	FROM productos;
END //
-- GET ACTIVOS
CREATE PROCEDURE spObtenerProductosActivos()
BEGIN
    SELECT id, nombre, precio, descripcion, disponible, puntosGanados, urlImagen
	FROM productos
    WHERE activo = true;
END //
-- GET BY ID
CREATE PROCEDURE spObtenerProductoPorID(
	IN id int
)
BEGIN
    SELECT p.id, p.nombre, p.precio, p.descripcion, p.observaciones, p.activo, p.disponible, p.puntosGanados, p.urlImagen
	FROM productos p
    WHERE p.id = id;
END //

-- CREATE
CREATE PROCEDURE spInsertarProducto(
IN nom varchar(32),
IN pre double,
IN des varchar(100),
IN obs varchar(100),
IN act boolean,
IN disp boolean,
IN pg int,
IN url varchar(100)
)
BEGIN
    INSERT INTO productos (nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen)
    VALUES (nom, pre, des, obs, act, disp, pg, url);
END //

-- UPDATE
CREATE PROCEDURE spActualizarProducto(
IN i int,
IN nom varchar(32),
IN pre double,
IN des varchar(100),
IN obs varchar(100),
IN act boolean,
IN disp boolean,
IN pg int,
IN url varchar(100)
)
BEGIN
    UPDATE productos 
    SET nombre = nom,
	precio = pre,
    descripcion = des,
    observaciones = obs,
    activo = act,
    disponible = disp,
    puntosGanados = pg,
    urlImagen = url
    WHERE id = i;
    
END //

-- DELETE logico
CREATE PROCEDURE spBorrarProducto(
IN id1 int
)
BEGIN
	UPDATE productos 
    SET activo = false
    WHERE id = id1;
END //

##################### PEDIDOS #####################
-- NEW
CREATE PROCEDURE spRegistrarPedido(
IN idPuntoVenta1 int,
IN idSocio1 int,
IN idEmpleado1 int,
IN observaciones1 varchar(100),
OUT id int
)
BEGIN
    INSERT INTO pedidos (idPuntoVenta, idSocio, idEmpleado, idEstado, observaciones, fechaPedido)
    VALUES (idPuntoVenta1, idSocio1, idEmpleado1, 1, observaciones1, now());
    SET id := last_insert_id();
END //

-- NEW DETALLE
CREATE PROCEDURE spRegistrarDetallePedido(
IN idPedido1 int, 
IN idProducto1 int,
IN cantidad1 tinyint,
IN precioUnitario1 double,
IN puntosGanados1 int,
IN comentarios1 varchar(150)
)
BEGIN
    INSERT INTO detallespedido (idPedido, idProducto, cantidad, precioUnitario, puntosGanados, comentarios)
    Values (idPedido1, idProducto1, cantidad1, precioUnitario1, puntosGanados1, comentarios1);
END //

-- GET all Pedidos
CREATE PROCEDURE spObtenerPedidos()
BEGIN
    select p.id, pv.nombre as puntoVenta,
    CONCAT(so.apellido,' ',so.nombre) as socio,
    CONCAT(em.apellido,' ',em.nombre) as empleado,
    ep.nombre as estado,
    p.observaciones, p.fechaPedido
    from pedidos p 
    join puntosventa pv on p.idPuntoVenta = pv.id
    left join socios so on p.idSocio = so.id
    left join empleados em on p.idEmpleado = em.id
    join estadospedido ep on p.idEstado = ep.id
    order by fechaPedido desc;
END //

-- GET Pedidos pendientes
CREATE PROCEDURE spObtenerPedidosPendientes()
BEGIN
    select p.id, pv.nombre as puntoVenta,
    CONCAT(so.apellido,' ',so.nombre) as socio,
    CONCAT(em.apellido,' ',em.nombre) as empleado,
    ep.nombre as estado,
    p.observaciones, p.fechaPedido
    from pedidos p 
    join puntosventa pv on p.idPuntoVenta = pv.id
    left join socios so on p.idSocio = so.id
    left join empleados em on p.idEmpleado = em.id
    join estadospedido ep on p.idEstado = ep.id
    where ep.id = 1 or ep.id = 2
    order by fechaPedido desc;
END //

-- GET Pedido by ID
CREATE PROCEDURE spObtenerPedidoPorId(
	IN id1 int
)
BEGIN
    select p.id, pv.nombre as puntoVenta,
    CONCAT(so.apellido,' ',so.nombre) as socio,
    CONCAT(em.apellido,' ',em.nombre) as empelado,
    ep.nombre as estado,
    p.observaciones, p.fechaPedido
    from pedidos p 
    join puntosventa pv on p.idPuntoVenta = pv.id
    left join socios so on p.idSocio = so.id
    left join empleados em on p.idEmpleado = em.id
    join estadospedido ep on p.idEstado = ep.id
    where p.id = id1;
END //

-- GET Pedidos de un socio
CREATE PROCEDURE spObtenerMisPedidos(
	IN idSocio1 int
)
BEGIN
    select p.id,
    ep.nombre as estado,
	p.fechaPedido
    from pedidos p
    join estadospedido ep on p.idEstado = ep.id
    where p.idSocio = idSocio1
    order by p.fechaPedido desc;
END //

-- Get detalles de un pedido
CREATE PROCEDURE spObtenerDetalles(
	IN id int
)
BEGIN
    select idDetalle, idProducto, pr.nombre as nombreProducto,
    cantidad, precioUnitario,
    dp.puntosGanados, comentarios from detallespedido dp
    join productos pr on pr.id = dp.idProducto
    where idPedido = id;
END //

-- Cancelar un pedido
CREATE PROCEDURE spCancelarPedido(
	IN idPedido INT
)
BEGIN
	select id from estadospedido
    where nombre = 'Cancelado'
    into @idCancel;
    update pedidos p set p.idEstado = @idCancel where p.id = idPedido;
END//

-- Borrar un detalle por ID
CREATE PROCEDURE spBorrarDetalleId(
	IN idDetalle1 INT
)
BEGIN
	delete from detallespedido dp where dp.idDetalle = idDetalle1;
END //


##################### SOCIOS #####################
-- NEW Socio
CREATE PROCEDURE spRegistrarSocio(
IN idUsuario1 int,
IN nombre1 varchar(30),
IN apellido1 varchar(30),
IN domicilio1 varchar(50),
IN email1 varchar(40),
IN dni1 int,
IN telefono1 varchar(20)
)
BEGIN
    INSERT INTO socios (idUsuario, nombre, apellido,domicilio,email,dni,telefono,fechaAlta)
    VALUES (idUsuario1,nombre1,apellido1,domicilio1,email1,dni1,telefono1,NOW());
END //

-- GET all socios
CREATE PROCEDURE spObtenerSocios()
BEGIN
	select id, dni, nombre, apellido,fechaBaja from socios;
END //

-- GET by ID
CREATE PROCEDURE spObtenerSocioById(
	IN idSocio int
)
BEGIN
	select * from socios where id = idSocio;
END //

-- GET by DNI
CREATE PROCEDURE spObtenerSocioByDNI(
	IN dni1 int
)
BEGIN
	select * from socios where dni = dni1;
END //


-- Modificar Socio
CREATE PROCEDURE spModificarSocio(
	IN nombre1 varchar(30),
    IN apellido1 varchar(30),
    IN domicilio1 varchar(50),
    IN email1 varchar(40),
    IN telefono1 varchar(20),
    IN idSocio int
)
BEGIN
	UPDATE socios SET nombre = nombre1,
    apellido = apellido1, domicilio = domicilio1,
    email = email1, telefono = telefono1
    WHERE id = idSocio;
END //

-- DELETE
CREATE PROCEDURE spBorrarSocio(
IN id int
)
BEGIN
	DELETE 
    FROM socios s
    WHERE s.id = id;
END //

-- Dar de baja
CREATE PROCEDURE spDarDeBajaSocio(
IN idSocio1 int,
OUT status tinyint
)
BEGIN
	DECLARE count int;
	SELECT count(*) INTO count FROM socios s where s.id = idSocio1 and s.fechaBaja IS NULL;
    IF (count = 1) THEN
	BEGIN
		UPDATE socios set fechaBaja = NOW() where id=idSocio1;
		SET status = 1;
    END;
    ELSE SET status = 0;
    END IF;
END//


##################### PROMOCIONES #####################
-- NEW
CREATE PROCEDURE spRegistrarPromocion(
IN nombre1 varchar(50),
IN descripcion1 varchar(100),
IN precioPuntos1 mediumint,
IN fechaDesde1 datetime,
IN fechaHasta1 datetime,
OUT id int
)
BEGIN
    INSERT INTO promociones (nombre, descripcion, precioPuntos, fechaDesde, fechaHasta)
    VALUES (nombre1, descripcion1, precioPuntos1, fechaDesde1, fechaHasta1);
    SET id := last_insert_id();
END //

-- NEW DETALLE
CREATE PROCEDURE spRegistrarDetallePromocion(
IN idPromocion1 int, 
IN idProducto1 int,
IN cantidad1 tinyint
)
BEGIN
    INSERT INTO detallepromocion (idPromocion, idProducto, cantidad)
    Values (idPromocion1, idProducto1, cantidad1);
END //

-- GET all promociones
CREATE PROCEDURE spObtenerPromociones()
BEGIN
	select p.id, p.nombre,p.descripcion,p.precioPuntos,p.fechaDesde,p.fechaHasta
    from promociones p;
END //

-- GET detalles de una promocion
CREATE PROCEDURE spObtenerDetallesPromocion(
	IN id int
)
BEGIN
    select dp.id , pr.nombre as nombreProducto,
    cantidad from detallepromocion dp
    join productos pr on pr.id = dp.idProducto
    where idPromocion = id;
END //

-- GET promociones vigentes
CREATE PROCEDURE spObtenerPromocionesVigentes()
BEGIN 
    SELECT * from promociones
    where now() between fechaDesde and fechaHasta;
END //

-- Actualizar estado de pedido
CREATE PROCEDURE spActualizarEstadoPedido(
	IN idEstado1 int,
    IN idPedido1 int
)
BEGIN
	UPDATE chocolateriaDB.pedidos set idEstado = idEstado1 where id = idPedido1;
END //

-- Canjear promocion
CREATE PROCEDURE spCanjearPuntos(
	IN idPromocion1 int,
    IN idSocio1 int
)
BEGIN
	SELECT id, precioPuntos INTO @idPromo, @puntosConsumidos
    FROM promociones WHERE id = idPromocion1;
	INSERT INTO movimientospuntos (idPromocion, idSocio, puntos)
    values (@idPromo, idSocio1, @puntosConsumidos);
    SET @idMov := last_insert_id();
    
    SELECT id INTO @idPV FROM puntosventa WHERE nombre = 'Web';
    SELECT id INTO @idEst FROM estadospedido WHERE nombre = 'Pagado';
    INSERT INTO pedidos (idPuntoVenta, idSocio, idEstado, observaciones, fechaPedido)
    values (@idPV, idSocio1, @idEst, CONCAT('Según movimiento con ID ', @idMov), NOW());
END //

-- Editar promoción
CREATE PROCEDURE spEditarPromocion(
	IN idPromocion1 int,
    IN nombre1 varchar(50),
    IN descripcion1 varchar(100),
    IN precioPuntos1 mediumint,
    IN fechaDesde1 datetime,
    IN fechaHasta1 datetime
)
BEGIN
	UPDATE promociones SET nombre = nombre1,
    descripcion = descripcion1, precioPuntos = precioPuntos1,
    fechaDesde = fechaDesde1, fechaHasta = fechaHasta1
    WHERE id = idPromocion1;
END //

-- Terminar promoción
CREATE PROCEDURE spTerminarPromocion(
	IN idPromocion1 int
)
BEGIN
	UPDATE promociones
    SET fechaHasta = NOW()
    WHERE id = idPromocion1;
END //

##################### EMPLEADOS #####################

-- NEW
CREATE PROCEDURE spRegistrarEmpleado(
IN idUsuario1 int,
IN nombre1 varchar(30),
IN apellido1 varchar(30),
IN telefono1 varchar(50),
IN email1 varchar(40),
IN dni1 int
)
BEGIN
    INSERT INTO socios (idUsuario, nombre, apellido,domicilio,email,dni,telefono,fechaAlta)
    VALUES (idUsuario1,nombre1,apellido1,telefono1,email1,dni1,NOW());
END //


##################### TIPOS DE PAGO #####################
-- GET all tipos de pago
CREATE PROCEDURE spObtenerTiposPago()
BEGIN
	select id,nombre from tipospago;
END //

-- POST cobro
CREATE PROCEDURE spCobrar(
IN idPedido1 int,
IN idTipoPago1 int,
IN idEmpleado1 int,
IN codigoAutorizacion1 int,
IN montoCobrado1 double
)
BEGIN 
	INSERT INTO cobros(idPedido,idTipoPago,idEmpleado,fechaCobro,codigoAutorizacion,montoCobrado) 
    VALUES (idPedido1,idTipoPago1,idEmpleado1,NOW(),codigoAutorizacion1,montoCobrado1);
    UPDATE pedidos set idEstado = 2 where id=idPedido1;
END //

-- GET all estados de pedido
CREATE PROCEDURE spObtenerEstadosPedido()
BEGIN
	select id,nombre from estadosPedido;
END //

-- GET puntos by idSocio
CREATE PROCEDURE spObtenerPuntosDeSocio(
    IN idSocio1 int
)
BEGIN
	select ifnull(a.puntosPositivos,0) - ifnull(b.puntosNegativos,0) as puntos
        from (
            select idSocio, sum(puntos) as puntosPositivos
            from movimientospuntos
            where idSocio = idSocio1
            and idDetallePedido is not null
            group by idSocio
        ) as a left join 
        (
            select idSocio, sum(puntos) as puntosNegativos
            from movimientospuntos
            where idSocio = idSocio1
            and idPromocion is not null
            group by idSocio
        ) as b
        on a.idSocio = b.idSocio;
END //

DELIMITER ;

-- TRIGGER sumar puntos a socio
DELIMITER $$
CREATE TRIGGER after_cobros_insert
AFTER INSERT
ON cobros FOR EACH ROW
BEGIN
	SELECT idSocio INTO @idSocio
    FROM pedidos 
    WHERE id = NEW.idPedido;
    IF @idSocio IS NOT NULL THEN
        INSERT INTO movimientospuntos (idDetallePedido, idSocio, puntos) 
        SELECT idDetalle, @idSocio, puntosGanados
		FROM detallespedido 
		WHERE idPedido = NEW.idPedido;
    END IF;
END$$;

DELIMITER ;


