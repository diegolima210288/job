select
    a.nr_ordem,
    to_char(a.dt_ordem_servico, 'day') as ds_dia_semana_os,
    to_char(a.dt_ordem_servico, 'dd/mm/yyyy') as dt_ordem_servico,
    to_char(a.dt_ordem_servico, 'hh24:mi:ss') as hr_ordem_servico,
    to_char(a.dt_fim, 'dd/mm/yyyy') as dt_fim,
    to_char(a.dt_fim, 'hh24:mi:ss') as hr_fim,
    obter_dif_data(a.dt_ordem_servico, a.dt_fim, 'TM') as tp_execucao_min,
    a.nr_equipe,
    b.ds_equipe_atend,
    d.ds_tp_setor,
    a.nr_seq_estagio,
    e.ds_estagio,
    a.ie_status_ordem,
    case
        when a.ie_status_ordem = 1 then 'Aberta'
        when a.ie_status_ordem = 2 then 'Processo'
        when a.ie_status_ordem = 3 then 'Encerrado'
    end as ds_status,
    a.ds_prioridade,
    e.ds_tipo
from ordem_servico a
    inner join equip_execucao b
        on a.nr_equipe = b.nr_sequencia
    inner join localizacao c
        on a.nr_seq_localizacao = c.nr_sequencia
    inner join estagio_processo e
        on a.nr_seq_estagio = e.nr_sequencia
    left join setor d
        on c.cd_setor = d.cd_setor_atendimento
    left join tipo_ordem_servico e
        on a.nr_seq_tipo_ordem = e.nr_sequencia
where a.nr_grupo_planej = 00
    and to_char(a.dt_ordem_servico, 'yyyy') = 'XXXX'
;