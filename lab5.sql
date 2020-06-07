--1. Добавить внешние ключи
ALTER TABLE [order] ADD FOREIGN KEY (id_production) REFERENCES production (id_production)
ALTER TABLE [order] ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer)
ALTER TABLE [order] ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy)
ALTER TABLE dealer ADD FOREIGN KEY (id_company) REFERENCES company (id_company)
ALTER TABLE production ADD FOREIGN KEY (id_company) REFERENCES company (id_company)
ALTER TABLE production ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine)

-- 2.Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов
SELECT pharmacy.name, [order].date, [order].quantity FROM [order]
INNER JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
INNER JOIN production ON production.id_production = [order].id_production
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус'

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января
SELECT medicine.name FROM medicine
INNER JOIN production ON production.id_medicine = medicine.id_medicine
INNER JOIN [order] ON [order].id_production = production.id_production
INNER JOIN company ON production.id_company = company.id_company
WHERE company.name = 'Фарма' 
AND production.id_production NOT IN (SELECT [order].id_production FROM [order] WHERE [order].date < '2019-01-25') 
GROUP BY medicine.name

--4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов
SELECT company.name, MIN(production.rating) AS min_rating, MAX(production.rating) AS max_rating FROM production
INNER JOIN [order] ON [order].id_production = production.id_production
INNER JOIN company ON production.id_company = company.id_company
GROUP BY company.name
HAVING COUNT([order].id_order) >= 120

--5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.Если у дилера нет заказов, в названии аптеки проставить NULL
SELECT dealer.name, pharmacy.name FROM dealer
LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer
LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
LEFT JOIN company ON dealer.id_company = company.id_company
WHERE company.name = 'AstraZeneca'

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней
UPDATE production
SET price = price*0.8
WHERE production.id_medicine IN (SELECT production.id_medicine FROM production
LEFT JOIN medicine ON medicine.id_medicine = production.id_medicine 
WHERE production.price > 3000 AND medicine.cure_duration <= 7) 

--7. Добавить необходимые индексы.
CREATE NONCLUSTERED INDEX [IX_production_id_company] ON production
(
	id_company ASC
) 
CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON production
(
	id_medicine ASC
) 
CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [order]
(
	id_production ASC
) 
CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [order]
(
	id_dealer ASC
)
CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [order]
(
	id_pharmacy ASC
)
CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON dealer
(
	id_company ASC
)
CREATE NONCLUSTERED INDEX [IX_medicine_name] ON medicine
(
	name ASC
)
CREATE NONCLUSTERED INDEX [IX_company_name] ON company
(
	name ASC
)
CREATE NONCLUSTERED INDEX [IX_order_date] ON [order]
(
	date ASC
)
CREATE NONCLUSTERED INDEX [IX_medicine_cure_duration] ON [medicine]
(
	cure_duration ASC
)