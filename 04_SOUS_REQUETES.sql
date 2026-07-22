/*________________________________________________________________________________
******************************************************************************** 
 						PARTIE 04 : SOUS REQUETES
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
