--DROPS
/*
DROP TABLE historico;
DROP TABLE disciplina;
DROP TABLE professor;
DROP TABLE aluno;
*/
--SCHEMA

CREATE TABLE aluno (
cod_aluno INTEGER NOT NULL,
nome VARCHAR(50) NOT NULL,
morada VARCHAR(100) NOT NULL,
cidade VARCHAR(20),
CONSTRAINT PK_aluno PRIMARY KEY (cod_aluno));

CREATE TABLE professor (
cod_prof VARCHAR(3) NOT NULL,
nome VARCHAR(50) NOT NULL,
morada VARCHAR(100) NOT NULL,
cidade VARCHAR(20),
CONSTRAINT PK_professor PRIMARY KEY (cod_prof));

CREATE TABLE disciplina (
cod_disc INTEGER NOT NULL,
nome_d VARCHAR(20),
carga_horaria NUMBER(5,2),
ano INTEGER,
CONSTRAINT PK_disciplina PRIMARY KEY (cod_disc));

CREATE TABLE historico (
cod_aluno INTEGER NOT NULL,
cod_disc INTEGER NOT NULL,
cod_turma VARCHAR(4) NOT NULL,
cod_prof VARCHAR(3) NOT NULL,
ano INTEGER NOT NULL,
nota NUMBER(4,2),
CONSTRAINT PK_historico PRIMARY KEY (cod_aluno,cod_disc,cod_turma,cod_prof,ano),
CONSTRAINT FK_historico_aluno FOREIGN KEY (cod_aluno) 
REFERENCES aluno (cod_aluno),
CONSTRAINT FK_historico_disciplina FOREIGN KEY (cod_disc) 
REFERENCES disciplina (cod_disc),
CONSTRAINT FK_historico_professor FOREIGN KEY (cod_prof) 
REFERENCES professor (cod_prof));
  
  
--INSERTS


INSERT INTO aluno VALUES (1,'António','Rua A','Porto');
INSERT INTO aluno VALUES (2,'Filipa','Rua D','Porto');
INSERT INTO aluno VALUES (3,'Helena','Rua H','Lisboa');
INSERT INTO aluno VALUES (4,'David','Rua E','Coimbra');

INSERT INTO professor VALUES ('RMR','Rosinha','Beco','Inferno');
INSERT INTO professor VALUES ('AJO','António Rocha','Av.Boavista','Porto');
INSERT INTO professor VALUES ('JSE','José','R.doCarmo','Lisboa');
INSERT INTO professor VALUES ('MRC','Marcos','R.Sta.Catarina','Porto');

INSERT INTO disciplina VALUES (1,'BDDAD',100.0,2015);
INSERT INTO disciplina VALUES (2,'BDDAD',90.0,2014);
INSERT INTO disciplina VALUES (3,'DISC3',40.0,2010);
INSERT INTO disciplina VALUES (4,'DISC4',60.0,2009);
INSERT INTO disciplina VALUES (5,'DISC5',20.0,2011);
INSERT INTO disciplina VALUES (6,'DISC6',30.0,2014);

INSERT INTO historico VALUES(1,1,'2NA','AJO',2015,null);
INSERT INTO historico VALUES(1,6,'1NB','JSE',2014,18.0);
INSERT INTO historico VALUES(3,4,'1DBZ','JSE',2009,16.0);
INSERT INTO historico VALUES(2,3,'1NHA','JSE',2010,9.0);
INSERT INTO historico VALUES(3,5,'2DBZ','MRC',2011,11.0);
INSERT INTO historico VALUES(2,5,'2NHA','MRC',2012,12.0);
--INSERT INTO historico VALUES(2,4,'2NHA','MRC',2050,12.0);

--SELECT * FROM HISTORICO;

--DELETE HISTORICO WHERE ANO = 2050;

--SELECTS

--1
SELECT h.cod_aluno, A.nome FROM aluno A, historico H
WHERE H.COD_ALUNO = A.COD_ALUNO
AND H.COD_PROF LIKE 'MRC'
AND H.cod_aluno IN (SELECT cod_aluno FROM HISTORICO H
  WHERE H.COD_PROF LIKE 'JSE'
  AND (H.ANO = 2009
  OR H.ANO = 2010));

--2
SELECT morada FROM aluno WHERE cidade = 'Porto'
UNION
SELECT morada FROM professor WHERE cidade = 'Porto';

--3
SELECT a.nome, p.nome FROM aluno A, professor P, historico H, disciplina D
WHERE H.COD_ALUNO = A.COD_ALUNO
AND P.COD_PROF = H.COD_PROF
AND H.COD_DISC = D.COD_DISC  
AND D.CARGA_HORARIA < 60.00;

--4
SELECT DISTINCT nome FROM professor P, historico H 
WHERE P.COD_PROF = H.COD_PROF
AND H.cod_prof NOT IN (
  SELECT cod_prof FROM historico H, disciplina D
  WHERE H.COD_DISC = D.COD_DISC
  AND D.CARGA_HORARIA >= 60);
  
--5
SELECT A.cod_aluno, A.nome FROM aluno A
MINUS
SELECT DISTINCT A.cod_aluno, A.nome FROM aluno A, historico H
WHERE H.COD_ALUNO = A.COD_ALUNO
AND H.nota < 10;

--6
SELECT A.cod_aluno FROM aluno A
WHERE NOT EXISTS ( 
  SELECT H.cod_disc FROM professor P, historico H 
  WHERE P.cod_prof = H.cod_prof
  AND P.nome LIKE 'Marcos'
  AND cod_disc NOT IN (
    SELECT H.cod_disc FROM historico H
    WHERE A.cod_aluno = H.cod_aluno));
