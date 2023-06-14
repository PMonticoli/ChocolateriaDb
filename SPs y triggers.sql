DELIMITER //
##################### USUARIOS #####################

-- Iniciar Sesion
CREATE PROCEDURE spIniciarSesion(
    IN usuario1 VARCHAR(30),
    IN contrasenia1 VARCHAR(32),
    IN aceptoTerminos BOOLEAN
)
BEGIN
    DECLARE role VARCHAR(30);
    DECLARE fechaBajaVal DATETIME;

    SELECT u1.fechaBaja INTO fechaBajaVal FROM Usuarios u1 WHERE u1.usuario = usuario1;

    IF (fechaBajaVal IS NOT NULL) THEN
        SELECT 'Usuario dado de baja' AS mensaje;
    ELSE
        SELECT r1.nombre INTO role FROM Usuarios u1
        JOIN Roles r1 ON r1.id = u1.idRol
        WHERE u1.usuario = usuario1 AND u1.contrasenia = contrasenia1;

        IF (role IS NULL) THEN
            SELECT 'Usuario y/o contraseña incorrectos' AS mensaje;
        ELSE
            IF (role <> 'Socio') THEN
                BEGIN
                    DECLARE aceptoTerminosVal BOOLEAN;
                    SELECT u1.aceptoTerminos INTO aceptoTerminosVal FROM Usuarios u1 WHERE u1.usuario = usuario1;

                    IF (aceptoTerminosVal OR aceptoTerminos) THEN
                        UPDATE Usuarios SET aceptoTerminos = TRUE WHERE usuario = usuario1;
                        SELECT u3.id,
                            em.id AS idEmpleado,
                            r3.nombre AS rol,
                            u3.usuario, u3.fechaAlta,
                            u3.fechaBaja,
                            '' AS mensaje
                        FROM Usuarios u3
                        JOIN Roles r3 ON r3.id = u3.idRol
                        JOIN Empleados em ON em.idUsuario = u3.id
                        WHERE u3.usuario = usuario1 AND u3.contrasenia = contrasenia1;
                    ELSE
                        SELECT 'Debes aceptar los Términos y condiciones' AS mensaje;
                    END IF;
                END;
            ELSE
                BEGIN
                    DECLARE aceptoTerminosVal BOOLEAN;
                    SELECT u1.aceptoTerminos INTO aceptoTerminosVal FROM Usuarios u1 WHERE u1.usuario = usuario1;

                    IF (aceptoTerminosVal OR aceptoTerminos) THEN
                        UPDATE Usuarios SET aceptoTerminos = TRUE WHERE usuario = usuario1;
                        SELECT u2.id,
                            so.id AS idSocio,
                            r2.nombre AS rol,
                            u2.usuario, u2.fechaAlta,
                            u2.fechaBaja,
                            '' AS mensaje
                        FROM Usuarios u2
                        JOIN Roles r2 ON r2.id = u2.idRol
                        JOIN Socios so ON so.idUsuario = u2.id
                        WHERE u2.usuario = usuario1 AND u2.contrasenia = contrasenia1;
                    ELSE
                        SELECT 'Debes aceptar los Términos y condiciones' AS mensaje;
                    END IF;
                END;
            END IF;
        END IF;
    END IF;
END//

