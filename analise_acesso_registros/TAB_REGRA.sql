--TAB CADASTRO DE REGRAS

create sequence tab_regra_seq
nocache;

create table TAB_REGRA
(
nr_sequencia number(10) default tab_regra_seq.nextval,
dt_atualizacao_nrec date default sysdate,
nm_acesso_nrec varchar2(100),
ds_regra varchar2(500),
ds_sql clob,
ie_situacao varchar2(1),
qt_temp_acesso number(10),
qt_temp_resp_usuario number(10),
qt_temp_resp_gestor number(10),
nm_resp_regra varchar2(500),
ds_email_resp_regra varchar2(500),
dt_atualizacao date,
nm_acesso_atual varchar2(100)
);



insert into icesp.icesp_prj040_tbl003(NM_USUARIO_NREC, DS_REGRA, DS_SQL, IE_SITUACAO, QT_TEMP_ACESSO, QT_TEMP_RESP_USUARIO, QT_TEMP_RESP_GESTOR, NM_RESP_REGRA, DS_EMAIL_RESP_REGRA)
values ('diego.plima', 'MÉDICOS NEURO-CIRURGIÃO - PEDIATRA', 
'and exists(select 1
            from tasy.especialidade_medica em
            where em.CD_ESPECIALIDADE = 117
                and nvl(v.cd_espec_usuario,0) = em.CD_ESPECIALIDADE)
    and exists(select 1
                from tasy.area_atuacao_medica aam
                where aam.NR_SEQUENCIA = 8
                    and nvl(v.CD_AREA_ATU_USUARIO,0) = aam.NR_SEQUENCIA)',
'A', 15, 60, 60, 'Diego', 'diego.plima@hc.fm.usp.br');

insert into icesp.icesp_prj040_tbl003(NM_USUARIO_NREC, DS_REGRA, DS_SQL, IE_SITUACAO, QT_TEMP_ACESSO, QT_TEMP_RESP_USUARIO, QT_TEMP_RESP_GESTOR, NM_RESP_REGRA, DS_EMAIL_RESP_REGRA)
values ('diego.plima', 'EQUIPE DE SISTEMAS', 
'and exists(select 1
            from tasy.cargo c
            where cd_cargo =  116
                and nvl(v.CD_CARGO,0) = c.CD_CARGO)',
'A', 15, 60, 60, 'Diego', 'diego.plima@hc.fm.usp.br');

insert into icesp.icesp_prj040_tbl003(NM_USUARIO_NREC, DS_REGRA, DS_SQL, IE_SITUACAO, QT_TEMP_ACESSO, QT_TEMP_RESP_USUARIO, QT_TEMP_RESP_GESTOR, NM_RESP_REGRA, DS_EMAIL_RESP_REGRA)
values ('diego.plima', 'MÉDICOS NEURO-CIRURGIÃO', 
'and exists(select 1
            from tasy.especialidade_medica em
            where em.CD_ESPECIALIDADE = 117
                and nvl(v.cd_espec_usuario,0) = em.CD_ESPECIALIDADE)',
'A', 10, 60, 60, 'Diego', 'diego.plima@hc.fm.usp.br');

insert into icesp.icesp_prj040_tbl003(NM_USUARIO_NREC, DS_REGRA, DS_SQL, IE_SITUACAO, QT_TEMP_ACESSO, QT_TEMP_RESP_USUARIO, QT_TEMP_RESP_GESTOR, NM_RESP_REGRA, DS_EMAIL_RESP_REGRA)
values ('diego.plima', 'SUPERVISÃO DE SISTEMAS', 
'and exists(select 1
            from tasy.cargo c
            where cd_cargo = 176
                and nvl(v.CD_CARGO,0) = c.CD_CARGO)',
'A', 5, 60, 60, 'Diego', 'diego.plima@hc.fm.usp.br');

commit;


select * from icesp.icesp_prj040_tbl003;


delete from icesp.icesp_prj040_tbl003;

commit;


update icesp.icesp_prj040_tbl003
set qt_temp_acesso = 0
where nr_sequencia = 22;

commit;



grant all on icesp.icesp_prj040_tbl003 to icesp_sistemas;

grant all on icesp.icesp_prj040_tbl003_seq to icesp_sistemas;

