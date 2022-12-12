SELECT p.BusinessEntityID, CONCAT(p.FirstName, ' ', COALESCE(p.MiddleName + ' ', ''), p.LastName) AS 'Name', em.EmailAddress
FROM Person.Person p
    LEFT JOIN Person.EmailAddress em ON em.BusinessEntityID = p.BusinessEntityID
WHERE p.EmailPromotion != 0
ORDER BY Name

SELECT p.BusinessEntityID, CONCAT(p.FirstName, ' ', COALESCE(p.MiddleName + ' ', ''), p.LastName) AS 'Name', COUNT(bea.AddressID)
FROM Person.Person p
    LEFT JOIN Person.BusinessEntityAddress bea ON bea.BusinessEntityID = p.BusinessEntityID
GROUP BY p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
HAVING COUNT(bea.AddressID) > 1
ORDER BY Name

SELECT p.ProductID, p.Name, avgp.AvgPrice
FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    LEFT JOIN
        (SELECT p.ProductID AS 'ProductID', AVG(sod.UnitPrice) AS 'AvgPrice'
        FROM Sales.SalesOrderDetail sod
            INNER JOIN Production.Product p ON p.ProductID = sod.ProductID
        GROUP BY p.ProductID) AS avgp
        ON p.ProductID = avgp.ProductID
