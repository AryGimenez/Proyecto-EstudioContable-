CREATE DATABASE `contaduria`;

--creacion de la tabla pagos
CREATE TABLE `contaduria`.`pagos` (
    `id_pago` INT NOT NULL AUTO_INCREMENT ,
    `pago_fecha` VARCHAR(45) NOT NULL ,
    `pago_monto` VARCHAR(45) NOT NULL , 
    `pago_cliente` VARCHAR(45) NOT NULL , 
    `pago_impuesto` VARCHAR(45) NOT NULL , 
    `id_impuesto` INT NOT NULL ,            
    
    PRIMARY KEY (`id_pago`) 
) ENGINE = InnoDB;

--creacion de la tabla 'nombre_impuesto'
CREATE TABLE `contaduria`.`nombre_impuesto` (
    `id_nombre_impuesto` INT NOT NULL AUTO_INCREMENT , 
    `nombre_impuesto` VARCHAR(45) NOT NULL , 

    PRIMARY KEY (`id_nombre_impuesto`)
) ENGINE = InnoDB;

--creacion de la tabla 'alerta'
CREATE TABLE `contaduria`.`alerta` (
    `id_alerta` INT NOT NULL AUTO_INCREMENT , 
    `ale_dias_antes` INT NULL , 
    `ale_fecha` DATE NOT NULL , 
    `ale_mensaje` VARCHAR(45) NOT NULL , 
    `ale_id_dias_antes` INT NOT NULL ,      

    PRIMARY KEY (`id_alerta`)
) ENGINE = InnoDB;

--creacion de la tabla 'eventos'
CREATE TABLE `contaduria`.`eventos` (
    `id_alerta` INT NOT NULL, 

    PRIMARY KEY (`id_alerta`)
) ENGINE = InnoDB;

--creacion de la tabla 'vencimientos'
CREATE TABLE `contaduria`.`vencimientos` (
    `id_alerta` INT NOT NULL, 
    `id_impuesto` INT NOT NULL, 

    PRIMARY KEY (`id_alerta`)
) ENGINE = InnoDB;

--creacion de la tabla 'usuarios'
CREATE TABLE `contaduria`.`usuarios` (
    `id_usuario` INT NOT NULL AUTO_INCREMENT ,
    `nombre_usuario` VARCHAR(45) NOT NULL , 
    `email_usuario` VARCHAR(45) NOT NULL , 
    `contraseña_usuario` VARCHAR(45) NOT NULL , 
    `rol_usuario` VARCHAR(45) NOT NULL , 
    
    PRIMARY KEY (`id_usuario`)
) ENGINE = InnoDB;


--creacion de la tabla 'clientes'
CREATE TABLE `contaduria`.`clientes` (
    `id_cliente` INT NOT NULL AUTO_INCREMENT , 
    `nombre_cliente` VARCHAR(45) NOT NULL , 
    `direccion_cliente` VARCHAR(45) NULL , 
    `email_cliente` VARCHAR(45) NULL , 
    `whatsapp_cliente` VARCHAR(45) NULL , 
    `dato_contacto_cliente` VARCHAR(45) NULL , 
    `fecha_nas_cliente` DATE NOT NULL , 
    
    PRIMARY KEY (`id_cliente`)
) ENGINE = InnoDB;


--creacion de la tabla 'impuestos'
CREATE TABLE `contaduria`.`impuestos` (
    `id_impuesto` INT NOT NULL AUTO_INCREMENT , 
    `monto_impuesto` FLOAT NOT NULL , 
    `moneda_impuesto` VARCHAR(45) NULL , 
    `ferecuencia_impuesto` ENUM('diario','quincenal','mensual','anual') NOT NULL , 
    `dia_impuesto` VARCHAR(45) NULL , 
    `vencimiento_impuesto` VARCHAR(45) NOT NULL , 
    `id_cliente` INT NOT NULL , 
    `id_nombre_impuesto` INT NOT NULL , 
    `id_subimpuesto` INT NULL , 
    
    PRIMARY KEY (`id_impuesto`)
) ENGINE = InnoDB;

----------------------------    RELACIONES--(FK)    --------------------------------------------

--fk de impuestos en pagos
ALTER TABLE `contaduria`.`pagos` ADD CONSTRAINT `impuestos_impuesto_id_pagos` 
FOREIGN KEY (`id_impuesto`) REFERENCES `impuestos`(`id_impuesto`) 
ON DELETE NO ACTION ON UPDATE NO ACTION;

--fk de cliente en impuesto
ALTER TABLE `contaduria`.`impuestos` ADD CONSTRAINT `cliente_id_cliente_impuestos`
FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id_cliente`) 
ON DELETE NO ACTION ON UPDATE NO ACTION;

--fk de nombre_impuesto en impuesto
ALTER TABLE `contaduria`.`impuestos` ADD CONSTRAINT `nombre_imp_id_nombre_impuesto_impuesto` 
FOREIGN KEY (`id_nombre_impuesto`) REFERENCES `nombre_impuesto`(`id_nombre_impuesto`) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

--fk de impuestos en vencimientos
ALTER TABLE `contaduria`.`vencimientos` ADD CONSTRAINT `fk_vencimientos_impuesto` 
FOREIGN KEY (`id_impuesto`) REFERENCES `impuestos`(`id_impuesto`) 
ON DELETE NO ACTION ON UPDATE NO ACTION;

--fk de alerta en vencimientos
ALTER TABLE `contaduria`.`vencimientos` ADD CONSTRAINT `fk_vencimientos_alerta` 
FOREIGN KEY (`id_alerta`) REFERENCES `alerta`(`id_alerta`) 
ON DELETE CASCADE ON UPDATE CASCADE;

--fk de alerta en eventos
ALTER TABLE `contaduria`.`eventos` ADD CONSTRAINT `fk_eventos_alerta` 
FOREIGN KEY (`id_alerta`) REFERENCES `alerta`(`id_alerta`) 
ON DELETE CASCADE ON UPDATE CASCADE;

----------------------------------------------------------------------------------------------
