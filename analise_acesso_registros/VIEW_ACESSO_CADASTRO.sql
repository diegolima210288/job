create or replace view VIEW_ACESSO_CADASTRO
as
select
    lap.nr_sequencia,
    lap.nm_acesso,
    a.ds_email ds_email_acesso,
    nvl(fnc_obter_email_sup(lap.nm_usuario), acesso_sup.ds_email) ds_email_sup,
    obter_espec_medico(p_func.cd_pessoa_fisica, null) cd_espec_acesso,
    obter_areas_atuacao_med(p_func.cd_pessoa_fisica, null) cd_area_atu_acesso,
    p_func.cd_cargo,
    lap.dt_atualizacao dt_acesso,
    lap.cd_pessoa,
    ps.dt_obito,
    c.nr_seq_classif cd_ult_classif,
    lap.nr_ficha,
    f.dt_entrada,
    f.dt_alta
from log_acesso_prontuario lap
    inner join pessoa ps
        on lap.cd_pessoa_fisica = ps.cd_pessoa_fisica
    left join (select max(nr_sequencia) nr_sequencia, cd_pessoa_fisica
                from classif
                where dt_final_vigencia is null
                group by cd_pessoa_fisica) base
        on ps.cd_pessoa_fisica = base.cd_pessoa_fisica
    left join classif c
        on base.nr_sequencia = c.nr_sequencia
    left join ficha f
        on lap.nr_atendimento = f.nr_atendimento
    inner join acesso a
        on lap.nm_usuario = a.nm_usuario
    inner join pessoa p_func
        on u.cd_pessoa_fisica = p_func.cd_pessoa_fisica
    left join sup_pessoa sp
        on p_func.nr_seq_chefia = sp.nr_sequencia
    left join acesso acesso_sup
        on obter_acesso_ativo(sp.cd_pessoa) = acesso_sup.nm_usuario
where lap.cd_funcao = 281
;