-- Nuevo usuario socio
CREATE PROCEDURE spNuevoUsuarioSocio(
    IN usuario1 varchar(30),
    IN contrasenia1 varchar(32),
    IN dniSocio1 int
)
BEGIN
    -- Verificar si el usuario ya existe
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'El nombre de usuario ya existe. Ingrese otro.' AS error_message;
    END;

    IF EXISTS (SELECT 1 FROM usuarios WHERE usuario = usuario1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre de usuario ya existe.';
    ELSE
        SELECT id INTO @idSoc FROM roles WHERE nombre = 'Socio';
        INSERT INTO usuarios (idRol, usuario, contrasenia, fechaAlta) VALUES (@idSoc, usuario1, contrasenia1, NOW());
        UPDATE socios SET idUsuario = LAST_INSERT_ID() WHERE dni = dniSocio1 AND idUsuario IS NULL;
    END IF;
END//

-- Recuperar contraseña usuario
CREATE PROCEDURE spRecuperarPassword(
    IN usuario1 varchar(30),
    IN contrasenia1 varchar(32),
    IN dni1 int
)
BEGIN
    DECLARE rowsFound INT;
    DECLARE mensaje VARCHAR(100);

    SELECT COUNT(*) INTO rowsFound
    FROM Usuarios u
    INNER JOIN Socios s ON u.id = s.idUsuario
    WHERE u.usuario = usuario1 AND u.idRol = 1 AND s.dni = dni1;

    IF rowsFound > 0 THEN
        UPDATE Usuarios u
        INNER JOIN Socios s ON u.id = s.idUsuario
        SET u.contrasenia = contrasenia1
        WHERE u.usuario = usuario1 AND u.idRol = 1 AND s.dni = dni1;

        SET mensaje = 'Contraseña actualizada correctamente';
    ELSE
        SET mensaje = 'No se encontró ningún usuario con el nombre de usuario proporcionado o el DNI ingresado no coincide';
    END IF;

    SELECT mensaje AS mensaje;
END //

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
    SELECT id, nombre, precio, descripcion, observaciones, activo, disponible, puntosGanados, urlImagen,stock,fecha
	FROM productos
    ORDER BY nombre asc;
END //
-- GET ACTIVOS
CREATE PROCEDURE spObtenerProductosActivos()
BEGIN
    SELECT id, nombre, precio, descripcion, disponible, puntosGanados, urlImagen, stock
	FROM productos
    WHERE activo = true
    ORDER BY nombre asc;
END //

-- GET ACTIVOS FILTRADOS POR PRECIO
CREATE PROCEDURE spProductosFiltrados(
IN precioMin double,
IN precioMax double
)
BEGIN
    SELECT id, nombre, precio, descripcion, disponible, puntosGanados, urlImagen, stock
	FROM productos
    WHERE activo = true and precio between precioMin and precioMax
    ORDER BY precio asc;
END //

-- GET BY ID
CREATE PROCEDURE spObtenerProductoPorID(
	IN id int
)
BEGIN
    SELECT p.id, p.nombre, p.precio, p.descripcion, p.observaciones, p.activo, p.disponible, p.puntosGanados, p.urlImagen, p.stock
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
    VALUES (nom, pre, des, obs, true, true, pg, url);
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

-- UPDATE stock
CREATE PROCEDURE spActualizarStock(
    IN i INT,
    IN stock INT
)
BEGIN
    UPDATE productos 
    SET stock = stock,
        fecha = NOW()
    WHERE id = i;
END //




##################### PEDIDOS #####################
-- Registrar pedido
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

-- Registrar detalle pedido
-- DELIMITER $$
CREATE PROCEDURE spRegistrarDetallePedido(
 IN idPedido1 int, 
 IN idProducto1 int,
 IN cantidad1 tinyint,
 IN precioUnitario1 double,
 IN puntosGanados1 int,
 IN comentarios1 varchar(150)
)
BEGIN
  DECLARE stock_producto INT;
  
  START TRANSACTION;
  
  -- Verificar si el producto está disponible y hay suficiente stock
  SELECT disponible, stock INTO @disponible, @stock
  FROM Productos
  WHERE id = idProducto1;
  
  IF @disponible = 0 OR @stock < cantidad1 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no disponible o insuficiente stock';
  ELSE
    
    -- Registrar el detalle del pedido
    INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precioUnitario, puntosGanados)
    VALUES (idPedido1, idProducto1, cantidad1, 
    (SELECT precio FROM Productos WHERE id = idProducto1), 
    (SELECT puntosGanados FROM Productos WHERE id = idProducto1));
    
    -- Actualizar el stock del producto
    UPDATE Productos
    SET stock = stock - cantidad1
    WHERE id = idProducto1;
    
    COMMIT;
  END IF;
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
    where ep.id = 3 or ep.id = 4
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
    dp.puntosGanados, comentarios,p.observaciones from detallespedido dp
    join productos pr on pr.id = dp.idProducto join pedidos p on p.id = dp.idPedido
    where idPedido = id;
