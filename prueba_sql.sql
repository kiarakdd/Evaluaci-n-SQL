#desactiva los foreign key para poder eliminar tablas y las vuelve a activar con el 1 luego de eliminarlas
SET FOREIGN_KEY_CHECKS = 0;
drop table evaluacionsql_schema.facturas;
drop table evaluacionsql_schema.clientes;
drop table evaluacionsql_schema.libro_contable;
drop table evaluacionsql_schema.boletas;
drop table evaluacionsql_schema.proveedores;
drop table evaluacionsql_schema.compras;
drop table evaluacionsql_schema.ventas;
drop table evaluacionsql_schema.productos;

#no olvidar activar :)

SET FOREIGN_KEY_CHECKS = 1;

CREATE SCHEMA IF NOT EXISTS evaluacionsql_schema;

CREATE TABLE `evaluacionsql_schema`.`clientes`(
`id_cliente` INT NOT NULL AUTO_INCREMENT,
`rut` VARCHAR(12) NOT NULL,
`nombre`  VARCHAR(80) NOT NULL, 
`apellido`  VARCHAR(80) NOT NULL,
PRIMARY KEY (`id_cliente`));

CREATE TABLE `evaluacionsql_schema`.`proveedores`(
`id_proveedor` INT NOT NULL AUTO_INCREMENT,
`nombre`  VARCHAR(80) NOT NULL,
`rut` VARCHAR(12) NOT NULL,
PRIMARY KEY (`id_proveedor`));

CREATE TABLE `evaluacionsql_schema`.`compras`(
`id_compra` INT NOT NULL AUTO_INCREMENT,
`id_proveedor` INT NOT NULL,
`cantidad_productos` INT NOT NULL,
`nombre`  VARCHAR(80) NOT NULL,
`categoria`  VARCHAR(80) NOT NULL,
`fecha_compra` DATE NOT NULL,
PRIMARY KEY (`id_compra`),
foreign key (`id_proveedor`) references `evaluacionsql_schema`.`proveedores` (`id_proveedor`));

CREATE TABLE `evaluacionsql_schema`.`facturas`(
`id_factura` INT NOT NULL AUTO_INCREMENT,
`id_compra` INT NOT NULL,
`fecha_emision` DATE  NOT NULL,
`total_unidad`  float NOT NULL,
`total_neto`  float NOT NULL,
`total_ivacf` float NOT NULL,
`total` float NOT NULL,
PRIMARY KEY (`id_factura`),
FOREIGN KEY (`id_compra`) references `evaluacionsql_schema`.`compras` (`id_compra`));


CREATE TABLE `evaluacionsql_schema`.`productos`(
`id_producto` INT NOT NULL AUTO_INCREMENT,
`id_compra` INT NULL, 
`precio` FLOAT NOT NULL,
PRIMARY KEY (`id_producto`),
FOREIGN KEY (`id_compra`) references `evaluacionsql_schema`.`compras` (`id_compra`));

CREATE TABLE `evaluacionsql_schema`.`ventas`(
`id_venta` INT NOT NULL AUTO_INCREMENT,
`id_producto` INT NOT NULL,
`id_cliente` INT NOT NULL,
`fecha_venta` DATE  NOT NULL,
`cantidad` INT NOT NULL,
PRIMARY KEY (`id_venta`),
FOREIGN KEY (`id_producto`) references `evaluacionsql_schema`.`productos` (`id_producto`),
FOREIGN KEY (`id_cliente`) references `evaluacionsql_schema`.`clientes` (`id_cliente`));


CREATE TABLE `evaluacionsql_schema`.`boletas`(
`id_boleta` INT NOT NULL AUTO_INCREMENT,
`id_venta` INT NOT NULL,
`fecha_emision` DATE  NOT NULL,
`total_neto`  float NOT NULL,
`total_ivadf` float NOT NULL,
`total` float NOT NULL,
PRIMARY KEY (`id_boleta`),
FOREIGN KEY (`id_venta`) references `evaluacionsql_schema`.`ventas` (`id_venta`));


