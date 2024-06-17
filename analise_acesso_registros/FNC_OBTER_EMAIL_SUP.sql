create or replace function FNC_OBTER_EMAIL_SUP(p_nm_usuario varchar2)

return varchar2 is

w_ds_retorno varchar2(4000);
w_cd_espec_acesso espec_medico.cd_especialidade%type;
w_cd_area_atu_acesso area_at_medico.nr_sequencia%type;
w_ds_email tab_cad_email.ds_email%type;

begin

    select
        max(obter_espec_medico(p.cd_pessoa, null)) cd_espec_usuario,
        max(obter_areas_atuacao_med(p.cd_pessoa, null)) cd_area_atu_usuario
    into
        w_cd_espec_acesso,
        w_cd_area_atu_acesso
    from acesso a
        inner join pessoa p
            on a.cd_pessoa = p.cd_pessoa
    where a.nm_usuario = p_nm_usuario
        and a.ie_situacao = 'A';
        
    if nvl(w_cd_area_atu_acesso, 0) <> 0 then

        select
            ds_email
        into
            w_ds_retorno
        from tab_cad_email
        where nr_seq_cadastro = w_cd_area_atu_acesso;
        
    elsif nvl(w_cd_espec_acesso, 0) <> 0 then
    
        select
            ds_email
        into
            w_ds_retorno
        from tab_cad_email
        where nr_seq_cadastro = w_cd_espec_acesso;
        
    end if;

return w_ds_retorno;

end;
/
