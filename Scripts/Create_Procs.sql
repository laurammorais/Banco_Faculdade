CREATE PROCEDURE DISCIPLINA_INSERIR
	@nome VARCHAR(50),
	@qtd_aulas int 
AS 
BEGIN
	INSERT DISCIPLINA VALUES (@nome, @qtd_aulas)
END
GO
--=======================================================================================================================
CREATE PROC ALUNO_INSERIR
	@ra VARCHAR (10),
	@nome VARCHAR (50),
	@cpf VARCHAR (14),
	@data_nasc DATE,
	@telefone VARCHAR (14),
	@localidade VARCHAR (50),
	@logradouro VARCHAR (50),
	@numero INT,
	@cep VARCHAR (10),
	@bairro VARCHAR (50),
	@uf CHAR (2),
	@complemento VARCHAR(30) = NULL
AS
BEGIN
	INSERT ALUNO 
    VALUES (@ra, @nome, @cpf, @data_nasc, @telefone, @localidade, @logradouro, @numero, @cep, @bairro, @uf, @complemento)
END
GO
--=======================================================================================================================
CREATE PROC MATRICULA_INSERIR
	@ano INT,
	@semestre INT,
	@nota1 DECIMAL(4,2),
	@nota2 DECIMAL(4,2),
	@numero_faltas INT,
	@ra_aluno VARCHAR (10),
	@codigo_disciplina INT
AS
BEGIN
	INSERT MATRICULA (ano, semestre, nota1, nota2, numero_faltas, ra_aluno, codigo_disciplina) 
    VALUES (@ano, @semestre, @nota1, @nota2, @numero_faltas, @ra_aluno, @codigo_disciplina)
END
GO
--=======================================================================================================================
CREATE PROC MATRICULA_OBTER
	@ra VARCHAR(10) = NULL
AS
BEGIN
	SELECT A.nome, A.ra, D.nome AS disciplina, M.ano, M.semestre, M.media, S.descricao 
    FROM MATRICULA M
    JOIN ALUNO A ON  A.ra = M.ra_aluno
    JOIN DISCIPLINA D ON D.codigo = M.codigo_disciplina  
    JOIN [STATUS] S ON S.codigo = M.codigo_status 
    WHERE (@ra IS NULL OR A.ra = @ra)
END
GO
--=======================================================================================================================
CREATE PROC MATRICULA_REALIZAR_SUBSTITUTIVA
	@ra VARCHAR(10),
	@codigo_disciplina INT,
	@substitutiva DECIMAL(4,2)
AS
BEGIN
	DECLARE @nota1 DECIMAL(4,2) = (SELECT nota1 FROM MATRICULA WHERE codigo_disciplina = @codigo_disciplina AND ra_aluno = @ra),
		    @nota2 DECIMAL(4,2) = (SELECT nota2 FROM MATRICULA WHERE codigo_disciplina = @codigo_disciplina AND ra_aluno = @ra)

	IF((SELECT codigo_status FROM MATRICULA WHERE codigo_disciplina = @codigo_disciplina AND ra_aluno = @ra) = 2) 
	BEGIN
		IF(@nota1 >= @nota2)
		  UPDATE MATRICULA
		  SET nota2 = NULL,
			  substitutiva = @substitutiva,
			  media = (@nota1 + @substitutiva)/2,
			  codigo_status = CASE
								WHEN (@nota1 + @substitutiva)/2 >= 5 THEN 1
								ELSE 3
							  END
		  WHERE ra_aluno = @ra AND codigo_disciplina = @codigo_disciplina
		ELSE
		  UPDATE MATRICULA
		  SET nota1 = NULL,
			  substitutiva = @substitutiva,
			  media = (@nota2 + @substitutiva)/2,
			  codigo_status = CASE
								WHEN (@nota2 + @substitutiva)/2 >= 5 THEN 1
								ELSE 3
							  END
		  WHERE ra_aluno = @ra AND codigo_disciplina = @codigo_disciplina
	END
	ELSE
		PRINT 'PARA REALIZAR A PROVA SUBSTITUTIVA, O ALUNO DEVE ESTAR EM RECUPERAÇÃO!'
END
GO