END //

-- Cancelar un pedido
CREATE PROCEDURE spCancelarPedido(
    IN idPedido INT
)
BEGIN
    DECLARE idCancel INT;
    DECLARE cantidadProductos INT;

    -- Obtener el id del estado "Cancelado"
    SELECT id INTO idCancel
    FROM estadospedido
    WHERE nombre = 'Cancelado';
    -- Actualizar el estado del pedido a "Cancelado"
    UPDATE pedidos
    SET idEstado = idCancel
    WHERE id = idPedido;
    -- Obtener la cantidad de productos en el pedido
    SELECT COUNT(*) INTO cantidadProductos
    FROM detallespedido
    WHERE idPedido = idPedido;
    -- Actualizar el stock de los productos cancelados
    UPDATE Productos p
    INNER JOIN detallespedido d ON p.id = d.idProducto
    SET p.stock = p.stock + d.cantidad
    WHERE d.idPedido = idPedido;

    -- Actualizar la disponibilidad de los productos cancelados
    UPDATE Productos p
    INNER JOIN detallespedido d ON p.id = d.idProducto
    SET p.disponible = TRUE
    WHERE d.idPedido = idPedido;

    -- Retornar la cantidad de productos cancelados
    SELECT cantidadProductos AS 'Cantidad de Productos Cancelados';
END//

-- Borrar un detalle por ID
CREATE PROCEDURE spBorrarDetalleId(
	IN idDetalle1 INT
)
BEGIN
	delete from detallespedido dp where dp.idDetalle = idDetalle1;
END //


CREATE PROCEDURE spObtenerPedidosPorFecha(
IN fechaDesde1 datetime,
IN fechaHasta1 datetime
)
BEGIN
    select *
    from pedidos p join detallespedido dt on p.id = dt.idPedido
    where p.fechaPedido between  fechaDesde1 and fechaHasta1
    order by fechaPedido desc;
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
	select id, dni, nombre, apellido,fechaBaja,idUsuario from socios;
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
	SELECT p.id, p.nombre,p.descripcion,p.precioPuntos,p.fechaDesde,p.fechaHasta
    FROM promociones p
    ORDER BY p.fechaHasta desc;
END //


CREATE PROCEDURE spObtenerDetallesPromocion(
	IN idMovimientoPuntos int
)
BEGIN
	SELECT pr.nombre as 'producto', dt.cantidad, m.puntos   
	FROM movimientospuntos m 
    JOIN promociones p ON m.idPromocion = p.id   
	JOIN detallepromocion dt ON p.id = dt.idPromocion   
	JOIN productos pr ON pr.id = dt.idProducto      
	WHERE m.id = idMovimientoPuntos;
END //

-- GET promociones vigentes
CREATE PROCEDURE spObtenerPromocionesDisponibles()
BEGIN 
    SELECT *
    FROM promociones p
    WHERE now() BETWEEN p.fechaDesde AND p.fechaHasta
    AND NOT EXISTS (
        SELECT *
        FROM DetallePromocion dp
        JOIN Productos pr ON dp.idProducto = pr.id
        WHERE dp.idPromocion = p.id AND dp.cantidad > (
            SELECT COALESCE(MIN(pr.stock), 0)
            FROM DetallePromocion dp2
            JOIN Productos pr ON dp2.idProducto = pr.id
            WHERE dp2.idPromocion = p.id AND dp2.idProducto = dp.idProducto
        )
    )
    ORDER BY p.fechaHasta asc;
END //

