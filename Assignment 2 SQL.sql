# My SQL Assignment # 2 

# Question 1.  List the names of all pet owners along with the names of their pets. 

SELECT po.Name AS pet_owner, p.Name AS pet_name
FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID;

# Question 2.  List all pets and their owner names, including pets that don't have recorded owners.

SELECT p.Name AS pet_name, IFNULL(po.Name, 'Unassigned') AS owner_name
FROM pets p
LEFT JOIN petowners po ON p.OwnerID = po.OwnerID;

# Question 3.  Combine the information of pets and their owners, including those pets without owners and owners without pets.

SELECT IFNULL(p.Name, 'No Pet') AS pet_name,
    IFNULL(po.Name, 'Unassigned') AS owner_name
FROM (SELECT petID, Name, OwnerID FROM pets 
     UNION SELECT NULL AS petID, NULL AS Name, OwnerID FROM petowners) p
LEFT JOIN petowners po ON p.OwnerID = po.OwnerID
Order by pet_name;

# Question 4.  Find the names of pets along with their owners' names and the details of the procedures they have undergone.

SELECT p.Name AS pet_name, po.Name AS owner_name, ph.ProcedureType AS procedure_name
FROM Pets p
LEFT JOIN petowners po ON p.OwnerID = po.OwnerID
LEFT JOIN procedureshistory ph ON p.PetID = ph.PetID;

# Question 5.  List all pet owners and the number of dogs they own. 

SELECT po.OwnerID, po.Name,
    COUNT(p.PetID) AS number_of_dogs
FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID AND p.Kind = 'Dog'
GROUP BY po.OwnerID, po.Name;

# Question 6.  Identify pets that have not had any procedures. 

SELECT p.PetID, p.Name
FROM Pets p
LEFT JOIN procedureshistory ph ON p.PetID = ph.PetID
WHERE ph.PetID IS NULL; 

# Question 7. Find the name of the oldest pet.

SELECT Name
FROM Pets
ORDER BY age DESC
LIMIT 1;

# Question 8. List all pets who had procedures that cost more than the average cost of all procedures. 

SELECT p.PetID, p.Name, ph.procedureType, pd.price
FROM Pets p
LEFT JOIN Procedureshistory ph ON p.PetID = ph.PetID
LEFT JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE pd.price > (SELECT AVG(price) FROM proceduresdetails);

# Question 9.  Find the details of procedures performed on 'Cuddles'.

SELECT ph.PetID, ph.Date, ph.procedureType, ph.procedureSubCode
FROM procedureshistory ph
LEFT JOIN pets p ON p.PetID = ph.PetID
WHERE p.Name = 'Cuddles';

/* Question 10. Create a list of pet owners along with the total cost they have spent on procedures and 
display only those who have spent above the average spending*/



# Question 11.List the pets who have undergone a procedure called 'VACCINATIONS'.

SELECT p.PetID, p.Name, pd.ProcedureType
FROM Pets p
INNER JOIN Procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE pd.ProcedureType = 'VACCINATIONS'
group by p.petID, p.Name;
# Question 12. Find the owners of pets who have had a procedure called 'EMERGENCY'.

SELECT DISTINCT po.OwnerID, po.Name AS OwnerName
FROM Petowners po
INNER JOIN Pets p ON po.OwnerID = p.OwnerID
INNER JOIN Procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE pd.Description = 'EMERGENCY';

SELECT DISTINCT po.OwnerID, po.Name AS OwnerName
FROM Petowners po
INNER JOIN Pets p ON po.OwnerID = p.OwnerID
INNER JOIN Procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE pd.ProcedureType = 'EMERGENCY'; 

# The above question was tried with 2 ways but the result is still nill 

# Question 13. Calculate the total cost spent by each pet owner on procedures.

SELECT po.OwnerID, po.Name AS OwnerName, SUM(pd.Price) AS TotalCost
FROM Petowners po
INNER JOIN Pets p ON po.OwnerID = p.OwnerID
INNER JOIN Procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
GROUP BY po.OwnerID, po.Name;

# Question 14. Count the number of pets of each kind.

SELECT Kind, COUNT(*) AS PetCount
FROM Pets
GROUP BY Kind;

