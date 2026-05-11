-- Создание базы данных
USE master;
GO
DROP DATABASE IF EXISTS DentalClinicGraph;
GO
CREATE DATABASE DentalClinicGraph;
GO
USE DentalClinicGraph;
GO

-- ============================================
-- ТАБЛИЦЫ УЗЛОВ (NODE)
-- ============================================

-- Узел: Клиент
CREATE TABLE Client
(
    id         INT          NOT NULL PRIMARY KEY,
    full_name  NVARCHAR(70) NOT NULL,
    birth_date DATE         NOT NULL,
    phone      NVARCHAR(20)
) AS NODE;
GO

-- Узел: Врач
CREATE TABLE Doctor
(
    id               INT          NOT NULL PRIMARY KEY,
    full_name        NVARCHAR(70) NOT NULL,
    speciality       NVARCHAR(50) NOT NULL,
    experience_years INT
) AS NODE;
GO

-- Узел: Услуга
CREATE TABLE Service
(
    id               INT            NOT NULL PRIMARY KEY,
    name             NVARCHAR(100)  NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    duration_minutes INT
) AS NODE;
GO

-- Узел: Материал
CREATE TABLE Material
(
    id            INT            NOT NULL PRIMARY KEY,
    name          NVARCHAR(70)   NOT NULL,
    unit          NVARCHAR(20)   NOT NULL,
    cost_per_unit DECIMAL(10, 2) NOT NULL
) AS NODE;
GO

-- ============================================
-- ТАБЛИЦЫ РЁБЕР (EDGE) с ограничениями CONNECTION
-- ============================================

-- Ребро: Клиент использует Услугу
CREATE TABLE UsedService
(
    cost             DECIMAL(10, 2) NOT NULL,
    service_date     DATE           NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0
) AS EDGE;
GO
ALTER TABLE UsedService
    ADD CONSTRAINT EC_UsedService CONNECTION(Client TO SERVICE);
GO

-- Ребро: Врач оказывает Услугу
CREATE TABLE ProvidedService
(
    service_date DATE NOT NULL,
    rating       TINYINT CHECK (rating BETWEEN 1 AND 10),
    notes        NVARCHAR(200)
) AS EDGE;
GO
ALTER TABLE ProvidedService
    ADD CONSTRAINT EC_ProvidedService CONNECTION(Doctor TO SERVICE);
GO

-- Ребро: Услуга требует Материал
CREATE TABLE ServiceRequiresMaterial
(
    quantity      DECIMAL(8, 2)  NOT NULL,
    material_cost DECIMAL(10, 2) NOT NULL
) AS EDGE;
GO
ALTER TABLE ServiceRequiresMaterial
    ADD CONSTRAINT EC_ServiceRequiresMaterial CONNECTION(SERVICE TO Material);
GO



-- ============================================
-- ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ (по 10+ записей)
-- ============================================

-- Клиенты
INSERT INTO Client (id, full_name, birth_date, phone)
VALUES (1, N'Иванов Иван Иванович', '1985-03-15', '+7-900-111-22-33'),
       (2, N'Петрова Мария Сергеевна', '1990-07-22', '+7-900-222-33-44'),
       (3, N'Сидоров Пётр Александрович', '1978-11-30', '+7-900-333-44-55'),
       (4, N'Козлова Анна Владимировна', '1995-01-18', '+7-900-444-55-66'),
       (5, N'Смирнов Дмитрий Олегович', '1982-09-05', '+7-900-555-66-77'),
       (6, N'Волкова Екатерина Игоревна', '1993-04-12', '+7-900-666-77-88'),
       (7, N'Новиков Алексей Павлович', '1987-12-25', '+7-900-777-88-99'),
       (8, N'Морозова Ольга Николаевна', '1991-06-08', '+7-900-888-99-00'),
       (9, N'Лебедев Артём Викторович', '1989-02-14', '+7-900-999-00-11'),
       (10, N'Соколова Юлия Андреевна', '1996-08-20', '+7-900-000-11-22');