-- GET promociones canjeadas
CREATE PROCEDURE spObtenerPromocionesCanjeadas()
BEGIN
SELECT CONCAT(s.apellido,' ',s.nombre) as 'nombreSocio',m.id,
CONCAT(s.apellido,' ',s.nombre) as 'socio',p.nombre as 'promocion',p.nombre as 'nombrePromocion',
fechaMovimiento as 'fechaCanjeada'
FROM movimientospuntos m   
JOIN promociones p ON m.idPromocion = p.id   
JOIN socios s ON s.id = m.idSocio   
GROUP BY m.id,CONCAT(s.apellido,' ',s.nombre), p.nombre
ORDER BY m.id desc
LIMIT 0, 1000;
END //


-- Actualizar estado de pedido
CREATE PROCEDURE spActualizarEstadoPedido(
    IN idEstado1 INT,
    IN idPedido1 INT
)
BEGIN
    DECLARE cantidadProductos INT;

    -- Actualizar el estado del pedido
    UPDATE pedidos
    SET idEstado = idEstado1
    WHERE id = idPedido1;

    -- Verificar si el nuevo estado es "Cancelado"
    IF idEstado1 = (SELECT id FROM estadospedido WHERE nombre = 'Cancelado') THEN
        -- Obtener la cantidad de productos en el pedido
        SELECT COUNT(*) INTO cantidadProductos
        FROM detallespedido
        WHERE idPedido = idPedido1;

        -- Actualizar el stock de los productos cancelados
        UPDATE Productos p
        INNER JOIN detallespedido d ON p.id = d.idProducto
        SET p.stock = p.stock + d.cantidad
        WHERE d.idPedido = idPedido1;

        -- Actualizar la disponibilidad de los productos cancelados
        UPDATE Productos p
        INNER JOIN detallespedido d ON p.id = d.idProducto
        SET p.disponible = TRUE
        WHERE d.idPedido = idPedido1;

        -- Retornar la cantidad de productos cancelados
        SELECT cantidadProductos AS 'Cantidad de Productos Cancelados';
    END IF;
END//




-- Canjear promocion con actualizacion de stock
CREATE PROCEDURE spCanjearPuntos(
    IN idPromocion1 int,
    IN idSocio1 int
)
BEGIN
    -- Obtener los datos de la promoción
    SELECT id, precioPuntos INTO @idPromo, @puntosConsumidos
    FROM promociones WHERE id = idPromocion1;
    
    -- Verificar que hay suficiente stock para la promoción
    SELECT SUM(dp.cantidad) INTO @totalProductos
    FROM DetallePromocion dp
    WHERE dp.idPromocion = idPromocion1;
    
    IF @totalProductos IS NULL OR @totalProductos <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No hay productos disponibles para esta promoción.';
    END IF;
    
    -- Verificar que hay suficiente stock para los productos en la promoción
    SELECT COUNT(*) INTO @noStock
    FROM DetallePromocion dp
    JOIN Productos p ON dp.idProducto = p.id
    WHERE dp.idPromocion = idPromocion1 AND dp.cantidad > p.stock;
    
    IF @noStock > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No hay suficiente stock para los productos en esta promoción.';
    END IF;
    
    -- Insertar el registro de movimientospuntos
    INSERT INTO movimientospuntos (idPromocion, idSocio, puntos,fechaMovimiento)
    VALUES (@idPromo, idSocio1, @puntosConsumidos,now());
    
    -- Obtener el id del registro insertado en movimientospuntos
    SET @idMov := last_insert_id();
    


	-- Insertar el detalle de la promoción
	INSERT INTO DetallePromocion (idProducto, cantidad, idPromocion)
	SELECT idProducto, cantidad, idPromocion1
	FROM DetallePromocion
	WHERE idPromocion = idPromocion1
	  AND idProducto NOT IN (
		SELECT idProducto
		FROM DetallePromocion
		WHERE idPromocion = idPromocion1
		  AND idProducto IS NOT NULL
	  );

    
    -- Actualizar el stock de los productos
    UPDATE Productos p
    JOIN DetallePromocion dp ON p.id = dp.idProducto
    SET p.stock = p.stock - dp.cantidad
    WHERE dp.idPromocion = idPromocion1 AND p.stock >= dp.cantidad;
    
    -- Verificar que se actualizaron todos los productos
    SELECT ROW_COUNT() INTO @numActualizaciones;
    
    IF @numActualizaciones < @totalProductos THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No hay suficiente stock para los productos en esta promoción.';
    END IF;
    
    -- Obtener los ids de los puntos de venta y estados de pedido
    SELECT id INTO @idPV FROM puntosventa WHERE nombre = 'Web';
    SELECT id INTO @idEst FROM estadospedido WHERE nombre = 'Pagado';
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
CREATE PROCEDURE spFinalizarPromocion(
	IN idPromocion1 int
)
BEGIN
	UPDATE promociones
    SET fechaHasta = NOW()
    WHERE id = idPromocion1;
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


