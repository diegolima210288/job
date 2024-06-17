--TAB CADASTRO DE E-MAILS

create sequence tab_cad_email_seq 
nocache;

create table TAB_CAD_EMAIL
(
nr_sequencia number default tab_cad_email_seq.nextval primary key,
dt_atualizacao date default sysdate,
ds_email varchar2(100),
ie_cadastro varchar2(1),
nr_seq_cadastro number(10)
);
