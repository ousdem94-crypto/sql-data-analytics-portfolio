
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

/*________________________________________________________________________________
******************************************************************************** 
 						PARTIE 02 : LES JOINTURES
________________________________________________________________________________
********************************************************************************/

/* 6. Factures par agent de vente : Fournissez une requête affichant les factures associées à chaque agent de vente. 
Le tableau résultant doit inclure le nom complet de l'agent de vente.*/
SELECT 
	employeeid,
	e.lastname,
	e.firstname,
	i.*
FROM invoice i LEFT JOIN customer c ON i.CustomerId  = c.customerid JOIN employee e ON c.SupportRepId = e.employeeid

/*7. Détails des factures : Fournissez une requête affichant le total de chaque facture, le nom du client, 
le pays et le nom de l'agent de vente.  */
select c.lastname, c.firstname, c.country, e.lastname, e.firstname, i.total
from invoice i left join customer c on i.CustomerId  = c.CustomerId join employee e on e.EmployeeId = c.SupportRepId 

/*11. Nom des morceaux : Fournissez une requête incluant le nom du morceau pour chaque ligne de facture. */
-- track(trackid) --> invoiceline(invoiceid) --> invoice
select i.*, t.name as Nom_morceau
from invoice i
join invoiceline i2 using(invoiceid)
join track t using(trackid)

/*12. Morceaux et artistes : 
Fournissez une requête incluant le nom du morceau acheté ET le nom de l'artiste pour chaque ligne de facture. 
artist(artistid)--> album(albumid) -->tack(trackid)--> invoiceline(invoiceid)--> invoice */
select 
	invoiceid,
	t.name as Morceau,
	ar.name as Artiste
from invoice i 
	join invoiceline i2 using(invoiceid)
	join track t using(trackid)
	join album a using(albumid)
	join artist ar using(artistid)

/*15. Liste des morceaux : Fournissez une requête affichant tous les morceaux (Tracks), mais sans afficher les IDs. 
Le tableau résultant doit inclure le nom de l'album, le type de média et le genre.
-- track -album(albumid) -genre(genreid) -mediatype(mediatypeid) */
select 
	t.Name as Morceau,
	a.Title,
	m.Name as Type_media,
	g.Name as Genre
from track t
	join album a using(albumid)
	join mediatype m using(mediatypeid)
	join genre g using(genreid)

/*25. Top 3 des artistes les plus vendus : Fournissez une requête affichant les 3 artistes les plus vendus. */
-- artist(artistid) -album(albumid) -track(trackid) -invoiceline(invoiceid) -invoice
select
	ar.ArtistId,
	ar.Name,
	count(ar.ArtistId) as Nb_morceau,
	sum(Quantity ) as CA_artiste
from artist ar
	join album a using(artistid)
	join track t using(albumid)
	join invoiceline i using(trackid)
	join invoice i2 using(invoiceid)
group by ar.ArtistId, ar.Name
order by Nb_morceau desc
limit 3

/*26. Type de média le plus acheté : Fournissez une requête affichant le type de média le plus acheté.*/
-- mediatype(mediatypeid) -track(trackid) -invoiceline(invoiceid) -invoice
select
	m.name,
	count(mediatypeid) as Nb_media
from mediatype m
	join track t using(mediatypeid)
	join invoiceline i using(trackid)
	join invoice i2 using(invoiceid)
group by name
order by Nb_media desc
limit 1	
	
/*________________________________________________________________________________
******************************************************************************** 
 						PARTIE 03 : GROUP BY
________________________________________________________________________________
********************************************************************************/

/*Analyse par année et lignes de facture 
8. Ventes par année : Combien de factures y a-t-il eu en 2009 et 2011 ? 
Quels sont les montants totaux des ventes pour chacune de ces années ? */
select year(invoicedate) as Annee, count(invoiceid) as Nb_facture
from invoice i 
where year(invoicedate) in (2023, 2024)
group by Annee

/*9. Articles pour une facture donnée : Fournissez une requête comptant le nombre d'articles (line items) pour l'ID de facture 37. */
select invoiceid, count(*) as NB_items
from invoiceline i   
where invoiceId = 37
group by invoiceid

/*10. Articles par facture : Fournissez une requête comptant le nombre d'articles (line items) pour chaque facture. 
Astuce : utilisez GROUP BY.*/ 
select invoiceid, count(*) as NB_items
from invoiceline i
group by invoiceid

/*Détails des morceaux 

/*Comptages et regroupements 
13. Nombre de factures par pays : Fournissez une requête affichant le nombre de factures par pays. Astuce : utilisez GROUP BY.  */
select billingcountry, count(invoiceid) as Nb_facture
from invoice i 
group by billingcountry 
order by nb_facture  desc

