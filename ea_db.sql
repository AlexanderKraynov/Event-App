-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Апр 02 2020 г., 19:20
-- Версия сервера: 10.4.11-MariaDB
-- Версия PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+03:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `ea_db`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `bind_use_to_event` (IN `u_id` INT UNSIGNED, IN `e_id` INT UNSIGNED)  begin
    declare same int unsigned;
    select count(1) into same from event_participant_table where event_id = e_id and user_id = u_id;
    if same = 0 then
        insert into event_participant_table value (u_id, e_id);
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_custom_events` ()  begin
    select id from event_table where kudago_id is null;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_event_details` (IN `e_id` INT UNSIGNED)  begin
    select * from event_details_table where id = (
        select details_id from event_table where id = e_id
        );
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_event_participants` (IN `e_id` INT UNSIGNED)  begin
    select user_id from event_participant_table where event_id = e_id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_events` (IN `id` INT UNSIGNED)  BEGIN
    select event_id from event_participant_table where user_id = id;
end$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `add_user` (`foreign_user_id` INT UNSIGNED, `foreign_server_id` INT UNSIGNED) RETURNS INT(10) UNSIGNED BEGIN
	DECLARE count_same INT UNSIGNED;
    SELECT COUNT(1) 
    INTO count_same
    FROM user_table
    WHERE foreign_id = foreign_user_id AND foreign_server_id = foreign_server;
	IF count_same = 0 THEN
    	INSERT INTO user_table VALUE(NULL, foreign_user_id, foreign_server_id);
       	RETURN LAST_INSERT_ID();
    ELSE
    	RETURN 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `create_custom_event` (`_title` VARCHAR(120), `_brief` BLOB) RETURNS INT(10) UNSIGNED begin
    insert into event_details_table value (null, _title, _brief);
    insert into event_table value (null, null, last_insert_id());
    return last_insert_id();
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_event_from_kudago` (`k_id` INT UNSIGNED) RETURNS INT(10) UNSIGNED begin
    declare same int unsigned default 0;
    select kudago_id into same from event_table where kudago_id = k_id;
    if same = 0 then
        insert into event_table value (null, k_id, null);
        return last_insert_id();
    else
        return (select id from event_table where kudago_id = same);
    end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `event_details_table`
--

CREATE TABLE `event_details_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(120) NOT NULL,
  `brief` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `event_participant_table`
--

CREATE TABLE `event_participant_table` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `event_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `event_table`
--

CREATE TABLE `event_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `kudago_id` int(10) UNSIGNED DEFAULT NULL,
  `details_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `foreign_server_table`
--

CREATE TABLE `foreign_server_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `user_table`
--

CREATE TABLE `user_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `foreign_id` int(10) UNSIGNED NOT NULL,
  `foreign_server` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `event_details_table`
--
ALTER TABLE `event_details_table`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `event_participant_table`
--
ALTER TABLE `event_participant_table`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Индексы таблицы `event_table`
--
ALTER TABLE `event_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kudago_id` (`kudago_id`),
  ADD KEY `details_id` (`details_id`);

--
-- Индексы таблицы `foreign_server_table`
--
ALTER TABLE `foreign_server_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `address` (`address`);

--
-- Индексы таблицы `user_table`
--
ALTER TABLE `user_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `foreign_server` (`foreign_server`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `event_details_table`
--
ALTER TABLE `event_details_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `event_table`
--
ALTER TABLE `event_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `foreign_server_table`
--
ALTER TABLE `foreign_server_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `user_table`
--
ALTER TABLE `user_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `event_participant_table`
--
ALTER TABLE `event_participant_table`
  ADD CONSTRAINT `event_participant_table_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_table` (`id`),
  ADD CONSTRAINT `event_participant_table_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event_table` (`id`);

--
-- Ограничения внешнего ключа таблицы `event_table`
--
ALTER TABLE `event_table`
  ADD CONSTRAINT `details_id` FOREIGN KEY (`details_id`) REFERENCES `event_details_table` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_table`
--
ALTER TABLE `user_table`
  ADD CONSTRAINT `user_table_ibfk_1` FOREIGN KEY (`foreign_server`) REFERENCES `foreign_server_table` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
