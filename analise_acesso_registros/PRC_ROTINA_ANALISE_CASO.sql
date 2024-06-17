create or replace procedure PRC_ROTINA_ANALISE_CASO
as

v_temp_min_parametro number := 0;
ds_stack_w varchar2(4000);

procedure gravar_log (p_ds_objeto varchar2,
    p_nr_seq_acesso number, 
    p_nr_seq_regra number,
    p_ds_stack varchar2)

is

begin

    insert into tab_log_erro_seq
    (ds_objeto,
    nr_seq_acesso, 
    nr_seq_regra,
    ds_stack)
    values 
    (p_ds_objeto,
    p_nr_seq_acesso, 
    p_nr_seq_regra,
    p_ds_stack);

    commit;

end;

procedure identificacao_novos_casos(p_dt_inicio date, p_dt_fim date)
is

cursor c_view is
select
    vw.cd_pessoa_fisica,
    vw.nr_atendimento,
    vw.nm_usuario_acesso,
    vw.dt_acesso,
    vw.nr_sequencia
from view_acesso_cadastro vw
where vw.dt_acesso between p_dt_inicio and p_dt_fim
--eliminando acessos já registrados como caso ou histórico
    and not exists (select 1
                    from tab_registro reg
                    where vw.nr_sequencia = reg.nr_seq_acesso);

w_c_view c_view%rowtype;

cursor c_regras is
select
    regras.nr_sequencia nr_seq_regra,
    regras.ds_regra,
    regras.ds_sql,
    regras.qt_temp_acesso
from tab_regra regras
where regras.ie_situacao = 'A'
order by regras.nr_sequencia;

w_c_regras c_regras%rowtype;

cursor c_excecao is
select
    excecao.nr_sequencia nr_seq_excecao,
    excecao.ds_sql
from tab_regra_excecao rel
    inner join tab_excecao excecao
        on rel.nr_seq_excecao = excecao.nr_sequencia
where excecao.ie_situacao = 'A'
    and rel.nr_seq_regra = w_c_regras.nr_seq_regra;

w_c_excecao c_excecao%rowtype;

w_sql_regras varchar2(32767);
w_sql_excecao varchar2(32767);

v_teste_regra number;
v_teste_excecao number := 0;
v_teste_excecao2 number := 0;

v_historico_duplicado number;
v_caso_duplicado number;

v_nr_seq_registro tab_registro.nr_sequencia%type;

v_tempo_acesso number;

begin

--LENDO TODOS AS LINHAS DA VIEW
    open c_view;
    loop
        fetch c_view into w_c_view;
        exit when c_view%notfound;
    
    --ZERANDO VARIAVEL DE TESTE DA REGRA
        v_teste_regra := 0;
    
    --VALIDANDO AS LINHAS DA VIEW EM CADA CADASTRO DE REGRA
        open c_regras;
        loop
            fetch c_regras into w_c_regras;
            exit when c_regras%notfound;
            
            w_sql_regras := 'select
                count(*) quant
            from view_acesso_cadastro v
            where 1 = 1 
                and v.nr_sequencia = '||w_c_view.nr_sequencia||
            ' '||w_c_regras.ds_sql;
            
            begin
            
                execute immediate w_sql_regras into v_teste_regra;
            
                exception
                when others then
                    ds_stack_w :=
                           'error stack: '
                        || sys.dbms_utility.format_error_stack
                        || chr(13)
                        || 'error backtrace: '
                        || sys.dbms_utility.format_error_backtrace
                        || chr(13)
                        || 'call stack: '
                        || sys.dbms_utility.format_call_stack;
                    gravar_log('IDENTIFICACAO_NOVOS_CASOS',
                            w_c_view.nr_sequencia,
                            w_c_regras.nr_seq_regra,
                            ds_stack_w);
            
            end;
            
        --SE A LINHA FOR FILTRADA PELA REGRA, VALIDAMOS SE A LINHA SERÁ DESCARTADA PELA VALIDAÇÃO DAS EXCEÇÕES DA REGRA
            if v_teste_regra > 0 then
            
                v_teste_excecao := 0;
                v_teste_excecao2 := 0;
            
            --VALIDANDO A LINHA FILTRADA PELA REGRA NAS EXCEÇÕES DA REGRA 
                open c_excecao;
                loop
                    fetch c_excecao into w_c_excecao;
                    exit when c_excecao%notfound;

                    w_sql_excecao := 'select
                        count(*) quant
                    from view_acesso_cadastro v
                    where 1 = 1 
                        and v.nr_sequencia = '||w_c_view.nr_sequencia||
                    ' '||w_c_excecao.ds_sql;
                    
                    begin
                    
                        execute immediate w_sql_excecao into v_teste_excecao;
                    
                        exception
                        when others then
                            ds_stack_w :=
                                   'error stack: '
                                || sys.dbms_utility.format_error_stack
                                || chr(13)
                                || 'error backtrace: '
                                || sys.dbms_utility.format_error_backtrace
                                || chr(13)
                                || 'call stack: '
                                || sys.dbms_utility.format_call_stack;
                            gravar_log('IDENTIFICACAO_NOVOS_CASOS',
                                    w_c_view.nr_sequencia,
                                    w_c_regras.nr_seq_regra,
                                    ds_stack_w);
                    
                    end;

                --se o acesso for descartado por uma exceção, então será registrado como histórico
                    if v_teste_excecao = 0 then
                    
                        v_teste_excecao2 := v_teste_excecao2 + 1;
                        
                        begin
                            
                            insert into tab_registro(cd_pessoa, nr_ficha, nm_acesso, dt_acesso, nr_seq_acesso, nr_seq_regra, ie_desfecho, dt_desfecho, ds_observacao, nr_seq_excecao, ie_tp_registro)
                            values(w_c_view.cd_pessoa, w_c_view.nr_fichar, w_c_view.nm_acesso, w_c_view.dt_acesso, w_c_view.nr_sequencia, w_c_regras.nr_seq_regra, null, null, null, w_c_excecao.nr_seq_excecao, 'H');
                            
                            commit;

                            exception
                            when others then
                                ds_stack_w :=
                                       'error stack: '
                                    || sys.dbms_utility.format_error_stack
                                    || chr(13)
                                    || 'error backtrace: '
                                    || sys.dbms_utility.format_error_backtrace
                                    || chr(13)
                                    || 'call stack: '
                                    || sys.dbms_utility.format_call_stack;
                                gravar_log('IDENTIFICACAO_NOVOS_CASOS',
                                        w_c_view.nr_sequencia,
                                        w_c_regras.nr_seq_regra,
                                        ds_stack_w);
                        
                        end;
                        
                    end if;
                        
                end loop;
                close c_excecao;
           
            --se o acesso não for descartado por nenhum exceção, então será registrado como casos
                if v_teste_excecao2 = 0 then
                
                    v_tempo_acesso := obter_dif_data(w_c_view.dt_acesso, sysdate, 'TM');
                    
                    if v_tempo_acesso >= w_c_regras.qt_temp_acesso then
    
                        begin

                            insert into tab_registro(cd_pessoa, nr_ficha, nm_acesso, dt_acesso, nr_seq_acesso, nr_seq_regra, ie_desfecho, dt_desfecho, ds_observacao, nr_seq_excecao, ie_tp_registro)
                            values(w_c_view.cd_pessoa, w_c_view.nr_fichar, w_c_view.nm_acesso, w_c_view.dt_acesso, w_c_view.nr_sequencia, w_c_regras.nr_seq_regra, null, null, null, null, 'C');
                            
                            commit;
                        
                            exception
                            when others then
                                ds_stack_w :=
                                       'error stack: '
                                    || sys.dbms_utility.format_error_stack
                                    || chr(13)
                                    || 'error backtrace: '
                                    || sys.dbms_utility.format_error_backtrace
                                    || chr(13)
                                    || 'call stack: '
                                    || sys.dbms_utility.format_call_stack;
                                gravar_log('identificacao_novos_casos',
                                        w_c_view.nr_sequencia,
                                        w_c_regras.nr_seq_regra,
                                        ds_stack_w);

                        end;

                    end if;

                end if;

            end if;
                
        end loop;
        close c_regras;

    end loop;
    close c_view;