# Question 15. Group pets by their kind and gender and count the number of pets in each group.

SELECT Kind, Gender, COUNT(*) AS PetCount
FROM Pets
GROUP BY Kind, Gender
Order by Gender;

# Question 16. Show the average age of pets for each kind, but only for kinds that have more than 5 pets.

SELECT Kind, AVG(Age) AS Average_Age
FROM Pets
GROUP BY Kind
HAVING COUNT(*) > 5;

# Question 17. Find the types of procedures that have an average cost greater than $50.

SELECT ProcedureType, AVG(Price) AS Average_Cost
FROM Proceduresdetails
GROUP BY ProcedureType
HAVING AVG(Price) > 50; 

/* Question 18. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then
3 Young, Age between 3and 8 Adult, else Senior. */ 

SELECT PetID, Name, Age,
CASE
WHEN Age < 3 THEN 'Young'
WHEN Age BETWEEN 3 AND 8 THEN 'Adult'
ELSE 'Senior'
END AS Age_Category
FROM Pets;

/* Question 19. Calculate the total spending of each pet owner on procedures, labeling them
as 'Low Spender' for spending under $100, 'Moderate Spender' for spending
between $100 and $500, and 'High Spender' for spending over $500.*/ 

SELECT po.OwnerID, po.Name AS OwnerName,
    SUM(pd.Price) AS Total_Price,
CASE
WHEN SUM(pd.Price) < 100 THEN 'Low Spender'
WHEN SUM(pd.Price) BETWEEN 100 AND 500 THEN 'Moderate Spender'
ELSE 'High Spender'
END AS Price_Spended
FROM Petowners po
INNER JOIN Pets p ON po.OwnerID = p.OwnerID
INNER JOIN Procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN Proceduresdetails pd ON ph.ProcedureSubCode = pd.ProcedureSubCode
GROUP BY po.OwnerID, po.Name;

# Question 20. Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).

SELECT PetID, Name, Gender,
CASE
WHEN Gender = 'Male' THEN 'Boy'
WHEN Gender = 'Female' THEN 'Girl'
ELSE 'Unknown'
END AS Gender_Label
FROM Pets;

/* Question 21. For each pet, display the pet's name, the number of procedures they've had,
and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to
7 procedures, and 'Super User' for more than 7 procedures.*/ 

SELECT p.PetID, p.Name,
    COUNT(ph.ProcedureType) AS Number_of_Procedures,
CASE
WHEN COUNT(ph.ProcedureType) BETWEEN 1 AND 3 THEN 'Regular'
WHEN COUNT(ph.ProcedureType) BETWEEN 4 AND 7 THEN 'Frequent'
WHEN COUNT(ph.ProcedureType) > 7 THEN 'Super User'
Else 'Null'
END AS Status_Label
FROM Pets p
LEFT JOIN Procedureshistory ph ON p.PetID = ph.PetID
GROUP BY p.PetID, p.Name;

# in above question i used "Null" for those who have 0 number_of_Procedures. 

# Question 22. Rank pets by age within each kind.

SELECT PetID, Name, Kind, Age,
    RANK() OVER (PARTITION BY Kind ORDER BY Age) AS Age_Rank
FROM Pets;

# Question 23. Assign a dense rank to pets based on their age, regardless of kind. 

SELECT PetID, Name, Age,
DENSE_RANK() OVER (ORDER BY Age) AS Age_Dense_Rank
FROM Pets;

# Quesiton 24. For each pet, show the name of the next and previous pet in alphabetical order.

SELECT PetID, Name,
LEAD(Name) OVER (ORDER BY Name) AS Next_Pet,
LAG(Name) OVER (ORDER BY Name) AS Previous_Pet
FROM Pets;

# Question 25. Show the average age of pets, partitioned by their kind.

SELECT PetID, Name, Kind, Age,
AVG(Age) OVER (PARTITION BY Kind) AS Average_Age_by_Kind
FROM Pets;

# Question 26. Create a CTE that lists all pets, then select pets older than 5 years from the CTE. 

WITH AllPets AS (SELECT PetID, Name, Kind, Age FROM Pets)
SELECT PetID, Name, Kind, Age
FROM AllPets
WHERE Age > 5;