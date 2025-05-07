-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-05-2025 a las 17:18:47
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `burger_house`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes`
--

CREATE TABLE `ordenes` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','preparando','completada','cancelada') DEFAULT 'pendiente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ordenes`
--

INSERT INTO `ordenes` (`id`, `fecha`, `total`, `estado`, `created_at`) VALUES
(1, '2025-04-30 22:52:28', 130.00, 'pendiente', '2025-05-01 04:52:28'),
(2, '2025-04-30 23:06:03', 215.00, 'pendiente', '2025-05-01 05:06:03'),
(3, '2025-04-30 23:09:16', 235.00, 'pendiente', '2025-05-01 05:09:16'),
(4, '2025-05-06 06:47:42', 130.00, 'pendiente', '2025-05-06 12:47:42'),
(5, '2025-05-06 07:39:16', 225.00, 'pendiente', '2025-05-06 13:39:16'),
(6, '2025-05-06 07:50:35', 240.00, 'pendiente', '2025-05-06 13:50:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_detalles`
--

CREATE TABLE `orden_detalles` (
  `id` int(11) NOT NULL,
  `orden_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `orden_detalles`
--

INSERT INTO `orden_detalles` (`id`, `orden_id`, `producto_id`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 4, 1, 130.00),
(2, 2, 1, 1, 120.00),
(3, 2, 11, 1, 25.00),
(4, 2, 16, 1, 70.00),
(5, 3, 6, 1, 125.00),
(6, 3, 11, 1, 25.00),
(7, 3, 15, 1, 85.00),
(8, 4, 4, 1, 130.00),
(9, 5, 6, 1, 125.00),
(10, 5, 14, 1, 75.00),
(11, 5, 10, 1, 25.00),
(12, 6, 4, 1, 130.00),
(13, 6, 11, 1, 25.00),
(14, 6, 15, 1, 85.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `categoria`, `imagen`, `activo`) VALUES
(1, 'Hamburguesa Clásica', 'Carne 100% de res, queso cheddar, lechuga, tomate y salsa especial', 120.00, 'Hamburguesas', 'slider1.png', 1),
(2, 'Mega Burger', 'Doble carne, doble queso, tocino, aros de cebolla y salsa BBQ', 180.00, 'Hamburguesas', 'slider2.png', 1),
(3, 'Chicken Burger', 'Pechuga de pollo empanizada, queso suizo, lechuga romana y mayonesa especial', 150.00, 'Hamburguesas', 'slider3.png', 1),
(4, 'Burrito Supreme', 'Extra grande con carne, frijoles, queso, pico de gallo y guacamole', 130.00, 'Burritos', 'food4.png', 1),
(5, 'Burrito Jalapeño', 'Picante con jalapeños, carne, queso y salsa especial', 145.00, 'Burritos', 'food5.png', 1),
(6, 'Burrito Veggie', '100% vegetariano con frijoles, arroz, vegetales asados y guacamole', 125.00, 'Burritos', 'food6.png', 1),
(7, 'Papas Supreme', 'Con queso, tocino y jalapeños', 95.00, 'Complementos', 'food7.png', 1),
(8, 'Aros de Cebolla', 'Crujientes con salsa ranch', 85.00, 'Complementos', 'food8.png', 1),
(9, 'Nachos Especiales', 'Con queso fundido, guacamole, pico de gallo y crema', 110.00, 'Complementos', 'food9.png', 1),
(10, 'Coca-Cola', 'Bebida refrescante 500ml', 25.00, 'Bebidas', 'cocacola.png', 1),
(11, 'Sprite', 'Bebida refrescante lima-limón 500ml', 25.00, 'Bebidas', 'sprite.jpg', 1),
(12, 'Fanta', 'Bebida refrescante de naranja 500ml', 25.00, 'Bebidas', 'fanta.jpg', 1),
(13, 'Té Frío', 'Té helado de limón o durazno 500ml', 30.00, 'Bebidas', 'tefrio.jpg', 1),
(14, 'Sundae de Chocolate', 'Helado de vainilla con salsa de chocolate y crema batida', 75.00, 'Postres', 'SundaedeChocolate.jpg', 1),
(15, 'Cheesecake', 'Con salsa de frutos rojos y galleta', 85.00, 'Postres', 'chiskeei.jpg', 1),
(16, 'Brownie', 'Con helado de vainilla y salsa de caramelo', 70.00, 'Postres', 'brownie.jpg', 1),
(17, 'Combo Clásico', 'Hamburguesa Clásica + Papas + Bebida', 180.00, 'Combos', 'comboclasico.jpg', 1),
(18, 'Combo Familiar', '2 Hamburguesas + 2 Burritos + 2 Papas + 4 Bebidas', 450.00, 'Combos', 'combofamiliar.jpg', 1),
(19, 'Combo Mega', 'Mega Burger + Papas Supreme + Aros de Cebolla + Bebida + Postre', 320.00, 'Combos', 'combomega.jpg', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `orden_detalles`
--
ALTER TABLE `orden_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orden_id` (`orden_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `orden_detalles`
--
ALTER TABLE `orden_detalles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `orden_detalles`
--
ALTER TABLE `orden_detalles`
  ADD CONSTRAINT `orden_detalles_ibfk_1` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`),
  ADD CONSTRAINT `orden_detalles_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
