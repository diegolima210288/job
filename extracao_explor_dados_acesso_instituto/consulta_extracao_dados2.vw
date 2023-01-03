select
    f.nr_ficha,
    a.tp_atendimento,
    a.nr_controle,
    a.cd_pessoa,
    to_char(a.dt_entrada_real, 'dd/mm/yyyy') as dt_entrada,
    to_char(a.dt_entrada_real, 'hh24:mi:ss') as hr_entrada,
    case
    when (( to_char(a.dt_entrada_real,'hh24:mi') >= '06:00') and (to_char(a.dt_entrada_real,'hh24:mi') <= '11:59')) then
        'Manhã'
    when (( to_char(a.dt_entrada_real,'hh24:mi') >= '12:00') and (to_char(a.dt_entrada_real,'hh24:mi') <= '17:59')) then
        'Tarde'
    when ((( to_char(a.dt_entrada_real,'hh24:mi') >= '18:00') and (to_char(a.dt_entrada_real,'hh24:mi') <= '23:59')) or
        (( to_char(a.dt_entrada_real,'hh24:mi') >= '00:00') and (to_char(a.dt_entrada_real,'hh24:mi') <= '05:59')))then
        'Noite'
    end as ds_turno,
    to_char(a.dt_entrada_real, 'day') as ds_dia_semana,
    to_char(a.dt_saida_real, 'dd/mm/yyyy') as  dt_saida,
    to_char(a.dt_saida_real, 'hh24:mi:ss') as  hr_saida,
    b.ie_sexo,
    obter_idade(b.dt_nascimento, sysdate, 'A') as qt_idade_anos,
    'Acompanhante' as ds_tipo,
    g.ds_setor,
    d.nm_pais,
    c.sg_estado,
    e.ds_municipio
from acompanhante a
    inner join pessoa b
        on a.cd_pessoa_fisica = b.cd_pessoa_fisica
    left join compl_pessoa c
        on b.cd_pessoa_fisica = c.cd_pessoa_fisica
        and c.ie_tipo_complemento = 1
    left join pais d
        on c.nr_seq_pais = d.nr_sequencia
    left join municipio e
        on c.cd_municipio_ibge = e.cd_municipio_ibge
    left join visita f
        on a.nr_seq_paciente = f.nr_sequencia
    left join setor g
        on f.cd_setor_atendimento = g.cd_setor_atendimento
where (a.nr_controle between '41141525' and '41148521'
        or a.nr_controle between '20000001' and '20005000')
    and to_char(a.dt_entrada_real, 'yyyy') = 'XXXX'
union all
select
    a.nr_ficha,
    a.tp_atendimento,
    to_char(a.nr_seq_controle), 
    a.cd_pessoa,
    to_char(nvl(a.dt_entrada_real,a.dt_entrada), 'dd/mm/yyyy') as dt_entrada,
    to_char(nvl(a.dt_entrada_real,a.dt_entrada), 'hh24:mi:ss') as hr_entrada,
    case
    when (( to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') >= '06:00') and (to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') <= '11:59')) then
        'Manhã'
    when (( to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') >= '12:00') and (to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') <= '17:59')) then
        'Tarde'
    when ((( to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') >= '18:00') and (to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') <= '23:59')) or
        (( to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') >= '00:00') and (to_char(nvl(a.dt_entrada_real,a.dt_entrada),'hh24:mi') <= '05:59')))then
        'Noite'
    end as ds_turno,
    to_char(nvl(a.dt_entrada_real,a.dt_entrada), 'day') as ds_dia_semana,
    to_char(nvl(a.dt_saida_real, a.dt_saida), 'dd/mm/yyyy') as dt_saida,
    to_char(nvl(a.dt_saida_real, a.dt_saida), 'hh24:mi:ss') as hr_saida,
    b.ie_sexo,
    obter_idade(b.dt_nascimento, sysdate, 'A') qt_idade_anos,
    decode(a.IE_PACIENTE, 'S', 'Cliente',
    decode(obter_descricao_padrao('VISITANTE','DS_VISITANTE',a.nr_seq_tipo), 'Paciente', 
            'Cliente', obter_descricao_padrao('VISITANTE','DS_VISITANTE',a.nr_seq_tipo))) as ds_tipo,
    f.ds_setor,
    d.nm_pais,
    c.sg_estado,
    e.ds_municipio
from visita a
    inner join pessoa b
        on a.cd_pessoa_fisica = b.cd_pessoa_fisica
    left join compl_pessoa c
        on b.cd_pessoa_fisica = c.cd_pessoa_fisica
        and c.ie_tipo_complemento = 1
    left join pais d
        on c.nr_seq_pais = d.nr_sequencia
    left join municipio e
        on c.cd_municipio_ibge = e.cd_municipio_ibge
    left join setor f
        on a.cd_setor_atendimento = f.cd_setor_atendimento
where (a.nr_seq_controle between 20000001 and 20005000
        or a.nr_seq_controle between 41141525 and 41148521)
    and to_char(a.dt_entrada, 'yyyy') = 'XXXX'
;