-- https://en.wikibooks.org/wiki/SQL_Exercises/Scientists

-- projects.Code, projects.Name, projects.Hours --
-- scientists.SSN, scientists.Name --
-- assignedto.Scientist assignedto.Project --

-- 6.1 List all the scientists' names, their projects' names, 
    -- and the hours worked by that scientist on each project, 
    -- in alphabetical order of project name, then scientist name.
    
SELECT scientists.Name AS scientists, Projects.Name AS Projects, Projects.Hours AS Hours
FROM assignedto JOIN scientists ON assignedto.Scientist = scientists.SSN 
				JOIN projects ON assignedto.Project = projects.Code
ORDER BY Projects.Name ASC, scientists.Name ASC;
    
-- 6.2 Select the project names which are not assigned yet
SELECT Name
FROM Projects
WHERE Code NOT IN
	(
	SELECT Project
	FROM assignedto
	)