-- TRIGGER sumar puntos a socio
-- DELIMITER $$
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
-- END$$;
END //

##################### REPORTES #####################
-- Reporte ranking PRODUCTOS
-- Cantidad de veces que vendi un determinado producto y promedio de unidades vendidas por pedido
-- de cada producto 
CREATE PROCEDURE spRankingCantidadProd(
    IN fechaDesde DATETIME,
    IN fechaHasta DATETIME,
    IN limite INT
)
BEGIN
    SELECT 
        p.id, 
        p.nombre, 
        SUM(dt.cantidad) AS 'cantidad'
    FROM detallespedido dt 
    JOIN productos p ON dt.idProducto = p.id 
    JOIN pedidos pe ON dt.idPedido = pe.id AND pe.idEstado = (SELECT id FROM estadospedido WHERE nombre = 'Entregado')
    WHERE pe.fechaPedido BETWEEN fechaDesde AND fechaHasta
    GROUP BY p.id, p.nombre
    ORDER BY cantidad DESC
    LIMIT limite;
END//


CREATE PROCEDURE spRankingPromedioProd(
    IN fechaDesde DATETIME,
    IN fechaHasta DATETIME,
    IN limite INT
)
BEGIN
    SELECT 
        p.id, 
        p.nombre,  
        AVG(dt.cantidad) AS 'promedio'
    FROM detallespedido dt 
    JOIN productos p ON dt.idProducto = p.id 
    JOIN pedidos pe ON dt.idPedido = pe.id AND pe.idEstado = (SELECT id FROM estadospedido WHERE nombre = 'Entregado')
    WHERE pe.fechaPedido BETWEEN fechaDesde AND fechaHasta
    GROUP BY p.id, p.nombre
    ORDER BY promedio DESC
    LIMIT limite;
END//


-- Reportes PRODUCTOS
CREATE PROCEDURE spReporteCantidadProd(
    IN fechaDesde DATETIME,
    IN fechaHasta DATETIME 
)
BEGIN
    SELECT 
        p.id, 
        p.nombre, 
        SUM(dt.cantidad) AS 'cantidad'
    FROM detallespedido dt 
    JOIN productos p ON dt.idProducto = p.id 
    JOIN pedidos pe ON dt.idPedido = pe.id AND pe.idEstado IN (SELECT id FROM estadospedido WHERE nombre IN ('Entregado', 'Cancelado'))
    WHERE pe.fechaPedido BETWEEN fechaDesde AND fechaHasta
    GROUP BY p.id, p.nombre
    ORDER BY cantidad DESC;
END//


CREATE PROCEDURE spReportePromedioProd(
    IN fechaDesde DATETIME,
    IN fechaHasta DATETIME
)
BEGIN
    SELECT 
        p.id, 
        p.nombre,  
        AVG(dt.cantidad) AS 'promedio'
    FROM detallespedido dt 
    JOIN productos p ON dt.idProducto = p.id 
    JOIN pedidos pe ON dt.idPedido = pe.id AND pe.idEstado IN (SELECT id FROM estadospedido WHERE nombre IN ('Entregado', 'Cancelado'))
    WHERE pe.fechaPedido BETWEEN fechaDesde AND fechaHasta
    GROUP BY p.id, p.nombre
    ORDER BY promedio DESC;
END//


