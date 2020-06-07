-- 1. Добавить внешние ключи
ALTER TABLE booking ADD FOREIGN KEY (id_client) REFERENCES client (id_client)
ALTER TABLE room ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel)
ALTER TABLE room ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category)
ALTER TABLE room_in_booking  ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking)
ALTER TABLE room_in_booking  ADD FOREIGN KEY (id_room) REFERENCES room (id_room)

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г
SELECT client.id_client, client.name, client.phone FROM client 
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
WHERE hotel.name = 'Космос' AND room_category.name = 'Люкс' AND room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date >= '2019-04-01'

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля
SELECT room.id_room, room.id_hotel, room.id_room_category, room.number FROM room 
LEFT JOIN (SELECT id_room FROM room_in_booking WHERE room_in_booking.checkin_date <= '2019-04-22' 
AND room_in_booking.checkout_date > '2019-04-22') AS taken_room ON room.id_room = taken_room.id_room
WHERE taken_room.id_room IS NULL

-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
SELECT room_category.name, COUNT(client.name) AS count_client FROM client 
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
WHERE hotel.name = 'Космос' AND room_in_booking.checkin_date <= '2019-03-23' AND room_in_booking.checkout_date > '2019-03-23'
GROUP BY room_category.name

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда
SELECT client.name, room.number, room_in_booking.checkout_date FROM client
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room_in_booking.id_room = room.id_room
INNER JOIN (SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS last_date FROM 
(SELECT * FROM room_in_booking WHERE room_in_booking.checkout_date BETWEEN '2019-04-01' AND '2019-04-30') 
AS room_in_booking GROUP BY room_in_booking.id_room) AS last_taken_room ON last_taken_room.id_room = room_in_booking.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' AND room_in_booking.id_room = last_taken_room.id_room AND last_taken_room.last_date = room_in_booking.checkout_date

--6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая
UPDATE room_in_booking
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM hotel
INNER JOIN room ON room.id_hotel = hotel.id_hotel
INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room
WHERE hotel.name = 'Космос' AND room_category.name = 'Бизнес' AND room_in_booking.checkin_date = '2019-05-10'

--7. Найти все "пересекающиеся" варианты проживания
SELECT * FROM room_in_booking person1, room_in_booking person2
WHERE person1.id_room_in_booking != person2.id_room_in_booking AND person1.id_room = person2.id_room 
AND person1.checkin_date <= person2.checkin_date AND person1.checkout_date > person2.checkin_date

--8. Создать бронирование в транзакции
BEGIN TRANSACTION
	INSERT INTO client VALUES ('Киселева Дарья Андреевна', '7(917)-704-10-98')
	INSERT INTO booking VALUES (SCOPE_IDENTITY(), '2020-05-10')
	INSERT INTO room_in_booking VALUES(SCOPE_IDENTITY(), 4, '2020-06-04', '2020-07-04')
COMMIT

--9. Добавить необходимые индексы для всех таблиц
CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON [dbo].[booking]
(
	[id_client] ASC
) 
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON [dbo].[room_in_booking]
(
	[id_booking] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON [dbo].[room_in_booking]
(
	[id_room] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_id_hotel] ON [dbo].[room]
(
	[id_hotel] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON [dbo].[room]
(
	[id_room_category] ASC
)
CREATE NONCLUSTERED INDEX [IX_hotel_name] ON [dbo].[hotel]
(
	[name] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_category_name] ON [dbo].[room_category]
(
	[name] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkin_date] ON [dbo].[room_in_booking]
(
	[checkin_date] ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkout_date] ON [dbo].[room_in_booking]
(
	[checkout_date] ASC
)