/*
CREATE TABLE addresses (                                             
  adr_id INTEGER NOT NULL PRIMARY KEY,                               
  adr_city VARCHAR(15),                                              
  adr_country VARCHAR(15) NOT NULL);                                 
  
  CREATE TABLE persons (                                               
  prs_id INTEGER NOT NULL PRIMARY KEY,                               
  prs_father_id INTEGER,                                             
  prs_mother_id INTEGER,                                             
  prs_adr_id INTEGER,                                                
  prs_first_name VARCHAR(15),                                        
  prs_surname VARCHAR(15),                                           
  CONSTRAINT prs_prs_father_fk FOREIGN KEY (prs_father_id)           
    REFERENCES persons(prs_id),                                      
  CONSTRAINT prs_prs_mother_fk FOREIGN KEY (prs_mother_id)           
    REFERENCES persons(prs_id),                                      
  CONSTRAINT prs_adr_fk FOREIGN KEY (prs_adr_id)                     
    REFERENCES addresses(adr_id));  
    
INSERT INTO addresses VALUES (1, 'RIGA', 'LATVIA');                  
INSERT INTO addresses VALUES (2, 'BERLIN', 'GERMANY');               
INSERT INTO addresses VALUES (3, 'NEW YORK', 'USA');                 
INSERT INTO persons VALUES (1, NULL, NULL, NULL, 'JANIS', 'BERZINS');
INSERT INTO persons VALUES (2, 1, NULL, 2, 'PETER', 'BERZINS');      
INSERT INTO persons VALUES (3, NULL, NULL, 2, 'ANN', 'SMYTH');       
INSERT INTO persons VALUES (4, 2, 3, 2, 'CHARLES', 'BERZINS');       
COMMIT;  
*/
SELECT * FROM persons;
SELECT * FROM addresses;

--CROSS JOIN
select * from persons, addresses;

--self join
SELECT father.prs_first_name "Father Name",       
       mother.prs_first_name "Mother Name",       
       child.prs_first_name "Child Name"          
FROM persons child, persons father, persons mother
WHERE child.prs_father_id = father.prs_id         
  AND child.prs_mother_id = mother.prs_id;  