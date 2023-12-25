--1. Показать все книги, количество страниц в которых больше 500, но меньше 650.
SELECT * FROM books WHERE Pages > 500 AND Pages < 650;

--2. Показать все книги, в которых первая буква названия либо «А», либо «З».
SELECT * FROM books
WHERE Name LIKE '[А-З]%';

--3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров.
SELECT books.Name, COUNT(s.BookId) as Quantity
FROM books
JOIN sales s ON books.id = s.BookId
JOIN themes t ON books.ThemeId = t.id
WHERE t.Name = 'Детектив'
GROUP BY books.Name
HAVING COUNT(s.BookId) > 30

--4. Показать все книги, в названии которых есть слово «Microsoft», но нет слова «Windows».
SELECT * FROM books
WHERE Name NOT LIKE '%Windows%' AND Name LIKE '%Microsoft%';

--5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек.
SELECT books.Name, t.Name, CONCAT(a.Name, a.Surname) AS AllName, books.Price
FROM books
INNER JOIN themes t ON books.ThemeId = t.id
INNER JOIN authors a ON books.AuthorId = a.id
WHERE books.Price < 65;

--6. Показать все книги, название которых состоит из 4 слов.
SELECT * FROM books
WHERE Name LIKE '% % % %';

--7. Показать информацию о продажах в следующем виде:
--▷ Название книги, но, чтобы оно не содержало букву «А».
--▷ Тематика, но, чтобы не «Программирование».
--▷ Автор, но, чтобы не «Герберт Шилдт».
--▷ Цена, но, чтобы в диапазоне от 10 до 20 гривен.
--▷ Количество продаж, но не менее 8 книг.
--▷ Название магазина, который продал книгу, но он не должен быть в Украине или России.
SELECT b.Name 
FROM books b 
INNER JOIN sales s ON s.Bookid=b.id
WHERE b.Name NOT LIKE '%А%'
 
SELECT b.Name 
FROM books b  
INNER JOIN themes t ON t.id=b.ThemeId
WHERE t.Name != 'Программирование'
 
SELECT b.Name 
FROM books b  
INNER JOIN authors a ON a.id=b.AuthorId
WHERE CONCAT_WS(' ',a.Name,a.Surname) != N'Герберт Шилдт'

SELECT b.Name 
FROM books b 
INNER JOIN sales s ON s.Bookid =b.AuthorId
WHERE s.Price between 10 and 20

SELECT sh.Name AS "Название магазина", b.Name AS "Название книги"
FROM sales s
INNER JOIN shops sh ON s.ShopId = sh.Id
INNER JOIN books b ON s.BookId = b.id
WHERE sh.CountryId NOT IN (1, 4);  -- 1 потому, что нет в списке Украины

--8. Показать следующую информацию в два столбца (числа в правом столбце приведены в качестве примера):
--▷ Количество авторов: 14
--▷ Количество книг: 47
--▷ Средняя цена продажи: 85.43 грн.
--▷ Среднее количество страниц: 650.6.
SELECT 'Количество авторов' , COUNT(DISTINCT AuthorId) FROM books
UNION ALL
SELECT 'Количество книг', COUNT(*) FROM books
UNION ALL
SELECT 'Средняя цена продажи', AVG(Price) FROM books
UNION ALL
SELECT 'Среднее количество страниц', AVG(Pages) FROM books;

--9. Показать тематики книг и сумму страниц всех книг по каждой из них.
SELECT t.Name, SUM(books.Pages) AS "Сумма страниц"
FROM books
JOIN themes t ON books.ThemeId = t.id
GROUP BY t.Name;

--10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов.
SELECT a.Name, COUNT(*) AS "Количество книг", SUM(books.Pages) AS "Сумма страниц"
FROM books
JOIN authors a ON books.AuthorId = a.id
GROUP BY a.Name;

--11. Показать книгу тематики «Программирование» с наибольшим количеством страниц.
SELECT b.id, b.Name, b.Pages
FROM books b
JOIN themes t ON b.ThemeId = t.id
WHERE t.Name = 'Программирование'
AND b.Pages = (SELECT MAX(Pages) FROM books WHERE ThemeId = t.id);

--12. Показать среднее количество страниц по каждой тематике, которое не превышает 400.
SELECT t.Name, AVG(books.Pages) AS "Среднее количество страниц"
FROM books
JOIN themes t ON books.ThemeId = t.id
GROUP BY t.Name
HAVING AVG(books.Pages) <= 400;

--13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400, и чтобы тематики были «Программирование», «Администрирование» и «Дизайн».
SELECT t.Name, SUM(books.Pages) AS "Сумма страниц"
FROM books
JOIN themes t ON books.ThemeId = t.id
WHERE t.Name IN ('Программирование', 'Детектив', 'Роман') AND books.Pages > 400  -- «Администрирование» и «Дизайн» не нашла
GROUP BY t.Name;

--14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано.
SELECT sales.id, sh.Name, b.Name, sales.Quantity, sales.SaleDate, c.Name
FROM sales
JOIN shops sh ON sales.Shopid = sh.id
JOIN books b ON sales.Bookid = b.id
JOIN countries c ON sh.CountryId = c.id;

--15. Показать самый прибыльный магазин.
SELECT TOP 1 sh.Name, SUM(b.Price * sales.Quantity) AS "Общая прибыль"
FROM sales
JOIN shops sh ON sales.Shopid = sh.id
JOIN books b ON sales.Bookid = b.id
GROUP BY sh.Name
ORDER BY SUM(b.Price * sales.Quantity) DESC;

