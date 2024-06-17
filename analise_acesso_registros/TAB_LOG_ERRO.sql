--histórico de erro durante execução da procedure

create sequence tab_log_erro_seq 
nocache;

create table TAB_LOG_ERRO
(
nr_sequencia number default tab_log_erro_seq.nextval primary key,
dt_log date default sysdate,
ds_objeto varchar2(4000),
nr_seq_acesso number(10),
nr_seq_regra number(10),
nr_seq_excecao number(10),
ds_stack varchar2(4000)
);