GO

-- Врачи
INSERT INTO Doctor (id, full_name, speciality, experience_years)
VALUES (1, N'Алексеева Ирина Петровна', N'Терапевт', 12),
       (2, N'Борисов Павел Сергеевич', N'Хирург', 18),
       (3, N'Егоров Константин Владимирович', N'Имплантолог', 15),
       (4, N'Жукова Светлана Михайловна', N'Ортодонт', 10),
       (5, N'Иванов Михаил Александрович', N'Пародонтолог', 8),
       (6, N'Крылова Анна Дмитриевна', N'Детский стоматолог', 14),
       (7, N'Леонтьев Игорь Викторович', N'Ортопед', 20),
       (8, N'Медведева Елена Сергеевна', N'Гигиенист', 6),
       (9, N'Николаев Андрей Петрович', N'Челюстно-лицевой хирург', 22),
       (10, N'Орлова Татьяна Ивановна', N'Эндодонтист', 11);
GO

-- Услуги
INSERT INTO Service (id, name, price, duration_minutes)
VALUES (1, N'Первичный осмотр', 500.00, 30),
       (2, N'Лечение кариеса (1 поверхность)', 2500.00, 45),
       (3, N'Профессиональная чистка', 3500.00, 60),
       (4, N'Удаление зуба', 4000.00, 40),
       (5, N'Имплантация (1 имплант)', 45000.00, 120),
       (6, N'Установка брекет-системы', 60000.00, 180),
       (7, N'Отбеливание зубов', 15000.00, 90),
       (8, N'Лечение пульпита', 5500.00, 60),
       (9, N'Протезирование коронкой', 25000.00, 90),
       (10, N'Рентген зуба', 800.00, 10);
GO

-- Материалы
INSERT INTO Material (id, name, unit, cost_per_unit)
VALUES (1, N'Анестетик Ультракаин', N'ампула 2мл', 150.00),
       (2, N'Композитный пломбировочный материал', N'шприц 4г', 2500.00),
       (3, N'Коффердам', N'шт', 350.00),
       (4, N'Бор алмазный', N'шт', 450.00),
       (5, N'Титановый имплант', N'шт', 25000.00),
       (6, N'Керамическая коронка', N'шт', 12000.00),
       (7, N'Брекет металлический', N'шт', 1500.00),
       (8, N'Отбеливающий гель', N'шприц 3мл', 3000.00),
       (9, N'Штифт стекловолоконный', N'шт', 800.00),
       (10, N'Пломбировочная паста', N'туба 20г', 1200.00);
GO

-- ============================================
-- ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР
-- ============================================

-- UsedService: Клиент → Услуга
INSERT INTO UsedService ($from_id, $to_id, cost, service_date, discount_percent)
SELECT (SELECT $node_id FROM Client WHERE id = c_id),
       (SELECT $node_id FROM SERVICE WHERE id = s_id),
       cost_val,
       svc_date,
       disc
FROM (VALUES (1, 1, 500.00, '2024-01-15', 0),
             (1, 2, 2500.00, '2024-02-10', 10),
             (2, 3, 3500.00, '2024-01-20', 0),
             (2, 8, 5500.00, '2024-03-05', 5),
             (3, 4, 4000.00, '2024-02-28', 0),
             (3, 5, 45000.00, '2024-04-12', 15),
             (4, 6, 60000.00, '2024-03-18', 0),
             (5, 7, 15000.00, '2024-01-30', 20),
             (6, 9, 25000.00, '2024-04-01', 0),
             (7, 10, 800.00, '2024-02-14', 0),
             (8, 1, 500.00, '2024-03-22', 0),
             (9, 2, 2500.00, '2024-04-05', 0),
             (10, 3, 3500.00, '2024-01-25', 10)) AS data(c_id, s_id, cost_val, svc_date, disc);
GO

