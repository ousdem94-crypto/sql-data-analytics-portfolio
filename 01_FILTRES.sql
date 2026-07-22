
/*						  PARTIE 01 : LES FILTRES
________________________________________________________________________________
********************************************************************************/

-- 1- Clients non américains : Fournissez une requête affichant les Clients (leurs noms complets, ID client et pays) qui ne sont pas aux États-Unis.
select firstname, lastname, customerid, country
from customer
where country not like "USA"

-- 2. Clients brésiliens : Fournissez une requête affichant uniquement les Clients provenant du Brésil. 
select *
from customer c 
where c.Country like "Brazil"

/* 3. Factures des clients brésiliens : Fournissez une requête affichant les factures des clients qui sont du Brésil. 
Le tableau résultant doit inclure le nom complet du client, 
l'ID de la facture, la date de la facture et le pays de facturation. */
select country, firstname, lastname, invoiceid, invoicedate, billingcountry
from customer c join invoice i using(customerid)
where country = "Brazil"

/* 4. Agents de vente : Fournissez une requête affichant uniquement les employés qui sont des Agents de Vente */
select *
from employee e 
where title = "sales support agent"

/* 5. Pays uniques dans les factures : Fournissez
une requête affichant une liste unique des pays de facturation présents dans la table Invoice. */
select distinct i.BillingCountry 
from invoice i 
order by billingcountry 