end;

procedure solicitacao_justif_acesso
is

cursor c_casos is
select
    reg.nr_sequencia nr_seq_caso,
    reg.dt_acesso,
    reg.nm_acesso,
    vw.ds_email_acesso,
    nvl(regra.ds_email_resp_regra, vw.ds_email_chefia) ds_email_sup,
    pf.nm_pessoa,
    pf.nr_registro||pf.nr_reg_dv ds_rghc,
    vw.nr_sequencia nr_seq_acesso,
    reg.cd_pessoa
from tab_registro reg
    inner join view_acesso_cadastro vw
        on reg.nr_seq_acesso = vw.nr_sequencia
    left join tab_regra regra
        on reg.nr_seq_regra = regra.nr_sequencia
    inner join pessoa pf
        on vw.cd_pessoa_fisica = pf.cd_pessoa_fisica
where reg.ie_desfecho is null
    and reg.ie_tp_registro = 'C'
order by 1;

v_c_casos c_casos%rowtype;

v_nr_seq_caso tab_registro.nr_sequencia%type;

begin

    open c_casos;
    loop
        fetch c_casos into v_c_casos;
        exit when c_casos%notfound;
        
        begin
        
            insert into tab_email_enviado(nr_seq_caso, dt_acesso, nm_cliente, nr_registro, nm_acesso, ds_email_acesso, ds_email_sup)
            values(v_c_casos.nr_seq_caso, v_c_casos.dt_acesso, v_c_casos.nm_pessoa, v_c_casos.ds_registro, v_c_casos.nm_acesso, v_c_casos.ds_email_acesso, v_c_casos.ds_email_sup);
    
            update tab_registro
            set ie_desfecho = 'E',
                dt_desfecho = sysdate
            where nr_sequencia = v_c_casos.nr_seq_caso;

            commit;
            
            exception
            when others then
                ds_stack_w :=
                       'error stack: '
                    || sys.dbms_utility.format_error_stack
                    || chr(13)
                    || 'error backtrace: '
                    || sys.dbms_utility.format_error_backtrace
                    || chr(13)
                    || 'call stack: '
                    || sys.dbms_utility.format_call_stack;
                gravar_log ('ENVIANDO_CASOS_TABELA_EMAIL',
                        v_c_casos.nr_seq_acesso,
                        null,
                        ds_stack_w);
                update tab_registro
                set ie_desfecho = 'i',
                    dt_desfecho = sysdate,
                    ds_observacao = 'Erro ao registrar caso na tabela de e-mail.'
                where nr_sequencia = v_c_casos.nr_seq_caso;
                
                commit;
        
        end;

    end loop;
    close c_casos;

end;

begin

    select
        max(regras.qt_temp_acesso)
    into
        v_temp_min_parametro
    from tab_regra regras
    where regras.ie_situacao = 'A'
    order by regras.nr_sequencia;

    --#STEP 1: identificação de novos casos
    identificacao_novos_casos((sysdate - v_temp_min_parametro/60/24), sysdate);

    --#STEP 2: solicitação justificativa
    solicitacao_justif_acesso;

end;
