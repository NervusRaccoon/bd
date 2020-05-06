--1. INSERT
--1.1. Без указания списка полей
	INSERT INTO student VALUES ('Ivan', 'Petrov', 'Faculty of Informatics and Computer Engineering', 'Software Engineering', 2);
--1.2. С указанием списка полей
	INSERT INTO physical_norm (name, passed_date, place)
	VALUES ('Run 30m', '06.05.2020', 'Gagarina 12');
--1.3. С чтением значения из другой таблицы
	INSERT INTO result (passed_date) SELECT passed_date FROM physical_norm;
	
--2. DELETE
--2.1. Всех записей
	DELETE teacher;
--2.2. По условию
	DELETE FROM student WHERE course > 1;
--2.3. Очистить таблицу
	TRUNCATE TABLE record_book;

--3. UPDATE
--3.1. Всех записей 
	UPDATE student SET second_name = 'Kozlov';
--3.2. По условию обновляя один атрибут
	UPDATE result SET rating = 5 WHERE passed_date = '01.03.2020';
--3.3. По условию обновляя несколько атрибутов
	UPDATE physical_norm SET name = 'Run 60m', place = 'Kirova 6' WHERE passed_date = '01.03.2020';

--4. SELECT
--4.1. С определенным набором извлекаемых атрибутов
	SELECT faculty, specialty FROM student;
--4.2. Со всеми атрибутами
	SELECT * FROM teacher;
--4.3. С условием по атрибуту
	SELECT * FROM physical_norm WHERE passed_date = '01.03.2020';

--5. SELECT ORDER BY + TOP (LIMIT)
--5.1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
	SELECT TOP 20 * FROM student ORDER BY second_name ASC;
--5.2. С сортировкой по убыванию DESC
	SELECT TOP 3 * FROM result ORDER BY rating DESC;
--5.3. С сортировкой по двум атрибутам + ограничение вывода количества записей
	SELECT * FROM physical_norm ORDER BY name DESC, passed_date DESC LIMIT 5;
--5.4. С сортировкой по первому атрибуту, из списка извлекаемых
	SELECT * FROM teacher ORDER BY 1 DESC;

--6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
-- 6.1 WHERE по дате
	SELECT * FROM physical_norm WHERE passed_date = '01.03.2020';
-- 6.2 Извлечь из таблицы не всю дату, а только год.
	SELECT EXTRACT(YEAR FROM passed_date) from result;

--7. SELECT GROUP BY с функциями агрегации 
--7.1. MIN
	SELECT second_name, MIN(course) AS min_course FROM student GROUP BY second_name;
--7.2. MAX
	SELECT second_name, MAX(course) AS max_course FROM student GROUP BY second_name;
--7.3. AVG
	SELECT second_name, AVG(course) AS avg_course FROM student GROUP BY second_name;
--7.4. SUM
	SELECT passed_date, SUM(rating) AS sum_rating FROM result GROUP BY passed_date;
--7.5. COUNT
	SELECT passed_date, COUNT(rating) AS count_rating FROM result GROUP BY passed_date;

--8. SELECT GROUP BY + HAVING
--8.1. Написать 3 разных запроса с использованием GROUP BY + HAVING
	SELECT passed_date FROM result GROUP BY id_result, rating HAVING MIN(rating) > 10;
	SELECT number, id_norm FROM record_book GROUP BY id_norm HAVING SUM(number) > 50;
	SELECT id_result, MAX(rating) AS max_rating FROM result GROUP BY id_result HAVING id_result < 100;

--9. SELECT JOIN
--9.1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT * FROM student LEFT JOIN teacher ON teacher.id_teacher = student.id_teacher WHERE second_name = 'Petrov';
--9.2. RIGHT JOIN
	SELECT * FROM student RIGHT JOIN teacher ON teacher.id_teacher = student.id_teacher ORDER BY name ASC;
--9.3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT student.id_student, teacher.id_teacher, record_book.id_record_book FROM record_book 
	LEFT JOIN student ON record_book.id_record_book = student.id_record_book
	LEFT JOIN teacher ON teacher.id_teacher = student.id_teacher
	WHERE buyer.id_buyer = 3 and "publisher".phone = '89276736461' and book.id_book = 128;
--9.4. FULL OUTER JOIN двух таблиц
	SELECT * FROM result FULL OUTER JOIN physical_norm ON result.id_result = physical_norm.id_result;

--10. Подзапросы
--10.1. Написать запрос с WHERE IN (подзапрос)
SELECT name, second_name FROM student WHERE course IN (1, 3);
--10.2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT id_result, rating FROM result WHERE MIN(rating) > 0;