--1. INSERT
--1.1. Без указания списка полей
	INSERT INTO student VALUES ('Ivan', 'Petrov', 'Faculty of Informatics and Computer Engineering', 'Software Engineering', 2);
--1.2. С указанием списка полей
	INSERT INTO physical_norm (norm_name, passed_date, min_recuirements)
	VALUES ('Run 100m', '06.05.2020', '14,4sec');
--1.3. С чтением значения из другой таблицы
	INSERT INTO result (id_student) SELECT id_student FROM student;
	
--2. DELETE
--2.1. Всех записей
	DELETE physical_norm;
--2.2. По условию
	DELETE FROM student WHERE course > 3;
--2.3. Очистить таблицу
	TRUNCATE TABLE result;

--3. UPDATE
--3.1. Всех записей 
	UPDATE facility SET quantity = 10;
--3.2. По условию обновляя один атрибут
	UPDATE facility SET quality = 'Good' WHERE facility_name = 'Jump rope';
--3.3. По условию обновляя несколько атрибутов
	UPDATE physical_norm SET name = 'Running jump', min_recuirements = '3,84m' WHERE date = '01.03.2020';

--4. SELECT
--4.1. С определенным набором извлекаемых атрибутов
	SELECT faculty, specialty FROM student;
--4.2. Со всеми атрибутами
	SELECT * FROM result;
--4.3. С условием по атрибуту
	SELECT * FROM gym WHERE gym_address = 'Gagarina 12';

--5. SELECT ORDER BY + TOP (LIMIT)
--5.1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
	SELECT * FROM gym ORDER BY number ASC;
--5.2. С сортировкой по убыванию DESC
	SELECT * FROM result ORDER BY mark DESC;
--5.3. С сортировкой по двум атрибутам + ограничение вывода количества записей
	SELECT TOP 3 * FROM student ORDER BY specialty DESC, course DESC;
--5.4. С сортировкой по первому атрибуту, из списка извлекаемых
	SELECT * FROM facility ORDER BY 1 DESC;

--6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
-- 6.1 WHERE по дате
	SELECT * FROM physical_norm WHERE passed_date = '01.03.2020';
-- 6.2 Извлечь из таблицы не всю дату, а только год.
	SELECT YEAR(passed_date) from physical_norm;

--7. SELECT GROUP BY с функциями агрегации 
--7.1. MIN
	SELECT faculty, MIN(course) AS min_course FROM student GROUP BY faculty;
--7.2. MAX
	SELECT id_student, MAX(mark) AS max_mark FROM result GROUP BY id_student;
--7.3. AVG
	SELECT id_norm, AVG(mark) AS avg_mark FROM result GROUP BY id_norm;
--7.4. SUM
	SELECT facility_name, SUM(quantity) AS sum_quantity FROM facility GROUP BY facility_name;
--7.5. COUNT
	SELECT gym_address, COUNT(number) AS count_number FROM gym GROUP BY gym_address;

--8. SELECT GROUP BY + HAVING
--8.1. Написать 3 разных запроса с использованием GROUP BY + HAVING
	SELECT id_student, id_norm FROM result GROUP BY id_norm HAVING mark > 4;
	SELECT COUNT(area) AS count_small_gym, area FROM gym GROUP BY area HAVING area < 1008;
	SELECT norm_name, MAX(id_gym) AS max_gym FROM physical_norm GROUP BY norm_name HAVING norm_name = 'Running jump';

--9. SELECT JOIN
--9.1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT id_norm, mark, first_name, second_name FROM result 
		LEFT JOIN student ON result.id_student = student.id_student WHERE mark = 5;
--9.2. RIGHT JOIN
	SELECT number, gym_address, facility_name, quantity FROM facility 
		RIGHT JOIN gym ON gym.id_facility = facility.id_facility ORDER BY number ASC;
--9.3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT second_name, norm_name, mark FROM student
	LEFT JOIN result ON student.id_student = result.id_student
	LEFT JOIN physical_norm ON physical_norm.id_norm = result.id_norm
	WHERE physical_norm.norm_name = 'Run 100m' and student.specialty = 'Software Engineering' and result.mark < 4;
--9.4. FULL OUTER JOIN двух таблиц
	SELECT norm_name, gym_address FROM physical_norm FULL OUTER JOIN gym ON gym.id_gym = physical_norm.id_gym;

--10. Подзапросы
--10.1. Написать запрос с WHERE IN (подзапрос)
SELECT first_name, second_name, course FROM student WHERE id_student IN (SELECT id_student FROM result WHERE mark = 4);
--10.2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT norm_name, passed_date, (SELECT gym_address FROM gym INNER JOIN physical_norm ON gym.id_gym = physical_norm.id_gym) AS norm_address FROM physical_norm;