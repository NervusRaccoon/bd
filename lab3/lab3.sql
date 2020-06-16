--1. INSERT
--1.1. Без указания списка полей
	INSERT INTO student VALUES ('Иван Петров', 'мужской', 19, 2);
--1.2. С указанием списка полей
	INSERT INTO physical_norm (name, min_recuirement, passed_result, mark)
	VALUES ('Прыжки в длину с разбега', '3,84м', '3,84м', 3);
--1.3. С чтением значения из другой таблицы
	INSERT INTO result (id_student) SELECT id_student FROM student;
	
--2. DELETE
--2.1. Всех записей
	DELETE physical_norm;
--2.2. По условию
	DELETE FROM student WHERE age > 20;
--2.3. Очистить таблицу
	TRUNCATE TABLE result;

--3. UPDATE
--3.1. Всех записей 
	UPDATE health_state SET inspection_date = '2019-11-30';
--3.2. По условию обновляя один атрибут
	UPDATE health_state SET doctor_name = 'Илья Киселев' WHERE inspection_date = '2019-11-29';
--3.3. По условию обновляя несколько атрибутов
	UPDATE gym SET gym_address = 'Гагарина 12', limit_students = 20 WHERE number = 2;

--4. SELECT
--4.1. С определенным набором извлекаемых атрибутов
	SELECT name, gender, age FROM student;
--4.2. Со всеми атрибутами
	SELECT * FROM result;
--4.3. С условием по атрибуту
	SELECT * FROM gym WHERE gym_address = 'Гагарина 12';

--5. SELECT ORDER BY + TOP (LIMIT)
--5.1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
	SELECT * FROM gym ORDER BY number ASC;
--5.2. С сортировкой по убыванию DESC
	SELECT * FROM physical_norm ORDER BY mark DESC;
--5.3. С сортировкой по двум атрибутам + ограничение вывода количества записей
	SELECT TOP 3 * FROM student ORDER BY name DESC, age DESC;
--5.4. С сортировкой по первому атрибуту, из списка извлекаемых
	SELECT * FROM health_state ORDER BY 1 DESC;

--6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
-- 6.1 WHERE по дате
	SELECT * FROM result WHERE completion_date = '01.03.2020';
-- 6.2 Извлечь из таблицы не всю дату, а только год.
	SELECT YEAR(inspection_date) from health_state;

--7. SELECT GROUP BY с функциями агрегации 
--7.1. MIN
	SELECT id_gym, MIN(limit_student) AS min_limit FROM gym GROUP BY id_gym;
--7.2. MAX
	SELECT id_student, MAX(age) AS max_age FROM student GROUP BY id_student;
--7.3. AVG
	SELECT name, AVG(mark) AS avg_mark FROM physical_norm GROUP BY name;
--7.4. SUM
	SELECT id_gym, SUM(limit_student) AS sum_limit_students FROM gym GROUP BY id_gym;
--7.5. COUNT
	SELECT gym_address, COUNT(number) AS count_number FROM gym GROUP BY gym_address;

--8. SELECT GROUP BY + HAVING
--8.1. Написать 3 разных запроса с использованием GROUP BY + HAVING
	SELECT id_student, COUNT(id_physical_norm) AS count_norm FROM result GROUP BY id_student HAVING COUNT(id_physical_norm) > 5; -- вывести id студентов, которые сдали больше 5 нормативов
	SELECT name, AVG(mark) AS avg_mark FROM physical_norm GROUP BY name HAVING AVG(mark) < 4; -- вывести список нормативов, средняя оценка которых меньше 4
	SELECT name, COUNT(name) AS count_same_name FROM student GROUP BY name HAVING COUNT(name) > 1; -- вывести людей, у которых совпадают имя и фамилия

--9. SELECT JOIN
--9.1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT student.name, health_state.medical_group FROM student
		LEFT JOIN health_state ON health_state.id_health_state = student.id_health_state WHERE student.age > 20; -- вывести имя и мед.группу студентов, возраст которых больше 20
--9.2. RIGHT JOIN
	SELECT student.id_student, student.name, id_physical_norm FROM result
		RIGHT JOIN student ON student.id_student = result.id_student WHERE student.age <= 22; -- вывести id норм, которые сдает студент не младше 22 лет
--9.3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT student.name, physical_norm.name, physical_norm.mark FROM result 
	LEFT JOIN student ON student.id_student = result.id_student
	LEFT JOIN physical_norm ON physical_norm.id_physical_norm = result.id_physical_norm
	WHERE student.age >= 19 AND physical_norm.mark > 3 AND result.completion_date IS NOT NULL; -- вывести имя, название нормы и оценку студентов старше 19
--9.4. FULL OUTER JOIN двух таблиц
	SELECT result.id_physical_norm, gym.gym_address, result.completion_date FROM result FULL OUTER JOIN gym ON gym.id_gym = result.id_gym; --

--10. Подзапросы
--10.1. Написать запрос с WHERE IN (подзапрос)
SELECT name, gender, age FROM student WHERE id_health_state IN (SELECT id_health_state FROM health_state WHERE medical_group = 'Общая медицинская группа'); -- вывести данные студента из общей мед. группы
--10.2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT number, gym_address, (SELECT id_physical_norm FROM result WHERE result.id_gym = gym.id_gym) AS id_norm FROM gym; -- вывести номер, адрес и id нормы, которые проводятся в спортзале
