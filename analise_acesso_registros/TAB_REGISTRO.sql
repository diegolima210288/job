--registro de acesso que entraram na regra (caso) ou sairão pela exeção (histórico)

create sequence tab_registro_seq
nocache;

create table TAB_REGISTRO
(
nr_sequencia number(10) default tab_registro_seq.nextval,
dt_atualizacao date default sysdate,
cd_pessoa varchar2(10),
nr_ficha number(10),
nm_acesso varchar2(15),
dt_acesso date,
nr_seq_acesso number(10),
nr_seq_regra number(10),
ie_desfecho varchar2(1),
dt_desfecho date,
ds_observacao varchar2(4000),
nr_seq_excecao number(10),
ie_tp_registro varchar2(1),
dt_conversao date
);


