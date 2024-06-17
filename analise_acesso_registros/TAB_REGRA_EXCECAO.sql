--TAB RELAÇÃO REGRAS E EXCEÇÕES

create sequence tab_regra_excecao_seq 
nocache;

create table TAB_REGRA_EXCECAO
(
nr_sequencia number(10) default tab_regra_excecao_seq.NEXTVAL,
dt_atualizacao date default sysdate,
nr_seq_regra number(10),
nr_seq_excecao number(10)
);