CREATE TABLE `evaluacionsql_schema`.`libro_contable`(
`id_libro_contable` INT NOT NULL AUTO_INCREMENT,
`id_factura`  INT NOT NULL, 
`id_boleta`  INT NOT NULL, 
PRIMARY KEY (`id_libro_contable`),
FOREIGN KEY (`id_factura`) references `evaluacionsql_schema`.`facturas` (`id_factura`),
FOREIGN KEY (`id_boleta`) references `evaluacionsql_schema`.`boletas` (`id_boleta`)); 

#compras y ventas llevan fechas por lo que no era necesario replicar el campo de fecha por los fk, pero volvi a 
#replicar las fechas en facturas y boletas por temas contables.

#no especificaron si las ganancias que en un futuro quería poder extraer eran bruta(con iva), o neta
#comente a hector esto, así que aclaro que considere iva, ya que, ganacia bruta o neta se podran obtener

INSERT INTO evaluacionsql_schema.proveedores (nombre, rut) 
VALUES ('abarrotes spaa', '24.244.244-4'),
('lacteos spa', '25.555.244-8'),
('de todo spa', '22.222.244-8'),
('botanas spa', '26.666.244-8');

INSERT INTO evaluacionsql_schema.compras (id_proveedor, cantidad_productos, nombre, categoria, fecha_compra)
VALUES (1, 50, 'arroz', 'abarrotes', '2021-01-01'),
(1, 20, 'fideos', 'abarrotes', '2021-02-01'),
(3, 100, 'caramelo', 'confiteria', '2021-03-01'),
(2, 20, 'leche', 'lacteos', '2021-04-01'),
(4, 10, 'semillas', 'botanas', '2021-05-01'),
(3, 40, 'coca-cola', 'bebidas', '2021-06-01');

INSERT INTO evaluacionsql_schema.facturas
VALUES (1, 1, '2021-01-01',2000, 100000, 19000, 119000),
(2, 2, '2021-02-01', 1500, 30000, 5700, 35700),
(3, 3, '2021-03-01', 100, 10000, 1900, 11900),
(4, 4, '2021-04-01', 1000, 20000, 3800, 23800),
(5, 5, '2021-05-01', 1500, 15000, 2850, 17850),
(6, 6, '2021-06-01', 750, 30000, 5700, 35700);

INSERT INTO evaluacionsql_schema.productos (id_compra, precio)
VALUES (1, 5000), (2, 5000), (3, 5000), (4, 5000), (5, 5000), (6, 7500);

INSERT INTO evaluacionsql_schema.clientes
VALUES (1, '21.111.111-1', 'ruben', 'perez'), (2, '22.111.111-1', 'belen', 'gomez'), (3, '23.111.111-1', 'jose', 'diaz');

INSERT INTO evaluacionsql_schema.ventas (id_producto, id_cliente, fecha_venta, cantidad)
VALUES (1, 1, '2021-01-05', 100), (2, 2, '2021-02-01', 50), (4, 1, '2021-03-01', 100);

INSERT INTO evaluacionsql_schema.boletas (id_venta, fecha_emision, total_neto, total_ivadf, total)
VALUES (1, '2021-01-05', 420168, 79832, 500000), (2, '2021-02-01', 210084, 39916, 250000), (3, '2021-02-01', 420168, 79832, 500000);



SELECT compras.nombre, compras.cantidad_productos, proveedores.nombre, proveedores.rut
FROM evaluacionsql_schema.compras
LEFT JOIN evaluacionsql_schema.proveedores on evaluacionsql_schema.compras.id_proveedor = evaluacionsql_schema.proveedores.id_proveedor
WHERE proveedores.nombre = 'de todo spa';


SET sql_safe_updates=0;