-- ProvidedService: Врач → Услуга
INSERT INTO ProvidedService ($from_id, $to_id, service_date, rating, notes)
SELECT (SELECT $node_id FROM Doctor WHERE id = d_id),
       (SELECT $node_id FROM SERVICE WHERE id = s_id),
       svc_date,
       rating_val,
       notes_txt
FROM (VALUES (1, 1, '2024-01-15', 9, N'Пациент доволен'),
             (1, 2, '2024-02-10', 8, N'Стандартное лечение'),
             (2, 4, '2024-02-28', 10, N'Сложное удаление, успешно'),
             (3, 5, '2024-04-12', 10, N'Имплантация прошла отлично'),
             (4, 6, '2024-03-18', 9, N'Установка брекетов'),
             (5, 3, '2024-01-20', 8, N'Профгигиена'),
             (6, 1, '2024-03-22', 10, N'Осмотр ребёнка'),
             (7, 9, '2024-04-01', 9, N'Протезирование'),
             (8, 7, '2024-01-30', 10, N'Отбеливание'),
             (9, 4, '2024-02-14', 8, N'Удаление зуба мудрости'),
             (10, 8, '2024-03-05', 9, N'Лечение каналов')) AS data(d_id, s_id, svc_date, rating_val, notes_txt);
GO

-- ServiceRequiresMaterial: Услуга → Материал
INSERT INTO ServiceRequiresMaterial ($from_id, $to_id, quantity, material_cost)
SELECT (SELECT $node_id FROM SERVICE WHERE id = s_id),
       (SELECT $node_id FROM Material WHERE id = m_id),
       qty_val,
       mat_cost
FROM (VALUES (2, 1, 2.0, 300.00),    -- Лечение кариеса → Анестетик
             (2, 2, 3.0, 7500.00),   -- Лечение кариеса → Композит
             (2, 3, 1.0, 350.00),    -- Лечение кариеса → Коффердам
             (4, 1, 3.0, 450.00),    -- Удаление → Анестетик
             (4, 4, 2.0, 900.00),    -- Удаление → Бор
             (5, 1, 4.0, 600.00),    -- Имплантация → Анестетик
             (5, 5, 1.0, 25000.00),  -- Имплантация → Имплант
             (6, 7, 20.0, 30000.00), -- Брекеты → Брекеты
             (7, 8, 2.0, 6000.00),   -- Отбеливание → Гель
             (8, 1, 2.0, 300.00),    -- Пульпит → Анестетик
             (8, 9, 1.0, 800.00),    -- Пульпит → Штифт
             (9, 6, 1.0, 12000.00) -- Коронка → Коронка
     ) AS data(s_id, m_id, qty_val, mat_cost);
GO


-- ============================================
-- ЗАПРОСЫ С ФУНКЦИЕЙ MATCH (5+ запросов)
-- ============================================

-- 🔹 Запрос 1: Какие услуги получал клиент "Иванов Иван" и кто их оказывал?
-- Цепочка: Client → UsedService → Service ← ProvidedService ← Doctor
SELECT c.full_name     AS Клиент,
       s.name          AS Услуга,
       us.cost         AS Стоимость,
       us.service_date AS Дата,
       d.full_name     AS Врач,
       ps.rating       AS Оценка_работы
FROM Client AS c,
     UsedService AS us,
     Service AS s,
     ProvidedService AS ps,
     Doctor AS d
WHERE MATCH(c - (us) - > s < -(ps) - d)
  AND c.full_name = N'Иванов Иван Иванович';
GO

-- 🔹 Запрос 2: Какие материалы использовались при лечении кариеса
-- и кто из врачей проводил такие процедуры?
-- Цепочка: Service → ServiceRequiresMaterial → Material + Doctor → ProvidedService → Service
SELECT s.name       AS Услуга,
       m.name       AS Материал,
       srm.quantity AS Количество,
       d.full_name  AS Врач,
       ps.rating    AS Средняя_оценка