-- Reporte SOCIOS
-- Socios con mas puntos 
CREATE PROCEDURE spSociosConMasPuntos(
IN limite int
)
BEGIN
    select p.idSocio, CONCAT(s.apellido,' ',s.nombre) as 'socio', 
    s.dni, ifnull(p.puntosPositivos,0) - ifnull(n.puntosNegativos,0) as puntos
	from (
		select idSocio, sum(puntos) as puntosPositivos
		from movimientospuntos
		where idDetallePedido is not null
		group by idSocio
	) as p left join 
	(
		select idSocio, sum(puntos) as puntosNegativos
		from movimientospuntos
		where idPromocion is not null
		group by idSocio
	) as n
	on p.idSocio = n.idSocio 
	join socios s on p.idSocio = s.id
	order by puntos desc
	limit limite;
END //

-- Reporte SOCIOS
--  Cantidad de socios nuevos
CREATE PROCEDURE spSociosNuevos(
IN fechaDesde datetime,
IN fechaHasta datetime
)
BEGIN
	SELECT count(id) as 'cantSociosNuevos'
    FROM socios
    WHERE fechaAlta between fechaDesde and fechaHasta;
END //

-- Reporte SOCIOS
-- Cantidad de socios dados de baja en un determinado periodo 
CREATE PROCEDURE spSociosBaja(
IN fechaDesde datetime,
IN fechaHasta datetime
)
BEGIN
	SELECT count(id) as 'cantidadSociosBaja' 
	FROM socios
	WHERE fechaBaja is not null and fechaBaja between fechaDesde and fechaHasta;
END //

-- Reporte SOCIOS
-- Cantidad de pedidos por periodo que realizaron los socios
CREATE PROCEDURE spCantPedidosPeriodo(
    IN fechaDesde DATETIME,
    IN fechaHasta DATETIME
)
BEGIN
    SELECT s.id AS ID, CONCAT(s.apellido, ' ', s.nombre) AS 'socio', s.dni, COUNT(p.id) AS 'cantPedidos'
    FROM socios s
    JOIN pedidos p ON s.id = p.idSocio
    JOIN estadospedido ep ON p.idEstado = ep.id AND ep.nombre = 'Entregado'
    WHERE p.fechaPedido BETWEEN fechaDesde AND fechaHasta
    GROUP BY s.id, socio, dni
    ORDER BY cantPedidos DESC;
END//

-- Reporte PROMOCIONES
-- Cantidad de veces que se canjeo cada promocion
CREATE PROCEDURE spReportePromociones(
    IN fechaDesde1 DATETIME,
    IN fechaHasta1 DATETIME
)
BEGIN
    SELECT p.nombre AS 'nombrePromocion', p.descripcion, COUNT(DISTINCT mv.id) AS 'cantidadCanjeos'
    FROM promociones p
    JOIN detallepromocion dp ON p.id = dp.idPromocion
    JOIN movimientospuntos mv ON p.id = mv.idPromocion
    WHERE mv.fechaMovimiento BETWEEN fechaDesde1 AND fechaHasta1
    GROUP BY p.id, p.nombre, p.descripcion
    ORDER BY cantidadCanjeos DESC;
END //

-- Reporte COBROS
CREATE PROCEDURE spReporteCobros(
    IN fechaDesde datetime,
    IN fechaHasta datetime
)
BEGIN
    SELECT c.idTipoPago AS 'idTipoPago', tp.nombre, COUNT(tp.id) AS 'cantidadCobros', SUM(c.montoCobrado) AS 'totalCobro'
    FROM cobros c
    JOIN pedidos p ON c.idPedido = p.id
    JOIN estadospedido ep ON p.idEstado = ep.id AND ep.nombre = 'Entregado'
    JOIN tipospago tp ON c.idTipoPago = tp.id
    WHERE c.fechaCobro BETWEEN fechaDesde AND fechaHasta
    GROUP BY c.idTipoPago, tp.nombre
    ORDER BY totalCobro DESC;
END //

DELIMITER ;

