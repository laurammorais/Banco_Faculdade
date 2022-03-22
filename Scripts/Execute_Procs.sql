EXEC DISCIPLINA_INSERIR @nome = 'DIREITO PENAL', @qtd_aulas = 35

EXEC ALUNO_INSERIR @ra = '4321', @nome = 'JOSE', @cpf = '321.654.987-00', @data_nasc = '2000-01-20', @telefone = '(16)99788-6655', @localidade = 'ARARAQUARA', @logradouro = 'RUA SAPÃO', @numero = 1234, @cep = '14830-420', @bairro = 'VILA HARMONIA', @uf = 'SP'

EXEC MATRICULA_INSERIR @ano = 2022, @semestre = 1, @nota1 = 3, @nota2 = 5, @numero_faltas = 2, @ra_aluno = '4321', @codigo_disciplina = 1

EXEC MATRICULA_OBTER @ra = '4321'

EXEC MATRICULA_REALIZAR_SUBSTITUTIVA @ra = '4321', @codigo_disciplina = 1, @substitutiva = 3