FROM Service AS s,
     ServiceRequiresMaterial AS srm,
     Material AS m,
     ProvidedService AS ps,
     Doctor AS d
WHERE MATCH(s - (srm) - > m)
  AND MATCH(d - (ps) - > s)
  AND s.name LIKE N'%кариес%';
GO

-- 🔹 Запрос 3: Найти всех клиентов, которые получали услуги от врачей
-- со стажем более 15 лет, и какие это были услуги
-- Цепочка: Client → UsedService → Service ← ProvidedService ← Doctor
SELECT DISTINCT c.full_name        AS Клиент,
                c.phone            AS Телефон,
                d.full_name        AS Врач,
                d.experience_years AS Стаж_врача,
                s.name             AS Услуга,
                us.service_date    AS Дата_услуги
FROM Client AS c,
     UsedService AS us,
     Service AS s,
     ProvidedService AS ps,
     Doctor AS d
WHERE MATCH(c - (us) - > s < -(ps) - d)
  AND d.experience_years > 15
ORDER BY us.service_date DESC;
GO

-- 🔹 Запрос 4: Рассчитать общую стоимость материалов для каждой услуги,
-- которую оказывал врач "Борисов Павел Сергеевич"
-- Цепочка: Doctor → ProvidedService → Service → ServiceRequiresMaterial → Material
SELECT s.name                                AS Услуга,
       SUM(srm.material_cost * srm.quantity) AS Общая_стоимость_материалов,
       COUNT(DISTINCT m.id)                  AS Кол_видов_материалов
FROM Doctor AS d,
     ProvidedService AS ps,
     Service AS s,
     ServiceRequiresMaterial AS srm,
     Material AS m
WHERE MATCH(d - (ps) - > s - (srm) - > m)
  AND d.full_name = N'Борисов Павел Сергеевич'
GROUP BY s.name
ORDER BY Общая_стоимость_материалов DESC;
GO

-- 🔹 Запрос 5: Найти клиентов, которые получали услуги с оценкой врача 10 баллов,
-- и какие материалы при этом использовались
-- Цепочка: Client → UsedService → Service ← ProvidedService ← Doctor + Service → ServiceRequiresMaterial → Material
SELECT c.full_name  AS Клиент,
       s.name       AS Услуга,
       ps.rating    AS Оценка,
       m.name       AS Использованный_материал,
       srm.quantity AS Количество
FROM Client AS c,
     UsedService AS us,
     Service AS s,
     ProvidedService AS ps,
     Doctor AS d,
     ServiceRequiresMaterial AS srm,
     Material AS m
WHERE MATCH(c - (us) - > s < -(ps) - d)
  AND MATCH(s - (srm) - > m)
  AND ps.rating = 10
ORDER BY c.full_name, s.name;
GO

-- 🔹 Запрос 6 (дополнительный): Статистика по врачам —
-- сколько услуг оказали, средний рейтинг, общая выручка от их услуг
SELECT d.full_name                   AS Врач,
       d.speciality                  AS Специальность,
       COUNT(DISTINCT ps.$edge_id)   AS Оказано_услуг,
       AVG(CAST(ps.rating AS FLOAT)) AS Средний_рейтинг,
       SUM(us.cost)                  AS Общая_выручка
FROM Doctor AS d,
     ProvidedService AS ps,
     Service AS s,
     UsedService AS us,
     Client AS c
WHERE MATCH(d - (ps) - > s < -(us) - c)
GROUP BY d.id, d.full_name, d.speciality
ORDER BY Общая_выручка DESC;
GO


-- ============================================
-- ЗАПРОСЫ С ФУНКЦИЕЙ SHORTEST_PATH (2+ запроса)
-- ============================================

