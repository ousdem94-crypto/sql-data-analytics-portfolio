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
	