--TAB CADASTRO DE EXCEÇÕES

create sequence tab_excecao_seq 
nocache;

create table TAB_EXCECAO
(
nr_sequencia number(10) default tab_excecao_seq.NEXTVAL,
dt_atualizacao_nrec date default sysdate,
nm_acesso_nrec varchar2(100),
ds_excecao varchar2(100),
ds_sql clob,
ie_situacao varchar2(1),
dt_atualizacao date,
nm_acesso_atual varchar2(100)
);