-- 🔹 Запрос SP1: Найти кратчайший путь от клиента к материалам,
-- Путь: Client → UsedService → Service → ServiceRequiresMaterial → Material
-- Используем шаблон "+" для поиска кратчайшего пути любой длины
SELECT c.full_name                                         AS Клиент,
       STRING_AGG(s.name, ' → ') WITHIN GROUP (GRAPH PATH) AS Пройденные_услуги,
       LAST_VALUE(m.name) WITHIN GROUP (GRAPH PATH)        AS Итоговый_материал,
       LAST_VALUE(srm.quantity) WITHIN GROUP (GRAPH PATH)  AS Количество
FROM Client AS c,
     UsedService FOR PATH AS us, SERVICE FOR PATH AS s, ServiceRequiresMaterial FOR PATH AS srm, Material FOR PATH AS m
WHERE MATCH(SHORTEST_PATH(c(-(us)-
    > s -(srm)-
    > m)+))
  AND c.full_name = N'Иванов Иван Иванович'
GO

-- 🔹 Запрос SP2: Найти все возможные связи клиента с врачами
-- на глубину не более 3 шагов (шаблон "{1,3}")
-- Путь может включать: Клиент→Услуга←Врач или Клиент→Услуга→Материал←Услуга←Врач и т.д.

-- Упрощённый вариант: Клиент → Услуга ← Врач (максимум 3 шага)
DECLARE @TargetClient NVARCHAR(70) = N'Петрова Мария Сергеевна';

SELECT c.full_name                                         AS Стартовый_клиент,
       STRING_AGG(s.name, ' → ') WITHIN GROUP (GRAPH PATH) AS Услуги_на_пути,
       LAST_VALUE(d.full_name) WITHIN GROUP (GRAPH PATH)   AS Найденный_врач,
       LAST_VALUE(ps.rating) WITHIN GROUP (GRAPH PATH)     AS Рейтинг_услуги
FROM Client AS c,
     UsedService FOR PATH AS us, SERVICE FOR PATH AS s, ProvidedService FOR PATH AS ps, Doctor FOR PATH AS d
WHERE MATCH(SHORTEST_PATH(c(-(us)-
    > s
    <-(ps)- d){1
    , 3}))
  AND c.full_name = @TargetClient
GO

-- 🔹 Запрос SP3 (упрощённый): -- Находим кратчайший путь от клиента к врачу через услуги
-- -- Шаблон: Клиент → Услуга ← Врач
--
SELECT c.full_name AS Клиент,
       s.name      AS Услуга,
       d.full_name AS Врач,
       ps.rating   AS Оценка,
       us.cost     AS Стоимость_для_клиента
FROM Client AS c,
     UsedService AS us,
     Service AS s,
     ProvidedService AS ps,
     Doctor AS d
WHERE MATCH(c - (us) - > s < -(ps) - d)
  AND c.id IN (1, 2, 3)
ORDER BY c.full_name, us.service_date;
GO


-- Показать ВСЕ услуги, через которые клиент связан с врачами (с агрегацией названий)
SELECT c.full_name                   AS Клиент,
       COUNT(DISTINCT s.id)          AS Кол_услуг,
       STRING_AGG(s.name, ', ')      AS Список_услуг,
       STRING_AGG(d.full_name, ', ') AS Врачи
FROM Client AS c,
     UsedService AS us,
     Service AS s,
     ProvidedService AS ps,
     Doctor AS d
WHERE MATCH(c - (us) - > s < -(ps) - d)
  AND c.full_name LIKE N'Иванов%'
GROUP BY c.full_name, c.$node_id;
GO





----------------------------------------------------
USE DentalClinicGraph;
GO

-- Объединяем все рёбра графа в одну таблицу для Power BI
SELECT
    'C_' + CAST(c.id AS NVARCHAR(10)) AS SourceID,
    c.full_name AS SourceName,
    'S_' + CAST(s.id AS NVARCHAR(10)) AS TargetID,
    s.name AS TargetName,
    CAST(us.cost AS DECIMAL(10,2)) AS Weight,
    N'Клиент → Услуга' AS RelationshipType
FROM Client c, UsedService us, Service s
WHERE MATCH(c-(us)->s)

UNION ALL

