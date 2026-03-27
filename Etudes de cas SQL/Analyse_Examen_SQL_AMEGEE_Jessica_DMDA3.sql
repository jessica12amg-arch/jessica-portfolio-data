---QUESTION 1 – Produits filtrés

-- Le service marketing souhaite identifier les produits destinés à une opération promotionnelle.

-- Ils recherchent des produits :

-- - dont le nom contient le mot "Bar"

-- - de classe "High"

-- - ayant un prix inférieur ou égal à 80 €

-- - et modifiés après le 1er janvier 2017

-- Affichez le nom, le prix, la classe et la date de modification.


SELECT p.ProductName, p.Price, p.Class, p.ModifyDate 
FROM products p 
WHERE p.ProductName LIKE '%Bar%'
AND p.Class = 'High'
AND p.Price <= 80
AND p.ModifyDate >= '2017-01-01'


---QUESTION 2 – Analyse des ventes par produit 

-- Le service commercial souhaite connaître le détail des ventes par produit.

-- Pour chaque vente, affichez :

-- - la date de vente

-- - le nom du produit

-- - la quantité vendue

-- - le prix unitaire

-- - et le montant total (quantité × prix)

SELECT s.SalesDate, p.ProductName, s.Quantity, p.Price, s.Quantity * p.Price  AS MontantTotal
FROM sales s 
JOIN products p 
ON p.ProductID = s.ProductID
GROUP BY p.ProductName 
ORDER BY MontantTotal DESC

-- QUESTION 3 – Classement des vendeurs 
-- La direction souhaite identifier les vendeurs ayant généré le plus de chiffre d'affaires.
-- Affichez, pour chaque vendeur :
-- - son id, prénom et nom
-- - le montant total des ventes
-- - uniquement si ce montant dépasse 300 €
-- Tri selon le total des ventes du plus élevé au plus faible.

SELECT e.EmployeeID, e.FirstName, e.LastName, SUM(s.Quantity*p.Price ) AS MontantVentes
FROM employees e 
JOIN sales s 
ON s.SalesPersonID = e.EmployeeID
JOIN products p
ON p.ProductID = s.ProductID
GROUP BY e.EmployeeID 
HAVING MontantVentes > 300
ORDER BY MontantVentes DESC

-- QUESTION 4 – Produits par pays 
-- Le service achats souhaite connaître les produits les plus vendus par pays.
-- Affichez :
-- - le pays
-- - le nom du produit
-- - le total des quantités vendues
-- Classez les résultats du plus vendu au moins vendu.

SELECT c3.CountryName, p.ProductName, SUM(s.Quantity ) AS TotalVendus
FROM products p
JOIN sales s 
ON s.ProductID = p.ProductID
JOIN customers c 
ON c.CustomerID = s.CustomerID
JOIN cities c2 
ON c2.CityID = c.CityID
JOIN countries c3 
ON c3.CountryID = c2.CountryID
GROUP BY c3.CountryName, p.ProductName 
ORDER BY TotalVendus DESC

---QUESTION 5 – Analyse croisée complète
-- La direction générale souhaite analyser les performances commerciales selon :
-- - le client (prénom + nom concaténés avec un espace)
-- - le vendeur (prénom + nom concaténés avec un espace)
-- - la ville du client
-- - le pays du client
-- Pour chaque groupe client + vendeur + ville + pays :
-- - Affichez le nombre total de ventes
-- - Calculez le chiffre d'affaires total (quantité × prix)
-- - Ne conservez que les groupes dont le chiffre d'affaires dépasse 200 €

SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS Client,
    CONCAT(e.FirstName, ' ', e.LastName) AS Vendeur,
    c2.CityName AS Ville,
    c3.CountryName AS Pays,
    COUNT(s.SalesID) AS NombreVentes,
    SUM(s.Quantity * p.Price) AS ChiffreAffaires
FROM customers c
JOIN sales s ON s.CustomerID = c.CustomerID
JOIN employees e ON e.EmployeeID = s.SalesPersonID
JOIN products p ON p.ProductID = s.ProductID
JOIN cities c2 ON c2.CityID = c.CityID
JOIN countries c3 ON c3.CountryID = c2.CountryID
GROUP BY 
    Client, Vendeur, Ville, Pays
HAVING ChiffreAffaires > 200
ORDER BY ChiffreAffaires DESC;


