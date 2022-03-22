CREATE TRIGGER CALCULAR_STATUS
ON MATRICULA 
FOR INSERT
AS
BEGIN 
	DECLARE @ra_aluno VARCHAR(10), @codigo_disciplina INT, @media DECIMAL(4,2), @numero_faltas INT, @codigo_status SMALLINT, @frequencia DECIMAL, @qtd_aulas INT

	SELECT @ra_aluno = ra_aluno, @codigo_disciplina = codigo_disciplina, @media = (nota1 + nota2)/2, @numero_faltas = numero_faltas FROM INSERTED
	
	SET @qtd_aulas = (SELECT qtd_aulas FROM DISCIPLINA WHERE codigo = @codigo_disciplina)

	SET @frequencia = (@numero_faltas * 100)/@qtd_aulas

	SET @codigo_status = CASE 
							 WHEN @frequencia>25 THEN 4 
							 WHEN @media < 5 THEN 2
							 ELSE 1
						 END

	UPDATE MATRICULA 
	SET media = @media,
		codigo_status = @codigo_status
	WHERE ra_aluno = @ra_aluno AND codigo_disciplina = @codigo_disciplina

END