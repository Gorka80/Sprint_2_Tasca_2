USE transactions;
/*-------------------NIVELL 1-----------------------------------------*/
/*EXERCICI 1-(Solució 1-----------------------------------------------*/
SELECT 
t.*
FROM transaction t
INNER JOIN company c
ON t.company_id=c.id
WHERE c.country='Germany';
 
 /*EXERCICI 1-(Solució 2)-----------------------------------------------*/
SELECT 
t.*
FROM transaction t,
company c
WHERE (t.company_id=c.id) AND c.country='Germany';

/*EXERCICI 1 (Solució 3)-----------------------------------------------*/
SELECT 
*
FROM transaction t
WHERE t.company_ID IN 
	(SELECT 
	c.id
	FROM company c
	WHERE c.country='Germany');

/*EXERCICI 2 (Solució 1)-----------------------------------------------*/
SELECT
DISTINCT c.company_name
FROM transaction t
INNER JOIN company c
ON t.company_id=c.id
WHERE t.amount>(SELECT AVG(t.amount) FROM transaction t);

/*EXERCICI 2 (Solució 2)-----------------------------------------------*/
SELECT
c.company_name
FROM company c
WHERE c.id IN (
	SELECT
	t.company_id
	FROM transaction t
	WHERE t.amount>(
	SELECT AVG(t.amount) FROM transaction t));

/*EXERCICI 3  (Solució 1)-----------------------------------------------*/
SELECT
t.*
FROM transaction t
INNER JOIN company c
ON t.company_id=c.id
WHERE c.company_name LIKE 'c%';

/*EXERCICI 3  (Solució 2)-----------------------------------------------*/
SELECT
*
FROM transaction t
WHERE t.company_id IN 
	(SELECT
	c.id
	FROM company c
	WHERE c.company_name LIKE 'c%');

/*EXERCICI 4 (Solució 1)--------------------------------------------------*/
SELECT
c.company_name
FROM transaction t
RIGHT JOIN company c
ON t.company_id=c.id
WHERE t.company_id IS NULL;

/*EXERCICI 4 (Solució 2)--------------------------------------------------*/
SELECT
c.company_name
FROM company c
WHERE c.id NOT IN 
	(SELECT
	DISTINCT t.company_id
	FROM transaction t);

/*EXERCICI 4 (Solució 3)--------------------------------------------------*/
SELECT
c.id
FROM company c
WHERE NOT EXISTS (
SELECT
t.company_id
FROM transaction t);

/*-------------------NIVELL 2-----------------------------------------*/
/*EXERCICI 1 (Solució 1-----------------------------------------------*/
SELECT 
*
FROM transaction t
	WHERE t.company_id IN (
		SELECT c.id 
		FROM company c 
		WHERE c.country= 
			(SELECT c.country 
			FROM company c 
			WHERE c.company_name='Non Institute'));

/*EXERCICI 1 (Solucio 2)---------------------------------------------*/
SELECT 
t.*
FROM transaction t
INNER JOIN company c
ON t.company_id=c.id 
WHERE c.country=(
	SELECT 
	c.country
	FROM company c
	WHERE c.company_name='Non Institute');

/*EXERCICI 2 (Solució 1)--------------------------------------------*/
SELECT
c.company_name
FROM company c
WHERE c.id=
	(SELECT
	t.company_id
	FROM transaction t
	WHERE t.amount=(SELECT
	MAX(amount)
	FROM transaction t));

/*EXERCICI 2 (Solució 2)--------------------------------------------*/
SELECT
c.company_name
FROM company c
WHERE c.id=
	(SELECT 
	trans_max_x_company.company_id
	FROM 
		(SELECT
			t.company_id,
			MAX(t.amount) trans_max
		FROM transaction t
		GROUP BY t.company_id
		ORDER BY trans_max DESC) trans_max_x_company
		LIMIT 1);
    
/*EXERCICI 2 (Optimització Solució 2)---------------------------------*/
SELECT
c.company_name
FROM company c
WHERE c.id=
	(SELECT
		t.company_id
		-- MAX(t.amount) trans_max
	FROM transaction t
	GROUP BY t.company_id
	ORDER BY MAX(t.amount)  DESC
	LIMIT 1);

/*EXERCICI 2 (Variant Solució 2 amb ROW encara experimental)---------------------------------*/
SELECT
c.company_name
FROM company c
WHERE (c.id,499.23)=(
	(SELECT
		t.company_id,
		MAX(t.amount) trans_max
	FROM transaction t
	GROUP BY t.company_id
	ORDER BY trans_max DESC)
	LIMIT 1);

/*-------------------NIVELL 3-----------------------------------------*/
/*EXERCICI 1 (Solució 1)-----------------------------------------------*/
SELECT
trans_mig_x_pais.pais
FROM(SELECT
	c.country pais,
	AVG (t.amount) avg_amount
	FROM transaction t
	INNER JOIN company c
	ON t.company_id=c.id
	GROUP BY c.country) trans_mig_x_pais
	WHERE trans_mig_x_pais.avg_amount>(SELECT AVG(t.amount) FROM transaction t);

/*EXERCICI 1 (Optimització solució 1)----------------------------------------------------------*/
SELECT
c1.country
-- AVG(t1.amount) avg_amount
FROM transaction t1
INNER JOIN company c1
ON t1.company_id=c1.id
GROUP BY c1.country
HAVING AVG(t1.amount)>
	(SELECT
    AVG(t.amount)
    FROM transaction t)
	ORDER BY AVG(t1.amount) DESC;


/*EXERCICI 2----------------------------------------------------------*/
SELECT
trans_x_company.company_name,
IF(trans_x_company.count_trans>=4,'Sí','No')  'Empreses amb 4 o més transaccions'
FROM (SELECT
	c.company_name,
	COUNT(t.company_id) count_trans
	FROM transaction t
	INNER JOIN company c
	ON t.company_id=c.id
	GROUP BY c.company_name) trans_x_company;