/*14. Nombre de morceaux par playlist : Fournissez une requête affichant le nombre total de morceaux dans chaque playlist. 
Le nom de la playlist doit être inclus dans le tableau résultant. */
-- playlist(palylistid) -playlisttrack(trackid) -track
select p.PlaylistId, count(trackid) as Nb_morceau, p2.Name 
from track t
	join playlisttrack p using(trackid)
	join playlist p2 using(playlistid)
group by p.PlaylistId, p2.Name 

/*Analyse des ventes 
16. Factures et articles : Fournissez une requête affichant toutes les factures, avec le nombre d'articles par facture. */
select
    invoiceid,
    sum(quantity) as Nb_articles
from invoiceline
group by invoiceid;

/*17. Ventes par agent de vente : Fournissez une requête affichant les ventes totales réalisées par chaque agent de vente. */
-- invoice(customerid) -customer(SupportRepId) -employee(employeeid)
select
	e.EmployeeId,
	e.FirstName,
	e.LastName,
	sum(total) as CA_employés
from employee e
	join customer c on c.SupportRepId = e.EmployeeId
	join invoice i using(customerid)
group by e.EmployeeId, FirstName, LastName

/*Analyse des clients et des pays 
21. Clients par agent de vente : Fournissez une requête affichant le nombre de clients attribués à chaque agent de vente. */
select
	e.FirstName,
	e.LastName, 
	count(customerid) as Nb_Client
from customer c join employee e on e.EmployeeId = c.SupportRepId
group by e.FirstName, e.LastName, e.EmployeeId 
order by Nb_Client desc

/*22. Ventes totales par pays : Fournissez une requête affichant les ventes totales par pays. Quel pays a dépensé le plus ?  */
select billingcountry, sum(total) as CA_pays
from invoice i 
group by billingcountry 
order by ca_pays desc

/*________________________________________________________________________________
******************************************************************************** 
 						PARTIE 04 : SOUS REQUETES & FONCTIONS_FENETRES
________________________________________________________________________________
********************************************************************************/

/*18. Meilleur agent de 2009 : Quel agent de vente a réalisé le plus de ventes en 2009 ? */
-- je prends 2022 à la place de 2009
with bilan2022 
as	
	(select
		e.EmployeeId,
		e.FirstName,
		e.LastName,
		year(invoicedate) as annee,
		sum(total) as CA_employés,
		dense_rank()
		over(order by sum(total) desc) as Rang
	from employee e
		join customer c on c.SupportRepId = e.EmployeeId
		join invoice i using(customerid)
	where year(invoicedate) = 2022
	group by e.EmployeeId, FirstName, LastName, annee 
)
select * from bilan2022 
where rang = 1

/*19. Meilleur agent de 2010 : Quel agent de vente a réalisé le plus de ventes en 2010 ? */
-- je prends 2023 à la place de 2010
with bilan2023 
as	
	(select
		e.EmployeeId,
		e.FirstName,
		e.LastName,
		year(invoicedate) as annee,
		sum(total) as CA_employés,
		dense_rank()
		over(order by sum(total) desc) as Rang
	from employee e
		join customer c on c.SupportRepId = e.EmployeeId
		join invoice i using(customerid)
	where year(invoicedate) = 2023
	group by e.EmployeeId, FirstName, LastName, annee 
)
select * from bilan2023 
where rang = 1

/*20. Meilleur agent global : Quel agent de vente a réalisé le plus de ventes en tout ? */
with bilanAgent 
as	
	(select
		e.EmployeeId,
		e.FirstName,
		e.LastName,
		sum(total) as CA_employés,
		dense_rank()
		over(order by sum(total) desc) as Rang
	from employee e
		join customer c on c.SupportRepId = e.EmployeeId
		join invoice i using(customerid)
	group by e.EmployeeId, FirstName, LastName 
)
select * from bilanAgent  
where rang = 1

/*Analyse des morceaux et des artistes 
23. Morceau le plus acheté en 2013 : Fournissez une requête affichant le morceau le plus acheté en 2013. */
-- je prends 2024 à la place de 2013
-- track(trackid) -invoiceline(invoiceid) -invoice
with morceau_1
as (
	select
		t.name,
		year(invoicedate) as Annee,
		count(trackid) as Nb_morceau_vendu,
		sum(total) as CA_morceau,
		dense_rank()
		over(order by sum(total) desc) as Rang
	from track t
		join invoiceline i using(trackid)
		join invoice i2 using(invoiceid)
	where year(invoicedate) = 2024
	group by t.name, Annee
)
select *
from morceau_1
where rang =1

/*24. Top 5 des morceaux les plus achetés : Fournissez une requête affichant les 5 morceaux les plus achetés en tout. */
with morceau_1
as (
	select
		t.name,
		count(invoiceid) as Nb_morceau_vendu,
		sum(total) as CA_morceau,
		dense_rank()
		over(order by sum(total) desc) as Rang
	from track t
		join invoiceline i using(trackid)
		join invoice i2 using(invoiceid)
	group by t.name
)
select *
from morceau_1
limit 5

