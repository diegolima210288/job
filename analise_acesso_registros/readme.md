## Explicação em Português

Neste diretório contém os objetos do banco de dados Oracle, referente ao desenvolvimento de um projeto que visa validar o acesso dos usuários ao cadastro de clientes.

A principal linguagem utilizada neste projeto é PL/SQL (linguagem procedural, do SGBD Oracle, que é uma extensão da linguagem SQL).

E o principal objeto é a procedure PRC_ROTINA_ANALISE_CASO.sql:
 - No início do código deste objeto há declaração das variáveis globais;
  - E no corpo da procedure que serão criadas em tempo de execução: GRAVAR_LOG, IDENTIFICACAO_NOVOS_CASOS e SOLICITACAO_JUSTIF_ACESSO;
   - A procedure GRAVAR_LOG irá ser executada sempre quando uma exception declarada for acionada e irá gravar log na tabela TAB_LOG_ERRO
   - A procedure IDENTIFICACAO_NOVOS_CASOS é a principal procedure:
    - No início do seu código contém a declaração das variáveis locais e cursores;
    - Ao iniciar seu corpo executei o cursor C_VIEW que é a leitura dos registros acesso obtidos no SELECT da view VIEW_ACESSO_CADASTRO;
    - Através do SQL dinâmico faço a validação de cada registro de acesso ao SQL dos registros da tabela de regras (TAB_REGRA);
     - Se o registro for selecionado por alguma regra, valido no SQL dos registros das exceções (TAB_EXCECAO), vinculados a regra;
    - Se o registro for descartado por uma exceção registro como históricos (TAB_REGISTRO);
    - Ou se o registro não for descartado, então registro como caso (TAB_REGISTRO);
   - E na procedure SOLICITACAO_JUSTIF_ACESSO verifico todos os acessos registrados como caso na tabela TAB_REGISTRO;
   - E os registros sem desfecho registro na tabela TAB_EMAIL_ENVIADO.



## Explanation in English

This directory contains objects from the Oracle database, relating to the development of a project that aims to validate user access to customer records.

The main language used in this project is PL/SQL (procedural language, from the Oracle DBMS, which is an extension of the SQL language).

And the main object is the procedure PRC_ROTINA_ANALISE_CASO.sql:
 - At the beginning of this object's code there is a declaration of global variables;
  - And in the body of the procedure that will be created at run time: GRAVAR_LOG, IDENTIFICACAO_NOVOS_CASOS and SOLICITACAO_JUSTIF_ACESSO;
   - The RECORD_LOG procedure will always be executed when a declared exception is triggered and will write log to the TAB_LOG_ERRO table
   - The IDENTIFICACAO_NOVOS_CASOS procedure is the main procedure:
    - The beginning of your code contains the declaration of local variables and cursors;
    - When starting its body I executed the C_VIEW cursor which is reading the access records obtained in the SELECT of the VIEW_ACESSO_CADASTRO view;
    - Using dynamic SQL, I validate each SQL access record in the rules table records (TAB_REGRA);
     - If the record is selected by a rule, I validate it in the SQL of the exception records (TAB_EXCECAO), linked to the rule;
    - If the record is discarded by an exception record as historical (TAB_REGISTRO);
    - Or if the record is not discarded, then record as case (TAB_REGISTRO);
   - And in the SOLICITACAO_JUSTIF_ACESSO procedure I check all accesses registered as cases in the TAB_REGISTRO table;
   - And records without an outcome are recorded in the TAB_EMAIL_ENVIADO table.