SELECT
    'D_' + CAST(d.id AS NVARCHAR(10)),
    d.full_name,
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    CAST(ps.rating AS DECIMAL(5,2)),
    N'Врач → Услуга'
FROM Doctor d, ProvidedService ps, Service s
WHERE MATCH(d-(ps)->s)

UNION ALL

SELECT
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    'M_' + CAST(m.id AS NVARCHAR(10)),
    m.name,
    srm.quantity,
    N'Услуга → Материал'
FROM Service s, ServiceRequiresMaterial srm, Material m
WHERE MATCH(s-(srm)->m);
GO

------------------------------------------------------------
USE DentalClinicGraph;
GO

-- Представление для клиентов
CREATE VIEW vw_ClientForPowerBI AS
SELECT id, full_name, birth_date, phone FROM Client;
GO

-- Представление для врачей
CREATE VIEW vw_DoctorForPowerBI AS
SELECT id, full_name, speciality, experience_years FROM Doctor;
GO

-- Представление для услуг
CREATE VIEW vw_ServiceForPowerBI AS
SELECT id, name, price, duration_minutes FROM Service;
GO

-- Представление для материалов
CREATE VIEW vw_MaterialForPowerBI AS
SELECT id, name, unit, cost_per_unit FROM Material;
GO

-- Единая таблица связей для Force-Directed Graph
CREATE VIEW vw_GraphEdgesForPowerBI AS
SELECT
    'C_' + CAST(c.id AS NVARCHAR(10)) AS SourceID,
    c.full_name AS SourceName,
    'S_' + CAST(s.id AS NVARCHAR(10)) AS TargetID,
    s.name AS TargetName,
    CAST(us.cost AS DECIMAL(10,2)) AS Weight,
    N'Клиент→Услуга' AS RelationshipType
FROM Client c, UsedService us, Service s WHERE MATCH(c-(us)->s)

UNION ALL

SELECT
    'D_' + CAST(d.id AS NVARCHAR(10)),
    d.full_name,
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    CAST(ps.rating AS DECIMAL(5,2)),
    N'Врач→Услуга'
FROM Doctor d, ProvidedService ps, Service s WHERE MATCH(d-(ps)->s)

UNION ALL

SELECT
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    'M_' + CAST(m.id AS NVARCHAR(10)),
    m.name,
    srm.quantity,
    N'Услуга→Материал'
FROM Service s, ServiceRequiresMaterial srm, Material m WHERE MATCH(s-(srm)->m);
GO


------------------------------------------------------
USE DentalClinicGraph;
GO

CREATE OR ALTER VIEW vw_ForceGraphComplete AS
SELECT
    'C_' + CAST(c.id AS NVARCHAR(10)) AS SourceID,
    c.full_name AS SourceName,
    'Клиент' AS SourceType,
    'S_' + CAST(s.id AS NVARCHAR(10)) AS TargetID,
    s.name AS TargetName,
    'Услуга' AS TargetType,
    CAST(us.cost AS DECIMAL(10,2)) AS Weight,
    N'Получил услугу' AS EdgeType,
    us.service_date AS EventDate
FROM Client c, UsedService us, Service s
WHERE MATCH(c-(us)->s)

UNION ALL

SELECT
    'D_' + CAST(d.id AS NVARCHAR(10)),
    d.full_name,
    'Врач',
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    'Услуга',
    CAST(ps.rating AS DECIMAL(5,2)),
    N'Оказал услугу',
    ps.service_date
FROM Doctor d, ProvidedService ps, Service s
WHERE MATCH(d-(ps)->s)

UNION ALL

SELECT
    'S_' + CAST(s.id AS NVARCHAR(10)),
    s.name,
    'Услуга',
    'M_' + CAST(m.id AS NVARCHAR(10)),
    m.name,
    'Материал',
    srm.quantity,
    N'Требует материал',
    NULL
FROM Service s, ServiceRequiresMaterial srm, Material m
WHERE MATCH(s-(srm)->m);
GO