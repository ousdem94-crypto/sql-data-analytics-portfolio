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
