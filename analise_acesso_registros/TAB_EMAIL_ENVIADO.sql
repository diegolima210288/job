--TAB E-MAILS

create sequence tab_email_enviado_seq
nocache;

create table TAB_EMAIL_ENVIADO
(
nr_sequencia number(10) default tab_email_enviado_seq.NEXTVAL,
dt_atualizacao date default sysdate,
nr_seq_caso number(10),
dt_acesso date,
nm_cliente varchar2(500),
nr_registro varchar2(500),
nm_acesso varchar(500),
dt_envio date,
dt_resposta_acesso date,
ds_resposta_acesso clob,
dt_resposta_sup date,
ds_resposta_sup clob,
ds_email_acesso varchar(500),
ds_email_sup varchar(500),
dt_envio_sup date,
nm_usuario varchar2(500),
qt_cobranca_acesso number(10),
qt_cobranca_sup number(10)
);


grant all on icesp.ICESP_PRJ040_TBL005 to icesp_sistemas;

grant all on icesp.ICESP_PRJ040_TBL005_SEQ to icesp_sistemas;

