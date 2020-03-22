prompt PL/SQL Developer Export User Objects for user URP_AIA@FRFR.F3322.NET:702/ORCL
prompt Created by zhouqk on 2020��3��17��
set define off
spool �洢����.log

prompt
prompt Creating procedure GROUP_AML_INS_LXADDRESS
prompt ==========================================
prompt
create or replace procedure group_aml_ins_lxaddress(
	i_dealno in lxaddress_temp.dealno%type,
	i_clientno in cr_address.clientno%type
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXADDRESS_TEMP��
  -- parameter in: i_dealno    ���ױ��(ҵ���)
  --               i_clientno  �ͻ���
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     baishuai    2019/12/31 ����
  -- =============================================

  INSERT INTO LXADDRESS_TEMP (
    serialno,
		DealNo,
		ListNo,
		CSNM,
		Nationality,
		LinkNumber,
		Adress,
		CusOthContact,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
  (
		select
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,--������
			ROW_NUMBER () OVER (ORDER BY clientno) AS ListNo,--�ͻ���
			A.clientno AS CSNM,--�ͻ���
			A.nationality AS Nationality,--����
			A.linknumber AS LinkNumber,--��ϵ�绰
			A.adress AS Adress,--�ͻ���ַ
			A.cusothcontact AS CusOthContact,--�ͻ�������ϵ��ַ
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'hh24:mi:ss') AS MakeTime,
			'' AS ModifyDate,
			'' AS ModifyTime
		from
			GR_ADDRESS A
		where
			A.clientno = i_clientno
  );

  dbms_output.put_line('���뽻��������ϵ��ʽɸѡ������--ִ�����');

end group_aml_ins_lxaddress;
/

prompt
prompt Creating procedure GROUP_AML_INS_LXISTRADEBNF
prompt =============================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_INS_LXISTRADEBNF (
	i_dealno in NUMBER,
	i_contno in VARCHAR2
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lLXISTRADEBNF_TEMP��
  -- parameter in: i_dealno ���ױ��(ҵ���)
  --               i_contno ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/12/31  ����
  -- =============================================

  insert into LXISTRADEBNF_TEMP(
    serialno,
		DealNo,
		CSNM,
		InsuredNo,
		BnfNo,
		BNNM,
		BITP,
		OITP,
		BNID,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
(
			SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_contno AS CSNM,
			r.insureno AS InsuredNo,
			c.clientno AS BnfNo,
			c.NAME AS BNNM,
			c.cardtype AS BITP,
			nvl(c .OtherCardType, '@N') AS OITP,
      nvl((case c.cardtype when 'Ӫҵִ�պ�' then c.BUSINESSLICENSENO when '��֯����֤��' then c.ORGCOMCODE  when '˰��ǼǺ�' then c.TAXREGISTCERTNO else c.cardid end),'@N') as BNID,
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'HH:mm:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime
			FROM
					gr_client c,
					gr_rel r
			WHERE
					c.clientno = r.clientno
			AND r.custype = 'B'
			and r.contno=i_contno

  );
end GROUP_AML_INS_LXISTRADEBNF;
/

prompt
prompt Creating procedure GROUP_AML_INS_LXISTRADECONT
prompt ==============================================
prompt
create or replace procedure GROUP_AML_INS_LXISTRADECONT(
  i_dealno in varchar2,
  i_clientno in varchar2,
  i_contno in varchar2
) is
begin
  -- ============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADECONT_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_clientno �ͻ���
  --               i_contno   ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     baishuai    2019/12/31 ����
  -- ============================================

   --���ɽ��׺�ͬ��Ϣɸѡ������
  insert into LXISTRADECONT_TEMP(
    serialno,
    DealNo,
    CSNM,
    ALNM,
    AppNo,
    ContType,
    AITP,
    OITP,
    ALID,
    ALTP,
    ISTP,
    ISNM,
    RiskCode,
    Effectivedate,
    Expiredate,
    ITNM,
    ISOG,
    ISAT,
    ISFE,
    ISPT,
    CTES,
    FINC,
    DataBatchNo,
    MakeDate,
    MakeTime,
    ModifyDate,
    ModifyTime)
  (
    SELECT
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') AS DealNo,--���ױ��
      i_contno AS CSNM,     --������
      (select c.name from gr_client ct,gr_rel rl where rl.clientno=ct.clientno and rl.custype='O' and rl.contno=r.contno) AS ALNM,--�ͻ���
      (select c.clientno from gr_client ct,gr_rel rl where rl.clientno=ct.clientno and rl.custype='O' and rl.contno=r.contno) AS APPNO,--�ͻ���
      p.conttype AS ContType,--�Ÿ��ձ�־
      c.cardtype AS AITP,--֤������
      nvl(c.OtherCardType,'@N') AS OITP,--����֤������
      --nvl(c.cardid,'@N') AS ALID,
     (case when c.cardtype='B' then c.BusinessLicenseNo
           when c.cardtype='O' then c.OrgComCode
           when c.cardtype='T' then c.TaxRegistCertNo
       end) AS ALID,--֤����
      c.clienttype AS ALTP,--�ͻ�����
      (select risktype from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from gr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS ISTP,--��������
      (select riskname from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from gr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS ISNM,  --��������
      (select riskcode from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from gr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS RiskCode,--���ֱ���
      p.effectivedate AS Effectivedate,--��Ч��
      p.expiredate AS Expiredate,--��ֹ��
      p.insuredpeoples AS ITNM,--����������
      p.inssubject AS ISOG,--���ձ��
      p.amnt AS ISAT,--���ս��
      p.prem AS ISFE,--���շ�
      p.paymethod AS ISPT,--�ɷѷ�ʽ
      nvl(p.othercontinfo, '@N') AS CTES,--���պ�ͬ������Ϣ
      p.locid AS FINC,--���ڻ����������
      NULL AS DataBatchNo,
      to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') AS MakeDate,
      to_char(sysdate,'HH:mm:ss') AS MakeTime,
      NULL AS ModifyDate,
      NULL AS ModifyTime
      from
        GR_POLICY p,
        GR_CLIENT c,
        GR_REL r
      where
          p.contno=r.contno
      and c.clientno=r.clientno
      and r.custype='O'
      and r.contno=i_contno
  );

  dbms_output.put_line('������ɽ��׺�ͬ��Ϣɸѡ������--ִ�����');

end GROUP_AML_INS_LXISTRADECONT;
/

prompt
prompt Creating procedure GROUP_AML_INS_LXISTRADEDETAIL
prompt ================================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_INS_LXISTRADEDETAIL (
i_dealno in NUMBER,
	i_contno in VARCHAR2,
	i_transno in VARCHAR2,
	i_triggerflag in VARCHAR2
	) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADEDETAIL_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_ocontno  ������
  --               i_transno  ���ױ��(ƽ̨��)
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/12/31  ����
  -- =============================================


  insert into LXISTRADEDETAIL_TEMP(
    serialno,
    DealNo,
		TICD,
		ICNM,
		TSTM,
		TRCD,
		ITTP,
		CRTP,
		CRAT,
		CRDR,
		CSTP,
		CAOI,
		TCAN,
		ROTF,
		DataState,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime,
		TRIGGERFLAG)
  (
    SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_transno AS TICD,
			i_contno AS ICNM,
			to_char(t.transdate,'yyyymmddHHmmss') AS TSTM,
			t.transfromregion AS TRCD,
			t.transtype AS ITTP,
			t.curetype AS CRTP,
			t.payamt AS CRAT,
			T.PAYWAY AS CRDR,
			T.PAYMODE AS CSTP,
			nvl(t.accbank,'@N') AS CAOI,
			nvl(t.accno,'@N') AS TCAN,
			nvl(t.remark, '@N') AS ROTF,
      'A01' as DataState,
			NULL  AS DataBatchNo,
		  to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') AS MakeDate,
			to_char(sysdate,'HH24:mi:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime,
			i_triggerflag AS TRIGGERFLAG
		from
			gr_trans t
		where
				t.contno = i_contno
		and t.transno = i_transno
  );

end GROUP_AML_INS_LXISTRADEDETAIL;
/

prompt
prompt Creating procedure GROUP_AML_INS_LXISTRADEINSURED
prompt =================================================
prompt
create or replace procedure GROUP_AML_INS_LXISTRADEINSURED(
	i_dealno in LXISTRADEINSURED_TEMP.Dealno%type,
	i_contno in LXISTRADEINSURED_TEMP.CSNM%type
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADEINSURED_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_contno   ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     baishuai    2019/12/31  ����
  -- =============================================

  --���ɽ��ױ�������Ϣɸѡ������
  insert into LXISTRADEINSURED_TEMP(
    serialno,
		DEALNO,
		CSNM,
		INSUREDNO,
		ISTN,
		IITP,
		OITP,
		ISID,
		RLTP,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
(
    SELECT
      getSerialno(sysdate) as serialno,
 			LPAD(i_dealno,20,'0') AS DealNo,--���ױ��
			i_contno AS CSNM,     --������
			c.clientno AS INSUREDNO, --�ͻ���
			c.NAME AS ISTN,          --����������
			nvl(c.cardtype, '@N') AS IITP,--������֤������
			nvl(c.OtherCardType, '@N') AS OITP,--����֤������
			c.cardid AS ISID,--֤������
			nvl(r.relaappnt, '@N') AS RLTP,--Ͷ�����뱻�����˹�ϵ
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'HH:mm:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime
			FROM
					gr_client c,
					gr_rel r
			WHERE
					c.clientno = r.clientno
			AND r.custype = 'I'
			AND r.contno = i_contno
  );

  dbms_output.put_line('������ɽ��ױ�������Ϣɸѡ������--ִ�����');

end GROUP_AML_INS_LXISTRADEINSURED;
/

prompt
prompt Creating procedure GROUP_AML_INS_LXISTRADEMAIN
prompt ==============================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_INS_LXISTRADEMAIN (
	i_dealno in NUMBER,
  i_clientno in varchar2,
  i_contno in varchar2,
  i_operator in varchar2,
  i_stcr in varchar2 ,
  i_baseLine in DATE) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxistrademain_temp��
  -- parameter in: i_clientno �ͻ���
  --               i_dealno   ���ױ��
	--               i_operator ������
  --               i_stcr     ���ɽ�����������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     xn    2019/12/31  ����
  -- =============================================

  insert into lxistrademain_temp(
    serialno,
    dealno, -- ���ױ��
    rpnc,   -- �ϱ��������
    detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
    torp,   -- ���ʹ�����־
    dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
    odrp,   -- �������ͷ���
    tptr,   -- ���ɽ��ױ��津����
    otpr,   -- �������ɽ��ױ��津����
    stcb,   -- �ʽ��׼��ͻ���Ϊ���
    aosp,   -- �ɵ����
    stcr,   -- ���ɽ�������
    csnm,   -- �ͻ���
    senm,   -- ������������/����
    setp,   -- �����������֤��/֤���ļ�����
    oitp,   -- �������֤��/֤���ļ�����
    seid,   -- �����������֤��/֤���ļ�����
    sevc,   -- �ͻ�ְҵ����ҵ
    srnm,   -- �������巨������������
    srit,   -- �������巨�����������֤������
    orit,   -- �������巨���������������֤��/֤���ļ�����
    srid,   -- �������巨�����������֤������
    scnm,   -- ��������عɹɶ���ʵ�ʿ���������
    scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
    scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    strs,   -- ���佻�ױ�ʶ
    datastate, -- ����״̬
    filename,  -- ��������
    filepath,  -- ����·��
    rpnm,      -- ���
    operator,  -- ����Ա
    managecom, -- �������
    conttype,  -- �������ͣ�01-����, 02-�ŵ���
    notes,     -- ��ע
		baseline,       -- ���ڻ�׼
    getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩
    nextfiletype,   -- �´��ϱ���������
    nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
    nextpackagetype,-- �´��ϱ����İ�����
    databatchno,    -- �������κ�
    makedate,       -- ���ʱ��
    maketime,       -- �������
    modifydate,     -- ����������
    modifytime,			-- ������ʱ��
		judgmentdate,   -- ��������
    ORXN,           -- ���������״��ϱ��ɹ��ı�������
		ReportSuccessDate)-- �ϱ��ɹ�����
(
    select
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') as dealno,
      '@N' as rpnc,
      '01' as detr,  -- ��������̶ȣ�01-���ر������
      '1' as torp,
      '01' as dorp,  -- ���ͷ���01-�����й���ϴǮ���������ģ�
      '@N' as odrp,
      '01' as tptr,  -- ���ɽ��ױ��津���㣨01-ģ��ɸѡ��
      '@N' as otpr,
      '' as stcb,
      '' as aosp,
      i_stcr as stcr,
      c.clientno as csnm,
      c.name as senm,
      nvl(c.cardtype,'@N') as setp,
      nvl(c.othercardtype,'@N') as oitp,
      --�ŵ���ȡ Ӫҵִ�պŻ���֯����֤�Ż�˰��ǼǺ�
      nvl((case c.cardtype when 'Ӫҵִ�պ�' then c.BUSINESSLICENSENO when '��֯����֤��' then c.ORGCOMCODE  when '˰��ǼǺ�' then c.TAXREGISTCERTNO else c.cardid end),'@N') as seid,
      nvl(c.occupation,'@N') as sevc,
      nvl(c.legalperson,'@N') as srnm,
      nvl(c.legalpersoncardtype,'@N') as srit,
      nvl(c.otherlpcardtype,'@N') as orit,
      nvl(c.legalpersoncardid,'@N') as srid,
      nvl(c.holdername,'@N') as scnm,
      nvl(c.holdercardtype,'@N') as scit,
      nvl(c.otherholdercardtype,'@N') as ocit,
      nvl(c.holdercardid,'@N') as scid,
      '@N' as strs,
      'A01' as datastate,
      '' as filename,
      '' as filepath,
      (select username from lduser where usercode = i_operator) as rpnm,
      i_operator as operator,
      (select locid from gr_policy where contno=i_contno) as managecom,
      c.conttype as conttype,
      '' as notes,
      i_baseLine as baseline,
      '01' as getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ��
      '' as nextfiletype,
      '' as nextreferfileno,
      '' as nextpackagetype,
      null as databatchno,
      to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
      to_char(sysdate,'hh24:mi:ss') as maketime,
      null as modifydate,  -- ������ʱ��
      null as modifytime,
			null as judgmentdate,--��������
      null as ORXN,        -- ���������״��ϱ��ɹ��ı�������
			null as ReportSuccessDate--�ϱ��ɹ�����
    from
      gr_client c
    where
     c.clientno = i_clientno
  );

end GROUP_AML_INS_LXISTRADEMAIN;
/

prompt
prompt Creating procedure GROUP_AML_A0101
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_A0101(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)

begin
  -- =============================================
  -- Rule:
  --  ���ݱ����ϵ�Ͷ����λ���������ˡ������ˣ��������������ˣ����ɶ������ˡ���λ�����˺͵�����������/����˵�Ψһҵ������ƥ���Ƿ����ڽ�ֹ������,����ϵͳץȡ���ɿ��ɽ���
  --  ͳ��ά��: ����
  --  Ψһҵ��������
  --  Ͷ����λ����λ����+֤������+֤������
  --  ��������:
  --     1.֤��������������֤������+֤�����룻
  --     2.����Ϊ������+�Ա�+��������+֤������+֤������
  --  �����ˣ�
  --     1.֤��������������֤������+֤�����룬
  --     2.����Ϊ������+�Ա�+��������+֤������+֤������
  --  �ɶ����ɶ�����+֤������+֤������
  --  ���ˣ���������+֤������+֤������
  --  �����ˣ�����������+֤������+֤������
  --      ��ȡ������
  --        1) ��ȡ����ά��
  --          ��ȡǰһ������/���ѽ��׵ı�����
  --      ��ȡ�����
  --        1����ȡ�����Ʋ������ĸñ����ͻ���ΪͶ���˻򱻱��˻��������������б�������/���ѵĽ�����Ϊ��
  --        2���������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2020/01/07
  -- ============================================
dbms_output.put_line('��ʼִ�����չ���A0101');
    -- �������ʱ��
  delete from Assist;
  
  insert into Assist(
       clientno,
       contno,
       transno,
       transdate,
       custype,
       args1, -- name
       args2, -- sex
       args3, -- birthday
       args4, -- cardtype
       args5, -- cardid
       args6, -- �ɶ�
       args7,
       args8,
       args9, -- ����
       args10,
       args11,
       args12,-- ������ 
       args13,
       args14,
       mark   -- ���
  )select 
       r.clientno,
       r.contno,
       t.transno,
       t.transdate,
       r.custype,
       
       c.name,
       c.sex,
       c.birthday,
       c.cardtype,
       c.cardid,
       
       c.holdername,             -- �ɶ�
       c.holdercardtype,         
       c.holdercardid,
       
       c.legalperson,            -- ����
       c.legalpersoncardtype,
       c.legalpersoncardid,
       
       c.satrap,                 -- ������
       c.satrapidtype,           
       c.satrapid,
                 
       'A0101_1'
    from 
       gr_client c, gr_rel r, gr_trans t
    where c.clientno = r.clientno
      and r.contno = t.contno
      and r.custype in ('O', 'I', 'B') -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      and t.payway in ('01', '02')
      and t.conttype = '2'             -- �������ͣ�2-�ŵ�
      and trunc(t.transdate) = trunc(i_baseLine);
  
  -- �Ӹ�������ɸѡ����
  
  -- Ͷ����
  insert into Assist(
       clientno,
       transno,
       contno,
       mark
  )
  select
       clientno,
       transno,
       contno,
       'Ͷ����'
    from
       Assist a
    where
        a.custype = 'O'              -- Ͷ����
    and GR_isValidCont(a.contno)='yes'  -- ��Ч����
    and a.mark = 'A0101_1'
    and exists(
        select 
             1 
          from 
            lxblacklist 
          where 
              source = '1'
          and isactive ='0'
          -- Ͷ���� 
          and (name = a.args1 and cardtype = a.args4 and idnumber = a.args5)
           -- �ɶ�
           or (name = a.args6 and cardtype = a.args7 and idnumber = a.args8)
           -- ����
           or (name = a.args9 and cardtype = a.args10 and idnumber = a.args11)
           -- ������
           or (name = a.args12 and cardtype = a.args13 and idnumber = a.args14)
      );
      
  -- �����˺�������
  insert into Assist(
       clientno,
       transno,
       contno,
       mark
  )
  select
       -- ȡͶ���˵Ŀͻ���
       (select clientno from Assist where custype ='O' and transno = a.transno and contno = a.contno),
       transno,
       contno,
       '�����˺�������'
    from
       Assist a
    where
        a.custype in ('I','B')       -- �����˺�������
    and GR_isValidCont(a.contno)='yes'    -- ��Ч����
    and a.mark = 'A0101_1'
    and exists(
        select 
             1 
          from 
            lxblacklist 
          where 
              source = '1'
          and isactive ='0'
          -- �����˻���������
          and (a.args4 = '110001' and name = a.args1 and idnumber = a.args5)
           -- �������֤
           or (name = a.args1 and sex = a.args2 and to_date(substr(birthday,1,10),'yyyy-MM-dd') = a.args3 
              
              and cardtype = a.args4 and idnumber = a.args5)
              
           -- �ɶ�
           or (name = a.args6 and cardtype = a.args7 and idnumber = a.args8)
           -- ����
           or (name = a.args9 and cardtype = a.args10 and idnumber = a.args11)
           -- ������
           or (name = a.args12 and cardtype = a.args13 and idnumber = a.args14)
      );
  
  
  

  declare
     cursor baseInfo_sor is
        select
            distinct
            clientno,
            transno,
            contno
          from
            Assist a
          where
              a.mark in ('Ͷ����','�����˺�������')
          order by clientno;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GA0101', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���A0101ִ�гɹ�');
  delete from Assist a where a.mark in ( 'A0101_1','Ͷ����','�����˺�������');

  commit;
end Group_aml_A0101;
/

prompt
prompt Creating procedure GROUP_AML_A0102
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_A0102(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)

begin
  -- ============================================
  -- Rule:
  -- �ͻ����ע������ƥ�䡣���У��ͻ�����Ͷ���ˡ������ˡ������ˡ�������������/����ˣ�
  --   �Լ������е����������ˡ��ɶ��͸߼������Ȳɼ��������Ϣ�Ķ���
  -- 1) ͳ��ά�ȣ�����
  --     ץȡǰһ����Ч����Ч�������ⰸ��Ϣ
  --     ���ݱ����ϵ�Ͷ����λ���������ˡ������ˣ��������������ˣ���
  --     �ɶ������ˡ���λ�����˺͵�����������/����˵�Ψһҵ������ƥ���Ƿ����ڹ�ע��������
  --     Ψһҵ������ƥ��������"PNRϵͳ������"��
  -- 2) ��������ϵ�����һ���Ȼ�˻�λ�������ֹ����������ץȡ���������ɼ�����ݡ�
  -- 3) ���У������º���ϵͳ��
  --     ������������ȡ"�Ƿ������ί�н���"��Ӧ�Ŀ������ƣ�
  --     ��������ȡ�˵��жϣ�����Ǳ�ȫ�˱������ȡ��Ͷ����λ���������˿������ƣ�
  --     ���������֧���ĵ����������ȡ���������˼�����������������˵Ŀ������ƣ�
  --     ����������������Ƹ��������˺����������ƽ��бȽϣ�����һ��Ϊ����������ˡ�
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/08
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/08     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���A0102');
    -- �������ʱ��
  delete from Assist;
  
  insert into Assist(
       clientno,
       contno,
       transno,
       transdate,
       custype,
       args1, -- name
       args2, -- sex
       args3, -- birthday
       args4, -- cardtype
       args5, -- cardid
       args6, -- �ɶ�
       args7,
       args8,
       args9, -- ����
       args10,
       args11,
       args12,-- ������ 
       args13,
       args14,
       mark   -- ���
  )select 
       r.clientno,
       r.contno,
       t.transno,
       t.transdate,
       r.custype,
       
       c.name,
       c.sex,
       c.birthday,
       c.cardtype,
       c.cardid,
       
       c.holdername,             -- �ɶ�
       c.holdercardtype,         
       c.holdercardid,
       
       c.legalperson,            -- ����
       c.legalpersoncardtype,
       c.legalpersoncardid,
       
       c.satrap,                 -- ������
       c.satrapidtype,           
       c.satrapid,
                 
       'A0102_1'
    from 
       gr_client c, gr_rel r, gr_trans t
    where c.clientno = r.clientno
      and r.contno = t.contno
      and r.custype in ('O', 'I', 'B') -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      and t.payway in ('01', '02')
      and t.conttype = '2'             -- �������ͣ�2-�ŵ�
      and trunc(t.transdate) = trunc(i_baseLine);
  
  -- �Ӹ�������ɸѡ����
  
  -- Ͷ����
  insert into Assist(
       clientno,
       transno,
       contno,
       mark
  )
  select
       clientno,
       transno,
       contno,
       'Ͷ����'
    from
       Assist a
    where
        a.custype = 'O'              -- Ͷ����
    and GR_isValidCont(a.contno)='yes'  -- ��Ч����
    and a.mark = 'A0102_1'
    and exists(
        select 
             1 
          from 
            lxblacklist 
          where 
              source = '2'
          and isactive ='0'
          -- Ͷ���� 
          and (name = a.args1 and cardtype = a.args4 and idnumber = a.args5)
           -- �ɶ�
           or (name = a.args6 and cardtype = a.args7 and idnumber = a.args8)
           -- ����
           or (name = a.args9 and cardtype = a.args10 and idnumber = a.args11)
           -- ������
           or (name = a.args12 and cardtype = a.args13 and idnumber = a.args14)
      );
      
  -- �����˺�������
  insert into Assist(
       clientno,
       transno,
       contno,
       mark
  )
  select
       -- ȡͶ���˵Ŀͻ���
       (select clientno from Assist where custype ='O' and transno = a.transno and contno = a.contno),
       transno,
       contno,
       '�����˺�������'
    from
       Assist a
    where
        a.custype in ('I','B')       -- �����˺�������
    and GR_isValidCont(a.contno)='yes'    -- ��Ч����
    and a.mark = 'A0102_1'
    and exists(
        select 
             1 
          from 
            lxblacklist 
          where 
              source = '2'
          and isactive ='0'
          -- �����˻���������
          and (a.args4 = '110001' and name = a.args1 and idnumber = a.args5)
           -- �������֤
           or (name = a.args1 and sex = a.args2 and to_date(birthday,'yyyy-MM-dd') = a.args3 
              
              and cardtype = a.args4 and idnumber = a.args5)
              
           -- �ɶ�
           or (name = a.args6 and cardtype = a.args7 and idnumber = a.args8)
           -- ����
           or (name = a.args9 and cardtype = a.args10 and idnumber = a.args11)
           -- ������
           or (name = a.args12 and cardtype = a.args13 and idnumber = a.args14)
      );
  
  
  

  declare
     cursor baseInfo_sor is
        select
            distinct
            clientno,
            transno,
            contno
          from
            Assist a
          where
              a.mark in ('Ͷ����','�����˺�������')
          order by clientno;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GA0102', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���A0102ִ�гɹ�');
  delete from Assist a where a.mark in ( 'A0102_1','Ͷ����','�����˺�������');

  commit;
end Group_aml_A0102;
/

prompt
prompt Creating procedure GROUP_AML_A0200
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_A0200(
    i_baseLine IN DATE,
    i_oprater  IN VARCHAR2)
IS
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type;                       -- �ͻ���
  v_threshold_money NUMBER := getparavalue('GA0200', 'M1'); -- ��ֵ �ۼƱ��ѽ��
BEGIN
  -- =============================================
  -- Rule:
  -- Ͷ���˵Ĺ������ڸ߷��չ��һ���������ۼ��ѽ����ѽ����ڵ��ڷ�ֵ��
  --  1) ��ȡ����ά��
  --   1.ץȡǰһ����Ч����Ч��������
  --2.���ݱ�����Ͷ����λ�Ĺ���������ֶ�ƥ���Ƿ����ڸ߷��չ��һ������
  --3.������ڸ߷��չ��һ������ͳ�Ƹ�Ͷ����λ����������Ч�������ۼ��ѽ����ѣ���/���ѽ������ݣ����ڵ�����ֵ��
  --3.��ֵ����Ϊ��100��
  --4.���������������ɼ������
  --������Դ��PNR
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2019/1/6
  -- Changes log:
  -- ============================================
  delete from lxassista;

    dbms_output.put_line('��ʼִ�����չ���A0200');

--��ȡ����Ͷ����Ͷ�������ڸ߷��չ��һ�����ı�����Ϣ
insert into lxassista
  (policyno,
   CustomerNo,
   args4, --���ױ��
   args1, --Ͷ����ҵ����
   args2, --֤����
   args3, --֤������
   args5)
  select t.contno,
         r.clientno,
         t.transno,
         c.name,
         (case
           when c.CardType = 'B' then
            c.BusinessLicenseNo --Ӫҵִ�պ�
           when c.CardType = 'O' then
            c.OrgComCode --��֯����֤��
           else
            c.TaxRegistCertNo --˰��ǼǺ�
         end),
         c.CardType,
         'A0200_1'
    from gr_client c��gr_rel r��gr_trans t
   where c.clientno = r.clientno
     and t.contno = r.contno
     and exists
   ( --�߷��չ���
          select 1
            from lxriskinfo lx
           where lx.code = c.nationality
             and lx.recordtype = '02' -- �������ͣ�02-����
             and lx.risklevel = '3' -- ���յȼ���3-�߷��յȼ�
          )
     and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
     and t.payway = '01'  --��
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and t.transtype = 'AA001' -- ��������ΪͶ��
     and t.source='1'  --1-PNR 
     and t.conttype = '2' -- �������ͣ�2-�ŵ�
     and trunc(t.transdate) = trunc(i_baseLine);

--ȥ�� :������ҵ���ƺ�֤����ȥ��
insert into lxassista
  (args1, args2, args3, args5)
  select args1, args2, args3, 'A0200_2'
    from lxassista lx
   where lx.args5 = 'A0200_1'
   group by args2, args1, args3;

--��ȡͶ�����������б����͸ñ����µ��ۼ��ѽ�����
insert into lxassista
  (policyno, numargs1, CustomerNo,args1, args2, args3, args5)
  select p.contno,
         p.SumPrem,    --�ۼ��ѽ�����
         r.clientno,
         c.name,
         (case
           when c.CardType = 'B' then
            c.BusinessLicenseNo --Ӫҵִ�պ�
           when c.CardType = 'O' then
            c.OrgComCode --��֯����֤��
           else
            c.TaxRegistCertNo --˰��ǼǺ�
         end),
         c.CardType,
         'A0200_3'
    from gr_policy p, gr_rel r, gr_client c
   where p.contno = r.contno
     and r.clientno = c.clientno
     and exists
   (select 1
            from lxassista la
           where la.args1 = c.name
             and la.args3 = c.cardtype
             and (la.args2 = c.BusinessLicenseNo or la.args2 = c.OrgComCode or
                 la.args2 = c.TaxRegistCertNo)
             and la.args5 = 'A0200_2')
     and GR_isValidCont(p.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and p.source='1'  --1-PNR 
     and p.conttype = '2' -- �������ͣ�2-�ŵ�
     order by r.clientno,p.contno desc;

--��ȡ�ͻ�������Ч�������ۼ�Ͷ��������100��ı�����Ϣ
   declare
   cursor baseInfo_sor is
          select 
             r.clientno,
             t.transno,
             t.contno
          from gr_trans t, gr_rel r, gr_client c
          where t.contno = r.contno
          and exists
          (select 1
                  from lxassista la
                  where 
                       la.args1 = c.name
                       and la.args3 = c.cardtype
                       and (la.args2 = c.BusinessLicenseNo or la.args2 = c.OrgComCode or
                       la.args2 = c.TaxRegistCertNo)
                       and la.args5 = 'A0200_3'
                       group by la.args1,la.args2, la.args3
                       having sum(la.numargs1) >= v_threshold_money)
     and r.clientno = c.clientno
     and t.payway = '01'  --��
     and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and t.transtype = 'AA001' -- ��������ΪͶ��
     and t.source = '1' --1-PNR 2-RPAS 3-GTA
     and t.conttype = '2' -- �������ͣ�1-����
     order by r.clientno,t.contno desc;
   

    -- �����α����
    c_clientno gr_client.clientno%type; -- �ͻ���
    c_contno gr_trans.contno%type;      -- ������
    c_tranid gr_trans.transno%type;     -- ���׺�


  BEGIN
    OPEN baseInfo_sor;
    LOOP
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      FETCH baseInfo_sor INTO c_clientno, c_contno,c_tranid;
      EXIT
    WHEN baseInfo_sor%notfound; -- �α�ѭ������
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      IF v_clientno IS NULL OR c_clientno <> v_clientno THEN
        v_dealNo    :=NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GA0200', i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_tranid,'1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      ELSE
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno ,c_tranid,'');
      END IF;
      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);
      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);
      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    END LOOP;
    CLOSE baseInfo_sor;
  END;
  DELETE FROM LXAssistA;
    dbms_output.put_line('���չ���A0200ִ�гɹ�');
  commit;
END GROUP_AML_A0200;
/

prompt
prompt Creating procedure GROUP_AML_A0300
prompt ==================================
prompt
create or replace procedure GROUP_AML_A0300(i_baseLine in date,
                                           i_oprater  in varchar2) is
  v_threshold_money NUMBER := getparavalue('GA0300', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_dealNo   lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --  �߷��տͻ��ڱ��������ڼ䣬�����ӱ���׷�ӱ��ѡ��˱��������ȡ�ֽ��ֵ���ʽ������˾������Ҵﵽ��ֵ�����������������ͽ��ɱ��ѡ�
  --"�������߼�ͬ����
  --��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ����Ч����Ч��������
  --2.���ݱ�����Ͷ����λ����ҵ�����ֶ�ƥ���Ƿ����ڸ߷�����ҵ�ͻ���
  --3.������ڸ߷�����ҵ�ͻ���ͳ�Ƹ�Ͷ����λ����������Ч�������ۼ��ѽ����ѣ���/���ѽ������ݣ����ڵ�����ֵ��
  --4.��ֵ����Ϊ��100��ʵ�ֿ�������ʽ
  --5.���������������ɼ������"
  --������Դ��RPAS��PNR
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/09
  -- ============================================
dbms_output.put_line('��ʼִ�����չ���A0300');

DELETE FROM LXAssistA;

--��ȡͶ����Ͷ������,Ͷ����ҵ������ҵ�ķ��յȼ�Ϊ�߷��յı���
insert into lxassista
  (policyno,
   CustomerNo,
   args4, --���ױ��
   args1, --Ͷ����ҵ����
   args2, --֤����
   args3, --֤������
   args5)
  select t.contno,
         r.clientno,
         t.transno,
         c.name,
         (case
           when c.CardType = 'B' then
            c.BusinessLicenseNo --Ӫҵִ�պ�
           when c.CardType = 'O' then
            c.OrgComCode --��֯����֤��
           else
            c.TaxRegistCertNo --˰��ǼǺ�
         end),
         c.CardType,
         'A0300_01'
    from gr_trans t, gr_rel r, gr_client c
   where t.contno = r.contno
     and exists
   ( --Ͷ����ҵ��ҵΪ�߷�����ҵ
          select 1
            from lxriskinfo lx
           where lx.code = c.BusinessType
             and lx.recordtype = '04'
             and lx.risklevel = '3')
     and r.clientno = c.clientno
     and t.payway = '01'  --��
     and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and t.transtype = 'AA001' -- ��������ΪͶ��
     and t.source in ('2','1') --1-PNR 2-RPAS 3-GTA
     and t.conttype = '2' -- �������ͣ�1-����
     and trunc(t.transdate) = trunc(i_baseLine);

--ȥ��
insert into lxassista
  (args1, args2, args3, args5)
  select args1, args2, args3, 'A0300_02'
    from lxassista lx
   where lx.args5 = 'A0300_01'
   group by args2, args1, args3;

--��ȡͶ�����������б���
insert into lxassista
  (policyno, numargs1, CustomerNo,args1, args2, args3, args5)
  select p.contno,
         p.SumPrem,    --�ۼ��ѽ�����
         r.clientno,
         c.name,
         (case
           when c.CardType = 'B' then
            c.BusinessLicenseNo --Ӫҵִ�պ�
           when c.CardType = 'O' then
            c.OrgComCode --��֯����֤��
           else
            c.TaxRegistCertNo --˰��ǼǺ�
         end),
         c.CardType,
         'A0300_03'
    from gr_policy p, gr_rel r, gr_client c
   where p.contno = r.contno
     and r.clientno = c.clientno
     and exists
   (select 1
            from lxassista la
           where la.args1 = c.name
             and la.args3 = c.cardtype
             and (la.args2 = c.BusinessLicenseNo or la.args2 = c.OrgComCode or
                 la.args2 = c.TaxRegistCertNo)
             and la.args5 = 'A0300_02')
     and GR_isValidCont(p.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and p.source in ('2','1') --1-PNR 2-RPAS 3-GTA
     and p.conttype = '2' -- �������ͣ�1-����
     order by r.clientno;

--��ȡ�ͻ�������Ч�������ۼ�Ͷ��������100��ı�����Ϣ
declare
   cursor baseInfo_sor is
          select 
             r.clientno,
             t.transno,
             t.contno
          from gr_trans t, gr_rel r, gr_client c
          where t.contno = r.contno
          and exists
          (select 1
                  from lxassista la
                  where 
                       la.args1 = c.name
                       and la.args3 = c.cardtype
                       and (la.args2 = c.BusinessLicenseNo or la.args2 = c.OrgComCode or
                       la.args2 = c.TaxRegistCertNo)
                       and la.args5 = 'A0300_03'
                       group by la.args1,la.args2, la.args3
                       having sum(la.numargs1) >= v_threshold_money)
     and r.clientno = c.clientno
     and t.payway = '01'  --��
     and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and t.transtype = 'AA001' -- ��������ΪͶ��
     and t.source in ('2','1') --1-PNR 2-RPAS 3-GTA
     and t.conttype = '2' -- �������ͣ�1-����
     order by r.clientno,t.contno desc;

    -- �����α����
    g_clientno  gr_client.clientno%type; -- �ͻ���
    g_transno   gr_trans.transno%type; -- ���׺�
    g_contno    gr_trans.contno%type; -- ������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor
        into g_clientno, g_transno, g_contno;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽����
      if v_clientno is null or g_clientno <> v_clientno then

        v_dealNo   := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        v_clientno := g_clientno; -- ���¿�������Ŀͻ���

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        GROUP_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   g_clientno,
                                   g_contno,
                                   i_oprater,
                                   'GA0300',
                                   i_baseLine);

        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '1');
      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, g_clientno, g_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, g_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, g_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, g_clientno);

    end loop;
    close baseInfo_sor;
  end;
  DELETE FROM LXAssistA;
    dbms_output.put_line('���չ���A0300ִ�гɹ�');
  commit;
END GROUP_AML_A0300;
/

prompt
prompt Creating procedure GROUP_AML_A0801
prompt ==================================
prompt
create or replace procedure GROUP_AML_A0801(i_baseLine in date,
                                           i_oprater  in varchar2) is
  v_dealNo   lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --  ϵͳ����Ϊ���߷��տͻ���Ͷ����Ϊ��
  --"�������߼�ͬ����
  --��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ����Ч����Ч��������
  --2.���ݱ�����Ͷ����λΨһҵ������ƥ��ͻ������Ƿ�Ϊ���߷��տͻ�������ǣ�ϵͳ���ɿ������ݡ�"
  --������Դ��RPAS��GTA��PNR
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/09
  -- ============================================
dbms_output.put_line('��ʼִ�����չ���A0801');

declare
   cursor baseInfo_sor is
   select r.clientno, t.transno, t.contno
   from gr_trans t, gr_rel r
   where t.contno = r.contno
         and exists
             (select 1
              from lxriskinfo lx
              where lx.CODE = r.clientno
              and lx.RECORDTYPE = '01'
              and lx.RISKLEVEL = '4')
        and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
        and t.payway = '01'  --��
        and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
        and t.transtype = 'AA001' -- ��������ΪͶ��
        and t.source in ('3','2','1') --1-PNR 2-RPAS 3-GTA
        and t.conttype = '2' -- �������ͣ�2-�ŵ�
        and trunc(t.transdate) = trunc(i_baseLine)
       
        order by r.clientno, t.transdate desc;

    -- �����α����
    g_clientno  gr_client.clientno%type; -- �ͻ���
    g_transno   gr_trans.transno%type; -- ���׺�
    g_contno    gr_trans.contno%type; -- ������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor
        into g_clientno, g_transno, g_contno;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽����
      if v_clientno is null or g_clientno <> v_clientno then

        v_dealNo   := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        v_clientno := g_clientno; -- ���¿�������Ŀͻ���

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        GROUP_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   g_clientno,
                                   g_contno,
                                   i_oprater,
                                   'GA0801',
                                   i_baseLine);

        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '1');
      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, g_clientno, g_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, g_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, g_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, g_clientno);

    end loop;
    close baseInfo_sor;
  end;
    dbms_output.put_line('���չ���A0801ִ�гɹ�');
  commit;
END GROUP_AML_A0801;
/

prompt
prompt Creating procedure GROUP_AML_A0802
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_A0802 (i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type;                         -- �ͻ���
BEGIN
  -- =============================================
  -- Rule:
  -- ���߷��տͻ��ڱ��������ڼ䣬�����ӱ���׷�ӱ��ѡ��˱��������ȡ�ֽ��ֵ���ʽ������˾��������ų����������ͽ��ɱ��ѡ�
  --"��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ����Ч����Ч��������
  --2.���ݱ�����Ͷ����λΨһҵ������ƥ��ͻ������Ƿ�Ϊ���߷��տͻ���
  --3.����ǣ�������Ч�����ı�ȫ��Ŀ�����жϸÿͻ��Ƿ����ӱ������ˡ������˱�����ȡ�ֽ��ֵ��RPAS����Ϊ���緢�����ϱ�ȫ����ɿ������ݡ�

  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- i_oprater ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/09
  -- Changes log:
  --     Author     Date     Description
  -- =============================================
 dbms_output.put_line('��ʼִ�����չ���A0802');

  DECLARE
  -- �����α꣺ͬһͶ����λ�����ڸ����ౣȫ��Ŀ����ͬһ�������˻�����3�μ�����
  cursor baseInfo_sor is
         select r.clientno, t.transno, t.contno
         from gr_trans t, gr_rel r, gr_policy p
         where t.contno = r.contno
               and r.contno = p.contno
               and exists
                   ( --- 1���߷��տͻ�
                     select 1
                     from lxriskinfo rinfo
                     where r.clientno = rinfo.code
                     and rinfo.recordtype = '01' -- �������ͣ�01-�ͻ�������յȼ�
                     and rinfo.risklevel = '4' -- ���յȼ���4-���߷��յȼ�
                    )
               and GR_isvalidcont(t.contno) = 'yes'
               and t.payway in ('01', '02') -- ����֧����ʽΪ�պ͸�
               and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����λ
               and (t.transtype in ('NI','ZT','CT') or t.transtype in(select code from ldcode where codetype ='transtype_thirdparty')) --�ӱ������ˡ������˱�����ȡ�ֽ��ֵ��RPAS����Ϊ,�ų����������ͽ��ɱ��ѡ�
               and t.conttype = '2' -- �������ͣ�2-�ŵ�
               and t.source in ('2','1')     --1-PNR 2-RPAS 3-GTA
               and trunc(t.transdate) >= trunc(p.effectivedate) -- ��������>=������Ч��
               and trunc(t.transdate) < trunc(p.expiredate) -- ��������<������ֹ��
               and trunc(t.transdate) = trunc(i_baseLine)
               order by r.clientno, t.transdate desc;


     -- �����α����
      c_clientno gr_client.clientno%type;   -- �ͻ���
      c_transno gr_trans.transno%type;      -- �ͻ����֤������
      c_contno gr_trans.contno%type;        -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'GA0802', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
         GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
         GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
         GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

 dbms_output.put_line('���չ���A0802ִ�гɹ�');
  commit;

END GROUP_AML_A0802;
/

prompt
prompt Creating procedure GROUP_AML_A0900
prompt ==================================
prompt
create or replace procedure GROUP_AML_A0900(i_baseLine in date,
                                           i_oprater  in varchar2) is
  v_threshold_money NUMBER := getparavalue('GA0900', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_dealNo   lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --�߷��տͻ��ڱ��������ڼ䣬�����ӱ���׷�ӱ��ѡ��˱��������ȡ�ֽ��ֵ���ʽ������˾������Ҵﵽ��ֵ�����������������ͽ��ɱ��ѡ�
  --"��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ����Ч����Ч��������
  --2.���ݱ�����Ͷ����λΨһҵ������ƥ��ͻ������Ƿ�Ϊ�߷��տͻ���
  --3.����ǣ����ݱ����ı�ȫ��Ŀ�����жϸÿͻ��Ƿ����ӱ������ˡ������˱�����ȡ�ֽ��ֵ���緢�����ϱ�ȫ�ͳ�Ƹ�Ͷ����λ�����б����ۼ��ѽ����Ѵ��ڵ�����ֵ�������ɿ������ݡ�
  --4.��ֵ����Ϊ��200��ʵ�ֿ�������ʽ
  --������Դ��RPAS��PNR
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/09
  -- ============================================
dbms_output.put_line('��ʼִ�����չ���A0900');

delete from lxassista;

--��ȡ���챣�������Ǽӱ������ˡ������˱�����ȡ�ֽ��ֵ�ĸ߷��տͻ�������Ϣ
insert into lxassista
  (tranid, policyno, customerno, args5)
  select t.transno, t.contno, r.clientno, 'GR_A0900_1'
    from gr_trans t, gr_rel r, gr_policy p
   where t.contno = r.contno
     and r.contno = p.contno
     and exists
   ( --�ͻ����ڸ߷��տͻ�
          select 1
            from lxriskinfo lx
           where lx.code = r.clientno
             and lx.recordtype = '01'
             and lx.risklevel = '3')
     and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
     and t.payway in ('01', '02') -- �����ʽ����
     and (t.transtype in ('NI','ZT','CT') or t.transtype in(select code from ldcode where codetype ='transtype_thirdparty')) --�ӱ������ˡ������˱�����ȡ�ֽ��ֵ��RPAS����Ϊ,�ų����������ͽ��ɱ��ѡ�
     and trunc(t.transdate) >= trunc(p.effectivedate) -- ��������>=������Ч��
     and trunc(t.transdate) < trunc(p.expiredate) -- ��������<������ֹ��
     and t.source in ('2','1')--1-PNR 2-RPAS 3-GTA
     and t.conttype = '2' -- �������ͣ�2-�ŵ�
     and trunc(t.transdate) = trunc(i_baseLine)
     order by r.clientno, t.contno desc;

--��ȡ�ϲ��е�Ͷ����λ
insert into lxassista
  (args1, args2, args3, args5)
  select distinct c.name,
                  c.cardtype,
                  (case
                    when c.CardType = 'B' then
                     c.BusinessLicenseNo --Ӫҵִ�պ�
                    when c.CardType = 'O' then
                     c.OrgComCode --��֯����֤��
                    else
                     c.TaxRegistCertNo --˰��ǼǺ�
                  end),
                  'GR_A0900_2'
    from lxassista lx, gr_client c
   where lx.customerno = c.clientno
     and lx.args5 = 'GR_A0900_1';


 --��ȡ�ڶ����е�Ͷ����λ�µ����б���
insert into lxassista
  (numargs1, customerno, policyno, args1, args2, args3, args5)
  select p.sumprem,    --���׽��
         c.clientno, --�ͻ���
         p.contno, --������
         c.name, --��˾����
         c.cardtype, --֤������
         ( --֤������
         case
           when c.CardType = 'B' then
            c.BusinessLicenseNo --Ӫҵִ�պ�
           when c.CardType = 'O' then
            c.OrgComCode --��֯����֤��
           else
            c.TaxRegistCertNo --˰��ǼǺ�
         end),
         'GR_A0900_3'
    from gr_policy p, gr_client c, gr_rel r
   where p.contno = r.contno
     and c.clientno = r.clientno
     and exists(select 1 from lxassista lx
           where lx.args1 = c.name
             and lx.args2 = c.cardtype
             and (lx.args3 = c.BusinessLicenseNo or lx.args3 = c.OrgComCode or
                 lx.args3 = c.TaxRegistCertNo)
             and lx.args5 = 'GR_A0900_2')
     and GR_isValidCont(p.contno) = 'yes' -- ��Ч����
     and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����   
     and p.source in ('2','1')--1-PNR 2-RPAS 3-GTA
     and p.conttype = '2' -- �������ͣ�2-�ŵ�
     order by c.clientno,p.contno desc;

--��ȡ������ֵ�ĵ��챣��
declare
   cursor baseInfo_sor is
select lx.customerno,lx.tranid, lx.policyno
  from lxassista lx, gr_client c
 where lx.customerno = c.clientno
   and exists( --�ۼƱ��ѳ�����ֵ
        select 1
          from lxassista la
         where c.name = la.args1
           and c.cardtype = la.args2
           and (la.args3 = c.BusinessLicenseNo or la.args3 = c.OrgComCode or
               la.args3 = c.TaxRegistCertNo)
           and la.args5 = 'GR_A0900_3'
         group by la.args1, la.args3
        having sum(la.numargs1) >= v_threshold_money
        )
   and lx.args5 = 'GR_A0900_1'
   order by lx.customerno desc;



    -- �����α����
    g_clientno  gr_client.clientno%type; -- �ͻ���
    g_transno   gr_trans.transno%type; -- ���׺�
    g_contno    gr_trans.contno%type; -- ������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor
        into g_clientno, g_transno, g_contno;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽����
      if v_clientno is null or g_clientno <> v_clientno then

        v_dealNo   := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        v_clientno := g_clientno; -- ���¿�������Ŀͻ���

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        GROUP_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   g_clientno,
                                   g_contno,
                                   i_oprater,
                                   'GA0900',
                                   i_baseLine);

        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '1');
      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, g_contno, g_transno, '');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, g_clientno, g_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, g_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, g_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, g_clientno);

    end loop;
    close baseInfo_sor;
  end;
    dbms_output.put_line('���չ���A0900ִ�гɹ�');

    delete from lxassista;
  commit;
END GROUP_AML_A0900;
/

prompt
prompt Creating procedure GROUP_AML_B0101
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_B0101(
    i_baseLine IN DATE,
    i_oprater  IN VARCHAR2)
IS
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��(ҵ���)
  v_clientno gr_client.clientno%type;                       -- �ͻ���
  v_threshold_money NUMBER := getparavalue('GB0101', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_threshold_month NUMBER := getparavalue('GB0101', 'D1'); -- ��ֵ ��Ȼ��
  v_threshold_count NUMBER := getparavalue('GB0101', 'N1'); -- ��ֵ �������
BEGIN
  -- =============================================
  -- Rule:
  -- Ͷ����λ3�����ڱ���������Σ����������Σ���ϵ�绰���Ҹ�Ͷ����λ��ΪͶ���˵�������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --  1) ��ȡ����ά��
  --     ץȡǰһ����Ч����Ч��������;
  --     ����Ϊ3���µ��ж��߼�Ϊϵͳ��ǰʱ�����ȫ�������ʱ���Ƿ���3������
  --     �����ϵ�绰��ͳ���ֻ��ŵı����������ͬһͶ���˱�����ű����ֻ��ţ�������ֻ�����ͬ�ģ�������������кϲ���Ϊһ�α����
  --     ����3�����ڱ��3�μ����ϵ�Ͷ����λ��ͳ�Ƹ�Ͷ����λ��������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ�������ɿ�������
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��ֵ���ã��ѽ�����Ϊ200������Ϊ3���£�����Ϊ3�Σ�ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: XN
  -- Create date: 2019/12/30
  -- Changes log:
  -- ============================================
    dbms_output.put_line('��ʼִ�����չ���B0101');
  INSERT INTO LXAssistA
    (CustomerNo,
     TranId,
     PolicyNo,
     TranMoney,
     Trantime,
     args1,
     args2,
     args4,
     args5)
    SELECT r.clientno,
           t.transno,
           t.contno,
           (SELECT p.sumprem FROM gr_policy p WHERE p.contno = t.contno) AS sumprem,
           t.transdate,
           t.transtype,
           td.ext1,
           td.ext2,
           'GB0101_1'
      FROM gr_trans t, gr_rel r, gr_transdetail td
     WHERE t.contno = r.contno
       AND t.contno = td.contno
       AND t.transno = td.transno
       AND EXISTS
     (SELECT 1
              FROM gr_trans tmp_t, gr_rel tmp_r
             WHERE r.clientno = tmp_r.clientno
               AND tmp_t.contno = tmp_r.contno
               and exists
             (select 1
                      from gr_transdetail tmp_td
                     where tmp_td.contno = tmp_t.contno
                       and tmp_td.transno = tmp_t.transno
                       and tmp_td.remark = 'Ͷ������ϵ�绰')
               AND tmp_r.custype = 'O' -- Ͷ����
               AND tmp_t.transtype = 'AC'
               AND tmp_t.conttype = '2' -- �ŵ�
               AND TRUNC(tmp_t.transdate) = TRUNC(i_baseline))
       AND GR_isValidCont(t.contno) = 'yes'
       AND r.custype = 'O' --ͬһͶ����
       AND td.remark = 'Ͷ������ϵ�绰'
       AND t.transtype = 'AC'
       AND t.conttype = '2'
       AND TRUNC(t.transdate) <= TRUNC(i_baseline)
       AND TRUNC(t.transdate) >
           TRUNC(add_months(i_baseline, v_threshold_month * (-1))); --��ǰʱ���ǰ3����                                  --��ǰʱ��
  
  --ͬһͶ����3������3�Σ�������3�����ϱ����ϵ�绰���ۼ��ѽ����Ѵ��ڷ�ֵ
  DECLARE
    CURSOR baseInfo_sor
    IS
    SELECT CustomerNo, PolicyNo, TranId
      FROM LXAssistA a
     WHERE EXISTS (SELECT 1
              FROM LXAssistA tmp
             WHERE tmp.customerno = a.customerno
             GROUP BY tmp.customerno
            HAVING -- ��֤���Ϊͬһ��ϵ�绰���������
            COUNT(DISTINCT tmp.args4) > v_threshold_count)
       AND ( -- ��������������Ч�����ۼ��ѽ������ܶ�
            SELECT SUM(NVL(p.sumprem, 0))
              FROM gr_rel r, gr_policy p
             WHERE r.clientno = a.customerno
               AND r.contno = p.contno
               AND GR_isValidCont(r.contno) = 'yes'
               AND r.custype = 'O') >= v_threshold_money
       AND args5 = 'GB0101_1'
     ORDER BY a.customerno, a.Trantime;
      
      
    -- �����α����
    c_clientno gr_client.clientno%type; -- �ͻ���
    c_contno gr_trans.contno%type;      -- ������
    c_tranid gr_trans.transno%type;     -- ���׺�
    
    
  BEGIN
    OPEN baseInfo_sor;
    LOOP
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      FETCH baseInfo_sor INTO c_clientno, c_contno,c_tranid;
      EXIT
    WHEN baseInfo_sor%notfound; -- �α�ѭ������
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      IF v_clientno IS NULL OR c_clientno <> v_clientno THEN
        v_dealNo    :=NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GB0101', i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_tranid,'1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      ELSE
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno ,c_tranid,'');
      END IF;
      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);
      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);
      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    END LOOP;
    CLOSE baseInfo_sor;
  END;
  DELETE FROM LXAssistA WHERE args5 IN ('GB0101_1');
    dbms_output.put_line('���չ���B0101ִ�гɹ�');
  commit;
END GROUP_AML_B0101;
/

prompt
prompt Creating procedure GROUP_AML_B0102
prompt ==================================
prompt
create or replace procedure GROUP_AML_B0102(i_baseLine in date, i_oprater in varchar2)
is
    v_dealNo lxistrademain.dealno%type; -- ���ױ��(ҵ���)
    v_clientno gr_client.clientno%type; -- �ͻ���

    v_threshold_money number := getparavalue('GB0102', 'M1'); -- ��ֵ �ۼƱ��ѽ��
    v_threshold_month number := getparavalue('GB0102', 'D1'); -- ��ֵ ��Ȼ��
    v_threshold_count number := getparavalue('GB0102', 'N1'); -- ��ֵ �������
    
BEGIN
  -- =============================================
  -- Rule:
  -- Ͷ����λ3�����ڱ���������Σ����������Σ�ͨ�ŵ�ַ���Ҹ�Ͷ����λ��ΪͶ���˵�������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --  1) ��ȡ����ά��
  --     ץȡǰһ����Ч����Ч��������;
  --     ����Ϊ3���µ��ж��߼�Ϊϵͳ��ǰʱ�����ȫ�������ʱ���Ƿ���3������
  --     ���ͨ�ŵ�ַ��ͳ���ֻ��ŵı����������ͬһͶ����λ������ű���ͨ�ŵ�ַ�������ͨ�ŵ�ַ��ͬ�ģ�������������кϲ���Ϊһ�α����
  --     ����3�����ڱ��3�μ����ϵ�Ͷ����λ��ͳ�Ƹ�Ͷ����λ��������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ�������ɿ�������
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��ֵ���ã��ѽ�����Ϊ200������Ϊ3���£�����Ϊ3�Σ�ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: XN
  -- Create date: 2019/12/30
  -- Changes log:
  -- ============================================
      dbms_output.put_line('��ʼִ�����չ���B0102');
  INSERT INTO LXAssistA
    (
      CustomerNo,
      TranId,
      PolicyNo,
      TranMoney,
      Trantime,
      args1,
      args2,
      args4,         --  ext2   �����жϴ���
      args5          -- 'B0102_1'
    )
     SELECT r.clientno,
       t.transno,
       t.contno,
       (SELECT p.sumprem FROM gr_policy p WHERE p.contno = t.contno) AS sumprem,
       t.transdate,
       t.transtype,
       td.ext1,
       td.ext2,
       'GB0102_1'
     FROM gr_trans t,
          gr_rel r,
          gr_transdetail td
     WHERE t.contno = r.contno
           AND t.contno   = td.contno
           AND t.transno  = td.transno
           AND EXISTS  (
              SELECT 1
                 FROM gr_trans tmp_t, gr_rel tmp_r
                 WHERE r.clientno = tmp_r.clientno
                      AND tmp_t.contno = tmp_r.contno
                      and exists
                         (select 1
                             from gr_transdetail tmp_td
                             where tmp_td.contno = tmp_t.contno
                              and tmp_td.transno = tmp_t.transno
                              and tmp_td.remark = 'Ͷ����ͨѶ��ַ')
                      AND tmp_r.custype = 'O' -- Ͷ����
                      AND tmp_t.transtype = 'AC'
                      AND tmp_t.conttype = '2' -- �ŵ�
                      AND TRUNC(tmp_t.transdate) = TRUNC(i_baseline))        
       AND r.custype            ='O' --ͬһͶ����
       AND td.remark           = 'Ͷ����ͨѶ��ַ'
       AND t.transtype         ='AC'
       AND t.conttype           ='2'
       AND GR_isValidCont(t.contno)='yes'
       AND TRUNC(t.transdate)   > TRUNC(add_months(i_baseLine,v_threshold_month*(-1))) --��ǰʱ���ǰ3����
       AND TRUNC(t.transdate)   <= TRUNC(i_baseLine);                                    --��ǰʱ��
       
  --ͬһͶ����λ3������3�Σ�������3�����ϱ��ͨ�ŵ�ַ���ۼ��ѽ����Ѵ��ڷ�ֵ
  DECLARE
    CURSOR baseInfo_sor
    IS
      SELECT CustomerNo,
        PolicyNo,
        TranId
      FROM LXAssistA a
      WHERE EXISTS
        (SELECT 1
        FROM LXAssistA tmp
        WHERE tmp.customerno = a.customerno
        GROUP BY tmp.customerno
        HAVING -- ��֤���Ϊͬһͨ�ŵ�ַ���������
          COUNT(DISTINCT tmp.args4) > v_threshold_count
        )
    AND ( -- ��������������Ч�����ۼ��ѽ������ܶ� 
      SELECT SUM(NVL(p.sumprem,0))
      FROM gr_rel r,
        gr_policy p
      WHERE r.clientno          = a.customerno
      AND r.contno              = p.contno
      AND GR_isValidCont(r.contno) = 'yes'
      AND r.custype             ='O') >= v_threshold_money
    and args5 = 'GB0102_1'
    ORDER BY a.customerno,
      a.Trantime;
    -- �����α����
    c_clientno gr_client.clientno%type; -- �ͻ���
    c_contno gr_trans.contno%type;      -- ������
    c_tranid gr_trans.transno%type;      -- ���׺�
     
  BEGIN
    OPEN baseInfo_sor;
    LOOP
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      FETCH baseInfo_sor INTO c_clientno, c_contno,c_tranid;
      EXIT
    WHEN baseInfo_sor%notfound; -- �α�ѭ������
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      IF v_clientno IS NULL OR c_clientno <> v_clientno THEN
        v_dealNo    :=NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
       GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GB0102', i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
       GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_tranid,'1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      ELSE
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno ,c_tranid,'');
      END IF;
      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);
      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);
      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    END LOOP;
    CLOSE baseInfo_sor;
  END;
    delete from LXAssistA where args5 in ('GB0102_1');
   dbms_output.put_line('���չ���B0102ִ�гɹ�');
  commit;
END GROUP_AML_B0102;
/

prompt
prompt Creating procedure GROUP_AML_B0103
prompt ==================================
prompt
create or replace procedure GROUP_AML_B0103(i_baseLine in date, i_oprater in varchar2) is

    v_threshold_money number := getparavalue('GB0103', 'M1'); -- ��ֵ �ۼƱ��ѽ��
		v_threshold_month number := getparavalue('GB0103', 'D1'); -- ��ֵ ��Ȼ��
		v_threshold_count number := getparavalue('GB0103', 'N1'); -- ��ֵ �������
		v_dealNo lxistrademain.dealno%type;												-- ���ױ��(ҵ���)
		v_clientno gr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --     Ͷ����3������(����������ռ��㣩�������ϣ��������Σ���������ˡ���ϵ�ˡ����������˻��߸����ˣ��Ҹ�Ͷ����λ��������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --     1) ͬһͶ����λ������ű��������ˡ���ϵ�ˡ����������˻��߸�������ͬ�ģ�������������кϲ���Ϊһ�α��������ͬ������ͬһ��᰸��Ϊһ�Σ���
--          ���������˵ı����ͳ�ƿھ�Ϊ�����������ˡ�ɾ�������ˡ��޸������ˣ������ϵ�ˡ����������˻��߻����˵�ͳ�ƿھ���Ϊ����˵�����
  --     2) �ۼ��ѽ������߼�ͬ7.1.1
  --     3) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ǰһ����ְҵ��ǩ���������˻��������Ч��ȫ�ı���
  --     4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     5) ��������ֵΪ200��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����췢�����Ͷ����λ�������������б����¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    Trantime,
    args2,     --remark
    args4,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.transdate,
        td.remark,
        td.ext2,
        'GB0103_1'
      from
        gr_trans t,gr_rel r,gr_transdetail td
      where
          t.contno=r.contno
      and t.contno=td.contno
      and t.transno=td.transno
      and exists(
          select 1
          from
              gr_trans tmp_t, gr_rel tmp_r, gr_transdetail tmp_td
          where
              tmp_r.clientno = r.clientno
          and tmp_t.contno = tmp_r.contno
          and tmp_t.contno = tmp_td.contno
          and tmp_t.transno = tmp_td.transno
          and tmp_r.custype = 'O'
          and tmp_t.conttype='2'
          and tmp_td.remark in ('����������','�޸�������','ɾ��������','��ϵ���������','�����������������','�������������')
          and tmp_t.transtype in  ('AC','BC')
          and trunc(tmp_t.transdate)=trunc(i_baseline)
          )
      and r.custype = 'O'
      and td.remark in ('����������','�޸�������','ɾ��������','��ϵ���������','�����������������','�������������')
      and t.transtype in  ('AC','BC')
      and GR_isValidCont(t.contno) = 'yes'
      and t.conttype = '2'
      and trunc(t.transdate) > trunc(add_months(i_baseLine,v_threshold_month*(-1)))  --��������3����ǰ
      and trunc(t.transdate) <= trunc(i_baseLine);   --�����յ���;

--ͬһ������ͬһ�ʽ��׽�remark�͸ı���ֵ����ƴ�ӳ�1���ֶ�    
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    Trantime,
    args2,     --remark
    args4,
		args5)
      select 
        a.CustomerNo,
        a.TranId,
        a.PolicyNo,
        a.Trantime,
        listagg(a.args2,',') WITHIN group  (ORDER BY a.args2),
        listagg(a.args4,',') WITHIN group  (ORDER BY a.args2),
        'GB0103_2'
      from LXAssistA a where a.args5 = 'GB0103_1'
      group by a.CustomerNo, a.TranId, a.PolicyNo, a.Trantime, 'GB0103_2';

-- �ж��ۼƴ�������ֵ
	 --ͬһͶ����λ3������3�Σ�������3�����ϱ�������������ˡ���˾���ơ�ǩ�¡������ˡ���ϵ�ˡ����������˻��߸����ˣ��ۼ��ѽ����Ѵ��ڷ�ֵ
  DECLARE
    CURSOR baseInfo_sor
    IS
      SELECT CustomerNo,
        PolicyNo,
        TranId
      FROM LXAssistA a
      WHERE EXISTS
        (SELECT 1
        FROM LXAssistA tmp
        WHERE tmp.customerno = a.customerno and tmp.args5 = 'GB0103_2'
        GROUP BY tmp.customerno
        HAVING -- ��֤���Ϊͬһ�����������ˡ���˾���ơ�ǩ�¡������ˡ���ϵ�ˡ����������˻��߸����˲��������
          COUNT(DISTINCT tmp.args4) >= v_threshold_count
        )
    AND ( -- ��������������Ч�����ۼ��ѽ������ܶ� 
      SELECT SUM(NVL(p.sumprem,0))
      FROM gr_rel r,
        gr_policy p
      WHERE r.clientno          = a.customerno
      AND r.contno              = p.contno
      AND GR_isValidCont(r.contno) = 'yes'
      AND r.custype             ='O') >= v_threshold_money
    and a.args5 = 'GB0103_2'
    ORDER BY a.customerno,
      a.Trantime;
       
      
    -- �����α����
    c_clientno gr_client.clientno%type; -- �ͻ���
    c_contno gr_trans.contno%type;      -- ������
    c_tranid gr_trans.transno%type;      -- ���׺�
     
  BEGIN
    OPEN baseInfo_sor;
    LOOP
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      FETCH baseInfo_sor INTO c_clientno, c_contno,c_tranid;
      EXIT
    WHEN baseInfo_sor%notfound; -- �α�ѭ������
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      IF v_clientno IS NULL OR c_clientno <> v_clientno THEN
        v_dealNo    :=NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
       GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GB0103', i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
       GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_tranid,'1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      ELSE
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno ,c_tranid,'');
      END IF;
      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);
      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);
      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    END LOOP;
    CLOSE baseInfo_sor;
  END;
    delete from LXAssistA where args5 in ('GB0103_1','GB0103_2');
   dbms_output.put_line('���չ���B0103ִ�гɹ�');
  commit;
END GROUP_AML_B0103;
/

prompt
prompt Creating procedure GROUP_AML_C0400
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_C0400(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_money NUMBER := getparavalue ('GC0400', 'M1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- Ͷ���ˡ�����������ĵ������˻����ɱ��ѣ���׷�ӱ��ѣ����Ҵﵽһ����
  -- 1) ͳ��ά�ȣ�Ͷ����λ
  --     ��ȡǰһ����Ч����Ч��������
  -- 2) ͳ��ͬһ��Ͷ����λ�²�ͬ������ί�нɷ��˻���������Ч����
  --     ���ۼ��ѽ����Ѵ��ڵ�����ֵ
  -- 3) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/02
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/02     ����
  --     baishuai  2020/02/03    �ۼ��ѽ����ѵ��߼��޸ģ��ۼ��ѽ�����Ϊͳ��Ͷ����λά���µ��ۼ��ѽ�����
  -- ============================================
  
  dbms_output.put_line('��ʼִ�����չ���C0400');
  
  -- ͬһ��Ͷ����λ�²�ͬ������ί�нɷ��˻���������Ч����,�ۼ��ѽ����Ѵ��ڵ�����ֵ
  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
             t.contno = r.contno
           -- ͬһ��Ͷ����λ�²�ͬ������ί�нɷ��˻���������Ч�������ۼ��ѽ����Ѵ��ڵ�����ֵ
           and exists (
                  select 1
                  from
                    gr_policy temp_p,gr_rel temp_r
                  where 
                        r.clientno = temp_r.clientno
                    and temp_p.contno=temp_r.contno
                    and gr_isValidCont(temp_p.contno) = 'yes' -- ��Ч����
                    and temp_r.custype='O'
                    and temp_p.source = '1'                -- ��Դ��PNRϵͳ
                    and temp_p.conttype = '2'              -- �ŵ� 
                  group by 
                     temp_r.clientno
                  having 
                     sum(abs(temp_p.sumprem))>= v_threshold_money      -- �������������ɱ��ѣ�����Ч�������ۼƱ��Ѵ��ڵ��ڷ�ֵ
              )
              -- ͬһ��Ͷ����λ�²�ͬ������ί�нɷ��˻���������Ч�������ۼ��ѽ����Ѵ��ڵ�����ֵ
           /*and exists (                       ԭ�߼�
                  select 1
                  from
                    gr_trans temp_t,gr_rel temp_r
                  where 
                        r.clientno = temp_r.clientno
                    and temp_t.contno=temp_r.contno
                    and isValidCont(temp_t.contno) = 'yes' -- ��Ч����
                    and temp_r.custype='O'
                    and temp_t.payway='01'                 -- �ʽ��������01-��
                    and temp_t.isthirdaccount = '1'        -- �������˻�
                    and temp_t.source = '1'                -- ��Դ��PNRϵͳ
                    and temp_t.conttype = '2'              -- �ŵ� 
                  group by 
                     temp_r.contno
                  having 
                     sum(abs(temp_t.payamt))>=v_threshold_money
              )*/
            -- ���췢�����������ɱ���
            and exists(
                select
                      1
                  from gr_trans tr, gr_rel re
                   where
                        tr.contno = re.contno
                    and r.clientno=re.clientno
                    and tr.isthirdaccount='1'
                    and tr.payway='01'         -- �ʽ��������01-��
                    and re.custype='O'
                    and tr.source = '1'        -- ��Դ��PNRϵͳ
                    and tr.conttype='2'
                    and trunc(tr.transdate) = trunc(i_baseLine)
            )
            and GR_isValidCont(r.contno) = 'yes' -- ��Ч����
            and t.IsThirdAccount= '1'         -- ʹ�õ������˻�
            and t.payway='01'                 -- �ʽ��������01-��
            and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
            and t.source = '1'                -- ��Դ��PNRϵͳ
            and t.conttype = '2'              -- �������ͣ�2-�ŵ�
            order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GC0400', i_baseLine);
          
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);
        
        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
        
        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
        
      end loop;
    close baseInfo_sor;
  end;
  
  dbms_output.put_line('���չ���C0400ִ�гɹ�');
  
  commit;
end Group_aml_C0400;
/

prompt
prompt Creating procedure GROUP_AML_C0500
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_C0500(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_money NUMBER := getparavalue ('GC0500', 'M1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- Ҫ���˱�������𣨷ֿ����㣩֧��������Ȩ��������ĵ������˻����Ҵﵽһ�����
  -- 1) ͳ��ά�ȣ�����
  --     ��ȡǰһ����Ч����Ч��������
  -- 2) ������˵��˻�����Ͷ����λ���ƽ��жԱȣ�����ʻ�����Ϣ��ͬͳ�Ƶ�����
  --     ���ۼ��ѽ����Ѵ��ڵ�����ֵ
  -- 3) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/02
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/02     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���C0500');
  -- ���췢���������˻��˱� ��������ֵ
  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
                t.contno = r.contno
            -- �������������ĵ���������������ֵ���бȽ�    
            and exists(
                  select
                     1
                  from
                      gr_trans temp_t, gr_rel temp_r
                  where temp_t.contno = t.contno
                  and temp_t.contno = temp_r.contno
                  and temp_t.payway='02'            -- �ʽ��������02-��
                  and temp_r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
                  and temp_t.accname != (select temp_c.name from gr_client temp_c where temp_c.clientno = r.clientno)-- �������˻�
                  and t.transtype = 'CT'            -- ��������Ϊ�˱�
                  and t.source = '1'                -- ��Դ��PNRϵͳ
                  and t.conttype = '2'              -- �������ͣ�2-�ŵ�
                  group by 
                      temp_t.contno
                  having
                      sum(abs(temp_t.payamt)) >= v_threshold_money
            )
            -- ���췢���������˱�����
            and exists(
                  select
                     1
                  from
                      gr_trans temp_t, gr_rel temp_r
                  where
                      temp_t.contno = temp_r.contno
                  and temp_t.contno = t.contno
                  and temp_t.payway='02'            -- �ʽ��������02-��
                  and temp_r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
                  and temp_t.accname != (select temp_c.name from gr_client temp_c where temp_c.clientno = r.clientno)-- �������˻�
                  and t.transtype = 'CT'            -- ��������Ϊ�˱�
                  and t.source = '1'                -- ��Դ��PNRϵͳ
                  and t.conttype = '2'              -- �������ͣ�2-�ŵ�
                  and trunc(t.transdate) = trunc(i_baseLine) -- ����
            )
            and t.payway='02'                 -- �ʽ��������02-��
            and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
            and t.accname != (select temp_r.name from gr_client temp_r where temp_r.clientno = r.clientno)-- �������˻�
            and t.transtype = 'CT'            -- ��������Ϊ�˱�
            and t.source = '1'                -- ��Դ��PNRϵͳ
            and t.conttype = '2'              -- �������ͣ�2-�ŵ�
            order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GC0500', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���C0500ִ�гɹ�');

  commit;
end Group_aml_C0500;
/

prompt
prompt Creating procedure GROUP_AML_C0600
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_C0600(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_money NUMBER := getparavalue ('GC0600', 'M1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- �����Ϣ��payment�󣬽��е�����˱��
  -- 1) ͳ��ά�ȣ�����
  --     ��ȡǰһ����payment�ϲ���������˱�����ı���
  -- 2) ���ű����ۼƣ��ñ����������н����ˡ��������ˡ��ĸ��������ۼƣ������˱������⣩���
  -- 3) ��ֵΪ5��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/02
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/02     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���C0600');

  -- ͬһ��Ͷ����λ�²�ͬ������ί�нɷ��˻���������Ч����,�ۼ��ѽ����Ѵ��ڵ�����ֵ
  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
             t.contno = r.contno
            -- ���������б������˵Ľ��׽�������ֵ
            and exists(
                select
                      1
                  from
                      gr_trans tr
                   where
                        t.contno = tr.contno
                    and tr.transtype in ('PAY01','PAY02','PAY03','PAY04') -- ��������Ϊ��������
                    and tr.source = '1'                -- ��Դ��PNRϵͳ
                    and tr.conttype='2'
                    group by
                      tr.contno
                    having
                      sum(abs(tr.payamt)) >= v_threshold_money
            )
            -- ���췢������˱������           
            and exists(
                select
                      1
                  from 
                      gr_trans tr
                   where
                        r.contno=tr.contno
                    and tr.transtype in ('PAY01','PAY02','PAY03','PAY04') -- ��������Ϊ��������
                    and t.source = '1' -- ��Դ��PNRϵͳ
                    and tr.conttype='2'
                    and trunc(tr.transdate) = trunc(i_baseLine)
            )
            and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
            and t.transtype in ('PAY01','PAY02','PAY03','PAY04')
            and t.source = '1'                -- ��Դ��PNRϵͳ
            and t.conttype = '2'              -- �������ͣ�2-�ŵ�
            order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GC0600', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���C0600ִ�гɹ�');

  commit;
end Group_aml_C0600;
/

prompt
prompt Creating procedure GROUP_AML_C0801
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_C0801 (i_baseLine in date,i_oprater in varchar2) is
  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_count number := getparavalue('GC0801', 'N1');   -- ��ֵ �ۼƴ���
  v_threshold_month NUMBER := getparavalue ('GC0801', 'D1' ); -- ��ֵ ��Ȼ��
BEGIN
  -- =============================================
  -- Rule:
  -- ��ͬһͶ����λ�ı����������ౣȫ��Ŀ������ͬһ�������˻�������ﵽ���μ����ϡ�
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM��
  --    ��ȡǰһ�츶���ౣȫ��Ч�ı�����
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ3�Σ�ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- i_oprater ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2020/01/03
  -- Changes log:
  --     Author     Date     Description
  -- =============================================
 dbms_output.put_line('��ʼִ�����չ���C0801');
 
  DECLARE
  -- �����α꣺ͬһͶ����λ�����ڸ����ౣȫ��Ŀ����ͬһ�������˻�����3�μ�����
  cursor baseInfo_sor is
      select
         r.clientno,t.transno,t.contno
            from
         gr_trans t,gr_rel r
            where
              t.contno=r.contno
             -- �������ڵ��췢�������ౣȫ��Ŀ�¼��Լ��ﵽ����ֵ
              and exists(
                  select
                          1
                      from
                        gr_trans tmp_tr,gr_rel tmp_re
                      where r.clientno=tmp_re.clientno
                        and tmp_tr.contno=tmp_re.contno
                        and tmp_tr.accname = t.accname
                         --���״����ﵽ��ֵ
                        and exists
                        (
                          select
                            1
                          from
                            gr_trans tr,gr_rel re
                          where
                                re.clientno=tmp_re.clientno
                            and tr.accname = tmp_tr.accname
                            and tr.contno=re.contno
                            and tr.accname <> (select c.name from gr_client c where c.clientno = re.clientno)
                            and re.custype='O'
                            and tr.payway='02'
                            and tr.transtype in ('CT','ZT')        -- �������ͣ������ౣȫ��Ŀ
                            and tr.conttype='2'
                            and GR_isValidCont(tmp_tr.contno) = 'yes' -- ��Ч����
                            and trunc(tr.transdate) <= trunc(i_baseLine)                                 -- ���������ڰ����� 
                            and trunc(tr.transdate) > trunc(ADD_MONTHS( i_baseLine, - v_threshold_month))  -- ���������ڰ�����
                            group by re.clientno,tr.accname
                            having  count(tr.transno)>= v_threshold_count
                        )
                        and tmp_re.custype='O'
                        and tmp_tr.payway='02'
                        and tmp_tr.transtype in ('CT','ZT')        -- �������ͣ������ౣȫ��Ŀ
                        and tmp_tr.conttype='2'
                        and GR_isValidCont(tmp_tr.contno) = 'yes' -- ��Ч����
                        and trunc(tmp_tr.transdate) = trunc(i_baseLine)    -- �������ڵ���
                  )
              and t.accname <> (select c.name from gr_client c where c.clientno = r.clientno)
              and r.custype='O'
              and t.payway='02'
              and T.transtype in ('CT','ZT')        -- �������ͣ������ౣȫ��Ŀ
              and t.conttype='2'
              and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
              and trunc(t.transdate) <= trunc(i_baseLine)                                  -- ���������ڰ�����
              and trunc(t.transdate) > trunc(ADD_MONTHS( i_baseLine, - v_threshold_month)) 	 -- ���������ڰ�����
              order by r.clientno,t.transdate desc;

     -- �����α����
      c_clientno gr_client.clientno%type;   -- �ͻ���
      c_transno gr_trans.transno%type;      -- �ͻ����֤������
      c_contno gr_trans.contno%type;        -- ������

      v_clientno gr_client.clientno%type;   -- �ͻ���

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'GC0801', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
         GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
         GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
         GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
         
      end loop;
    close baseInfo_sor;
  end;
  
 dbms_output.put_line('���չ���C0801ִ�гɹ�');
  commit;
  
END GROUP_AML_C0801;
/

prompt
prompt Creating procedure GROUP_AML_C0802
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE GROUP_AML_C0802(i_baseLine in date,i_oprater in varchar2) is

	v_dealNo lxistrademain.dealno%type;													-- ���ױ��(ҵ���)
	v_threshold_count number := getparavalue('GC0802', 'N1');		-- ��ֵ �ۼƴ���
	v_threshold_month NUMBER := getparavalue ('GC0802', 'D1' );		-- ��ֵ ��Ȼ��

BEGIN
	-- ============================================
	-- Rule:
	-- ��ʰ������������֧���������˻��߱���������ĵ������˻�������ﵽ���μ�����
	-- 1) Ͷ����λά��
	--    ��������OLAS��IGM
	--    ��ȡǰһ����Ч���⸶�������Ч��������
	-- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- 3) ��������ֵΪ3�Σ�ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater ������
	-- parameter out: none
	-- Author: xn
	-- Create date: 2020/01/03
	-- Changes log:
	--     Author     Date     Description
	-- ============================================
  
dbms_output.put_line('��ʼִ�����չ���C0802');

	DECLARE
	-- �����α꣺���������⸶����֧���������˻��߱���������ĵ������˻�����3�μ�����
	cursor baseInfo_sor is
        select
              r.clientno,t.transno,t.contno
            from
              gr_trans t,gr_rel r,gr_client c
            where
              t.contno=r.contno
              and c.clientno = r.clientno
             
              -- �����˺�������
              and not exists(
                    select
                        1
                    from
                       gr_client cl,gr_rel re
                    where
                        cl.name  =  t.accname
                    and re.contno = r.contno
                    and cl.clientno=re.clientno
                    and re.custype in ('B','I')
                )
                 -- �������ڵ��췢�����⸶�����¼�
              and exists(
                  select
                     1
                  from
                    gr_trans tmp_tr,gr_rel tmp_re
                  where
                      r.clientno=tmp_re.clientno
                      and tmp_tr.contno=tmp_re.contno
                      and tmp_tr.accname = t.accname
                       -- �жϰ�����֧���������˻�3�μ�����
                      and exists
                      (
                        select
                          1
                        from
                          gr_trans tr,gr_rel re
                        where
                              re.clientno=tmp_re.clientno
                          and tr.accname = tmp_tr.accname
                          and tr.contno=re.contno
                          and re.custype='O'
                          and tr.transtype = 'CLM'       -- �������ͣ����⸶����
                          and tr.conttype='2'
                          and tr.payway='02'
                          and GR_isValidCont(tr.contno) = 'yes' -- ��Ч����
                          and trunc(tr.transdate) > trunc(ADD_MONTHS( i_baseLine, - v_threshold_month))  -- ���������ڰ�����
                          and trunc(tr.transdate) <= trunc(i_baseLine)                                 -- ���������ڰ�����
                          and tr.accname <> (select c.name from gr_client c where c.clientno = re.clientno)
                          group by re.clientno,tr.accname
                          having  count(tr.transno)>= v_threshold_count
                      )
                      and GR_isValidCont(tmp_tr.contno) = 'yes' -- ��Ч����
                      and tmp_re.custype='O'
                      and tmp_tr.payway='02'
                      and tmp_tr.transtype = 'CLM'        -- �������ͣ�����֧��
                      and tmp_tr.conttype='2'
                      and trunc(tmp_tr.transdate) = trunc(i_baseLine)    -- �������ڵ���
               )
              and GR_isValidCont(t.contno) = 'yes' -- ��Ч����
              and r.custype='O'
              and t.payway='02'
              and t.transtype='CLM'
              and t.conttype='2'
              and trunc(t.transdate) > trunc(ADD_MONTHS( i_baseLine, - v_threshold_month)) 	 -- ���������ڰ�����
              and trunc(t.transdate) <= trunc(i_baseLine)                                  -- ���������ڰ�����
              order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno gr_client.clientno%type;   -- �ͻ���
      c_transno gr_trans.transno%type;      -- �ͻ����֤������
      c_contno gr_trans.contno%type;        -- ������
      v_clientno gr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

				-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'GC0802', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
         GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          GROUP_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;
  end;
  
  dbms_output.put_line('���չ���C0802ִ�гɹ�');
  commit;
  
end GROUP_AML_C0802;
/

prompt
prompt Creating procedure GROUP_AML_C1000
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_C1000(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_money NUMBER := getparavalue ('GC1000', 'M1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- �ϴ���ʧ�˱�,��֪�˱��нϴ���ʧ��ȻҪ���˱����Ҵﵽһ����
  -- 1) ͳ��ά�ȣ�����
  --     �ṩ��ȫ���ͣ��˱���������Ϣ
  -- 2) �����˱��ı��������ʧ�ﵽ��ֵ����ʧֵ����ʧ���=�ۼ��ѽ�����-�˱����֮�
  --     �������ʧ�����ڵ�����ֵ�����ɿ�������
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/02
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/02     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���C1000');

  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
              t.contno = r.contno         
          and
          -- ��ʧ���=�ۼ��ѽ�����-�˱����֮��  ���ڵ�����ֵ
          (
              (select 
                   temp_p.sumprem 
               from 
                   gr_policy temp_p 
               where 
                   temp_p.contno = r.contno
               and temp_p.conttype = '2'
              )
                - t.payamt) >= v_threshold_money
          and t.payway = '02'               -- �ʽ�������򣺸�
          and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
          and t.source = '1'                -- ��Դ��PNRϵͳ
          and t.conttype = '2'              -- �������ͣ�2-�ŵ�
          and t.transtype = 'CT'            -- �������ͣ������˱�
          and trunc(t.transdate) = trunc(i_baseLine) -- ����
          order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GC1000', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���C1000ִ�гɹ�');

  commit;
  
end Group_aml_C1000;
/

prompt
prompt Creating procedure GROUP_AML_D1100
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_D1100(i_baseLine in date,i_oprater in varchar2) is

       v_threshold_money NUMBER := getparavalue('GD1100', 'M1'); -- ��ֵ �ۼƱ��ѽ��
       v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
       v_clientno cr_client.clientno%type;                         -- �ͻ���

begin
  -- ============================================
  -- Rule:
  -- �˷�/������ȡ�ȵ�����ȡ���ڻ�����趨����ֵ
  --"��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ�챣ȫ��Ч���������Ч��������
  --2.�����˱��ı������ʴﵽ��ֵ��ͬһ��Ͷ����λ�±�ȫ��������ڽ�������˵����ݣ����ʴﵽ��ֵ�����ɿ�������
  --3.��ֵ���ã�500W��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/14
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/14    ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���D1100');

  declare
     cursor baseInfo_sor is
select r.clientno, t.transno, t.contno
  from gr_trans t, gr_rel r, gr_client c
 where t.contno = r.contno
   and exists
        ( --��ȫ������ʴﵽ��ֵ
         select 1
           from gr_trans cms_tb, gr_rel cms_rb, gr_client cms_cb
          where cms_cb.name = c.name
            and cms_cb.cardtype = c.cardtype
            and (cms_cb.BusinessLicenseNo = c.BusinessLicenseNo or
                cms_cb.OrgComCode = c.OrgComCode or
                cms_cb.TaxRegistCertNo = c.TaxRegistCertNo)
            and cms_cb.clientno = cms_rb.clientno
            and cms_rb.contno = cms_tb.contno
            and cms_tb.payamt >= v_threshold_money
            and cms_tb.payway = '02' --��
            and cms_rb.custype = 'O'
            and cms_tb.transtype in ('CT', 'CLM01', 'CLM02', 'CLM03') --�˱�������
            and cms_tb.conttype = '2'
            and trunc(t.transdate) = trunc(i_baseLine)
          group by cms_cb.name
       )
   and c.clientno = r.clientno
   and t.payway = '02' --��
   and r.custype = 'O' --Ͷ����
   and t.transtype in ('CT', 'CLM01', 'CLM02', 'CLM03') --�����������˱�������
   and t.conttype = '2' -- �������ͣ�1-����
   and trunc(t.transdate) = trunc(i_baseLine)
 order by r.clientno, t.contno;


      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������



  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GD1100', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���D1100ִ�гɹ�');

  commit;

end Group_aml_D1100;
/

prompt
prompt Creating procedure GROUP_AML_D1200
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_D1200(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_ratio NUMBER := getparavalue ('GD1200', 'N1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- ָ����������ְȨ��ﵽ�趨����ֵ��
  -- 1) ͳ��ά�ȣ�Ͷ����λ
  --     �ṩ��ȫ���ͣ��˱���������Ϣ
  -- 2) ��ְ��Ա�������� �����α�һ������ְȨ�����������
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/06     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���D1200');

  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
              t.contno = r.contno
          -- һ�������ڣ�һ���ڷ���Ͷ������һ���ڷ��������������ˣ�
          and (
                exists(
                   select 
                       1 
                   from 
                       gr_trans temp_t 
                   where
                       temp_t.contno = t.contno   
                   and temp_t.source = '2'        -- ��Դ��RPASϵͳ
                   and temp_t.conttype = '2'      -- �������ͣ�2-�ŵ�
                   and temp_t.transtype = 'AA001' -- �������ͣ�Ͷ��
                   and trunc(temp_t.transdate) > add_months(i_baseLine,-12)
                   )
             or 
                 exists(
                      select
                           1
                       from
                           gr_trans temp_t,gr_transdetail temp_td
                       where
                           temp_t.contno = temp_td.contno
                       and temp_t.transno = temp_td.transno
                       and temp_t.contno = t.contno
                       -- ������ְ����(���ٵı�������)�ͻ����ڱ��������������˵�һ����ϸ�д���
                       and temp_td.ext1 = 
                           (select gtd.ext1 from gr_transdetail gtd where gtd.contno = t.contno and gtd.transno = t.transno)
                       and temp_t.source = '2'        -- ��Դ��RPASϵͳ
                       and temp_td.remark = '�����������'
                       and temp_t.conttype = '2'      -- �������ͣ�2-�ŵ�
                       and temp_t.transtype = 'N1'    -- �������ͣ�������������
                       and trunc(temp_t.transdate) > add_months(i_baseLine,-12)    -- ��ϵͳʱ����ǰ��һ��
                 )
               )
          -- ����������д�����ְ����Ϊ��ֵ������(���췢�����ٱ���������ְ�������ְ������������ϸ)
          and exists(
              select
                  1
              from
                  gr_trans temp_t,gr_transdetail temp_td
              where
                  temp_t.contno = temp_td.contno
              and temp_t.transno = temp_td.transno
              and temp_td.contno = r.contno
              and temp_t.payway = '02'               -- �ʽ�������򣺸�
              and temp_t.source = '2'                -- ��Դ��RPASϵͳ
              and temp_t.conttype = '2'              -- �������ͣ�2-�ŵ�
              and temp_t.transtype = 'ZT'            -- �������ͣ����ٱ�������(���������˳���������ְ)
              and temp_td.remark = '��ְ��������'
              and to_number(temp_td.ext4) = v_threshold_ratio -- ���췢������ְ����Ϊ100
              and trunc(temp_t.transdate) = trunc(i_baseLine)
          )          
          and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
          and t.payway in ('01','02')       -- �ʽ�������򣺸�
          and t.source = '2'                -- ��Դ��RPASϵͳ
          and t.conttype = '2'              -- �������ͣ�2-�ŵ�
          and t.transtype in('ZT','AA001','N1') -- �������ͣ����ٱ������ˣ�Ͷ������������������
          order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GD1200', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���D1200ִ�гɹ�');

  commit;

end Group_aml_D1200;
/

prompt
prompt Creating procedure GROUP_AML_D1300
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_D1300(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_ratio NUMBER := getparavalue ('GD1300', 'N1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- ��ͬ��������֮����ͬ�ɷ������±��շ������趨����ֵ
  -- 1) ͳ��ά�ȣ�Ͷ����λ
  --     ץȡǰһ�챣����ͬһͶ����λ����ͬ�����ڼ��ڵĳ�Ա�������߶����Ͷ
  --     Ȼ����бȽ� ��ȥ�������Sub office ����)
  -- 2) ��ֵ���ã�������=20��
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/06     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���D1300');

  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
              t.contno = r.contno
          -- ���շ���������ֵ
          and ((
              select
                   max(temp_td.ext4) / min(temp_td.ext4)
              from
                    gr_transdetail temp_td
              where temp_td.contno = r.contno
                and temp_td.remark =  (select gtd.remark from gr_transdetail gtd where gtd.contno = r.contno and gtd.transno = t.transno)         
              )  > v_threshold_ratio   )
         and exists(
            SELECT 1
                 FROM gr_trans tmp_t, gr_rel tmp_r
                 WHERE r.clientno = tmp_r.clientno
                   and tmp_t.contno = t.contno
                   and tmp_r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
                   and tmp_t.transtype = 'NI'            -- ���췢����������Ϊ��������������
                   and tmp_t.source = '2'                -- ��Դ��RPASϵͳ
                   and tmp_t.conttype = '2'              -- �������ͣ�2-�ŵ�
                   and TRUNC(tmp_t.transdate) = TRUNC(i_baseLine))     -- ����
          and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
          and t.transtype = 'NI'            -- ���췢����������Ϊ��������������
          and t.source = '2'                -- ��Դ��RPASϵͳ
          and t.conttype = '2'              -- �������ͣ�2-�ŵ�
          order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GD1300', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���D1300ִ�гɹ�');

  commit;

end Group_aml_D1300;
/

prompt
prompt Creating procedure GROUP_AML_D1400
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_D1400(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_ratio NUMBER := getparavalue ('GD1400', 'M1' ); -- ��ֵ������С����
  v_threshold_year NUMBER := getparavalue ('GD1400', 'D1' );  -- ���ޣ�������

begin
  -- ============================================
  -- Rule:
  -- ָ�������ڣ���ְ����������Ч��������ְ���ս���ȡ�����ܽɷѽ��ı����ﵽ�趨����ֵ
  -- 1) ͳ��ά�ȣ�Ͷ����λ
  --     ץȡ1���ڣ� ��ְ���������Լ���Ч������ ��ȥ�������Sub office ����)
  --     ץȡһ���ڣ���ְ���ս���ȡ���ܽɷѽ�� ��ȥ�������Sub office ����)
  -- 2) ��ֵ���ã���ֵ����=50%
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/06     ����
  --     baishuai 2020/2/21      ����ʱ�޸ģ�����ʱ���ּ�����ʱgr_transdetail��gr_trans����������������ظ�����payamt�����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���D1400');

  declare
     cursor baseInfo_sor is
        select
            r.clientno,
            t.transno,
            t.contno
          from
            gr_trans t, gr_rel r
          where
              t.contno = r.contno
          -- ��ְ��������������������
          and (
          
              (
              (select 
                   count(1) 
                 from
                   gr_trans temp_t,gr_transdetail temp_td
                 where
                     temp_t.contno = temp_td.contno
                 and temp_t.transno = temp_td.transno
                 and temp_t.contno = r.contno
                 and temp_td.remark = '��ְ'          -- ��ְ��ʶ
                 and temp_t.transtype in ('CT','ZT')  -- ��������Ϊ�������˱����߼��ٱ�������
                 and temp_t.source = '2'              -- ��Դ��RPASϵͳ
                 and temp_t.conttype = '2'            -- �������ͣ�2-�ŵ�
                 and trunc(temp_t.transdate) >= trunc(add_months(i_baseLine,-12*v_threshold_year))
                 and trunc(temp_t.transdate) <= trunc(i_baseLine)  -- ץȡָ�������ڵ�������Ϣ
               )      >   -- ����
                -- �������ڵı�����������
               (select 
                  count(1) 
                from 
                  gr_rel temp_r
                where
                    temp_r.contno = r.contno
                and temp_r.custype = 'I'               -- ������
               )
          ) or 
          -- ��ְ���ս���ȡ�����ܽɷѽ��ı����ﵽ�趨����ֵ
          (
             (select 
                   sum(abs(temp_t.payamt))
                 from
                   gr_trans temp_t --,gr_transdetail temp_td
                 where
                     --temp_t.contno = temp_td.contno
                 --and temp_t.transno = temp_td.transno
                 temp_t.contno = r.contno
                 --and temp_td.remark = '��ְ'          -- ��ְ��ʶ
                 and temp_t.contno in (select contno from gr_transdetail temp_td 
                                       where temp_t.contno = temp_td.contno 
                                             and temp_t.transno = temp_td.transno 
                                             and temp_td.remark = '��ְ' )
                 and temp_t.transtype in ('CT','ZT')  -- ��������Ϊ�������˱����߼��ٱ�������
                 and temp_t.source = '2'              -- ��Դ��RPASϵͳ
                 and temp_t.conttype = '2'            -- �������ͣ�2-�ŵ�
                 and trunc(temp_t.transdate) >= trunc(add_months(i_baseLine,-12*v_threshold_year))
                 and trunc(temp_t.transdate) <= trunc(i_baseLine)  -- ץȡָ�������ڵ�������Ϣ
             ) > 
             (select temp_p.sumprem from gr_policy temp_p where temp_p.contno = r.contno)* v_threshold_ratio 
          )
          
          )
          -- ���췢���˱����߼��ٱ������˵Ľ���
          and exists(
              select
                   1
                from
                  gr_trans temp_t,gr_rel temp_r
                where
                    temp_t.contno  = temp_r.contno
                and temp_r.clientno = r.clientno
                and temp_r.custype = 'O'             -- �ͻ����ͣ�O-Ͷ����
                and temp_t.transtype in ('CT','ZT')  -- ��������Ϊ�������˱����߼��ٱ�������
                and temp_t.source = '2'              -- ��Դ��RPASϵͳ
                and temp_t.conttype = '2'            -- �������ͣ�2-�ŵ�
                and trunc(temp_t.transdate) = trunc(i_baseLine) -- ����
          )
          and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
          and t.transtype in ('CT','ZT')    -- ��������Ϊ�������˱����߼��ٱ�������
          and t.source = '2'                -- ��Դ��RPASϵͳ
          and t.conttype = '2'              -- �������ͣ�2-�ŵ�
          and trunc(t.transdate) >= trunc(add_months(i_baseLine,-12*v_threshold_year))
          and trunc(t.transdate) <= trunc(i_baseLine)  -- ץȡָ�������ڵ�������Ϣ
          order by r.clientno,t.transdate desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GD1400', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���D1400ִ�гɹ�');

  commit;

end Group_aml_D1400;
/

prompt
prompt Creating procedure GROUP_AML_D1500
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE Group_aml_D1500(i_baseLine in date,i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;                         -- �ͻ���
  v_threshold_ratio NUMBER := getparavalue ('GD1500', 'N1' ); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- �趨��ֵ����������ͻ�������Ϊͬһ��
  -- "��ϴǮץȡ����������
  --ͳ��ά�ȣ�Ͷ����λ
  --1.ץȡǰһ����Ч����Ч��������
  --2.�жϲ�ͬ�����µ���ϵ���Ƿ�Ϊͬһ�ˣ�����ǣ����ж϶�Ӧ��Ͷ����λ�Ƿ�Ϊͬһ������������Ҫ���ɿ�������
  --3.��ֵ���ã�����ͻ�������2����ʵ�ֿ�������ʽ
  --������Դ��RPAS��GTA��PNR
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date      Description
  --     zhouqk   2020/01/06     ����
  -- ============================================

  dbms_output.put_line('��ʼִ�����չ���D1500');

  delete from lxassista;
--1����ȡ���췢��Ͷ���Ĳ�����ϵ����ͬ�Ľ�����Ϣ
insert into lxassista
  (tranid,
   policyno,
   customerno,
   args1, --��ϵ��
   args2,
   args3,
   args4,
   args5)
  select t.transno,
         t.contno,
         r.clientno,
         LINKMAN, --��ϵ��
         c.name,  --�ͻ���
         c.CardType,--֤������
         (case when c.cardtype='B' then c.Businesslicenseno--֤����
               when c.cardtype ='O' then c.OrgComCode
               when c.cardtype='T' then c.Taxregistcertno
           end),
         'SD1500_1'
    from gr_client c ,gr_rel r,gr_trans t
   where t.contno = r.contno
     and c.clientno=r.clientno
     and exists(
         select 1 from
         gr_client tmp_c,gr_rel tmp_r,gr_trans tmp_t
         where
         tmp_c.clientno=tmp_r.clientno
         and tmp_r.contno=tmp_t.contno
         and c.linkman=tmp_c.linkman
         and GR_isvalidcont(tmp_t.contno) = 'yes' --��Ч����
         and tmp_r.custype = 'O'
         and tmp_t.payway='01'
         and tmp_t.transtype in ('AA001','BC')    --
         and tmp_t.conttype = '2'
         and trunc(tmp_t.transdate) = trunc(i_baseLine) --��Ч����
     )
     and GR_isvalidcont(t.contno) = 'yes' --��Ч����
     and r.custype = 'O'
     and t.payway='01'
     and t.transtype in ('AA001','BC')    --
     and t.conttype = '2'
     order by r.clientno desc;
 
--��ȡ��ͬ��ϵ���£���ͬ��������Ӧ����ҵ����ͬһ�����ҳ�����ֵ
  declare
     cursor baseInfo_sor is
select lx.customerno, lx.policyno, lx.tranid
  from lxassista lx
 where exists ( --��ͬ��ϵ���£���ͬ��������Ӧ����ҵ����ͬһ�����ҳ�����ֵ
        select 1
          from lxassista la
         where lx.args1 = la.args1 --��ϵ����ͬ
           and  exists (select 1   --��Ӧ��ҵ����ͬһ��
                      from lxassista lb
                      where lb.args1 = la.args1
                      and (lb.args2!=la.args2 or lb.args3!=la.args3 or lb.args4!=la.args4)
                      and lb.args5 = 'SD1500_1'
                   )
           and la.args5 = 'SD1500_1'
         group by la.args1
        having count(distinct la.customerno) >= v_threshold_ratio)
   and lx.args5 = 'SD1500_1'
 order by lx.customerno, lx.policyno desc;

      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������



  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          --��ȡ���ױ��(ҵ���)
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          GROUP_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'GD1500', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          GROUP_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        GROUP_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        GROUP_AML_INS_LXISTRADEINSURED(v_dealNo,c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        GROUP_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        GROUP_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;

  dbms_output.put_line('���չ���D1500ִ�гɹ�');

  delete from lxassista;

  commit;

end Group_aml_D1500;
/

prompt
prompt Creating procedure GROUP_AML_MID_TO_GR
prompt ======================================
prompt
create or replace procedure Group_aml_mid_to_gr(
  
  startDate in VARCHAR2
       
) is

  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ
  v_errormsg LLogTrace.DealDesc%type;
  v_TraceId LLogTrace.TraceId%type;

begin
  -- =============================================
  -- Description: �������κŽ����ݴ��м��(mid)Ǩ�Ƶ�����ƽ̨��(gr)��
  -- parameter in:  startDate ��ʼʱ��
  --                endDate ����ʱ��
  -- parameter out: none
  -- Author: zhouqk
  -- Create date:  2019/12/30
  -- Changes log:
  --     Author       Date        Description
  --     zhouqk    2019/12/       ����
  
  
  -- ���κ���Ҫ���Ƶ�mid�����־�л�ȡ��������ʱ��������Ϊ���κ�
  
  
  -- =============================================
   dbms_output.put_line('��ʼִ���������ݴ��м��Ǩ�Ƶ�ƽ̨����');
  
   --��ȡ������Ϊ��־����
   SELECT TO_char(sysdate, 'yyyymmddHH24mmss') into v_TraceId from dual;

   -- ����
   insert into LLogTrace(
     TraceId,
     FuncCode,
     StartTime,
     DealState,
     DealDesc,
     DataBatchNo,
     DataState,
     Operator,
     InsertTime,
     ModifyTime)
  values(
     v_TraceId,
     '000002',
     sysdate,
     '00',
     '�����м��������ƽ̨��ִ����',
     v_TraceId,
     '01',
     'system',
     sysdate,
     sysdate);
     
     commit;
  
    dbms_output.put_line('��־����ɹ�');
    --��ƽ̨���Ѿ����ڵ�����ɾ��
  
    delete from gr_client gc where exists(
      
      select 1 from mid_g_client mgc where mgc.clientno = gc.clientno 
      
    );
      
    delete from gr_policy gp where exists(
      
      select 1 from mid_g_policy mgp where mgp.contno = gp.contno
      
    );
      
    delete from gr_rel gr where exists(
      
      select 1 from mid_g_rel mgr where mgr.contno = gr.contno
      
    );

    delete from gr_risk gs where exists(
      
      select 1 from mid_g_risk mgs where mgs.contno = gs.contno 
      
    );
      
    delete from gr_trans gt where exists(
      
      select 1 from mid_g_trans mgt where mgt.transno = gt.transno
      
    );
      
    delete from gr_transdetail gtt where exists (
      
      select 1 from mid_g_transdetail mgtt where mgtt.transno = gtt.transno
      
    );
      
    delete from gr_address gd where exists(
      
      select 1 from mid_g_Address mgd where mgd.clientno=gd.clientno 
        
      and mgd.contno=gd.contno 
      
    );
    dbms_output.put_line('�������룬ɾ��ƽ̨��ɹ�');

  -- ���ͻ������ݽ���Ǩ��
  insert into gr_client(
      ClientNo,--�ͻ���,
      OriginalClientNo,--ԭʼ�ͻ���,
      Source,--�ͻ���Դ,
      Name,--�ͻ�����/����,
      Birthday,--����,
      Age,--����,
      Sex,--�Ա�,
      CardType,--�ͻ����֤��/֤���ļ�����,
      OtherCardType,--�������֤��/֤���ļ�����,
      CardID,--֤������,
      CardExpireDate,--֤����Ч��,
      ClientType,--�ͻ�����,
      WorkPhone,--�����绰,
      FamilyPhone,--��ͥ�绰,
      Telephone,--�ֻ�,
      Occupation,--�ͻ�ְҵ,
      Businesstype,--��ҵ����,
      Income,--Ͷ����������,
      GrpName,--��λ����,
      Address,--�ͻ���ϸ��ַ,
      OtherClientInfo,--�ͻ�������Ϣ,
      ZipCode,--�ʱ�,
      Nationality,--����,
      ComCode,--�������,
      ContType,--���ű�ʶ,
      BusinessLicenseNo,--Ӫҵִ�պ�,
      OrgComCode,--��֯����֤��,
      TaxRegistCertNo,--˰��ǼǺ�,
      LegalPerson,--����������,
      LegalPersonCardType,--����������֤������,
      OtherLPCardType,--�������巨���������������֤��/֤���ļ�����,
      LegalPersonCardID,--����������֤������,
      LinkMan,--��ϵ��,
      ComRegistArea,--��˾ע���,
      ComRegistType,--��λע������,
      ComBusinessArea,--��˾��Ӫ���ڵ�,
      ComBusinessScope,--��˾��Ӫ��Χ,
      AppntNum,--�����ͻ�Ͷ������,
      ComStaffSize,--��ҵ������,
      GrpNature,--��λ����,
      FoundDate,--��������ʱ��,
      HolderKey,--�ɶ����,
      HolderName,--�ɶ�����,
      HolderCardType,--�ɶ�֤������,
      OtherHolderCardType,--��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����,
      HolderCardID,--�ɶ�֤������,
      HolderOccupation,--�ɶ�ְҵ����ҵ,
      HolderRadio,--�ɶ��ֹɱ���,
      HolderOtherInfo,--�ɶ�������Ϣ,
      RelaSpecArea,--�������������,
      FATCTRY,--��˰��������,
      CountryCode,--���Ҵ���,
      SuspiciousCode,--�ͻ���������,
      FundSource,--�ʽ���Դ,
      MakeDate,--�������,
      MakeTime,--���ʱ��,
      BatchNo--�������
  )select
     ClientNo,--�ͻ���,
      OriginalClientNo,--ԭʼ�ͻ���,
      Source,--�ͻ���Դ,
      Name,--�ͻ�����/����,
      Birthday,--����,
      Age,--����,
      Sex,--�Ա�,
      CardType,--�ͻ����֤��/֤���ļ�����,
      OtherCardType,--�������֤��/֤���ļ�����,
      CardID,--֤������,
      CardExpireDate,--֤����Ч��,
      ClientType,--�ͻ�����,
      WorkPhone,--�����绰,
      FamilyPhone,--��ͥ�绰,
      Telephone,--�ֻ�,
      Occupation,--�ͻ�ְҵ,
      Businesstype,--��ҵ����,
      Income,--Ͷ����������,
      GrpName,--��λ����,
      Address,--�ͻ���ϸ��ַ,
      OtherClientInfo,--�ͻ�������Ϣ,
      ZipCode,--�ʱ�,
      Nationality,--����,
      ComCode,--�������,
      ContType,--���ű�ʶ,
      BusinessLicenseNo,--Ӫҵִ�պ�,
      OrgComCode,--��֯����֤��,
      TaxRegistCertNo,--˰��ǼǺ�,
      LegalPerson,--����������,
      LegalPersonCardType,--����������֤������,
      OtherLPCardType,--�������巨���������������֤��/֤���ļ�����,
      LegalPersonCardID,--����������֤������,
      LinkMan,--��ϵ��,
      ComRegistArea,--��˾ע���,
      ComRegistType,--��λע������,
      ComBusinessArea,--��˾��Ӫ���ڵ�,
      ComBusinessScope,--��˾��Ӫ��Χ,
      AppntNum,--�����ͻ�Ͷ������,
      ComStaffSize,--��ҵ������,
      GrpNature,--��λ����,
      FoundDate,--��������ʱ��,
      HolderKey,--�ɶ����,
      HolderName,--�ɶ�����,
      HolderCardType,--�ɶ�֤������,
      OtherHolderCardType,--��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����,
      HolderCardID,--�ɶ�֤������,
      HolderOccupation,--�ɶ�ְҵ����ҵ,
      HolderRadio,--�ɶ��ֹɱ���,
      HolderOtherInfo,--�ɶ�������Ϣ,
      RelaSpecArea,--�������������,
      FATCTRY,--��˰��������,
      CountryCode,--���Ҵ���,
      SuspiciousCode,--�ͻ���������,
      FundSource,--�ʽ���Դ,
      MakeDate,--�������,
      MakeTime,--���ʱ��,
      BatchNo--�������
   from
      mid_client;
   
   -- ������Ϣ��
   insert into gr_policy(
      ContNo,--���պ�ͬ��
      ContType,--�Ÿ��ձ�־
      LocId,--���ڻ����������
      Prem,--���շ�
      Amnt,--���ս��
      PayMethod,--�ɷѷ�ʽ
      ContStatus,--����״̬
      Effectivedate,--��Ч��
      Expiredate,--��ֹ��
      AccountNo,--�����ʺ�
      SumPrem,--�ۼƱ���
      MainYearPrem,--��Լ��ȱ���
      YearPrem,--��ȱ���
      AgentCode,--�����˴���
      GrpFlag,--��ɼ���־
      Source,--������Դ
      InsSubject,--���ձ��
      InvestFlag,--Ͷ����ʶ
      RemainAccount,--��Ч����ʣ���˻���ֵ
      PayPeriod,--�ɷ�����
      SaleChnl,--��������
      InsuredPeoples,--����������
      PayInteval,--���Ѽ��
      OtherContInfo,--���պ�ͬ������Ϣ
      CashValue,--������ǰ�ֽ��ֵ
      INSTFROM,--�����������
      PolicyAddress,--������ϵ��ַ
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo,--�������
      OverPrem,--��ɱ���
      phone,--��ϵ�绰
      PrimeYearPrem,--������ȱ���
      RestPayPeriod--ʣ�ཻ������
   )select
      ContNo,--���պ�ͬ��
      ContType,--�Ÿ��ձ�־
      LocId,--���ڻ����������
      Prem,--���շ�
      Amnt,--���ս��
      PayMethod,--�ɷѷ�ʽ
      ContStatus,--����״̬
      Effectivedate,--��Ч��
      Expiredate,--��ֹ��
      AccountNo,--�����ʺ�
      SumPrem,--�ۼƱ���
      MainYearPrem,--��Լ��ȱ���
      YearPrem,--��ȱ���
      AgentCode,--�����˴���
      GrpFlag,--��ɼ���־
      Source,--������Դ
      InsSubject,--���ձ��
      InvestFlag,--Ͷ����ʶ
      RemainAccount,--��Ч����ʣ���˻���ֵ
      PayPeriod,--�ɷ�����
      SaleChnl,--��������
      InsuredPeoples,--����������
      PayInteval,--���Ѽ��
      OtherContInfo,--���պ�ͬ������Ϣ
      CashValue,--������ǰ�ֽ��ֵ
      INSTFROM,--�����������
      PolicyAddress,--������ϵ��ַ
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo,--�������
      OverPrem,--��ɱ���
      phone,--��ϵ�绰
      PrimeYearPrem,--������ȱ���
      RestPayPeriod--ʣ�ཻ������
    from 
      mid_g_policy;
      
   -- �ͻ�����������
    insert into gr_rel(
      ContNo,--���պ�ͬ��
      ClientNo,--�ͻ���
      CusType,--�ͻ�����
      RelaAppnt,--Ͷ�����뱻�����˹�ϵ
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo,--�������
      PolicyPhone,--������ϵ�绰
      UseCardType,--����ʹ�õ�֤������
      UseOtherCardType,--����ʹ�õ�����֤������
      UseCardID,--����ʹ�õ�֤����
      Insureno--�����˿ͻ���
    )select
      ContNo,--���պ�ͬ��
      ClientNo,--�ͻ���
      CusType,--�ͻ�����
      RelaAppnt,--Ͷ�����뱻�����˹�ϵ
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo,--�������
      PolicyPhone,--������ϵ�绰
      UseCardType,--����ʹ�õ�֤������
      UseOtherCardType,--����ʹ�õ�����֤������
      UseCardID,--����ʹ�õ�֤����
      Insureno--�����˿ͻ���
    from
      mid_g_rel;
      
      
    insert into gr_risk(
      ContNo,--���պ�ͬ��
      RiskCode,--���ֱ���
      RiskName,--��������
      MainFlag,--�����ձ�ʶ
      RiskType,--��������
      InsAmount,--���ս��
      Prem,--���շ�
      PayInteval,--���Ѽ��
      Effectivedate,--��Ч��
      Expiredate,--��ֹ��
      YearPrem,--��ȱ���
      SaleChnl,--��������
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo--�������
    )select
      ContNo,--���պ�ͬ��
      RiskCode,--���ֱ���
      RiskName,--��������
      MainFlag,--�����ձ�ʶ
      RiskType,--��������
      InsAmount,--���ս��
      Prem,--���շ�
      PayInteval,--���Ѽ��
      Effectivedate,--��Ч��
      Expiredate,--��ֹ��
      YearPrem,--��ȱ���
      SaleChnl,--��������
      Makedate,--�������
      MakeTime,--���ʱ��
      BatchNo--�������
    from
      mid_g_risk;
      
      
   INSERT INTO GR_Address(
      ClientNo,      --�ͻ���
      Contno,        --��ϵ��ʽ����
      ClientType,    --�ͻ�����
      LinkNumber,    --��ϵ�绰
      Adress,        --�ͻ�סַ/��Ӫ��ַ
      CusOthContact, --�ͻ�������ϵ��ʽ
      Nationality,   --����
      Country,       --����
      MakeDate,      --�������
      MakeTime,      --���ʱ��
      BatchNo,       --�������
      ContType       --�Ÿ��ձ�־
    )SELECT 
      ClientNo, --�ͻ���
      Contno,        --��ϵ��ʽ����
      ClientType,    --�ͻ�����
      LinkNumber,    --��ϵ�绰
      Adress,        --�ͻ�סַ/��Ӫ��ַ
      CusOthContact, --�ͻ�������ϵ��ʽ
      Nationality,   --����
      Country,       --����
      MakeDate,      --�������
      MakeTime,      --���ʱ��
      BatchNo,       --�������
      ContType       --�Ÿ��ձ�־
    FROM 
      MID_G_Address;
      
      
    INSERT INTO GR_TransDetail(
      TransNo, --���ױ��
      ContNo,  --������ͬ��
      subno,   --���
      remark,     --��ע
      ext1,     --�����ֶ�1
      ext2,     --�����ֶ�2
      ext3,     --�����ֶ�3
      ext4,     --�����ֶ�4
      ext5,     --�����ֶ�5
      Makedate, --�������
      MakeTime, --���ʱ��
      BatchNo   --�������
     )SELECT 
        TransNo, --���ױ��
        ContNo,       --������ͬ��
        subno,        --���
        remark,     --��ע
        ext1,     --�����ֶ�1
        ext2,     --�����ֶ�2
        ext3,     --�����ֶ�3
        ext4,     --�����ֶ�4
        ext5,     --�����ֶ�5
        Makedate, --�������
        MakeTime, --���ʱ��
        BatchNo   --�������
      FROM 
        MID_G_TransDetail;
      
      
     INSERT INTO GR_Trans(
        TransNo,               --���ױ��
        ContNo,                --���պ�ͬ��
        clientno,              --�ͻ���
        ContType,              --�Ÿ��ձ�־
        TransMethod,           --������ʽ
        TransType,             --��������
        Transdate,             --��������
        TransFromRegion,       --���׷�����
        TransToRegion,         --����ȥ���
        CureType,              --����
        PayAmt,                --���׽��
        PayWay,                --�ʽ��������
        PayMode,               --�ʽ������ʽ
        PayType,               --���׷�ʽ
        AccBank,               --�ʽ��˻�������
        AccNo,                 --����ת���˺�
        AccName,               --�˻�����������
        AccType,               --�˻�����
        AgentName,             --���״���������
        AgentCardType,         --���������֤������
        AgentOtherCardType,    --�������������֤������
        AgentCardID,           --���������֤������
        AgentNationality,      --�����˹���
        OpposideFinaName,      --�Է����ڻ�����������
        OpposideFinaType,      --�Է����ڻ�����������
        OpposideFinaCode,      --�Է����ڽ����������
        OpposideZipCode,       --�Է����ڻ�������������������
        TradeCusName,          --���׶�������
        TradeCusCardType,      --���׶���֤������
        TradeCusOtherCardType, --���׶�������֤������
        TradeCusCardID,        --���׶���֤������
        TradeCusAccType,       --���׶����˺�����
        TradeCusAccNo,         --���׶����˺�
        Source,                --������Դ
        BusiMark,              --ҵ���ʶ��
        RelationWithRegion,    --��������������ϵ
        UseOfFund,             --�ʽ���;
        Makedate,              --�������
        MakeTime,              --���ʱ��
        BatchNo,               --�������
        AccOpenTime,           --�˻�����ʱ��
        BankCardType,          --�ͻ����п�����
        BankCardOtherType,     --�ͻ����п���������
        BankCardnumber,        --�ͻ����п�����
        RPMatchNoType,         --�ո��ƥ�������
        RPMatchNumber,         --�ո��ƥ���
        NonCounterTranType,    --�ǹ�̨���׷�ʽ
        NonCounterOthTranType, --�����ǹ�̨���׷�ʽ
        NonCounterTranDevice,  --�ǹ�̨���׷�ʽ���豸����
        BankPaymentTranCode,   --������֧������֮���ҵ���ױ���
        ForeignTransCode,      --������֧���׷��������
        CRMB,                  --���׽�������ң�
        CUSD,                  --���׽�����Ԫ��
        Remark,    --������Ϣ��ע
        IsThirdAccount, --�Ƿ�ʹ�õ������˻�
        RequestDate     --������
     )SELECT 
          TransNo,          --���ױ��
          ContNo,                --���պ�ͬ��
          clientno,              --�ͻ���
          ContType,              --�Ÿ��ձ�־
          TransMethod,           --������ʽ
          TransType,             --��������
          Transdate,             --��������
          TransFromRegion,       --���׷�����
          TransToRegion,         --����ȥ���
          CureType,              --����
          PayAmt,                --���׽��
          PayWay,                --�ʽ��������
          PayMode,               --�ʽ������ʽ
          PayType,               --���׷�ʽ
          AccBank,               --�ʽ��˻�������
          AccNo,                 --����ת���˺�
          AccName,               --�˻�����������
          AccType,               --�˻�����
          AgentName,             --���״���������
          AgentCardType,         --���������֤������
          AgentOtherCardType,    --�������������֤������
          AgentCardID,           --���������֤������
          AgentNationality,      --�����˹���
          OpposideFinaName,      --�Է����ڻ�����������
          OpposideFinaType,      --�Է����ڻ�����������
          OpposideFinaCode,      --�Է����ڽ����������
          OpposideZipCode,       --�Է����ڻ�������������������
          TradeCusName,          --���׶�������
          TradeCusCardType,      --���׶���֤������
          TradeCusOtherCardType, --���׶�������֤������
          TradeCusCardID,        --���׶���֤������
          TradeCusAccType,       --���׶����˺�����
          TradeCusAccNo,         --���׶����˺�
          Source,                --������Դ
          BusiMark,              --ҵ���ʶ��
          RelationWithRegion,    --��������������ϵ
          UseOfFund,             --�ʽ���;
          Makedate,              --�������
          MakeTime,              --���ʱ��
          BatchNo,               --�������
          AccOpenTime,           --�˻�����ʱ��
          BankCardType,          --�ͻ����п�����
          BankCardOtherType,     --�ͻ����п���������
          BankCardnumber,        --�ͻ����п�����
          RPMatchNoType,         --�ո��ƥ�������
          RPMatchNumber,         --�ո��ƥ���
          NonCounterTranType,    --�ǹ�̨���׷�ʽ
          NonCounterOthTranType, --�����ǹ�̨���׷�ʽ
          NonCounterTranDevice,  --�ǹ�̨���׷�ʽ���豸����
          BankPaymentTranCode,   --������֧������֮���ҵ���ױ���
          ForeignTransCode,      --������֧���׷��������
          CRMB,                  --���׽�������ң�
          CUSD,                  --���׽�����Ԫ��
          Remark,    --������Ϣ��ע
          IsThirdAccount, --�Ƿ�ʹ�õ������˻�
          RequestDate     --������
       FROM 
          MID_G_Trans;
      
      
     INSERT INTO GR_Trans(
          TransNo,    --���ױ��
          ContNo,    --���պ�ͬ��
          clientno,    --�ͻ���
          ContType,    --�Ÿ��ձ�־
          TransMethod,    --������ʽ
          TransType,    --��������
          Transdate,    --��������
          TransFromRegion,    --���׷�����
          TransToRegion,    --����ȥ���
          CureType,    --����
          PayAmt,    --���׽��
          PayWay,    --�ʽ��������
          PayMode,    --�ʽ������ʽ
          PayType,    --���׷�ʽ
          AccBank,    --�ʽ��˻�������
          AccNo,    --����ת���˺�
          AccName,    --�˻�����������
          AccType,    --�˻�����
          AgentName,    --���״���������
          AgentCardType,    --���������֤������
          AgentOtherCardType,    --�������������֤������
          AgentCardID,    --���������֤������
          AgentNationality,    --�����˹���
          OpposideFinaName,    --�Է����ڻ�����������
          OpposideFinaType,    --�Է����ڻ�����������
          OpposideFinaCode,    --�Է����ڽ����������
          OpposideZipCode,    --�Է����ڻ�������������������
          TradeCusName,    --���׶�������
          TradeCusCardType,    --���׶���֤������
          TradeCusOtherCardType,    --���׶�������֤������
          TradeCusCardID,    --���׶���֤������
          TradeCusAccType,    --���׶����˺�����
          TradeCusAccNo,    --���׶����˺�
          Source,    --������Դ
          BusiMark,    --ҵ���ʶ��
          RelationWithRegion,    --��������������ϵ
          UseOfFund,    --�ʽ���;
          Makedate,    --�������
          MakeTime,    --���ʱ��
          BatchNo,    --�������
          AccOpenTime,    --�˻�����ʱ��
          BankCardType,    --�ͻ����п�����
          BankCardOtherType,    --�ͻ����п���������
          BankCardnumber,    --�ͻ����п�����
          RPMatchNoType,    --�ո��ƥ�������
          RPMatchNumber,    --�ո��ƥ���      
          NonCounterTranType,    --�ǹ�̨���׷�ʽ
          NonCounterOthTranType,    --�����ǹ�̨���׷�ʽ  
          NonCounterTranDevice,    --�ǹ�̨���׷�ʽ���豸����
          BankPaymentTranCode,    --������֧������֮���ҵ���ױ���
          ForeignTransCode,    --������֧���׷��������
          CRMB,    --���׽�������ң�
          CUSD,    --���׽�����Ԫ��
          Remark,    --������Ϣ��ע
          IsThirdAccount,    --�Ƿ�ʹ�õ������˻�
          RequestDate    --������
       )SELECT 
            TransNo,    --���ױ��
            ContNo,    --���պ�ͬ��
            clientno,    --�ͻ���
            ContType,    --�Ÿ��ձ�־
            TransMethod,    --������ʽ
            TransType,    --��������
            Transdate,    --��������
            TransFromRegion,    --���׷�����
            TransToRegion,    --����ȥ���
            CureType,    --����
            PayAmt,    --���׽��
            PayWay,    --�ʽ��������
            PayMode,    --�ʽ������ʽ
            PayType,    --���׷�ʽ
            AccBank,    --�ʽ��˻�������
            AccNo,    --����ת���˺�
            AccName,    --�˻�����������
            AccType,    --�˻�����
            AgentName,    --���״���������
            AgentCardType,    --���������֤������
            AgentOtherCardType,    --�������������֤������
            AgentCardID,    --���������֤������
            AgentNationality,    --�����˹���
            OpposideFinaName,    --�Է����ڻ�����������
            OpposideFinaType,    --�Է����ڻ�����������
            OpposideFinaCode,    --�Է����ڽ����������
            OpposideZipCode,    --�Է����ڻ�������������������
            TradeCusName,    --���׶�������
            TradeCusCardType,    --���׶���֤������
            TradeCusOtherCardType,    --���׶�������֤������
            TradeCusCardID,    --���׶���֤������
            TradeCusAccType,    --���׶����˺�����
            TradeCusAccNo,    --���׶����˺�
            Source,    --������Դ
            BusiMark,    --ҵ���ʶ��
            RelationWithRegion,    --��������������ϵ
            UseOfFund,    --�ʽ���;
            Makedate,    --�������
            MakeTime,    --���ʱ��
            BatchNo,    --�������
            AccOpenTime,    --�˻�����ʱ��
            BankCardType,    --�ͻ����п�����
            BankCardOtherType,    --�ͻ����п���������
            BankCardnumber,    --�ͻ����п�����
            RPMatchNoType,    --�ո��ƥ�������
            RPMatchNumber,    --�ո��ƥ���      
            NonCounterTranType,    --�ǹ�̨���׷�ʽ
            NonCounterOthTranType,    --�����ǹ�̨���׷�ʽ  
            NonCounterTranDevice,    --�ǹ�̨���׷�ʽ���豸����
            BankPaymentTranCode,    --������֧������֮���ҵ���ױ���
            ForeignTransCode,    --������֧���׷��������
            CRMB,    --���׽�������ң�
            CUSD,    --���׽�����Ԫ��
            Remark,    --������Ϣ��ע
            IsThirdAccount,    --�Ƿ�ʹ�õ������˻�
            RequestDate    --������
         FROM  
            MID_G_Trans;
            
      dbms_output.put_line('���ݲ��������');            
     
      -- ���˴��м������ݷ���浵
      insert into mid_g_client_bak select * from mid_g_client;
      
      insert into mid_g_policy_bak select * from mid_g_policy;
      
      insert into mid_g_rel_bak select * from mid_g_rel;
      
      insert into mid_g_risk_bak select * from mid_g_risk;
      
      insert into mid_g_trans_bak select * from mid_g_trans;
      
      insert into mid_g_trans_bakdetail_bak select * from mid_g_transdetail;
      
      insert into mid_g_address_bak select * from mid_g_address;
     
      dbms_output.put_line('�м�����ݹ鵵����');            
            
      -- ����м����������
      delete from mid_g_client;
      
      delete from mid_g_policy;
      
      delete from mid_g_rel;
      
      delete from mid_g_risk;
      
      delete from mid_g_trans;
      
      delete from mid_g_transdetail;
      
      delete from mid_g_address;
      
      dbms_output.put_line('�м�����������');                  
      
      -- ִ����ϣ����¹켣״̬
      update 
        LLogTrace
      set 
       dealstate = '01',
       dealdesc = '�����м��������ƽ̨��ɹ�����',
       InsertTime = to_date(startDate,'YYYY-MM-DD'),
       modifytime = to_date(startDate,'YYYY-MM-DD'),
       endtime = sysdate
      where traceid = v_TraceId;
      
      dbms_output.put_line('��ϲ��������ɣ���');                        
      
      commit;
   -- �쳣����
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=errorCode||errorMsg;

  -- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
  
  update 
    LLogTrace
  set 
    dealstate  = '02',
    dealdesc   = v_errormsg,
    InsertTime = to_date(startDate,'YYYY-MM-DD'),
    modifytime = to_date(startDate,'YYYY-MM-DD')
  where 
    traceid = v_TraceId;
    
  commit;
end Group_aml_mid_to_gr;
/

prompt
prompt Creating procedure GROUP_INSURANCE_PROC_AML_RULE
prompt ================================================
prompt
create or replace procedure Group_insurance_proc_aml_rule(i_baseLine in date,i_oprater in VARCHAR2) is
begin
  -- =============================================
  -- Description:  ���ô��/���ɸ�ɸѡ������ش���
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/12/25
  -- Changes log:
  --     Author        Date         Description
  --     zhouqk     2019/12/25         ����
  -- =============================================

  --������Դ˴����е����չ������ѭ����ȡ
  dbms_output.put_line('��ʼִ�����չ���');
  ------------------------------��������ר����----------------------------------
    Group_aml_A0101(i_baseLine,i_oprater);
    
--    Group_aml_A0300(i_baseLine,i_oprater);
    
    GROUP_AML_B0101(i_baseLine,i_oprater);
    
--    GROUP_AML_B0102(i_baseLine,i_oprater);
   
--    GROUP_AML_B0103(i_baseLine,i_oprater);
  
--    GROUP_AML_C0801(i_baseLine,i_oprater);
  
--   GROUP_AML_C0802(i_baseLine,i_oprater);
 
--    Group_aml_C1000(i_baseLine,i_oprater);
  
--    Group_aml_D1100(i_baseLine,i_oprater);

--    Group_aml_D1300(i_baseLine,i_oprater);
  
  ------------------------------------------------------------------------------
  
  --Group_aml_A0200(i_baseLine,i_oprater);
  
  -- Group_aml_A0900(i_baseLine,i_oprater);
  
  -- Group_aml_C0400(i_baseLine,i_oprater);
  
  Group_aml_C0500(i_baseLine,i_oprater);
   
  -- Group_aml_C0600(i_baseLine,i_oprater);
  
  --Group_aml_D1400(i_baseLine,i_oprater);
  
  -- Group_aml_D1500(i_baseLine,i_oprater);

  -- Group_aml_A0102(i_baseLine,i_oprater);

  --Group_aml_A0801(i_baseLine,i_oprater);
  
  --Group_aml_A0802(i_baseLine,i_oprater);
  
  Group_aml_D1200(i_baseLine,i_oprater);
  
  dbms_output.put_line('����ִ�����');

end Group_insurance_proc_aml_rule;
/

prompt
prompt Creating procedure PROC_AML_DATA_MIGRATION
prompt ==========================================
prompt
create or replace procedure proc_aml_data_migration(i_dataBatchNo in varchar2) is
begin
  -- =============================================
  -- Description: �����/����ҵ����ʱ��������Ǩ�Ƶ�ҵ���
  -- parameter in: i_dataBatchNo ���κ�
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/05/10
  -- Changes log:
  --     Author     Date     Description
  --     xuexc   2019/05/10  ����
  -- =============================================

  -- ��������
  insert into Lxihtrademain
    select
      DealNo,
			CSNM,
			CRCD,
			CTVC,
			CustomerName,
			IDType,
			OITP,
			IDNo,
			HTDT,
			DataState,
			Operator,
			ManageCom,
			Typeflag,
			Notes,
			CustomerType,
			BaseLine,
			GetDataMethod,
			NextFileType,
			NextReferFileNo,
			NextPackageType,
			DataBatchNo,
			MakeDate,
			MakeTime,
			ModifyDate,
			ModifyTime,
			JudgmentDate,
      ReportSuccessDate
    from Lxihtrademain_Temp where DataBatchNo = i_dataBatchNo;

  -- ������ϸ��ȥ�غ�Ǩ�Ƶ�ҵ���
  insert into Lxihtradedetail
    select
      DealNo,
		  PolicyNo,
      TICD,
      ContType,
      FINC,
      RLFC,
      CATP,
      CTAC,
      OATM,
      CBCT,
      OCBT,
      CBCN,
      TBNM,
      TBIT,
      OITP,
      TBID,
      TBNT,
      TSTM,
      RPMT,
      RPMN,
      TSTP,
      OCTT,
      OOCT,
      OCEC,
      BPTC,
      TSCT,
      TSDR,
      TRCD,
      CRPP,
      CRTP,
      CRAT,
      CFIN,
      CFCT,
      CFIC,
      CFRC,
      TCNM,
      TCIT,
      OTTP,
      TCID,
      TCAT,
      TCAC,
      CRMB,
      CUSD,
      ROTF,
      DataState,
      DataBatchNo,
      MakeDate,
      MakeTime,
      ModifyDate,
      ModifyTime,
      triggerflag
    from Lxihtradedetail_Temp tmp,
      (select row_number() over(partition by DealNo, PolicyNo, TICD order by serialno asc) as rowno, serialno
         from Lxihtradedetail_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;

  -- ���ɽ�����Ϣ����
  insert into Lxistrademain
    select
      dealno, -- ���ױ��
      rpnc,   -- �ϱ��������
      detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
      torp,   -- ���ʹ�����־
      dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
      odrp,   -- �������ͷ���
      tptr,   -- ���ɽ��ױ��津����
      otpr,   -- �������ɽ��ױ��津����
      stcb,   -- �ʽ��׼��ͻ���Ϊ���
      aosp,   -- �ɵ����
      stcr,   -- ���ɽ�������
      csnm,   -- �ͻ���
      senm,   -- ������������/����
      setp,   -- �����������֤��/֤���ļ�����
      oitp,   -- �������֤��/֤���ļ�����
      seid,   -- �����������֤��/֤���ļ�����
      sevc,   -- �ͻ�ְҵ����ҵ
      srnm,   -- �������巨������������
      srit,   -- �������巨�����������֤������
      orit,   -- �������巨���������������֤��/֤���ļ�����
      srid,   -- �������巨�����������֤������
      scnm,   -- ��������عɹɶ���ʵ�ʿ���������
      scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
      ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
      scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
      strs,   -- ���佻�ױ�ʶ
      datastate, -- ����״̬
      filename,  -- ��������
      filepath,  -- ����·��
      rpnm,      -- ���
      operator,  -- ����Ա
      managecom, -- �������
      conttype,  -- �������ͣ�01-����, 02-�ŵ���
      notes,     -- ��ע
			baseline,       -- ���ڻ�׼
      getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩
      nextfiletype,   -- �´��ϱ���������
      nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
      nextpackagetype,-- �´��ϱ����İ�����
      databatchno,    -- �������κ�
      makedate,       -- ���ʱ��
      maketime,       -- �������
      modifydate,     -- ����������
      modifytime,     -- ������ʱ��
      judgmentdate,   -- ��������
      ORXN,           -- ���������״��ϱ��ɹ��ı�������
		  ReportSuccessDate
    from Lxistrademain_Temp where DataBatchNo=i_dataBatchNo;

  -- ���ɽ�����ϸ��Ϣ��ȥ�غ�Ǩ�Ƶ�ҵ���
  insert into Lxistradedetail
    select
      DealNo,
      TICD,
      ICNM,
      TSTM,
      TRCD,
      ITTP,
      CRTP,
      CRAT,
      CRDR,
      CSTP,
      CAOI,
      TCAN,
      ROTF,
      DataState,
      DataBatchNo,
      MakeDate,
      MakeTime,
      ModifyDate,
      ModifyTime,
      TRIGGERFLAG
    from Lxistradedetail_Temp tmp,
      (select row_number() over(partition by DealNo, TICD order by serialno asc) as rowno, serialno
         from Lxistradedetail_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;

  -- ���ɽ��׺�ͬ��Ϣ��ȥ�غ�Ǩ�Ƶ�ҵ���
  insert into Lxistradecont
    select
      DealNo,
      CSNM,
      ALNM,
      AppNo,
      ContType,
      AITP,
      OITP,
      ALID,
      ALTP,
      ISTP,
      ISNM,
      RiskCode,
      Effectivedate,
      Expiredate,
      ITNM,
      ISOG,
      ISAT,
      ISFE,
      ISPT,
      CTES,
      FINC,
      DataBatchNo,
      MakeDate,
      MakeTime,
      ModifyDate,
      ModifyTime
    from Lxistradecont_Temp tmp,
      (select row_number() over(partition by DealNo, CSNM order by serialno asc) as rowno, serialno
         from Lxistradecont_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;

  -- ���ɽ��ױ�������Ϣ��ȥ�غ�Ǩ�Ƶ�ҵ���
  insert into Lxistradeinsured
    select
      DEALNO,
      CSNM,
      INSUREDNO,
      ISTN,
      IITP,
      OITP,
      ISID,
      RLTP,
      DataBatchNo,
      MakeDate,
      MakeTime,
      ModifyDate,
      ModifyTime
    from Lxistradeinsured_Temp tmp,
      (select row_number() over(partition by DealNo, CSNM, INSUREDNO order by serialno asc) as rowno, serialno
         from Lxistradeinsured_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;

  -- ���ɽ�����������Ϣ��ȥ�غ�Ǩ�Ƶ�ҵ���
  insert into Lxistradebnf
    select
      DealNo,
      CSNM,
      InsuredNo,
      BnfNo,
      BNNM,
      BITP,
      OITP,
      BNID,
      DataBatchNo,
      MakeDate,
      MakeTime,
      ModifyDate,
      ModifyTime
    from Lxistradebnf_Temp tmp,
      (select row_number() over(partition by DealNo, CSNM, InsuredNo, BnfNo order by serialno asc) as rowno, serialno
         from Lxistradebnf_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;

    insert into Lxaddress
    select
      dealno,
      listno,
      csnm,
      nationality,
      linknumber,
      adress,
      cusothcontact,
      databatchno,
      makedate,
      maketime,
      modifydate,
      modifytime
    from Lxaddress_Temp tmp,
      (select row_number() over(partition by DealNo, CSNM, listno order by serialno asc) as rowno, serialno
         from Lxaddress_Temp
         where DataBatchNo = i_dataBatchNo) tmpsub
    where tmp.serialno = tmpsub.serialno and tmpsub.rowno = 1 and tmp.DataBatchNo = i_dataBatchNo;                                           -- ����������ϵ��ʽ

  -- ��մ��/����ҵ����ʱ��
  delete from Lxihtrademain_Temp;   -- ��������-��ʱ��
  delete from Lxihtradedetail_Temp; -- ������ϸ��-��ʱ��
  delete from Lxistrademain_Temp;   -- ���ɽ�����Ϣ����-��ʱ��
  delete from Lxistradedetail_Temp; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  delete from Lxistradecont_Temp;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  delete from Lxistradeinsured_Temp;-- ���ɽ��ױ�������Ϣ-��ʱ��
  delete from Lxistradebnf_Temp;    -- ���ɽ�����������Ϣ-��ʱ��
  delete from Lxaddress_Temp;       -- ����������ϵ��ʽ-��ʱ��

end proc_aml_data_migration;
/

prompt
prompt Creating procedure PROC_AML_INS_LXOPERATIONTRACE
prompt ================================================
prompt
create or replace procedure proc_aml_ins_lxoperationtrace(

  i_databatchno in number,
  i_dealno in varchar2,
  i_datatype in varchar2) is

  v_traceno lxoperationtrace.traceno%type;

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxoperationtrace�켣��
  -- parameter in: i_traceno     ��ˮ��
  --               i_databatchno ���κ�
  --               i_dealno      ���ױ��
  --               i_datatype    ��������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/06/13
  -- Changes log:
  --     Author     Date      Description
  --      zhouqk  2019/06/13     ����
  -- =============================================

  v_traceno := nextval2('AML_TRACENO','SN');

  -- �������������log��־��
  insert into lxoperationtrace(
    TRACENO,	    -- ��ˮ��
    DATABATCHNO,  -- �������κ�
    DEALNO,       -- ���ױ��
    DATATYPE,     -- ��������
    OPERATIONTYPE,-- ҵ������/ҵ��ڵ�
    OPERATIONCODE,-- ����
    AOSP,         -- �ɵ����
    REMARK,       -- ��ע
    OPERATOR,     -- ������
    MAKEDATE,     -- �������
    MAKETIME,     -- ���ʱ��
    MODIFYDATE,   -- ������������
    MODIFYTIME    -- ������ʱ��
  )
  values(
    LPAD(v_traceno,20,'0'),
    i_databatchno,
    i_dealno,
    i_datatype,
    '00',            -- ҵ������Ϊϵͳץȡ
    null,
    null,
    'ϵͳץȡ',
    'system',
    to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),
    to_char(sysdate,'hh24:mi:ss'),
    to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),
    to_char(sysdate,'hh24:mi:ss')
  );

end proc_aml_ins_lxoperationtrace;
/

prompt
prompt Creating procedure PROC_AML_DEALOPERATORDATA
prompt ============================================
prompt
create or replace procedure proc_aml_dealoperatordata(i_databatchno in varchar2) is
begin
  -- ============================================
  -- Description: �������������е����ݲ��뵽�켣����
  -- parameter in: i_databatchno   ���κ�
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/06/13
  -- Changes log:
  --     Author         Date        Description
  --     zhouqk     2019/06/13        ����
  -- =============================================

  declare

      --�����α�:�����������еĽ��ױ�ţ��������κţ�

      cursor baseInfo_IH_sor is
        select
            tmp_h.dealno
          from
            lxihtrademain_temp tmp_h
        where
            tmp_h.databatchno=i_databatchno;

      --�����α�:������������еĽ��ױ�ţ��������κţ�

      cursor baseInfo_IS_sor is
        select
            tmp_s.dealno
          from
            lxistrademain_temp tmp_s
        where
            tmp_s.databatchno=i_databatchno;

      v_ih_dealno lxihtrademain_temp.dealno%type;
      v_is_dealno lxistrademain_temp.dealno%type;

begin

    open baseInfo_IH_sor;
      loop
        fetch baseInfo_IH_sor into v_ih_dealno;
        exit when baseInfo_IH_sor%notfound;

         proc_aml_ins_lxoperationtrace(i_databatchno,v_ih_dealno,'IH');

      end loop;
    close baseInfo_IH_sor;


    open baseInfo_IS_sor;
      loop
        fetch baseInfo_IS_sor into v_is_dealno;
        exit when baseInfo_IS_sor%notfound;

         proc_aml_ins_lxoperationtrace(i_databatchno,v_is_dealno,'IS');

      end loop;
    close baseInfo_IS_sor;

end;
end proc_aml_dealoperatordata;
/

prompt
prompt Creating procedure PROC_AML_DELETE_LXIHTRADE
prompt ============================================
prompt
create or replace procedure proc_aml_delete_lxihtrade(i_baseLine in date) is
begin
	-- ============================================
  -- Description: �����/����ҵ����ʱ��������Ǩ�Ƶ�ҵ���
  --              ����ʵ�����Ṧ�ܣ��ж�ҵ������Ƿ�洢�Ѿ���ȡ�����ݣ�ɾ���Ѿ���������ݣ��������²���
  -- parameter in: i_baseline  ��������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/04/21
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk   2019/04/21    ����
  -- =============================================

	declare
			--�����α꣺����������������м��Ľ��ױ�ű��浽�α��У�����csnm���ͻ���  crcd��������������  baseline�����ڻ�׼��
			cursor baseInfo_sor is
				select
						temp.dealno
					from
						lxihtrademain main,lxihtrademain_temp temp
				where main.csnm=temp.csnm
				and main.crcd=temp.crcd
        and trunc(main.baseline)=trunc(i_baseline)
				and trunc(temp.baseline)=trunc(i_baseLine);

			--�������
			c_dealno lxihtrademain.dealno%type;

begin
			open baseInfo_sor;
			loop
				fetch baseInfo_sor into c_dealno;
				exit when baseInfo_sor%notfound;

          -- �����α��б���Ľ��ױ�Ž���ɾ��

					delete from lxihtrademain_temp where dealno=c_dealno;

					delete from lxihtradedetail_temp where dealno=c_dealno;

          delete from lxaddress_temp where dealno=c_dealno;

		end loop;
		close baseInfo_sor;

end;
end proc_aml_delete_lxihtrade;
/

prompt
prompt Creating procedure PROC_AML_DELETE_LXISTRADE
prompt ============================================
prompt
create or replace procedure proc_aml_delete_lxistrade(i_baseLine in date) is
begin
  -- ============================================
  -- Description: ����ʵ�����Ṧ�ܣ��ж�ҵ������Ƿ�洢�Ѿ���ȡ�����ݣ�ɾ���Ѿ���������ݣ��������²���
  -- parameter in: i_baseline  ��������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/04/21
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk   2019/04/21    ����
  -- =============================================

	declare
			--�����α꣺�����������������м��Ľ��ױ�ű��浽�α��У�����csnm���ͻ���  stcr�����ɽ�����������  baseline�����ڻ�׼��
			cursor baseInfo_sor is
				select
						temp.dealno
					from
						lxistrademain main,lxistrademain_temp temp
				where
				    main.csnm=temp.csnm
				and main.stcr=temp.stcr
        and main.orxn is null
        and temp.orxn is null
        and trunc(main.baseline)=trunc(i_baseline)
				and trunc(temp.baseline)=trunc(i_baseline);


			--�������
			v_dealno lxistrademain.dealno%type;			-- ���ױ��

begin

			open baseInfo_sor;
			loop
				fetch baseInfo_sor into v_dealno;
				exit when baseInfo_sor%notfound;

          -- �����α��еĽ��ױ�Ž���ɾ��

					delete from lxistrademain_temp where dealno=v_dealno;

          delete from lxistradedetail_temp where dealno=v_dealno;

					delete from lxistradecont_temp where dealno=v_dealno;

					delete from lxistradeinsured_temp where dealno=v_dealno;

					delete from lxistradebnf_temp where dealno=v_dealno;

					delete from lxaddress_temp where dealno=v_dealno;

		end loop;
		close baseInfo_sor;

end;
end proc_aml_delete_lxistrade;
/

prompt
prompt Creating procedure PROC_AML_INS_LDBATCHLOG
prompt ==========================================
prompt
create or replace procedure proc_aml_ins_ldbatchlog(

  i_databatchno in varchar2,i_batchtype in varchar2, i_state in varchar2, i_rundate in date,i_errormsg in varchar2) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������ldbatchlog��
  -- parameter in: i_databatchno  ���κ�
  --               i_batchtype 		�����ɱ�ʶ
  --               i_state  			�жϳɹ�ʧ�ܵı�ʶ
  --               i_rundate      ����ʱ��
	--							 i_errormsg			ʧ����Ϣ
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/01
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/04/12  ����
  -- =============================================

  -- �����������ȡ�����
  insert into ldbatchlog(
    batchno, 			-- ���κ�
		batchtype,		-- �����ɵı�ʶ
		state,				-- �жϳɹ�ʧ�ܵı�ʶ
		rundate,			-- ����ʱ��
		errormsg,			-- ʧ����Ϣ
		makedate			-- ����ʱ��
  )
  values(
    i_databatchno,
		i_batchtype,
		i_state,
		i_rundate,
		i_errormsg,
		to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd')
  );

end proc_aml_ins_ldbatchlog;
/

prompt
prompt Creating procedure PROC_AML_INS_LX_LDBATCHLOG
prompt =============================================
prompt
create or replace procedure proc_aml_ins_lx_ldbatchlog(

	i_databatchno in varchar2,i_state in varchar2,i_rundate in date,i_errormsg in varchar2

) is
begin

  -- =============================================
  -- Description: ������������������ȡ�����
  -- parameter in: i_databatchno ���κ�
  --               i_state       �����ɱ�־
  --               i_rundate     ����ʱ��
  --               i_errormsg    ������Ϣ
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/04/21
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/04/21  ����
  -- =============================================

		PROC_AML_INS_LDBATCHLOG(i_databatchno, 'IS', i_state, i_rundate, i_errormsg);


end proc_aml_ins_lx_ldbatchlog;
/

prompt
prompt Creating procedure PROC_AML_INS_LXCALLOG
prompt ========================================
prompt
create or replace procedure proc_aml_ins_lxcallog(
  i_appid in varchar2,i_csnmCount in number, i_operator in varchar2, i_stcr in varchar2,i_databatchno in VARCHAR2) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxcallog��
  -- parameter in: i_baseLine  ��������
  --               i_csnmCount �ͻ���
  --               i_operator  ������
  --               i_stcr      �㷨����
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/03/01
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/01  ����
  -- =============================================

  -- �������������log��־��
  insert into lxcallog(
    appid,    	-- Ӧ�ñ�ʶ��
    calcode,  	-- �㷨����
		dataBatchNo,-- ���κ�
    csnmcount,	-- ��ȡ���Ŀͻ�����
    operator, 	-- ����Ա
    makedate, 	-- ���ʱ��
    maketime  	-- �������
  )
  values(
    i_appid,
    i_stcr,
		i_databatchno,
    i_csnmCount,
    i_operator,
    to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'), -- �������
    to_char(sysdate,'hh24:mi:ss') 											 -- ���ʱ��
  );

end proc_aml_ins_lxcallog;
/

prompt
prompt Creating procedure PROC_AML_INS_LX_LXCALLOG
prompt ===========================================
prompt
create or replace procedure proc_aml_ins_lx_lxcallog(i_operator in varchar2,i_dataBatchNo in varchar2) is

begin

  -- =============================================
  -- Description: ������������������ȡ��־��
  -- parameter in: i_operator      ������
  --               i_dataBatchNo   ���κ�
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/04/21
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/04/21  ����
  -- =============================================

declare
		--�����α꣬�����Ѿ����뵽���ҵ����еģ�ȥ��֮�󣩽����������루���޴˴����κ��У�
		cursor baseInfo_IH_sor is
						select
								distinct hm.crcd
							from
								lxihtrademain hm
							where
								DataBatchNo = i_dataBatchNo;

		--�����α꣬�����Ѿ����뵽����ҵ����еģ�ȥ��֮�󣩽����������루���޴˴����κ��У�
		cursor baseInfo_IS_sor is
						select
								distinct im.stcr
							from
								lxistrademain im
							where
								DataBatchNo = i_dataBatchNo;


		--��������
		v_crcd lxihtrademain.crcd%type;
		v_csnmIHCount lxcallog.CSNMCOUNT%type; 				-- ������ҵ��Ĵ��ͻ�����

		--�������ɽ���
		v_stcr lxistrademain.stcr%type;
		v_csnmISCount lxcallog.CSNMCOUNT%type; 				-- ������ҵ��Ŀ��ɿͻ�����

begin

		open baseInfo_IH_sor;																-- �򿪱���˴��������Ѿ�ɸѡ���Ĺ�����������
			loop
				fetch baseInfo_IH_sor into v_crcd;
				exit when baseInfo_IH_sor%notfound;							-- ���˴�������û�в���ҵ������ݣ��˳�ѭ��

				select count(1) into v_csnmIHCount from lxihtrademain where DataBatchNo=i_dataBatchNo and crcd = v_crcd;
																												-- ��ÿ�������������ͻ���
				PROC_AML_INS_LXCALLOG('LIH',v_csnmIHCount, i_operator,v_crcd,i_dataBatchNo);

			end loop;
		close baseInfo_IH_sor;

		open baseInfo_IS_sor;																-- �򿪱���˴��������Ѿ�ɸѡ���Ĺ�����������
			loop
				fetch baseInfo_IS_sor into v_stcr;
				exit when baseInfo_IS_sor%notfound;							-- ���˴�������û�в���ҵ������ݣ��˳�ѭ��

				select count(1) into v_csnmISCount from lxistrademain where DataBatchNo=i_dataBatchNo and stcr = v_stcr;
																												-- ��ÿ�������������ͻ���
				PROC_AML_INS_LXCALLOG('LIS',v_csnmISCount,i_operator,v_stcr,i_dataBatchNo);

			end loop;
		close baseInfo_IS_sor;

end;
end proc_aml_ins_lx_lxcallog;
/

prompt
prompt Creating procedure PROC_AML_MAPPINGCODE
prompt =======================================
prompt
create or replace procedure proc_aml_mappingcode(

    i_dataBatchNo in varchar2

) is
begin
  -- =============================================
  -- Description:  ���/���ɽ���ҵ����ֶ�ת��
  -- parameter in:  i_dataBatchNo  ���κ�
  -- parameter out: none
  -- Author: zhouqk
  -- Create date:  2019/04/22
  -- Changes log:
  --     Author     Date             Description
  --     zhouqk  2019/04/21             ����
	--     zhouqk  2019/05/23           ���Ӵ��ҵ����н��׷�ʽ��ת�루Ĭ�ϸ�000051��
  -- =============================================
  update lxistrademain_temp a set

      --�����������֤��/֤���ļ�����
      setp = getTargetCodeByMapping('aml_idtype',a.setp),
      --�������巨�����������֤������
      srit = getTargetCodeByMapping('aml_idtype',a.srit),
      --��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
      scit = getTargetCodeByMapping('aml_idtype',a.scit),
      --�ͻ�ְҵ����ҵ
      sevc = getTargetCodeByMapping('aml_sevc',a.sevc),
      --�������
      managecom = getTargetCodeByMapping('aml_finc',a.managecom)

      where a.databatchno=i_dataBatchNo;

  update lxistradecont_temp a set
         --�ɷѷ�ʽ
         ispt = getTargetCodeByMapping('aml_ispt',a.ispt),
         --Ͷ�������֤��/֤���ļ�����
         aitp = getTargetCodeByMapping('aml_idtype',a.aitp)
         --���ڻ����������
         --finc = getTargetCodeByMapping('aml_finc',a.finc)

         where a.databatchno=i_dataBatchNo;

  --������֤������
  update lxistradeinsured_temp a set iitp = getTargetCodeByMapping('aml_idtype',a.iitp) where a.databatchno=i_dataBatchNo;

  --���������֤������
  update lxistradebnf_temp a set bitp = getTargetCodeByMapping('aml_idtype',a.bitp) where a.databatchno=i_dataBatchNo;

  update lxistradedetail_temp a set
         --���ɽ�������
         ittp = getTargetCodeByMapping('aml_ittp',a.ittp),
         --�ʽ��������
         crdr = getTargetCodeByMapping('aml_crdr',a.crdr),
         --�ʽ������ʽ
         cstp = getTargetCodeByMapping('aml_cstp',a.cstp),
         --����
         crtp = getTargetCodeByMapping('aml_crtp',a.crtp)

         where a.databatchno=i_dataBatchNo;

  update lxihtrademain_temp a set
         -- �������
         a.ManageCom = getTargetCodeByMapping('aml_finc',a.managecom),

         a.idtype = getTargetCodeByMapping('aml_idtype',a.idtype)

         where a.databatchno=i_dataBatchNo;

  update lxihtradedetail_temp a set

         finc = getTargetCodeByMapping('aml_finc',a.finc),
				 -- �����ϸ���н��׷�ʽ����Ϊ�գ���Ĭ��ֵ   000051
				 tstp = '000051',
         --����
         crtp = getTargetCodeByMapping('aml_crtp',a.crtp)

         where a.databatchno=i_dataBatchNo;


  update lxaddress_temp a set
         --����
         nationality = getTargetCodeByMapping('aml_country',a.nationality) where a.databatchno=i_dataBatchNo;

end proc_aml_mappingcode;
/

prompt
prompt Creating procedure GROUP_PROC_AML_MAIN
prompt ======================================
prompt
create or replace procedure Group_proc_aml_main(i_startDate in varchar, i_endDate in varchar,i_oprater in varchar) is
  v_dataBatchNo varchar2(28);
  v_startDate date := to_date(i_startDate, 'YYYY-MM-DD');
  v_endDate date := to_date(i_endDate, 'YYYY-MM-DD');
  v_baseLine date := v_startDate;

  v_errormsg ldbatchlog.errormsg%type;
  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ

begin
  -- =============================================
  -- Description: ɸѡ����ץȡ���������Ľ��׼�¼
  --              ����ץȡ�Ľ��׼�¼���������/����ҵ�����
  --              ���������
  -- parameter in: i_startDate ���׿�ʼ����
  --               i_endDate ���׽�������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/12/25
  -- Changes log:
  --     Author      Date     Description
  --     zhouqk   2019/12/25     ����
  -- ============================================
  
  -- ��������Ǩ�ƣ��������κŽ����ݴ�mid����Ǩ�Ƶ�gr����
  
  -- ��մ��/����ҵ����ʱ��
  delete from Lxihtrademain_Temp;   -- ��������-��ʱ��
  delete from Lxihtradedetail_Temp; -- ������ϸ��-��ʱ��
  delete from Lxistrademain_Temp;   -- ���ɽ�����Ϣ����-��ʱ��
  delete from Lxistradedetail_Temp; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  delete from Lxistradecont_Temp;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  delete from Lxistradeinsured_Temp;-- ���ɽ��ױ�������Ϣ-��ʱ��
  delete from Lxistradebnf_Temp;    -- ���ɽ�����������Ϣ-��ʱ��
  delete from Lxaddress_Temp;       -- ����������ϵ��ʽ-��ʱ��

  -- ʹ��sequences��ȡ���µ�dataBatchNo
  select CONCAT(to_char(sysdate,'yyyymmdd'),LPAD(SEQ_dataBatchNo.nextval,20,'0')) into v_dataBatchNo from dual;

  loop
    begin
      Group_insurance_proc_aml_rule(v_baseLine,i_oprater);
      v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;


  -- ���´��/����ҵ����ʱ���е����κ�
  update Lxihtrademain_Temp set Databatchno = v_dataBatchNo;   -- ��������-��ʱ��
  update Lxihtradedetail_Temp set Databatchno = v_dataBatchNo; -- ������ϸ��-��ʱ��
  update Lxistrademain_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ�����Ϣ����-��ʱ��
  update Lxistradedetail_Temp set Databatchno = v_dataBatchNo; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  update Lxistradecont_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  update Lxistradeinsured_Temp set Databatchno = v_dataBatchNo;-- ���ɽ��ױ�������Ϣ-��ʱ��
  update Lxistradebnf_Temp set Databatchno = v_dataBatchNo;    -- ���ɽ�����������Ϣ-��ʱ��
  update Lxaddress_Temp set Databatchno = v_dataBatchNo;       -- ����������ϵ��ʽ-��ʱ��

  --����ʱ��ת��(���չ�������֮ǰldcodemappingת�뷽ʽ)
  proc_aml_mappingcode(v_dataBatchNo);

  --�������治��Ҫת�룬��������
  -- ����v_baseLine
  /*
  v_baseLine := v_startDate;
  loop
    begin
      proc_aml_D0100(v_baseLine,i_oprater);
      v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;*/

  -- ���¿���ҵ����ʱ���е����κ�
  update Lxistrademain_Temp set Databatchno = v_dataBatchNo where Databatchno is null;   -- ���ɽ�����Ϣ����-��ʱ��
  update Lxistradedetail_Temp set Databatchno = v_dataBatchNo where Databatchno is null; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  update Lxistradecont_Temp set Databatchno = v_dataBatchNo where Databatchno is null;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  update Lxistradeinsured_Temp set Databatchno = v_dataBatchNo where Databatchno is null;-- ���ɽ��ױ�������Ϣ-��ʱ��
  update Lxistradebnf_Temp set Databatchno = v_dataBatchNo where Databatchno is null;    -- ���ɽ�����������Ϣ-��ʱ��
  update Lxaddress_Temp set Databatchno = v_dataBatchNo where Databatchno is null;       -- ����������ϵ��ʽ-��ʱ��

  -- ʵ�����Ṧ�ܣ��ж�ҵ������Ƿ�洢�Ѿ���ȡ�����ݣ����ҵ��������ɾ����ʱ����������ݣ�����ҵ������������
  -- ����v_baseLine
  --  PS:׫д���յ�ʱ��ʵ�����Ṧ���Ƿ�͸���һ��(��Ҫ������)
  v_baseLine := v_startDate;
  loop
    begin
      PROC_AML_DELETE_LXIHTRADE(v_baseLine);                       --ɾ�����ҵ������������
      PROC_AML_DELETE_LXISTRADE(v_baseLine);                       --ɾ������ҵ������������
      v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;

  -- ����켣��(���м��ͳ�����ݲ��뵽�켣���У���ʱ�м������û��ȥ�أ������������������ȥ��)
  proc_aml_dealoperatordata(v_dataBatchNo);

  -- �����/����ҵ����ʱ��������Ǩ�Ƶ�ҵ���ȥ�أ�
  -- PS:�����ȥ�ط�ʽ�Ƿ�Ҫ���е���
  proc_aml_data_migration(v_dataBatchNo);

  -- ����ҵ������Ѿ���������ݼ�¼����ȡ��־����
  PROC_AML_INS_LX_LXCALLOG(i_oprater,v_dataBatchNo);

  -- ���ɹ���ȡ�����ݼ�¼����ȡ�������
  PROC_AML_INS_LDBATCHLOG(v_dataBatchNo,'IS','01',trunc(sysdate),to_char(v_baseLine-1,'yyyy-mm-dd')||'���չ�����ȡ�ɹ���');

  commit;

--�쳣����
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;

  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=to_char((v_baseLine),'yyyy-mm-dd')||errorCode||errorMsg;

  -- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
  PROC_AML_INS_LX_LDBATCHLOG(v_dataBatchNo,'00',trunc(sysdate),v_errormsg);
  commit;


end Group_proc_aml_main;
/

prompt
prompt Creating procedure PRC_INHERENCE
prompt ================================
prompt
CREATE OR REPLACE PROCEDURE PRC_INHERENCE (p_item in varchar2,p_reportid in varchar2,p_managecom in varchar2)
AS 
p_date date:=to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd');
p_time varchar2(10):=to_char(sysdate,'hh24:mi:ss');
p_reportno reportmain.reportno%type;
BEGIN

p_reportno:=NEXTVAL2('AML_REPORTNO', 'SN');

insert into reportmain(reportno,reportType,statPara,managecom,reportName,operator,makedate,maketime)
	values(p_reportno,p_reportid,p_item,p_managecom,(select r.reportname from reportinfo r where r.reportid=p_reportid),'aml',p_date,p_time);

insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,1 ,'��������λ' ,p_date ,p_time );  
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,2 ,'����ʵʩ��λ' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,3 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,4 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,5 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,6 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,7 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,8 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,9 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,10 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,11 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,12 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,13 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,14 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,15 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,16 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,17 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,18 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,19 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,20 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,21 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,22 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,23 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,24 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,25 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,26 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,27 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,28 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,29 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,30 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,31 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,32 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,33 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,34 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,35 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,36 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,37 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,38 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,39 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,40 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,41 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,42 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,43 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,44 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,45 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,46 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,47 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,48 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,49 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,50 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,51 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,52 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,53 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,54 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,55 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,56 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,57 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,58 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,59 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,60 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,61 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,62 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,63 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,64 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,65 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,66 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,67 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,68 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,69 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,70 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,71 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,72 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,73 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,74 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,75 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,76 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,77 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,78 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,79 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,80 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,81 ,'0' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,82 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,83 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,84 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,85 ,'' ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,86 ,to_char(sysdate,'yyyy-mm-dd') ,p_date ,p_time );
insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno ,87 ,'' ,p_date ,p_time );
commit;
END PRC_INHERENCE;
/

prompt
prompt Creating procedure PRC_REPORT
prompt =============================
prompt
CREATE OR REPLACE PROCEDURE prc_report(p_item in varchar2,p_reportid in varchar2,p_managecom in varchar2)
AS
p_date date:=to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd');
p_time varchar2(10):=to_char(sysdate,'hh24:mi:ss');
p_startDate date:=to_date(substr(p_item,0,4)||'01'||'01','yyyymmdd');
p_endDate date:=to_date(substr(p_item,0,4)||'04'||'01','yyyymmdd');
p_reportno reportmain.reportno%type;

BEGIN

  -- ============================================
  -- �������
  -- parameter in: p_date       ���ڵ�����
  --               p_time       ���ڵ�ʱ��
  --               p_startDate  ͳ�ƵĿ�ʼʱ��
  --               p_endDate    ͳ�ƵĽ���ʱ��
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/04/26
  -- Changes log:
  --     Author     Date        Description
  --     ������   2019/04/26     ����
  --	 ������   2019/09/12	 �޸�
	-- ============================================

  select case substr(p_item,5)
      when '01' then p_startDate
      when '02' then add_months(p_startDate,3)
      when '03' then add_months(p_startDate,6)
			when '04' then add_months(p_startDate,9)
	   end,
	   case substr(p_item,5)
			when '01' then p_endDate
			when '02' then add_months(p_endDate,3)
			when '03' then add_months(p_endDate,6)
			when '04' then add_months(p_endDate,9)
	   end
	   into p_startDate,p_endDate
	from dual; --ͨ��ͳ�Ƽ����ж�ʱ��
	
	p_reportno:=NEXTVAL2('AML_REPORTNO', 'SN');
	
	insert into reportmain(reportno,reportType,statPara,managecom,reportName,operator,makedate,maketime)
	values(p_reportno,p_reportid,p_item,p_managecom,(select r.reportname from reportinfo r where r.reportid=p_reportid),'aml',p_date,p_time);

	--�����д�����֧
	insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'1','���λ',p_date,p_time);



  -- �����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'2',p_item,p_date,p_time);

  --һ���ͻ����ʶ�𣨼���
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'3','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) 
  values(p_reportno,'4',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '3'),p_date,p_time);


  --��һ���б�ʱ
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'5','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) 
  values(p_reportno,'6',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '5'),p_date,p_time);

  --���У��ﵽʶ�������ϣ�����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'7','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'8',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '7'),p_date,p_time);

  --ͨ��������ʶ�𣨼���
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'9','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'10',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '9'),p_date,p_time);


  --�������⣨����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'11','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'12',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '11'),p_date,p_time);

  --�������˱�ʱ
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'13','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'14',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '13'),p_date,p_time);

  --���У��ﵽʶ�������ϣ�����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'15','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'16',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '15'),p_date,p_time);

  --�������⣨����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'17','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'18',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '17'),p_date,p_time);

  --��������������ʱ
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'19','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'20',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '19'),p_date,p_time);

  --���У��ﵽʶ�������ϣ�����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'21','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'22',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '21'),p_date,p_time);

  --�������⣨����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'23','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'24',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '23'),p_date,p_time);

  --�����ͻ��������ʶ�𣨼���
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'25','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'26',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '25'),p_date,p_time);

  --���У������Ҫ��Ϣ������
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'27','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'28',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '27'),p_date,p_time);

  --��Ϊ�쳣������
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'29','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'30',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '29'),p_date,p_time);

  --�����Ϣ�쳣������
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'31','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'32',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '31'),p_date,p_time);

  --������Ѻ�������
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'33','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'34',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '33'),p_date,p_time);

  --�������⣨����
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'35','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'36',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '35'),p_date,p_time);

  --�����ͻ�������ϱ��棨�ף�
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'37','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'38',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '37'),p_date,p_time);

  --�ġ����׼�¼���棨�ף�
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'39','0',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'40',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '39'),p_date,p_time);

  --�塢���ױ��棨�ݣ�
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'41',(select count(1) from lxihtrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and managecom=p_managecom),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'42',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '41'),p_date,p_time);

  --�漰����Ԫ��
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'43',(select nvl(sum(CRAT),0) from lxihtradedetail where dealno in (select dealno from lxihtrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and managecom=p_managecom)),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'44',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '43'),p_date,p_time);

  --�������ɽ��ױ��棨�ݣ�
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'45',(select count(1) from lxistrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and managecom=p_managecom),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'46',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '45'),p_date,p_time);

  --�漰����Ԫ��
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'47',(select nvl(sum(CRAT),0) from lxistradedetail where dealno in (select dealno from lxistrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and ManageCom=p_managecom)),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'48',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '47'),p_date,p_time);

  --���У��ش���ɽ��ױ��棨�ݣ�
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'49',(select count(1) from lxistrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and DETR='02' and ManageCom=p_managecom),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'50',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '49'),p_date,p_time);

  --�漰����Ԫ��
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'51',(select nvl(sum(CRAT),0) from lxistradedetail where dealno in (select dealno from lxistrademain where ReportSuccessDate>=p_startDate and ReportSuccessDate<p_endDate and DETR='02' and ManageCom=p_managecom)),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'52',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '51'),p_date,p_time);

  --�����ۼ���
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'54',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '53'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'56',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '55'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'58',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '57'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'60',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '59'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'62',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '61'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'64',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '63'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'66',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '65'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'68',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '67'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'70',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '69'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'72',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '71'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'74',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '73'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'76',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '75'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'78',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '77'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'80',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '79'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'82',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '81'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'84',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '83'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'86',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '85'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'88',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '87'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'90',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '89'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'92',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '91'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'94',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '93'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'96',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '95'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'98',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '97'),p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,statevalue,makedate,maketime) values(p_reportno,'100',(select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01')    and r.ITEMID = '99'),p_date,p_time);

  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'53',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'55',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'57',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'59',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'61',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'63',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'65',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'67',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'69',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'71',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'73',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'75',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'77',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'79',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'81',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'83',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'85',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'87',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'89',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'91',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'93',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'95',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'97',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'99',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'101',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'102',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'103',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'104',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'105',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'106',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'107',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'108',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'109',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'110',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'111',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'112',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'113',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'114',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'115',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'116',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'117',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'118',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'119',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'120',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'121',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'122',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'123',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'124',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'125',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'126',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'127',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'128',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'129',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'130',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'131',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'132',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'133',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'134',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'135',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'136',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'137',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'138',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'139',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'140',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'141',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'142',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'143',p_date,p_time);
  insert into REPORTCOLLDETAIL(reportid,itemid,makedate,maketime) values(p_reportno,'144',p_date,p_time);
  commit;
END;
/

prompt
prompt Creating procedure PRC_UPDATETOTAL
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE prc_updateTotal(p_reportid in varchar2)
AS
p_item reportmain.statpara%type;
p_managecom reportmain.managecom%type;
BEGIN

  -- ============================================
  -- �������
  -- parameter in: p_item       ͳ��ά��
  --               p_item       ����id
  --               p_managecom  �������
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/04/26
  -- Changes log:
  --     Author     Date        Description
  --     ������   2019/04/26     ����
  --	 ������   2019/09/12	 �޸�
	-- ============================================
  select statpara,managecom into p_item,p_managecom from reportmain where reportno=p_reportid;
  
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '3') where  reportid = p_reportid  and itemid = '4';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '5') where  reportid = p_reportid  and itemid = '6';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '7') where  reportid = p_reportid  and itemid = '8';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '9') where  reportid = p_reportid  and itemid = '10';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '11') where  reportid = p_reportid  and itemid = '12';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '13') where  reportid = p_reportid  and itemid = '14';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '15') where  reportid = p_reportid  and itemid = '16';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '17') where  reportid = p_reportid  and itemid = '18';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '19') where  reportid = p_reportid  and itemid = '20';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '21') where  reportid = p_reportid  and itemid = '22';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '23') where  reportid = p_reportid  and itemid = '24';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '25') where  reportid = p_reportid  and itemid = '26';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '27') where  reportid = p_reportid  and itemid = '28';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '29') where  reportid = p_reportid  and itemid = '30';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '31') where  reportid = p_reportid  and itemid = '32';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '33') where  reportid = p_reportid  and itemid = '34';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '35') where  reportid = p_reportid  and itemid = '36';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '37') where  reportid = p_reportid  and itemid = '38';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '39') where  reportid = p_reportid  and itemid = '40';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '41') where  reportid = p_reportid  and itemid = '42';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '43') where  reportid = p_reportid  and itemid = '44';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '45') where  reportid = p_reportid  and itemid = '46';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '47') where  reportid = p_reportid  and itemid = '48';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '49') where  reportid = p_reportid  and itemid = '50';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '51') where  reportid = p_reportid  and itemid = '52';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '53') where  reportid = p_reportid  and itemid = '54';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '55') where  reportid = p_reportid  and itemid = '56';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '57') where  reportid = p_reportid  and itemid = '58';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '59') where  reportid = p_reportid  and itemid = '60';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '61') where  reportid = p_reportid  and itemid = '62';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '63') where  reportid = p_reportid  and itemid = '64';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '65') where  reportid = p_reportid  and itemid = '66';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '67') where  reportid = p_reportid  and itemid = '68';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '69') where  reportid = p_reportid  and itemid = '70';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '71') where  reportid = p_reportid  and itemid = '72';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '73') where  reportid = p_reportid  and itemid = '74';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '75') where  reportid = p_reportid  and itemid = '76';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '77') where  reportid = p_reportid  and itemid = '78';
  --TODO �������ɿͻ����ϵͳ����
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '79') where  reportid = p_reportid  and itemid = '80';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '81') where  reportid = p_reportid  and itemid = '82';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '83') where  reportid = p_reportid  and itemid = '84';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '85') where  reportid = p_reportid  and itemid = '86';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '87') where  reportid = p_reportid  and itemid = '88';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '89') where  reportid = p_reportid  and itemid = '90';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '91') where  reportid = p_reportid  and itemid = '92';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '93') where  reportid = p_reportid  and itemid = '94';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '95') where  reportid = p_reportid  and itemid = '96';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '97') where  reportid = p_reportid  and itemid = '98';
  update REPORTCOLLDETAIL set statevalue = (select (case when SUM(r.statevalue) is null then 0 else SUM(r.statevalue) end) from REPORTCOLLDETAIL r where r.reportid in (select m.reportno from reportmain m where m.managecom=p_managecom and m.STATPARA <= p_item and m.STATPARA>=substr(p_item, 0, 4)||'01') and ITEMID = '99') where  reportid = p_reportid  and itemid = '100';
  commit;
END;
/

prompt
prompt Creating procedure PROC_AML_0000
prompt ================================
prompt
create or replace procedure proc_aml_0000(i_Customno in varchar, i_BGDT in varchar,i_EDDT in varchar,i_informFileName in varchar) is
  v_dataBatchNo varchar2(28);
  v_Customno lxistrademain.csnm%type := i_Customno;
  v_startDate date := to_date(i_BGDT, 'YYYY-MM-DD');
  v_endDate date := to_date(i_EDDT, 'YYYY-MM-DD');
  v_baseLine date := v_startDate;
  v_dealNo lxistrademain.dealno%type;
  v_informFileName lxistrademain.strs%type := i_informFileName;

  v_errormsg ldbatchlog.errormsg%type;
  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ

begin
  -- =============================================
  -- Description:  �˹�������Ϣ����
  -- parameter in: i_startDate ���俪ʼ����
  --               i_endDate �����������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/06/06
  -- Changes log:
  --     Author     Date     Description
  --     yangjp   2019/06/06  ����
  -- ============================================

  -- ʹ��sequences��ȡ���µ�dataBatchNo
	select CONCAT(to_char(sysdate,'yyyymmdd'),LPAD(SEQ_dataBatchNo.nextval,20,'0')) into v_dataBatchNo from dual;
  v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

    begin
      --�˹�������Ϣ����lxistrademain_temp��
        insert into lxistrademain_temp(
            serialno,
            dealno, -- ���ױ��
            rpnc,   -- �ϱ��������
            detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
            torp,   -- ���ʹ�����־
            dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
            odrp,   -- �������ͷ���
            tptr,   -- ���ɽ��ױ��津����
            otpr,   -- �������ɽ��ױ��津����
            stcb,   -- �ʽ��׼��ͻ���Ϊ���
            aosp,   -- �ɵ����
            stcr,   -- ���ɽ�������
            csnm,   -- �ͻ���
            senm,   -- ������������/����
            setp,   -- �����������֤��/֤���ļ�����
            oitp,   -- �������֤��/֤���ļ�����
            seid,   -- �����������֤��/֤���ļ�����
            sevc,   -- �ͻ�ְҵ����ҵ
            srnm,   -- �������巨������������
            srit,   -- �������巨�����������֤������
            orit,   -- �������巨���������������֤��/֤���ļ�����
            srid,   -- �������巨�����������֤������
            scnm,   -- ��������عɹɶ���ʵ�ʿ���������
            scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
            ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
            scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
            strs,   -- ���佻�ױ�ʶ
            datastate, -- ����״̬
            filename,  -- ��������
            filepath,  -- ����·��
            rpnm,      -- ���
            operator,  -- ����Ա
            managecom, -- �������
            conttype,  -- �������ͣ�01-����, 02-�ŵ���
            notes,     -- ��ע
            baseline,       -- ���ڻ�׼
            getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩
            nextfiletype,   -- �´��ϱ���������
            nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
            nextpackagetype,-- �´��ϱ����İ�����
            databatchno,    -- �������κ�
            makedate,       -- ���ʱ��
            maketime,       -- �������
            modifydate,     -- ����������
            modifytime,			-- ������ʱ��
            judgmentdate,   -- ��������
            ORXN,           -- ���������״��ϱ��ɹ��ı�������
            ReportSuccessDate)-- �ϱ��ɹ�����
        (
            select
               getSerialno(sysdate) as serialno,
               LPAD(v_dealNo,20,'0') AS DealNo,
               '@N' as RPNC,
               '02' as DETR,
               '1' as TORP,
               '01' as DORP,
               '@N' as ODRP,
               '99' as TPTR,
               '��Ϣ����֪ͨӦ��' as OTPR,
               '��Ϣ����֪ͨӦ��' as STCB,
               '��Ϣ����֪ͨӦ��' as AOSP,
               '@N' as STCR,
               a.clientno as CSNM,
               a.name as SENM,
               a.cardtype as SETP,
               nvl(OtherCardType, '@N') as OITP,
               a.cardid as SEID,
               a.occupation as SEVC,
               nvl(a.legalperson, '@N') as SRNM,
               a.legalpersoncardtype as SRIT,
               nvl(OtherLPCardType, '@N') as ORIT,
               nvl(a.legalpersoncardid, '@N') as SRID,
               nvl(a.holdername, '@N') as SCNM,
               a.holdercardtype as SCIT,
               nvl(OtherHolderCardType, '@N') as OCIT,
               nvl(a.holdercardid, '@N') as SCID,
               v_informFileName as STRS,
               'A00' as DataState,
               '' as FileName,
               '' as FilePath,
               '@N' as RPNM,
               'system' as Operator,
               a.comcode as ManageCom,
               '1' as ContType,
               '' as Notes,
               v_endDate as BaseLine,
               '01' as GetDataMethod,
               '' as NextFileType,
               '' as NextReferFileNo,
               '' as NextPackageType,
               v_dataBatchNo as DataBatchNo,
               sysdate as MakeDate,
               to_char(sysdate, 'hh24:mi:ss') as MakeTime,
               '' as ModifyDate,
               '' as ModifyTime,
               '' as JUDGMENTDATE,
               '' as ORXN,
               '' as REPORTSUCCESSDATE
          from cr_client a
         where a.clientno = v_Customno );

     --�˹�������Ϣ����LXADDRESS_TEMP��
     INSERT INTO LXADDRESS_TEMP (
        serialno,
        DealNo,
        ListNo,
        CSNM,
        Nationality,
        LinkNumber,
        Adress,
        CusOthContact,
        DataBatchNo,
        MakeDate,
        MakeTime,
        ModifyDate,
        ModifyTime)
      (
        select
           getSerialno(sysdate) as serialno,
           LPAD(v_dealNo,20,'0') AS DealNo,
           rownum as ListNo,
           a.clientno as CSNM,
           a.nationality as Nationality,
           a.linknumber as LinkNumber,
           a.adress as Adress,
           a.cusothcontact as CusOthContact,
           v_dataBatchNo as DataBatchNo,
           sysdate as MakeDate,
           to_char(sysdate, 'hh24:mi:ss') as MakeTime,
           '' as ModifyDate,
           '' as ModifyTime
      from cr_address a
     where clientno = v_Customno);

     --�˹�������Ϣ����LXISTRADEDETAIL_TEMP��
      insert into LXISTRADEDETAIL_TEMP(
        serialno,
        DealNo,
        TICD,
        ICNM,
        TSTM,
        TRCD,
        ITTP,
        CRTP,
        CRAT,
        CRDR,
        CSTP,
        CAOI,
        TCAN,
        ROTF,
        DataState,
        DataBatchNo,
        MakeDate,
        MakeTime,
        ModifyDate,
        ModifyTime,
        TRIGGERFLAG)
      (
         select
               getSerialno(sysdate) as serialno,
               LPAD(v_dealNo,20,'0') AS DealNo,
               b.TRANSNO || b.CONTNO as TICD,
               b.contno as ICNM,
               to_char(b.transdate, 'YYYY-MM-DD') as TSTM,
               nvl(b.transfromregion, '@N') as TRCD,
               b.transtype as ITTP,
               b.curetype as CRTP,
               b.payamt as CRAT,
               b.payway as CRDR,
               b.paymode as CSTP,
               nvl(b.accbank, '@N') as CAOI,
               nvl(b.accno, '@N') as TCAN,
               nvl(b.remark, '@N') as ROTF,
               'A00' as DataState,
               v_dataBatchNo as DataBatchNo,
               sysdate as MakeDate,
               to_char(sysdate, 'hh24:mi:ss') as MakeTime,
               '' as ModifyDate,
               '' as ModifyTime,
               '' as TRIGGERFLAG
          from cr_rel a, cr_trans b
         where a.contno = b.contno
           and b.transdate between v_startDate and v_endDate
           and a.custype = 'O'
           and a.clientno = v_Customno);


        --�˹�������Ϣ����LXISTRADECONT_TEMP��
           insert into LXISTRADECONT_TEMP(
            serialno,
            DealNo,
            CSNM,
            ALNM,
            AppNo,
            ContType,
            AITP,
            OITP,
            ALID,
            ALTP,
            ISTP,
            ISNM,
            RiskCode,
            Effectivedate,
            Expiredate,
            ITNM,
            ISOG,
            ISAT,
            ISFE,
            ISPT,
            CTES,
            FINC,
            DataBatchNo,
            MakeDate,
            MakeTime,
            ModifyDate,
            ModifyTime)
          (
              select
               getSerialno(sysdate) as serialno,
               LPAD(v_dealNo,20,'0') AS DealNo,
               a.contno as CSNM,
               c.name as ALNM,
               c.clientno as APPNO,
               a.conttype as ContType,
               c.cardtype as AITP,
               nvl(c.OtherCardType, '@N') as OITP,
               c.cardid as ALID,
               c.clienttype as ALTP,
               (select d.risktype
                 from cr_risk d
                where d.contno = a.contno
                  and rownum = 1) as ISTP,
               (select d.riskname
                  from cr_risk d
                 where d.contno = a.contno
                   and rownum = 1) as ISNM,
               (select d.riskcode
                  from cr_risk d
                 where d.contno = a.contno
                   and rownum = 1) as RiskCode,
               a.effectivedate as Effectivedate,
               a.expiredate as Expiredate,
               a.insuredpeoples as ITNM,
               a.inssubject as ISOG,
               a.amnt as ISAT,
               a.prem as ISFE,
               a.paymethod as ISPT,
               nvl(a.othercontinfo, '@N') as CTES,
               a.locid as FINC,
               v_dataBatchNo as DataBatchNo,
               sysdate as MakeDate,
               to_char(sysdate, 'hh24:mi:ss') as MakeTime,
               '' as ModifyDate,
               '' as ModifyTime
          from cr_policy a, cr_rel b, cr_client c
         where a.contno = b.contno
           and b.clientno = c.clientno
           and b.custype = 'O'
           and b.clientno = v_Customno);


           --�˹�������Ϣ����LXISTRADEINSURED_TEMP��
             insert into LXISTRADEINSURED_TEMP(
                serialno,
                DEALNO,
                CSNM,
                INSUREDNO,
                ISTN,
                IITP,
                OITP,
                ISID,
                RLTP,
                DataBatchNo,
                MakeDate,
                MakeTime,
                ModifyDate,
                ModifyTime)
            (
                select getSerialno(sysdate) as serialno,
               LPAD(v_dealNo,20,'0') AS DealNo,
           b.contno as CSNM,
           a.clientno as INSUREDNO,
           a.name as ISTN,
           a.cardtype as IITP,
           nvl(a.OtherCardType, '@N') as OITP,
           a.cardid as ISID,
           b.relaappnt as RLTP,
           v_dataBatchNo as DataBatchNo,
           sysdate as MakeDate,
           to_char(sysdate, 'hh24:mi:ss') as MakeTime,
           '' as ModifyDate,
           '' as ModifyTime
      from cr_client a, cr_rel b, cr_risk c
     where a.clientno = b.clientno
       and b.contno = c.contno
       and b.custype = 'I'
       and b.contno in
           (select d.contno from cr_rel d where d.clientno = v_Customno));

           --�˹�������Ϣ����LXISTRADEINSURED_TEMP��
           insert into LXISTRADEBNF_TEMP(
              serialno,
              DealNo,
              CSNM,
              InsuredNo,
              BnfNo,
              BNNM,
              BITP,
              OITP,
              BNID,
              DataBatchNo,
              MakeDate,
              MakeTime,
              ModifyDate,
              ModifyTime)
          (
             select getSerialno(sysdate) as serialno,
               LPAD(v_dealNo,20,'0') AS DealNo,
         b.contno as CSNM,
         (select t. clientno
            from cr_rel t
           where t.custype = 'I'
             and t.contno = b.contno) as InsuredNo,
         a.clientno as BnfNo,
         a.name as BNNM,
         a.cardtype as BITP,
         nvl(a.OtherCardType, '@N') as OITP,
         a.cardid as BNID,
         v_dataBatchNo as DataBatchNo,
         sysdate as MakeDate,
         to_char(sysdate, 'hh24:mi:ss') as MakeTime,
         '' as ModifyDate,
         '' as ModifyTime
    from cr_client a, cr_rel b, cr_risk c
   where a.clientno = b.contno
     and b.contno = c.contno
     and b.custype = 'B'
     and b.contno in
         (select d.contno from cr_rel d where d.clientno = v_Customno));
    end;

 -- ���´��/����ҵ����ʱ���е����κ�
  update Lxihtrademain_Temp set Databatchno = v_dataBatchNo;   -- ��������-��ʱ��
  update Lxihtradedetail_Temp set Databatchno = v_dataBatchNo; -- ������ϸ��-��ʱ��
  update Lxistrademain_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ�����Ϣ����-��ʱ��
  update Lxistradedetail_Temp set Databatchno = v_dataBatchNo; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  update Lxistradecont_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  update Lxistradeinsured_Temp set Databatchno = v_dataBatchNo;-- ���ɽ��ױ�������Ϣ-��ʱ��
  update Lxistradebnf_Temp set Databatchno = v_dataBatchNo;    -- ���ɽ�����������Ϣ-��ʱ��
  update Lxaddress_Temp set Databatchno = v_dataBatchNo;       -- ����������ϵ��ʽ-��ʱ��

	--����ʱ��ת��
	proc_aml_mappingcode(v_dataBatchNo);

  -- �����/����ҵ����ʱ��������Ǩ�Ƶ�ҵ���ȥ�أ�
  proc_aml_data_migration(v_dataBatchNo);

  	-- ����ҵ������Ѿ���������ݼ�¼����ȡ��־����
  PROC_AML_INS_LX_LXCALLOG('system',v_dataBatchNo);

	-- ���ɹ���ȡ�����ݼ�¼����ȡ�������
	PROC_AML_INS_LX_LDBATCHLOG(v_dataBatchNo,'01',trunc(sysdate),'��ȡ�ɹ���');

  commit;

  --�쳣����
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;

  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=to_char((v_baseLine-2),'yyyy-mm-dd')||errorCode||errorMsg;

	-- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
	PROC_AML_INS_LX_LDBATCHLOG(v_dataBatchNo,'00',trunc(sysdate),v_errormsg);
  commit;

end proc_aml_0000;
/

prompt
prompt Creating procedure PROC_AML_026
prompt ===============================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_026 (p_item in varchar2,p_reportid in varchar2,p_managecom in varchar2,p_date in date ,p_time in varchar2)
iS 
    p_startDate date:=to_date(p_item||'01'||'01','yyyymmdd');
    p_endDate date:=to_date(p_item||'12'||'31','yyyymmdd');
    
BEGIN
  NULL;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
END PROC_AML_026;
/

prompt
prompt Creating procedure PROC_AML_INS_LXADDRESS
prompt =========================================
prompt
create or replace procedure proc_aml_ins_lxaddress(
	i_dealno in lxaddress_temp.dealno%type,
	i_clientno in cr_address.clientno%type
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXADDRESS_TEMP��
  -- parameter in: i_dealno    ���ױ��(ҵ���)
  --               i_clientno  �ͻ���
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/18
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/03/18  ����
  -- =============================================

  INSERT INTO LXADDRESS_TEMP (
    serialno,
		DealNo,
		ListNo,
		CSNM,
		Nationality,
		LinkNumber,
		Adress,
		CusOthContact,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
  (
		select
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			ROW_NUMBER () OVER (ORDER BY clientno) AS ListNo,
			A.clientno AS CSNM,
			A.nationality AS Nationality,
			A.linknumber AS LinkNumber,
			A.adress AS Adress,
			A.cusothcontact AS CusOthContact,
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'hh24:mi:ss') AS MakeTime,
			'' AS ModifyDate,
			'' AS ModifyTime
		from
			CR_ADDRESS A
		where
			A.clientno = i_clientno
  );

end proc_aml_ins_lxaddress;
/

prompt
prompt Creating procedure PROC_AML_INS_LXIHTRADEDETAIL
prompt ===============================================
prompt
create or replace procedure proc_aml_ins_lxihtradedetail(

	i_dealno in varchar2,
  i_contno in varchar2,
	i_transno in VARCHAR2,
	i_baseLine in DATE,
	i_triggerflag in VARCHAR2

)is
begin
  -- ============================================
  -- Description: ���ݹ���ɸѡ�������LXIHTradeMain_Temp��
  -- parameter in: i_clientno �ͻ���
  --               i_dealno   ���ױ��
	--               i_operator ������
  --               i_stcr     ������������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/04/08
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/01  ����
  -- =============================================

  insert into LXIHTRADEDETAIL_TEMP(
    serialno,
		DealNo,			--���ױ��
		PolicyNo,		--������
		TICD,				--ҵ���ʾ��
		ContType,		--��������
		FINC,				--���ڻ����������
		RLFC,				--���ڻ�����ͻ��Ĺ�ϵ
		CATP,				--�˻�����
		CTAC,				--�˺�
		OATM,				--�ͻ��˻�����ʱ��
		CBCT, 			--�ͻ����п�����
		OCBT,				--�ͻ����п���������
		CBCN,				--�ͻ����п�����
		TBNM,				--���״���������
		TBIT,				--���״��������֤��/֤���ļ�����
		OITP,				--�������֤��/֤���ļ�����
		TBID,				--���״��������֤��/֤���ļ�����
		TBNT,				--���״����˹���
		TSTM,				--����ʱ��
		RPMT,				--�ո��ƥ�������
		RPMN,				--�ո��ƥ���
		TSTP,				--���׷�ʽ
		OCTT,				--�ǹ�̨���׷�ʽ
		OOCT,				--�����ǹ�̨���׷�ʽ
		OCEC,				--�ǹ�̨���׷�ʽ���豸����
		BPTC,				--������֧������֮���ҵ���ױ���
		TSCT,				--������֧���׷��������
		TSDR,				--�ʽ��ո���ʶ
		TRCD,				--���׷�����
		CRPP,				--�ʽ���;
		CRTP,				--����
		CRAT,				--���׽��
		CFIN,				--�Է����ڻ�����������
		CFCT,				--�Է����ڻ�����������
		CFIC,				--�Է����ڽ����������
		CFRC,				--�Է����ڻ�������������������
		TCNM,				--���׶�������
		TCIT,				--���׶���֤������
		OTTP,				--�������֤��/֤���ļ�����
		TCID,				--���׶���֤������
		TCAT,				--���׶����˺�����
		TCAC,				--���׶����˺�
		CRMB,				--���׽�������ң�
		CUSD,				--���׽�����Ԫ��
		ROTF,				--������Ϣ��ע
		DataState,	--����״̬
		DataBatchNo,--�������κ�
		MakeDate,		--�������
		MakeTime,		--���ʱ��
		ModifyDate,	--����������
		ModifyTime,	--������ʱ��
		triggerflag)--ָ��ͳ�Ʊ�ʶ
(
    select
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') as dealno,
			t.CONTNO AS PolicyNo,
			t.transno AS TICD,
			t.conttype AS ContType,
			nvl(p.locid, '@N') AS FINC,
			nvl(t.RelationWithRegion, '@N') AS RLFC,
			nvl(t.AccType, '@N') AS CATP,
			nvl(t.accno, '@N') AS CTAC,
			nvl(to_char(t.AccOpenTime,'yyyymmddHH24mmss'),'@N') AS OATM,
			nvl(t.bankcardtype,'@N') AS CBCT,
			nvl(t.BankCardOtherType,'@N') AS OCBT,
			nvl(t.bankcardnumber,'@N')AS CBCN,
			nvl(t.AgentName, '@N') AS TBNM,
			nvl(t.AgentCardType, '@N') AS TBIT,
			nvl(t.agentothercardtype, '@N') AS OITP,
			nvl(t.agentcardid, '@N') AS TBID,
			nvl(t.agentnationality, '@N') AS TBNT,
			to_char(i_baseLine,'YYYYMMDDHH24MISS') AS TSTM,
			nvl(t.RPMatchNoType, '@N')AS RPMT,
			nvl(t.RPMatchNumber, '@N')AS RPMN,
			'000051' AS TSTP,
			nvl(t.NonCounterTranType, '@N') AS OCTT,
			nvl(t.NonCounterOthTranType,'@N')AS OOCT,
			nvl(t.NonCounterTranDevice,'@N')AS OCEC,
			nvl(t.BankPaymentTranCode, '@N') AS BPTC,
			nvl(t.ForeignTransCode,'000000') AS TSCT,
			nvl(t.PayWay, '@N') AS TSDR,
			t.TransFromRegion AS TRCD,
			'@N' AS CRPP,
			nvl(t.CureType, 'CNY') AS CRTP,
			t.payamt AS CRAT,
			nvl(t.OpposideFinaName, '@N') AS CFIN,
			'@N' AS CFCT,
			nvl(t.OpposideFinaCode, '@N') AS CFIC,
			nvl(t.OpposideZipCode, '@N') AS CFRC,
			nvl(t.TradeCusName, '@N') AS TCNM,
			nvl(t.TradeCusCardType, '@N') AS TCIT,
			nvl(t.tradecusothercardtype,'@N') AS OTTP,
			nvl(t.TradeCusCardID, '@N') AS TCID,
			nvl(t.TradeCusAccType, '@N') AS TCAT,
			nvl(t.TradeCusAccNo, '@N') AS TCAC,
			nvl(t.CRMB, '@N') AS CRMB,
			nvl(t.CUSD, '@N') AS CUSD,
			t.remark AS ROTF,
			'' AS DataState,
			'' AS DataBatchNo,
			to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
      to_char(sysdate,'hh24:mi:ss') as maketime,
			'' AS ModifyDate,
			'' AS ModifyTime,
			i_triggerflag AS triggerflag
		FROM
			cr_rel r,
			cr_trans t,
			cr_policy p
		WHERE
				r.contno = t.contno
		and t.contno = p.contno
		and t.transno = i_transno
    and t.contno=i_contno
  );

end proc_aml_ins_lxihtradedetail;
/

prompt
prompt Creating procedure PROC_AML_INS_LXIHTRADEMAIN
prompt =============================================
prompt
create or replace procedure proc_aml_ins_lxihtrademain(

	i_dealno in number,
	i_transno in varchar2,
  i_contno in varchar2,
	i_operator in varchar2,
	i_crcd in varchar2,
	i_baseLine in DATE

) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXIHTradeMain_Temp��
  -- parameter in: i_dealno   ���ױ��
	--							 i_clientno �ͻ���
	--               i_operator ������
  --               i_crcd     ������������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/04/08
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/01  ����
  -- =============================================

  insert into LXIHTRADEMAIN_TEMP(
      serialno,
			DealNo,
			CSNM,
			CRCD,
			CTVC,
			CustomerName,
			IDType,
			OITP,
			IDNo,
			HTDT,
			DataState,
			Operator,
			ManageCom,
			Typeflag,
			Notes,
			CustomerType,
			BaseLine,
			GetDataMethod,
			NextFileType,
			NextReferFileNo,
			NextPackageType,
			DataBatchNo,
			MakeDate,
			MakeTime,
			ModifyDate,
			ModifyTime,
			JudgmentDate		)
(
			select
        getSerialno(sysdate) as serialno,
				LPAD(i_dealno,20,'0') AS DealNo,
				c.clientno AS CSNM,
				i_crcd AS CRCD,
				nvl(c.businesstype, '@N') AS CTVC,
				c.NAME AS CustomerName,
				nvl(c.CardType, '@N') AS IDType,
				nvl(c.OtherCardType, '@N') AS OITP,
				c.CardID AS IDNo,
				t.transdate AS HTDT,
				'A01' AS DataState,
				i_operator AS OPERATOR,
				(select LocId from cr_policy where contno=i_contno) AS ManageCom,
				t.conttype AS Typeflag,
				'' AS Notes,
				c.ClientType AS CustomerType,
				i_baseLine AS BaseLine,
				'01' AS GetDataMethod,
				'' AS NextFileType,
				'' AS NextReferFileNo,
				'' AS NextPackageType,
				'' AS DataBatchNo,
				to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
				to_char(sysdate,'hh24:mi:ss') as maketime,
				'' AS ModifyDate,
				'' AS ModifyTime,
				'' AS JudgmentDate
			FROM
				cr_client c,
				cr_rel r,
				cr_trans t
			WHERE
         	c.clientno = r.clientno
			AND r.contno = t.contno
      and r.custype='O'
      and t.transno = i_transno
      and r.contno=i_contno
  );

end proc_aml_ins_lxihtrademain;
/

prompt
prompt Creating procedure PROC_AML_0501
prompt ================================
prompt
create or replace procedure proc_aml_0501(i_baseLine in date,i_oprater in VARCHAR2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('0501', 'M1'); -- ��ֵ

begin
  -- ============================================
  -- Rule:
  -- ���յ��ʽ��������5��Ԫ���ϣ���5��Ԫ�����ֽ�ɴ桢�ֽ�֧ȡ��������ʽ���ֽ���֧��
  -- �ֽ�ɴ棺ָ����PMCL�����н��׼�¼����'6'����)
  -- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 1)��������������н��׼�¼����'6'����)����ƥ����Ϊ��׼�ջ��ܡ�
  --       ע�������У���׼������ͬ�����������ͬ�����뽻���ܶ�Ϊһ�ʽ���
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/04/09
  -- Changes log:
  --     Author     Date        Description
  --     ������   2019/05/14    �޸�Ϊͨ�������Ž��з�����㷧ֵ
  -- ============================================

  declare
    cursor baseInfo_sor is
      select
          r.clientno,
          t.transno,
          t.contno
      from
          cr_trans t, cr_rel r
      where
          t.contno = r.contno
      and exists (
          select 1
          from
              cr_trans tmp_t
          where
              r.contno = tmp_t.contno
          and tmp_t.transtype not in (select code from ldcode where codetype = 'transtype_thirdparty')
          and tmp_t.paymode = '01'
          and tmp_t.payway in ('01','02')
          and tmp_t.conttype = '1'
          and trunc(tmp_t.transdate) = trunc(i_baseLine)
          group by
              tmp_t.contno
          having
              sum(abs(tmp_t.payamt))>=v_threshold_money
          )
      and t.paymode='01'          -- �ʽ������ʽΪ�ֽ�
      and t.payway in ('01','02') -- �����ո���
      and r.custype = 'O'         -- �ͻ����ͣ�O-Ͷ����
      and t.conttype = '1'        -- �������ͣ�1-����
      and trunc(t.transdate) = trunc(i_baseLine)
      order by
          r.clientno ,t.transdate desc;

    -- �������
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���ױ��
    c_contno cr_trans.contno%type;      -- ������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;--������з��Ϲ������ݽ���ѭ��
      exit when baseInfo_sor%notfound;                      --�α�ѭ������(û�з�����������Ľ���)

        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo :=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��
            v_clientno := c_clientno; -- ���¿ͻ���

            -- ���������Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXIHTRADEMAIN(v_dealNo, c_transno, c_contno, i_oprater, '0501', i_baseLine);
            -- ���������ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXIHTRADEDETAIL(v_dealNo, c_contno,c_transno,i_baseLine, '1');
        else
            -- ���������ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXIHTRADEDETAIL(v_dealNo, c_contno,c_transno,i_baseLine, '');
      end if;

      -- ����ͻ���ϵ��ʽ��_��ʱ�� LXADDRESS_TEMP
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_0501;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADEBNF
prompt ============================================
prompt
create or replace procedure proc_aml_ins_lxistradebnf(

  i_dealno in NUMBER,
  i_contno in VARCHAR2
  
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lLXISTRADEBNF_TEMP��
  -- parameter in: i_dealno ���ױ��(ҵ���)
  --               i_contno ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/15
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/03/15  ����
  -- =============================================

  insert into LXISTRADEBNF_TEMP(
    serialno,
    DealNo,
    CSNM,
    InsuredNo,
    BnfNo,
    BNNM,
    BITP,
    OITP,
    BNID,
    DataBatchNo,
    MakeDate,
    MakeTime,
    ModifyDate,
    ModifyTime)
(
      SELECT
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') AS DealNo,
      i_contno AS CSNM,
      i.InsuredNo AS InsuredNo,
      c.clientno AS BnfNo,
      c.NAME AS BNNM,
      nvl(c.cardtype,'@N') AS BITP,
      nvl((select ld.basicremark from ldcodemapping ld where ld.basiccode=c.cardtype and ld.targetcode='119999' and ld.codetype='aml_idtype'),'@N') AS OITP,
      c.cardid AS BNID,
      NULL AS DataBatchNo,
      sysdate AS MakeDate,
      to_char(sysdate,'HH:mm:ss') AS MakeTime,
      NULL AS ModifyDate,
      NULL AS ModifyTime
      FROM
          lxistradeinsured_temp i,
          cr_client c,
          cr_rel r
      WHERE
          c.clientno = r.clientno
      AND r.custype = 'B' 
      and i.csnm=i_contno
      and i.dealno=LPAD(i_dealno,20,'0') 
      and r.contno=i_contno     
  );
end proc_aml_ins_lxistradebnf;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADECONT
prompt =============================================
prompt
create or replace procedure proc_aml_ins_lxistradecont(
	i_dealno in varchar2,
	i_clientno in varchar2,
	i_contno in varchar2
) is
begin
  -- ============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADECONT_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_clientno �ͻ���
  --               i_contno   ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/15
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/03/15  ����
  -- ============================================

  insert into LXISTRADECONT_TEMP(
    serialno,
    DealNo,
		CSNM,
		ALNM,
		AppNo,
		ContType,
		AITP,
		OITP,
		ALID,
		ALTP,
		ISTP,
		ISNM,
		RiskCode,
		Effectivedate,
		Expiredate,
		ITNM,
		ISOG,
		ISAT,
		ISFE,
		ISPT,
		CTES,
		FINC,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
  (
    SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_contno AS CSNM,
			(select c.name from cr_client ct,cr_rel rl where rl.clientno=ct.clientno and rl.custype='O' and rl.contno=r.contno) AS ALNM,
			(select c.clientno from cr_client ct,cr_rel rl where rl.clientno=ct.clientno and rl.custype='O' and rl.contno=r.contno) AS APPNO,
			p.conttype AS ContType,
			c.cardtype AS AITP,
			nvl(c.OtherCardType,'@N') AS OITP,
			nvl(c.cardid,'@N') AS ALID,
			c.clienttype AS ALTP,
			(select risktype from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from cr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS ISTP,
			(select riskname from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from cr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS ISNM,
			(select riskcode from (select rk.RISKTYPE,rk.RISKNAME,rk.RISKCODE,row_number() over(partition by rk.RISKTYPE order by rk.RISKCODE asc) rn from cr_risk rk where rk.contno=i_contno and rk.mainflag='00')  where rn = 1) AS RiskCode,
			p.effectivedate AS Effectivedate,
			p.expiredate AS Expiredate,
			p.insuredpeoples AS ITNM,
			p.inssubject AS ISOG,
			p.amnt AS ISAT,
			p.prem AS ISFE,
			p.paymethod AS ISPT,
			nvl(p.othercontinfo, '@N') AS CTES,
			p.locid AS FINC,
			NULL AS DataBatchNo,
			to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') AS MakeDate,
			to_char(sysdate,'HH:mm:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime
			from
				CR_POLICY p,
				CR_CLIENT c,
				CR_REL r
			where
					p.contno=r.contno
      and c.clientno=r.clientno
			and r.custype='O'
			and r.contno=i_contno
  );

end proc_aml_ins_lxistradecont;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADEDETAIL
prompt ===============================================
prompt
create or replace procedure proc_aml_ins_lxistradedetail(
	i_dealno in NUMBER,
	i_contno in VARCHAR2,
	i_transno in VARCHAR2,
	i_triggerflag in VARCHAR2
	) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADEDETAIL_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_ocontno  ������
  --               i_transno  ���ױ��(ƽ̨��)
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/15
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/03/15  ����
  -- =============================================


  insert into LXISTRADEDETAIL_TEMP(
    serialno,
    DealNo,
		TICD,
		ICNM,
		TSTM,
		TRCD,
		ITTP,
		CRTP,
		CRAT,
		CRDR,
		CSTP,
		CAOI,
		TCAN,
		ROTF,
		DataState,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime,
		TRIGGERFLAG)
  (
    SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_transno AS TICD,
			i_contno AS ICNM,
			to_char(t.transdate,'yyyymmddHHmmss') AS TSTM,
			t.transfromregion AS TRCD,
			t.transtype AS ITTP,
			t.curetype AS CRTP,
			t.payamt AS CRAT,
			T.PAYWAY AS CRDR,
			T.PAYMODE AS CSTP,
			nvl(t.accbank,'@N') AS CAOI,
			nvl(t.accno,'@N') AS TCAN,
			nvl(t.remark, '@N') AS ROTF,
      'A01' as DataState,
			NULL  AS DataBatchNo,
		  to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') AS MakeDate,
			to_char(sysdate,'HH24:mi:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime,
			i_triggerflag AS TRIGGERFLAG
		from
			cr_trans t
		where
				t.contno = i_contno
		and t.transno = i_transno
  );

end proc_aml_ins_lxistradedetail;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADEINSURED
prompt ================================================
prompt
create or replace procedure proc_aml_ins_lxistradeinsured(
	i_dealno in NUMBER,
	i_contno in VARCHAR2
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADEINSURED_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_contno   ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/15
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/03/15  ����
  -- =============================================

  insert into LXISTRADEINSURED_TEMP(
    serialno,
		DEALNO,
		CSNM,
		INSUREDNO,
		ISTN,
		IITP,
		OITP,
		ISID,
		RLTP,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
(
    SELECT
      getSerialno(sysdate) as serialno,
 			LPAD(i_dealno,20,'0') AS DealNo,
			i_contno AS CSNM,
			c.clientno AS INSUREDNO,
			c.NAME AS ISTN,
			nvl(c.cardtype, '@N') AS IITP,
			nvl(c.OtherCardType, '@N') AS OITP,
			c.cardid AS ISID,
			nvl(r.relaappnt, '@N') AS RLTP,
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'HH:mm:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime
			FROM
					cr_client c,
					cr_rel r
			WHERE
					c.clientno = r.clientno
			AND r.custype = 'I'
			AND r.contno = i_contno
  );

end proc_aml_ins_lxistradeinsured;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADEMAIN
prompt =============================================
prompt
create or replace procedure proc_aml_ins_lxistrademain(

	i_dealno in NUMBER,
  i_clientno in varchar2,
  i_contno in varchar2,
  i_operator in varchar2,
  i_stcr in varchar2 ,
  i_baseLine in DATE) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxistrademain_temp��
  -- parameter in: i_clientno �ͻ���
  --               i_dealno   ���ױ��
	--               i_operator ������
  --               i_stcr     ���ɽ�����������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/03/01
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/01  ����
  -- =============================================

  insert into lxistrademain_temp(
    serialno,
    dealno, -- ���ױ��
    rpnc,   -- �ϱ��������
    detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
    torp,   -- ���ʹ�����־
    dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
    odrp,   -- �������ͷ���
    tptr,   -- ���ɽ��ױ��津����
    otpr,   -- �������ɽ��ױ��津����
    stcb,   -- �ʽ��׼��ͻ���Ϊ���
    aosp,   -- �ɵ����
    stcr,   -- ���ɽ�������
    csnm,   -- �ͻ���
    senm,   -- ������������/����
    setp,   -- �����������֤��/֤���ļ�����
    oitp,   -- �������֤��/֤���ļ�����
    seid,   -- �����������֤��/֤���ļ�����
    sevc,   -- �ͻ�ְҵ����ҵ
    srnm,   -- �������巨������������
    srit,   -- �������巨�����������֤������
    orit,   -- �������巨���������������֤��/֤���ļ�����
    srid,   -- �������巨�����������֤������
    scnm,   -- ��������عɹɶ���ʵ�ʿ���������
    scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
    scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    strs,   -- ���佻�ױ�ʶ
    datastate, -- ����״̬
    filename,  -- ��������
    filepath,  -- ����·��
    rpnm,      -- ���
    operator,  -- ����Ա
    managecom, -- �������
    conttype,  -- �������ͣ�01-����, 02-�ŵ���
    notes,     -- ��ע
		baseline,       -- ���ڻ�׼
    getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩
    nextfiletype,   -- �´��ϱ���������
    nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
    nextpackagetype,-- �´��ϱ����İ�����
    databatchno,    -- �������κ�
    makedate,       -- ���ʱ��
    maketime,       -- �������
    modifydate,     -- ����������
    modifytime,			-- ������ʱ��
		judgmentdate,   -- ��������
    ORXN,           -- ���������״��ϱ��ɹ��ı�������
		ReportSuccessDate)-- �ϱ��ɹ�����
(
    select
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') as dealno,
      '@N' as rpnc,
      '01' as detr,  -- ��������̶ȣ�01-���ر������
      '1' as torp,
      '01' as dorp,  -- ���ͷ���01-�����й���ϴǮ���������ģ�
      '@N' as odrp,
      '01' as tptr,  -- ���ɽ��ױ��津���㣨01-ģ��ɸѡ��
      '@N' as otpr,
      '' as stcb,
      '' as aosp,
      i_stcr as stcr,
      c.clientno as csnm,
      c.name as senm,
      nvl(c.cardtype,'@N') as setp,
      nvl(c.othercardtype,'@N') as oitp,
      nvl(c.cardid,'@N') as seid,
      nvl(c.occupation,'@N') as sevc,
      nvl(c.legalperson,'@N') as srnm,
      nvl(c.legalpersoncardtype,'@N') as srit,
      nvl(c.otherlpcardtype,'@N') as orit,
      nvl(c.legalpersoncardid,'@N') as srid,
      nvl(c.holdername,'@N') as scnm,
      nvl(c.holdercardtype,'@N') as scit,
      nvl(c.otherholdercardtype,'@N') as ocit,
      nvl(c.holdercardid,'@N') as scid,
      '@N' as strs,
      'A01' as datastate,
      '' as filename,
      '' as filepath,
      (select username from lduser where usercode = i_operator) as rpnm,
      i_operator as operator,
      (select locid from cr_policy where contno=i_contno) as managecom,
      c.conttype as conttype,
      '' as notes,
      i_baseLine as baseline,
      '01' as getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ��
      '' as nextfiletype,
      '' as nextreferfileno,
      '' as nextpackagetype,
      null as databatchno,
      to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
      to_char(sysdate,'hh24:mi:ss') as maketime,
      null as modifydate,  -- ������ʱ��
      null as modifytime,
			null as judgmentdate,--��������
      null as ORXN,        -- ���������״��ϱ��ɹ��ı�������
			null as ReportSuccessDate--�ϱ��ɹ�����
    from
      cr_client c
    where
     c.clientno = i_clientno
  );

end proc_aml_ins_lxistrademain;
/

prompt
prompt Creating procedure PROC_AML_A0101
prompt =================================
prompt
create or replace procedure proc_aml_A0101(i_baseLine in date,
                                           i_oprater  in varchar2) is
  v_dealNo   lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --      Ͷ���ˡ������˻������������Ʋ������ڣ��㼶ƥ�䣩,����ϵͳץȡ���ɿ��ɽ���
  --      ��ȡ������
  --        1) ��ȡ����ά��
  --          ����������OLAS��IGM��
  --          ��ȡǰһ������/���ѽ��׵ı�����
  --        2) ����ȡ������Ͷ���ˡ������ˡ������˵����Ʋ������д��ڣ�����ץȡ��
  --      ��ȡ�����
  --        1����ȡ�����Ʋ������ĸñ����ͻ���ΪͶ���˻򱻱��˻��������������б�������/���ѵĽ�����Ϊ��
  --        2���������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date        Description
  --     ������   2019/05/14    �޸�Ϊ�Կͻ�Ϊ���ĵ�չʾ��Ϣ���ı���뷽ʽ�����if������
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;

  -- ��ȡ���շ������׵Ŀͻ��嵥(Ͷ���ˡ������ˡ�������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0101_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and r.custype in ('O', 'I', 'B') -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
       and t.payway in ('01', '02')
       and t.transtype not in
           (select code from ldcode where codetype = 'transtype_thirdparty')
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);

  --ɸѡ֤���Ż��������Ʋ������ڵĿͻ���
  insert into LXAssistA
    (CustomerNo, policyno, args1, args5)
    select lx.CustomerNo, lx.policyno, lx.args1, 'A0101_2'
      from lxassista lx
     where (exists (select 1
                      from lxblacklist b
                     where lx.args1 = b.idnumber
                       and description2 = '1'
                       and description1 = '3'
                       and type = '1') or exists
            (select 1
               from lxblacklist b
              where (lx.args2 = b.name or lx.args2 = b.ename)
                and description2 = '1'
                and description1 = '3'
                and type = '1'))
       and lx.args5 = 'A0101_1';
       
    --ץȡ�Ʋ������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0101_3'
        from lxassista lx
       where isblacklist('1', lx.CustomerNo, lx.policyno, '') = 'yes'
         and lx.args5 = 'A0101_2';
  
  delete from lxassista where args5='A0101_1';

  -- �Ʋ������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
  insert into lxassista
    (customerno, args1, args5)
    select max(lx.customerno), lx.args1, 'A0101_4'
      from lxassista lx
     where lx.args5= 'A0101_3'
     group by lx.args1;

  --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
  insert into LXAssistA
    (PolicyNo, args1, args5)
    select distinct p.contno, lx.args1, 'A0101_5'
      from cr_policy p
      join cr_rel r
        on p.contno = r.contno
       and isvalidcont(p.contno) = 'yes' --��Ч����
      join lxassista lx
        on lx.args1 = r.usecardid
       and lx.args5 = 'A0101_4';

  --ƥ��ͻ��Ϳͻ���Ӧ�ı���
  insert into LXAssistA
    (customerno,PolicyNo,args5)
    select lx.customerno,la.PolicyNo,'A0101_6'
      from LXAssistA lx
      join LXAssistA la
        on lx.args1=la.args1
       and lx.args5= 'A0101_4'
       and la.args5= 'A0101_5';

  declare
    -- �����α꣺����Ͷ���ˡ������˻������������Ʋ���������Ϣ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate
        from cr_trans t
        join LXAssistA lx
          on t.contno=lx.policyno
         and lx.args5= 'A0101_6'
       where t.payway in ('01', '02')
         and t.transtype not in
             (select code
                from ldcode
               where codetype = 'transtype_thirdparty')
         and t.conttype = '1'
       order by lx.CustomerNo, t.transdate desc;

    -- �����α����
    c_clientno  lxassista.CustomerNo%type; -- �ͻ���
    c_transno   cr_trans.transno%type; -- ���׺�
    c_contno    cr_trans.contno%type; -- ������
    c_transdate cr_trans.transdate%type; -- ��������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor
        into c_clientno, c_transno, c_contno, c_transdate;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽����
      if v_clientno is null or c_clientno <> v_clientno then

        v_dealNo   := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SA0101',
                                   i_baseLine);

        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
  delete from LXAssistA;
end proc_aml_A0101;
/

prompt
prompt Creating procedure PROC_AML_INS_LXISTRADEMAIN2
prompt ==============================================
prompt
create or replace procedure proc_aml_ins_lxistrademain2(

	i_dealno in NUMBER,
  i_clientno in varchar2, 
  i_contno in varchar2,
  i_operator in varchar2,
  i_stcr in varchar2 ,
  i_baseLine in DATE,
  i_aosp in   varchar2) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxistrademain_temp��
  -- parameter in: i_clientno �ͻ���
  --               i_dealno   ���ױ��
	--               i_operator ������
  --               i_stcr     ���ɽ�����������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/03/01
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/01  ����
  -- =============================================

  insert into lxistrademain_temp(
    serialno,
    dealno, -- ���ױ��
    rpnc,   -- �ϱ��������
    detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
    torp,   -- ���ʹ�����־
    dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
    odrp,   -- �������ͷ���
    tptr,   -- ���ɽ��ױ��津����
    otpr,   -- �������ɽ��ױ��津����
    stcb,   -- �ʽ��׼��ͻ���Ϊ���
    aosp,   -- �ɵ����
    stcr,   -- ���ɽ�������
    csnm,   -- �ͻ���
    senm,   -- ������������/����
    setp,   -- �����������֤��/֤���ļ�����
    oitp,   -- �������֤��/֤���ļ�����
    seid,   -- �����������֤��/֤���ļ�����
    sevc,   -- �ͻ�ְҵ����ҵ
    srnm,   -- �������巨������������
    srit,   -- �������巨�����������֤������
    orit,   -- �������巨���������������֤��/֤���ļ�����
    srid,   -- �������巨�����������֤������
    scnm,   -- ��������عɹɶ���ʵ�ʿ���������
    scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
    scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    strs,   -- ���佻�ױ�ʶ
    datastate, -- ����״̬
    filename,  -- ��������
    filepath,  -- ����·��
    rpnm,      -- ���
    operator,  -- ����Ա
    managecom, -- �������
    conttype,  -- �������ͣ�01-����, 02-�ŵ��� 
    notes,     -- ��ע
		baseline,       -- ���ڻ�׼
    getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩 
    nextfiletype,   -- �´��ϱ���������
    nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
    nextpackagetype,-- �´��ϱ����İ�����
    databatchno,    -- �������κ�
    makedate,       -- ���ʱ��
    maketime,       -- �������
    modifydate,     -- ����������
    modifytime,			-- ������ʱ��
		judgmentdate,   -- ��������
    ORXN,           -- ���������״��ϱ��ɹ��ı�������
		ReportSuccessDate)-- �ϱ��ɹ�����
(
    select
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') as dealno,
      '@N' as rpnc,
      '01' as detr,  -- ��������̶ȣ�01-���ر������
      '1' as torp,
      '01' as dorp,  -- ���ͷ���01-�����й���ϴǮ���������ģ�
      '@N' as odrp,
      '01' as tptr,  -- ���ɽ��ױ��津���㣨01-ģ��ɸѡ��
      '@N' as otpr,
      '' as stcb,
      (select codename from ldcode where code=i_aosp and codetype='aml_rulereason' ) as aosp,
      i_stcr as stcr,
      c.clientno as csnm,
      c.name as senm,
      nvl(c.cardtype,'@N') as setp,
      nvl(c.othercardtype,'@N') as oitp,
      nvl(c.cardid,'@N') as seid,
      nvl(c.occupation,'@N') as sevc,
      nvl(c.legalperson,'@N') as srnm,
      nvl(c.legalpersoncardtype,'@N') as srit,
      nvl(c.otherlpcardtype,'@N') as orit,
      nvl(c.legalpersoncardid,'@N') as srid,
      nvl(c.holdername,'@N') as scnm,
      nvl(c.holdercardtype,'@N') as scit,
      nvl(c.otherholdercardtype,'@N') as ocit,
      nvl(c.holdercardid,'@N') as scid,
      '@N' as strs,
      'A01' as datastate,
      '' as filename,
      '' as filepath,
      (select username from lduser where usercode = i_operator) as rpnm,
      i_operator as operator,
      (select locid from cr_policy where contno=i_contno) as managecom,
      c.conttype as conttype,
      '' as notes,
      i_baseLine as baseline,
      '01' as getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ��
      '' as nextfiletype,
      '' as nextreferfileno,
      '' as nextpackagetype,
      null as databatchno,
      to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
      to_char(sysdate,'hh24:mi:ss') as maketime,
      null as modifydate,  -- ������ʱ��
      null as modifytime,
			null as judgmentdate,--��������
      null as ORXN,        -- ���������״��ϱ��ɹ��ı�������
			null as ReportSuccessDate--�ϱ��ɹ�����
    from
      cr_client c
    where
     c.clientno = i_clientno
  );

end proc_aml_ins_lxistrademain2;
/

prompt
prompt Creating procedure PROC_AML_A0101_TEST
prompt ======================================
prompt
create or replace procedure proc_aml_A0101_test(i_baseLine in date,
                                           i_oprater  in varchar2) is
  v_dealNo   lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --      Ͷ���ˡ������˻������������Ʋ������ڣ��㼶ƥ�䣩,����ϵͳץȡ���ɿ��ɽ���
  --      ��ȡ������
  --        1) ��ȡ����ά��
  --          ����������OLAS��IGM��
  --          ��ȡǰһ������/���ѽ��׵ı�����
  --        2) ����ȡ������Ͷ���ˡ������ˡ������˵����Ʋ������д��ڣ�����ץȡ��
  --      ��ȡ�����
  --        1����ȡ�����Ʋ������ĸñ����ͻ���ΪͶ���˻򱻱��˻��������������б�������/���ѵĽ�����Ϊ��
  --        2���������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date        Description
  --     ������   2019/05/14    �޸�Ϊ�Կͻ�Ϊ���ĵ�չʾ��Ϣ���ı���뷽ʽ�����if������
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;

  -- ��ȡ���շ������׵Ŀͻ��嵥(Ͷ���ˡ������ˡ�������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0101_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and r.custype in ('O', 'I', 'B') -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
       and t.payway in ('01', '02')
       and t.transtype not in
           (select code from ldcode where codetype = 'transtype_thirdparty')
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);

  --ɸѡ֤���Ż��������Ʋ������ڵĿͻ���
  insert into LXAssistA
    (CustomerNo, policyno, args1, args5)
    select lx.CustomerNo, lx.policyno, lx.args1, 'A0101_2'
      from lxassista lx
     where (exists (select 1
                      from lxblacklist b
                     where lx.args1 = b.idnumber
                       and description2 = '1'
                       and description1 = '3'
                       and type = '1') or exists
            (select 1
               from lxblacklist b
              where (lx.args2 = b.name or lx.args2 = b.ename)
                and description2 = '1'
                and description1 = '3'
                and type = '1'))
       and lx.args5 = 'A0101_1';

  --ץȡ�Ʋ������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1,args2, args5)
      select lx.CustomerNo, lx.policyno, lx.args1,
        isblacklist2('1', lx.CustomerNo, lx.policyno, '') as aosp,
       'A0101_3'
        from lxassista lx
       where lx.args5 = 'A0101_2';
               
  delete from lxassista where args5='A0101_1';

  -- �Ʋ������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
  insert into lxassista
    (customerno, args1,args2, args5)
    select max(lx.customerno), lx.args1,min(substr(lx.args2,4)),'A0101_4'
      from lxassista lx
     where substr(lx.args2,0,3)='yes'
     and lx.args5= 'A0101_3'
     group by lx.args1;

  --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
  insert into LXAssistA
    (PolicyNo, args1, args5)
    select distinct p.contno, lx.args1, 'A0101_5'
      from cr_policy p
      join cr_rel r
        on p.contno = r.contno
       and isvalidcont(p.contno) = 'yes' --��Ч����
      join lxassista lx
        on lx.args1 = r.usecardid
       and lx.args5 = 'A0101_4';
  
  --ƥ��ͻ��Ϳͻ���Ӧ�ı���     
  insert into LXAssistA
    (customerno,PolicyNo,args1,args5)
    select lx.customerno,la.PolicyNo,lx.args2,'A0101_6'
      from LXAssistA lx
      join LXAssistA la
        on lx.args1=la.args1
       and lx.args5= 'A0101_4'
       and la.args5= 'A0101_5';

  declare
    -- �����α꣺����Ͷ���ˡ������˻������������Ʋ���������Ϣ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate,lx.args1
        from cr_trans t
        join LXAssistA lx
          on t.contno=lx.policyno
         and lx.args5= 'A0101_6'
       where t.payway in ('01', '02')
         and t.transtype not in
             (select code
                from ldcode
               where codetype = 'transtype_thirdparty')
         and t.conttype = '1'
       order by lx.CustomerNo, t.transdate desc;
  
    -- �����α����
    c_clientno  lxassista.CustomerNo%type; -- �ͻ���
    c_transno   cr_trans.transno%type; -- ���׺�
    c_contno    cr_trans.contno%type; -- ������
    c_transdate cr_trans.transdate%type; -- ��������
    c_aosp lxassista.args1%type; --�ɵ��������
    
  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor
        into c_clientno, c_transno, c_contno, c_transdate, c_aosp;
      exit when baseInfo_sor%notfound;
    
      -- ���췢���Ĵ��������ף����뵽����
      if v_clientno is null or c_clientno <> v_clientno then
      
        v_dealNo   := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      
        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN2(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SA0101',
                                   i_baseLine,c_aosp);
      
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');
      end if;
    
      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);
    
      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);
    
      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);
    
      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    
    end loop;
    close baseInfo_sor;
  end;
  delete from LXAssistA;
end proc_aml_A0101_test;
/

prompt
prompt Creating procedure PROC_AML_A0102
prompt =================================
prompt
create or replace procedure proc_aml_A0102(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0102', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule:
  --   Ͷ���ˡ�����˹�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ��
  --   ����ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --   ?   ����������OLAS��IGM��
  --   ?   ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ������Ͷ�����ڡ�����˹�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱���
  --        ����������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --   ?  �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date        Description
  --     zhouqk   2019/05/11        ����
  --     zhouqk   2019/05/27     ��֤�����ڵ���˹�����и�Ϊ�㼶ƥ��
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;

  -- ��ȡ���շ������׵Ŀͻ��嵥(Ͷ����)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno,
                    r.contno,
                    r.USECARDID,
                    c.name,
                    'A0102_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);

    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0102_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0102_1';

    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0102_3'
        from lxassista lx
       where isblacklist('2', lx.CustomerNo, lx.policyno, '1') = 'yes'
         and lx.args5 = 'A0102_2';

    delete from lxassista where args5='A0102_1';

    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1, args5)
      select max(lx.customerno), lx.args1, 'A0102_4'
        from lxassista lx
       where lx.args5 = 'A0102_3'
       group by lx.args1;

    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0102_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0102_4';

    --ƥ��ͻ��Ϳͻ���Ӧ�ı���
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney, 'A0102_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0102_4'
         and la.args5 = 'A0102_5';


  declare
    -- �����α�,����Ͷ���˵�֤�����ڵ���˹�����ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ����Ϣ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0102_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0102_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc;

    -- �����α����
    c_clientno cr_rel.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type; -- ���ױ��
    c_contno cr_trans.contno%type;   -- ������
    c_transdate cr_trans.transdate%type;-- ��������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno, c_transno, c_contno,c_transdate;
      exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0102', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
end;
  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0102;
/

prompt
prompt Creating procedure PROC_AML_A0102_TEST
prompt ======================================
prompt
create or replace procedure proc_aml_A0102_test(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0102', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule: 
  --   Ͷ���ˡ�����˹�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ��
  --   ����ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --   ?   ����������OLAS��IGM��
  --   ?   ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ������Ͷ�����ڡ�����˹�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱���
  --        ����������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --   ?  �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date        Description
  --     zhouqk   2019/05/11        ����
  --     zhouqk   2019/05/27     ��֤�����ڵ���˹�����и�Ϊ�㼶ƥ��
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;
  
  -- ��ȡ���շ������׵Ŀͻ��嵥(Ͷ����)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno,
                    r.contno,
                    r.USECARDID,
                    c.name,
                    'A0102_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);
  
    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0102_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0102_1';
    
    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1, args2,args5)
      select lx.CustomerNo, lx.policyno, lx.args1,
       isblacklist2('2', lx.CustomerNo, lx.policyno, '1'),
       'A0102_3'
        from lxassista lx
       where lx.args5 = 'A0102_2';
         
    delete from lxassista where args5='A0102_1';
    
    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1,args2, args5)
      select max(lx.customerno), lx.args1,min(substr(lx.args2,4)), 'A0102_4'
        from lxassista lx
       where substr(lx.args2,0,3)='yes'
       and lx.args5 = 'A0102_3'
       group by lx.args1;
       
    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0102_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0102_4';
    
    --ƥ��ͻ��Ϳͻ���Ӧ�ı���     
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney,args1, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney,lx.args2, 'A0102_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0102_4'
         and la.args5 = 'A0102_5';
         

    

  declare
    -- �����α�,����Ͷ���˵�֤�����ڵ���˹�����ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ����Ϣ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate,lx.args1
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0102_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0102_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc; 
                     
    -- �����α����
    c_clientno cr_rel.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type; -- ���ױ��
    c_contno cr_trans.contno%type;   -- ������
    c_transdate cr_trans.transdate%type;-- ��������
    c_aosp lxassista.args1%type; --�ɵ��������
    
  begin
    open baseInfo_sor;                
    loop
      fetch baseInfo_sor into c_clientno, c_transno, c_contno,c_transdate,c_aosp;
      exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            
          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN2(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0102', i_baseLine,c_aosp);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else      
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
              
    end loop;
    close baseInfo_sor;
end;
  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0102_test;
/

prompt
prompt Creating procedure PROC_AML_A0103
prompt =================================
prompt
create or replace procedure proc_aml_A0103(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0103', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule:
  --   �������ڡ���Ҫ�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --   ?   ����������OLAS��IGM��
  --   ?   ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ�����ı������ڡ���Ҫ�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱��˻�
  --        ����������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --   ?   �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     2������µ��ı����˺�Ͷ������ͬһ�ˣ��򽫴��˹���Ͷ���ˣ�A0102���б���
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date     Description
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;

  -- ��ȡ���շ������׵Ŀͻ��嵥(������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0103_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and not exists
     (select 1
              from cr_rel tmp_r, cr_trans tmp_t
             where r.clientno = tmp_r.clientno
               and r.contno = tmp_r.contno
               and tmp_r.contno = tmp_t.contno
               and tmp_r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
               and tmp_t.transtype = 'AA001' --Ͷ��
               and tmp_t.conttype = '1' -- �������ͣ�1-����
               and trunc(tmp_t.transdate) = trunc(i_baseLine))
       and r.custype = 'I' -- �ͻ����ͣ�I-������
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);

    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0103_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0103_1';

    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0103_3'
        from lxassista lx
       where isblacklist('2', lx.CustomerNo, lx.policyno, '2') = 'yes'
         and lx.args5 = 'A0103_2';

    delete from lxassista where args5='A0103_1';

    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1, args5)
      select max(lx.customerno), lx.args1, 'A0103_4'
        from lxassista lx
       where lx.args5 = 'A0103_3'
       group by lx.args1;

    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0103_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0103_4';

    --ƥ��ͻ��Ϳͻ���Ӧ�ı���
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney, 'A0103_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0103_4'
         and la.args5 = 'A0103_5';


  declare
    -- �����α�,����֮ǰ���н���Ͷ���Ľ�����Ϣ�������ۼ��ѽ����ѽ����ڷ�ֵ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0103_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0103_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc;

    -- �����α����
    c_clientno cr_rel.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type; -- ���ױ��
    c_contno cr_trans.contno%type;   -- ������
    c_transdate cr_trans.transdate%type;-- ��������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno, c_transno, c_contno,c_transdate;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0103', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor ;
  end;
  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0103;
/

prompt
prompt Creating procedure PROC_AML_A0103_TEST
prompt ======================================
prompt
create or replace procedure proc_aml_A0103_test(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0103', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule: 
  --   �������ڡ���Ҫ�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --   ?   ����������OLAS��IGM��
  --   ?   ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ�����ı������ڡ���Ҫ�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱��˻�
  --        ����������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --   ?   �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     2������µ��ı����˺�Ͷ������ͬһ�ˣ��򽫴��˹���Ͷ���ˣ�A0102���б���
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date     Description
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;
  
  -- ��ȡ���շ������׵Ŀͻ��嵥(������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0103_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and not exists
     (select 1
              from cr_rel tmp_r, cr_trans tmp_t
             where r.clientno = tmp_r.clientno
               and r.contno = tmp_r.contno
               and tmp_r.contno = tmp_t.contno
               and tmp_r.custype = 'O' -- �ͻ����ͣ�O-Ͷ����
               and tmp_t.transtype = 'AA001' --Ͷ��
               and tmp_t.conttype = '1' -- �������ͣ�1-����
               and trunc(tmp_t.transdate) = trunc(i_baseLine))
       and r.custype = 'I' -- �ͻ����ͣ�I-������
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);
  
    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0103_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0103_1';
    
    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1,args2, args5)
      select lx.CustomerNo, lx.policyno, lx.args1,
        isblacklist2('2', lx.CustomerNo, lx.policyno, '2'),
       'A0103_3'
        from lxassista lx
       where lx.args5 = 'A0103_2';
         
    delete from lxassista where args5='A0103_1';
    
    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1,args2, args5)
      select max(lx.customerno), lx.args1,min(substr(lx.args2,4)),'A0103_4'
        from lxassista lx
       where substr(lx.args2,0,3)='yes'
       and lx.args5 = 'A0103_3'
       group by lx.args1;
       
    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0103_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0103_4';
    
    --ƥ��ͻ��Ϳͻ���Ӧ�ı���     
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney,args1, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney,lx.args2, 'A0103_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0103_4'
         and la.args5 = 'A0103_5'; 

  declare
    -- �����α�,����֮ǰ���н���Ͷ���Ľ�����Ϣ�������ۼ��ѽ����ѽ����ڷ�ֵ
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate,lx.args1
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0103_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0103_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc;
                     
    -- �����α����
    c_clientno cr_rel.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type; -- ���ױ��
    c_contno cr_trans.contno%type;   -- ������
    c_transdate cr_trans.transdate%type;-- ��������
    c_aosp lxassista.args1%type; --�ɵ��������
    
  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno, c_transno, c_contno,c_transdate,c_aosp;
      exit when baseInfo_sor%notfound;

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            
          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN2(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0103', i_baseLine,c_aosp);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
      else      
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno); 

    end loop;
    close baseInfo_sor ;
  end;
  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0103_test;
/

prompt
prompt Creating procedure PROC_AML_A0104
prompt =================================
prompt
create or replace procedure proc_aml_A0104(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0104', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule:
  --   �������ڡ���Ҫ�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --     ? ����������OLAS��IGM��
  --     ? ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ�����ı������ڡ���Ҫ�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱���
  --        ������������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --        �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     2������µ��������˺ͱ����˻�Ͷ������ͬһ�ˣ��򽫴��˹���Ͷ���ˣ�A0102���򱻱��ˣ�A0103)�б���
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date     Description
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;

  -- ��ȡ���շ������׵Ŀͻ��嵥(������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0104_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and not exists
     (select 1
              from cr_rel tmp_r, cr_trans tmp_t
             where r.clientno = tmp_r.clientno
               and r.contno = tmp_r.contno
               and tmp_r.contno = tmp_t.contno
               and tmp_r.custype in ('O','I') -- �ͻ����ͣ�O-Ͷ����/I-������
               and tmp_t.transtype = 'AA001' --Ͷ��
               and tmp_t.conttype = '1' -- �������ͣ�1-����
               and trunc(tmp_t.transdate) = trunc(i_baseLine))
       and r.custype = 'B' -- �ͻ����ͣ�B-������
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);

    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0104_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0104_1';

    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0104_3'
        from lxassista lx
       where isblacklist('2', lx.CustomerNo, lx.policyno, '3') = 'yes'
         and lx.args5 = 'A0104_2';

    delete from lxassista where args5='A0104_1';

    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1, args5)
      select max(lx.customerno), lx.args1, 'A0104_4'
        from lxassista lx
       where lx.args5 = 'A0104_3'
       group by lx.args1;

    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0104_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0104_4';

    --ƥ��ͻ��Ϳͻ���Ӧ�ı���
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney, 'A0104_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0104_4'
         and la.args5 = 'A0104_5';


  -- �����α�,����֮ǰ���н���Ͷ���Ľ�����Ϣ�������ۼ��ѽ����ѽ����ڷ�ֵ
  declare
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0104_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0104_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���ױ��
    c_contno cr_trans.contno%type;      -- ������
    c_transdate cr_trans.transdate%type;-- ��������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno,c_transno,c_contno,c_transdate;
      exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0104', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor ;
end;

  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0104;
/

prompt
prompt Creating procedure PROC_AML_A0104_TEST
prompt ======================================
prompt
create or replace procedure proc_aml_A0104_TEST(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0104', 'M1'); -- ��ֵ �ۼ��ѽ�����

begin
  -- =============================================
  -- Rule: 
  --   �������ڡ���Ҫ�������������������㼶ƥ�䣩�ڣ��ҵ�ǰ�ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --     ? ����������OLAS��IGM��
  --     ? ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ�����ı������ڡ���Ҫ�����������������д��ڣ��Ҵ�����ΪͶ���˻򱻱���
  --        ������������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --        �ۼ��ѽ�����ָ��AA001,AA003,AA004,AB001,AB002, FC***,WT001,WT005,NP370�е�
  --        �շѲ��֣�������HK001��������뽻�ף����ܽ����ﵽ��ֵ����ץȡ��
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --     1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     2������µ��������˺ͱ����˻�Ͷ������ͬһ�ˣ��򽫴��˹���Ͷ���ˣ�A0102���򱻱��ˣ�A0103)�б���
  --   ע���������˵�ʶ����Ϣ(ID/Sex/birth)��ȫ�������ȶ�
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/11
  -- Changes log:
  --     Author     Date     Description
  -- ============================================
  -- �������ʱ��
  delete from LXAssistA;
  
  -- ��ȡ���շ������׵Ŀͻ��嵥(������)
  insert into LXAssistA
    (CustomerNo, policyno, args1, args2, args5)
    select distinct r.clientno, r.contno, r.USECARDID, c.name, 'A0104_1'
      from cr_client c, cr_rel r, cr_trans t
     where c.clientno = r.clientno
       and r.contno = t.contno
       and not exists
     (select 1
              from cr_rel tmp_r, cr_trans tmp_t
             where r.clientno = tmp_r.clientno
               and r.contno = tmp_r.contno
               and tmp_r.contno = tmp_t.contno
               and tmp_r.custype in ('O','I') -- �ͻ����ͣ�O-Ͷ����/I-������
               and tmp_t.transtype = 'AA001' --Ͷ��
               and tmp_t.conttype = '1' -- �������ͣ�1-����
               and trunc(tmp_t.transdate) = trunc(i_baseLine))
       and r.custype = 'B' -- �ͻ����ͣ�B-������
       and t.transtype = 'AA001' --Ͷ��
       and t.conttype = '1' -- �������ͣ�1-����
       and trunc(t.transdate) = trunc(i_baseLine);
  
    --ɸѡ֤���Ż�������PEP���������������ڵĿͻ���
    insert into LXAssistA
      (CustomerNo, policyno, args1, args5)
      select lx.CustomerNo, lx.policyno, lx.args1, 'A0104_2'
        from lxassista lx
       where (exists (select 1
                        from lxblacklist b
                       where lx.args1 = b.idnumber
                         and ((description1 = '1' and type = '1') or
                             type = '2')) or exists
              (select 1
                 from lxblacklist b
                where (lx.args2 = b.name or lx.args2 = b.ename)
                  and ((description1 = '1' and type = '1') or type = '2')))
         and lx.args5 = 'A0104_1';
    
    --ץȡPEP���������������ͻ�
    insert into LXAssistA
      (CustomerNo, policyno, args1,args2 ,args5)
      select lx.CustomerNo, lx.policyno, lx.args1,
      isblacklist2('2', lx.CustomerNo, lx.policyno, '3'),
       'A0104_3'
        from lxassista lx
       where lx.args5 = 'A0104_2';
         
    delete from lxassista where args5='A0104_1';
    
    -- PEP���������������ͻ�ȥ�أ�һ��֤���Ŷ�Ӧ����ͻ��Ż���֤���š�������ƥ�䵽��������
    insert into lxassista
      (customerno, args1,args2, args5)
      select max(lx.customerno), lx.args1,min(substr(lx.args2,4)), 'A0104_4'
        from lxassista lx
       where substr(lx.args2,0,3)='yes'
       and lx.args5 = 'A0104_3'
       group by lx.args1;
       
    --ץȡ�ͻ�����������Ч����������֤����ƥ�䱣����
    insert into LXAssistA
      (PolicyNo, tranmoney, args1, args5)
      select distinct p.contno, p.sumprem, lx.args1, 'A0104_5'
        from cr_policy p
        join cr_rel r
          on p.contno = r.contno
         and isvalidcont(p.contno) = 'yes' --��Ч����
        join lxassista lx
          on lx.args1 = r.usecardid
         and lx.args5 = 'A0104_4';
    
    --ƥ��ͻ��Ϳͻ���Ӧ�ı���     
    insert into LXAssistA
      (customerno, PolicyNo, tranmoney,args1, args5)
      select lx.customerno, la.PolicyNo, la.tranmoney,lx.args2 ,'A0104_6'
        from LXAssistA lx
        join LXAssistA la
          on lx.args1 = la.args1
         and lx.args5 = 'A0104_4'
         and la.args5 = 'A0104_5';

  -- �����α�,����֮ǰ���н���Ͷ���Ľ�����Ϣ�������ۼ��ѽ����ѽ����ڷ�ֵ
  declare
    cursor baseInfo_sor is
      select lx.CustomerNo, t.transno, lx.policyno, t.transdate,lx.args1
        from cr_trans t
        join LXAssistA lx
          on t.contno = lx.policyno
         and lx.args5 = 'A0104_6'
         and exists (select 1
                from LXAssistA la
               where lx.customerno = la.customerno
                 and la.args5 = 'A0104_6'
               group by la.customerno
              having sum(la.tranmoney) >= v_threshold_money -- �ۼ��ѽ����Ѵ��ڵ��ڷ�ֵ
              )
       where t.transtype = 'AA001' -- ��������ΪͶ��
         and t.conttype = '1' -- �������ͣ�1-����
       order by lx.CustomerNo, t.transdate desc;                                

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���ױ��
    c_contno cr_trans.contno%type;      -- ������
    c_transdate cr_trans.transdate%type;-- ��������
    c_aosp lxassista.args1%type; --�ɵ��������
    
  begin
    open baseInfo_sor;              
    loop
      fetch baseInfo_sor into c_clientno,c_transno,c_contno,c_transdate,c_aosp;
      exit when baseInfo_sor%notfound;  
       
        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
                
          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN2(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0104', i_baseLine,c_aosp);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else      
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno); 
          
    end loop;
    close baseInfo_sor ;
end;

  -- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_A0104_TEST;
/

prompt
prompt Creating procedure PROC_AML_A0200
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_A0200(i_baseLine in date, i_oprater  in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0200', 'M1'); -- ��ֵ

BEGIN
  -- =============================================
  -- Rule:
  --   ��Ͷ���˵Ĺ������ڸ߷��չ��һ��������ֵ>=80)��
  --   ���ۼ��ѽ����ѽ����ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   ��ȡ������
  --     1) ��ȡ����ά��
  --     ? ����������OLAS��IGM��
  --     ? ��ȡǰһ����Ч�ı�����
  --     2) ����ȡ������Ͷ���˵Ĺ����ڸ߷��չ��������д��ڣ�
  --        �Ҵ�������(��ΪͶ���ˡ������ˡ�������)������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ��
  --     ? �߷��չ����嵥���¸���������ɲ��ո߷��չ���ӳ���ϵ����
  --     3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --         �ۼ��ѽ�����=��HK001��������뽻�׵��ܽ��
  --   ��ȡ�����
  --     1) ��ȡ�������и߷��չ��һ����������Ͷ������ΪͶ���˻򱻱��˻�����������������Ч������
  --     2���������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/19
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

  -- ��ȡ�������ڸ߷��չ��һ������Ͷ��������������Ч������Ϣ
  INSERT INTO LXAssistA(
    Customerno,
    Policyno,
    Numargs1,
    Args1)
      SELECT DISTINCT
          r.clientno,
          r.contno,
          (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
          'A0200'
      FROM
          cr_trans t,
          cr_rel r
      WHERE
          t.contno = r.contno
      AND EXISTS(
          SELECT 1
          FROM
              cr_client c,
              lxriskinfo rinfo
          WHERE
              c.clientno = r.clientno
          AND c.nationality = rinfo.code
          AND rinfo.recordtype = '02'-- �������ͣ�2-���һ����
          AND rinfo.risklevel = '3'  -- ���յȼ���3-�߷���
          )
      AND EXISTS(
          SELECT 1
          FROM
              cr_trans tmp_t,
              cr_rel tmp_r
          WHERE
              tmp_r.clientno = r.clientno
          AND tmp_r.contno = tmp_t.contno
          AND tmp_r.custype = 'O'       -- �ͻ����ͣ�O-Ͷ����
          AND tmp_t.transtype = 'AA001' -- ��������ΪͶ��
          AND tmp_t.conttype = '1'      -- �������ͣ�1-����
          AND TRUNC(tmp_t.transdate) = TRUNC(i_baseLine)
          )
      AND r.custype IN ('O', 'I', 'B')  -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      AND isValidCont(t.contno) = 'yes'-- ��Ч����
      AND t.conttype = '1'  ;            -- �������ͣ�1-����

  DECLARE
    CURSOR baseInfo_sor IS
      SELECT
          r.clientno,
          t.transno,
          t.contno
      FROM
          cr_trans t,
          cr_rel r
      WHERE
          t.contno  = r.contno
      AND r.clientno IN(
          SELECT
              a.customerno
          FROM
              LXAssistA a
          WHERE
              a.args1 = 'A0200'
          GROUP BY
              a.customerno
          HAVING
              SUM(a.numargs1) >= v_threshold_money
          )
      AND r.custype IN ('O','B','I')-- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      AND t.transtype = 'AA001'     -- �������ͣ�Ͷ��
      AND t.conttype= '1'           -- �������ͣ�1-����
      ORDER BY
          r.clientno  ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���ױ��
    c_contno cr_trans.contno%type;      -- ������

  BEGIN
    OPEN baseInfo_sor;
    LOOP
      FETCH baseInfo_sor INTO c_clientno,c_transno,c_contno;
      EXIT WHEN baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0200', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    END LOOP;
    CLOSE baseInfo_sor;
  END;
  -- ɾ��������ĸ�������
  DELETE FROM LXAssistA WHERE Args1 = 'A0200';
END proc_aml_A0200;
/

prompt
prompt Creating procedure PROC_AML_A0300
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE proc_aml_A0300 ( i_baseLine IN DATE, i_oprater IN VARCHAR2 )
IS
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money NUMBER := getparavalue ('SA0300', 'M1') ; -- ��ֵ �ۼ��ѽ�����

BEGIN
	-- =============================================
	-- Rule:
  --   ��Ͷ����ְҵ�����ڸ߷���ְҵ�������ֵ>=10)�У�
  --   �Ҵ�������������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --   1) ��ȡ����ά��
  --   ? ����������OLAS��IGM��
  --   ? ��ȡǰһ����Ч�ı�����
  --   2) ����ȡ������Ͷ���˵�ְҵ�����ڸ߷���ְҵ������У�
  --      �Ҵ�������������Ч�������ѽ������ۼƴﵽ��ֵ������ץȡ
  --   ? �߷���ְҵ����������б�Ʋ��֣�
  --   3) ��������ֵΪ10��ʵ��Ϊ��������ʽ
  --   ��ȡ�����
  --   1) ��ȡְҵ�������и߷���ְҵ������Ͷ������ΪͶ���˻򱻱��˻�����������������Ч������
  --   2���������ݸ�ʽͬ���п��ɽ��׸�ʽ
	--
	-- parameter in: i_baseLine ��������
	--         i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/19
	-- Changes log:
	--     Author     Date     Description
	-- =============================================

  -- ��ȡ�������ڸ߷��չ��һ������Ͷ��������������Ч������Ϣ
  delete from LXAssistA;
  
  INSERT INTO LXAssistA(
    Customerno,
    Policyno,
    Numargs1,
    Args1)
      SELECT DISTINCT
          r.clientno,
          r.contno,
          (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
          'A0300'
      FROM
          cr_trans t,
          cr_rel r
      WHERE
          t.contno = r.contno
      AND EXISTS(
          SELECT 1
          FROM
              cr_client c,
              lxriskinfo rinfo
          WHERE
              c.clientno = r.clientno
          AND c.occupation = rinfo.code
          AND rinfo.recordtype = '03'-- �������ͣ�3-ְҵ
          AND rinfo.risklevel = '3'  -- ���յȼ���3-�߷���
          )
      AND EXISTS(
          SELECT 1
          FROM
              cr_trans tmp_t,
              cr_rel tmp_r
          WHERE
              tmp_r.clientno = r.clientno
          AND tmp_r.contno = tmp_t.contno
          AND tmp_r.custype = 'O'       -- �ͻ����ͣ�O-Ͷ����
          AND tmp_t.transtype = 'AA001' -- ��������ΪͶ��
          AND tmp_t.conttype = '1'      -- �������ͣ�1-����
          AND TRUNC(tmp_t.transdate) = TRUNC(i_baseLine)
          )
      AND r.custype IN ('O', 'I', 'B')  -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      AND isValidCont(t.contno) = 'yes'-- ��Ч����
      AND t.conttype = '1';              -- �������ͣ�1-����

  DECLARE
    CURSOR baseInfo_sor IS
      SELECT
          r.clientno,
          t.transno,
          t.contno
      FROM
          cr_trans t,
          cr_rel r
      WHERE
          t.contno  = r.contno
      AND r.clientno IN(
          SELECT
              a.customerno
          FROM
              LXAssistA a
          WHERE
              a.args1 = 'A0300'
          GROUP BY
              a.customerno
          HAVING
              SUM(a.numargs1) >= v_threshold_money
          )
      AND r.custype IN ('O','B','I')-- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      AND t.transtype = 'AA001'     -- �������ͣ�Ͷ��
      AND t.conttype= '1'           -- �������ͣ�1-����
      ORDER BY
          r.clientno ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���ױ��
    c_contno cr_trans.contno%type;      -- ������

  BEGIN
    OPEN baseInfo_sor;
    LOOP
      FETCH baseInfo_sor INTO c_clientno,c_transno,c_contno;
      EXIT WHEN baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0300', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    END LOOP;
    CLOSE baseInfo_sor;
	END ;
  -- ɾ��������ĸ�������
	DELETE FROM LXAssistA WHERE Args1 = 'A0300' ;
END proc_aml_A0300 ;
/

prompt
prompt Creating procedure PROC_AML_A0400
prompt =================================
prompt
create or replace procedure proc_aml_A0400(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0400', 'M1'); -- ��ֵ ���ڱ���

begin
-- =============================================
  -- Rule:
  -- ����Լ�طò��ɹ������Ҳ��ɹ�ԭ��Ϊ��ϵ���Ͽͻ����ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��ȡǰһ��طò��ɹ����ط����ʱ��Ϊǰһ�죩���һط�ԭ��Ϊ��ϵ���Ͽͻ��ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/18
  -- Changes log:
  -- =============================================
  declare
    cursor baseInfo_sor is
      select
          r.clientno,
          t.transno,
          t.contno
      from
          cr_trans t,
          cr_rel r,
          cr_policy p
      where
          t.contno = r.contno
      and p.contno = r.contno
      and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
      and t.visitreason = '1'           -- �طò��ɹ�
      and p.sumprem >= v_threshold_money-- ���ڱ��Ѵ��ڷ�ֵ
      and t.transtype = 'AA002'         -- ��������ΪͶ��
      and t.conttype = '1'              -- �������ͣ�1-����
      and trunc(t.transdate) = trunc(i_baseLine)
      order by
          r.clientno ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���׺�
    c_contno cr_trans.contno%type;      -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0400', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0400;
/

prompt
prompt Creating procedure PROC_AML_A0500
prompt =================================
prompt
create or replace procedure proc_aml_A0500(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;     -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --      Ͷ���������������������ѵ�����֮һ���ڽ����ѵĶ���֮һ����ϵͳץȡ�����ɿ��ɽ��ף�
  --      ��ȡ������
  --        1) ��ȡ����ά��
  --           ����������OLAS��IGM��
  --          ��ȡǰһ����Ч�ı���
  --        2��Ͷ��������������µ��ı��ѽ��бȽϣ�������ڽɱ�������ת��ANP����бȽ�
  --           ���ڱ��ѣ���AA001,AA002,AA003)
  --           ������ȫ����������
  --           �ڽɣ�AA001ת����ANP��AA002��AA003����������
  --        4) ���������������÷�ֵ
  --      ��ȡ�����
  --        1) �������ݸ�ʽͬ���п��ɽ��׸�ʽͶ����������
  --      ע��Ͷ����������
  --        1���뵥���±����Ƚ�
  --        2�����ڽ�/�������У���ֱ���㣬��һ����������ץȡ
  --
  -- parameter in: i_baseLine ��������
  --                              i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/19
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

  declare
    cursor baseInfo_sor is
      select
          c.clientno,
          t.transno,
          t.contno
      from
          cr_trans t,
          cr_rel r,
          cr_client c
      where
          t.contno = r.contno
      and r.clientno = c.clientno
      and exists(
          select 1
          from
              cr_policy p
          where
              t.contno = p.contno
          and c.income <
              (case p.paymethod
               when '01' then 1/2 * (p.sumprem - p.prem + p.yearprem)--�ڽ����ѵĶ���֮һ
               when '02' then 1/3 * p.sumprem --�������ѵ�����֮һ
               end)
          )
      and c.income!=0                  --�����벻Ϊ0
      and r.custype = 'O'              -- �ͻ����ͣ�O-Ͷ����
      and t.transtype = 'AA001'        -- ��������Ͷ��
      and isValidCont(t.contno)='yes'  -- ��Ч����
      and t.conttype = '1'             -- �������ͣ�1-����
      and trunc(t.transdate) = trunc(i_baseLine)
      order by
          c.clientno ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type;   -- �ͻ���
    c_transno cr_trans.transno%type;      -- ���׺�
    c_contno cr_trans.contno%type;        -- ������

  begin
    open baseInfo_sor;
    loop
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0500', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0500;
/

prompt
prompt Creating procedure PROC_AML_A0601
prompt =================================
prompt
create or replace procedure proc_aml_A0601(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0601', 'M2'); -- ��ֵ ����
  v_income number := getparavalue('SA0601', 'M1');          -- ��ֵ ������

begin
  -- =============================================
  -- Rule: Ͷ����ְҵΪ����Ա�����ˡ�ѧ���������������30��
  --       �ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --       ��ȡ������
  --         1) ��ȡ����ά��
  --           ����������OLAS��IGM��
  --           ��ȡǰһ����Ч�ı���
  --         2) Ͷ����ְλΪ����Ա�����ˡ�ѧ���������������30���ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ
  --            ���ڱ��ѣ���AA001,AA002,AA003)
  --            ������ȫ����������
  --            �ڽɣ�AA001ת����ANP��AA002��AA003����������
  --         3) ��������ֵΪ30��ʵ��Ϊ��������ʽ
  --       ��ȡ�����
  --         1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --         2�����ڽ�/�������У���ֱ���㣬��һ����������ץȡ
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/19
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

  declare
    cursor baseInfo_sor is
      select
          c.clientno,
          t.transno,
          t.contno
      from
          cr_trans t,
          cr_rel r,
          cr_client c
      where
          t.contno = r.contno
      and r.clientno = c.clientno  -- Ͷ����������ڷ�ֵ
      and exists(
          select 1
          from
              cr_policy p
          where
              t.contno = p.contno
          and (case p.paymethod
               when '01' then p.sumprem - p.prem + p.yearprem   --�ڽ�
               when '02' then p.sumprem                         --����
               end
              ) >= v_threshold_money)
          and c.occupation in (select code from ldcode where codetype = 'occ_SA0601')
          and c.income > to_number(v_income)
      and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
      and t.transtype = 'AA001'         -- ��������ΪͶ��
      and isValidCont(t.contno) = 'yes' -- ��Ч����
      and t.conttype = '1'              -- �������ͣ�01-����
      and trunc(t.transdate) = trunc(i_baseLine)
       order by
          c.clientno ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type;   -- �ͻ���
    c_transno cr_trans.transno%type;      -- ���׺�
    c_contno cr_trans.contno%type;        -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0601', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0601;
/

prompt
prompt Creating procedure PROC_AML_A0602
prompt =================================
prompt
create or replace procedure proc_aml_A0602(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;	 -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_money number := getparavalue('SA0602', 'M2'); -- ��ֵ ���ڱ���
  v_income number:=getparavalue('SA0602', 'M1'); -- ��ֵ ������

begin
  -- =============================================
  -- Rule: Ͷ����ְҵΪ��ͥ��������������Ա�������������100��
  --       �ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --       ��ȡ������
  --         1) ��ȡ����ά��
  --            ����������OLAS��IGM��
  --            ��ȡǰһ����Ч�ı���
  --         2) Ͷ����ְҵΪ��ͥ��������������Ա�������������100���ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ
  --            ���ڱ��ѣ���AA001+AA003+AA004)
  --            ������ȫ����������
  --            �ڽɣ�ת����ANP��AA002��AA003����������
  --         3) ��������ֵΪ100��ʵ��Ϊ��������ʽ
  --       ��ȡ�����
  --         1) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/20
  -- Changes log:
  --     Author     Date     Description
  -- =============================================
  declare
    cursor baseInfo_sor is
      select
            c.clientno,
            t.transno,
            t.contno
        from
            cr_trans t,
            cr_rel r,
            cr_client c
        where
            t.contno = r.contno
        and r.clientno = c.clientno  -- Ͷ����������ڷ�ֵ
        and exists(
            select 1
            from
                cr_policy p
            where
                t.contno = p.contno
            and (case p.paymethod
                 when '01' then p.sumprem - p.prem + p.yearprem   --�ڽ�
                 when '02' then p.sumprem                         --����
                 end
                ) >= v_threshold_money
            )
        and c.occupation in (select code from ldcode where codetype = 'occ_SA0602')
        and c.income > to_number(v_income)
        and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
        and t.transtype = 'AA001'         -- ��������ΪͶ��
        and isValidCont(t.contno) = 'yes' -- ��Ч����
        and t.conttype = '1'              -- �������ͣ�01-����
        and trunc(t.transdate) = trunc(i_baseLine)
        order by c.clientno ,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno cr_trans.transno%type;    -- ���׺�
    c_contno cr_trans.contno%type;      -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0602', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0602;
/

prompt
prompt Creating procedure PROC_AML_A0700
prompt =================================
prompt
create or replace procedure proc_aml_A0700(i_baseLine in date, i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type; -- ���ױ��
  v_phone cr_rel.policyphone%type;    -- ��ϵ�绰
  v_iscount varchar2(2);       -- �Ƿ������ϸ����ָ��

  v_threshold_money number := getparavalue('SA0700', 'M1'); -- ��ֵ ���ڱ���

begin
  -- =============================================
  -- Rule:
  --      Ͷ���˵���ϵ�绰��ϵͳ�������ͻ���ϵ�绰��ͬ��
  --      �ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --      ��ȡ������
  --        1) ��ȡ����ά��
  --          ����������OLAS��IGM��
  --          ��ȡǰһ����Ч�ı���
  --        2) ����ȡ������Ͷ�����ֻ�����ϵͳ�������û��ֻ��Ž���ƥ�䣬
  --           ���ֻ�����ͬ�Ŀͻ���ȡ��������Ͷ���˽��бȶԣ�
  --           i��������alpha ID�Ŀͻ�����ȶ�alpha ID
  --           ii)������alpha ID�Ŀͻ��������ˣ�����ȶ�name+ID��
  --              ���ȶԲ�һ�£�����Ϊ��Ͷ���˵��ֻ�����ϵͳ�������ͻ��ֻ�����ͬ��
  --        3) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --        4) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  --        5) ���ڱ��ѣ���AA001+AA003+AA004)
  --           ������ȫ����������
  --           �ڽɣ�ת����ANP��AA002��AA003����������
  --
  -- parameter in: i_baseLine ��������
  --                i_oprater  ������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/03/20
  -- Changes log:
  --     Author     Date        Description
  --     xuexc    2019/05/10       ����
  --     zhouqk   2019/05/27    ���������Ϊ��ѯ����
  -- =============================================

  -- ��ȡϵͳ�е���Ͷ�����ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ��Ͷ���˺ͱ�����Ϣ
  insert into LXAssistA(
    Args1, -- �����ʶ
    Customerno,
    Policyno,
    Args2, -- ��ϵ�绰
    Args3, -- ֤������
    Args4) -- �ͻ���
      select distinct
          'A0700_1',
          r.clientno,
          t.contno,
          r.policyphone,
          r.usecardid,
          (select c.name from cr_client c where c.clientno = r.clientno) as clientname
      from
          cr_trans t,
          cr_rel r,
          cr_policy p
      where
          t.contno = r.contno
      and t.contno = p.contno
      and (case when r.custype = 'O' and nvl(r.policyphone, 'n') = 'n' then 'n' else 'y' end ) = 'y'
      and r.custype = 'O'
      and p.sumprem >= v_threshold_money -- ���ڱ��Ѵ��ڷ�ֵ
      and t.transtype = 'AA001'          -- �������ͣ�����Լ
      and trunc(t.transdate) = trunc(i_baseLine);

  -- ��ȡϵͳ������Ͷ����/������/��������Ϣ����ϵ�绰�뵱��Ͷ����Ͷ������ϵ�绰��ͬ��
  insert into LXAssistA(
    Args1, -- �����ʶ
    Customerno,
    Policyno,
    Args2, -- ��ϵ�绰
    Args3, -- ֤������
    Args4) -- �ͻ���
      select distinct
          'A0700_2',
          temp.clientno,
          temp.contno,
          temp.telephone,
          temp.cardid,
          temp.name
      from
      (
          select    -- ϵͳ������Ͷ����/��������Ϣ����ϵ�绰����շ���Ͷ����Ͷ������ϵ�绰��ͬ��
              r.clientno,
              r.contno,
              r.policyphone as telephone,
              r.usecardid as cardid,
              (select c.name from cr_client c where r.clientno = c.clientno) as name
          from
              cr_rel r
          where not exists(  -- �����ֻ�������ͬ�ҿͻ�����ͬ�Ŀͻ���Ϣ
              select 1
              from
                  LXAssistA a
              where
                  r.clientno = a.customerno
              and a.args1 = 'A0700_1'
              )
          and exists(     -- �ֻ�������ͬ�Ŀͻ���Ϣ
              select 1
              from
                  LXAssistA a
              where
                  r.policyphone = a.args2
              and a.args1 = 'A0700_1'
              )
          and r.custype in ('O', 'I') -- �ͻ����ͣ�O-Ͷ����/I-������
          union
          select    -- ϵͳ����������Ϣ����ϵ�绰��Ͷ������ϵ�绰��ͬ��
              c.clientno,
              r.contno,
              c.telephone,
              c.cardid,
              c.name
          from
              cr_rel r,
              cr_client c
          where
              r.clientno = c.clientno
          and not exists(  -- �����ֻ�������ͬ��֤�������������ͬ�Ŀͻ���Ϣ
              select 1
              from
                  LXAssistA a
              where
                  c.name = a.args4
              and c.cardid = a.args3
              and a.args1 = 'A0700_1'
              )
          and exists(
              select 1
              from
                  LXAssistA a
              where
                  c.telephone = a.args2
              and a.args1 = 'A0700_1'
              )
          and r.custype in ('B') -- �ͻ����ͣ�B-������
        ) temp;

  -- ��ȡϵͳ�е���Ͷ���ķ��Ϲ����Ͷ���˺ͱ�����Ϣ
  insert into LXAssistA(
    Args1, -- �����ʶ
    Customerno,
    Policyno,
    Args2, -- ��ϵ�绰
    Args3, -- ֤������
    Args4) -- �ͻ���
      select distinct
          'A0700_3',
          la.customerno,
          la.policyno,
          la.args2,
          la.args3,
          la.args4
      from
          LXAssistA la
      where
          la.args2 in (
          select
              a.args2
          from
              LXAssistA a
          where
              a.args1 in ('A0700_1','A0700_2')
          group by
              a.args2
          having
              count(distinct a.customerno) >= 2)
      and la.args1 in ('A0700_1','A0700_2');

  -- Ͷ���˵���ϵ�绰��ϵͳ�������ͻ���ϵ�绰��ͬ���ҵ��ڱ��Ѵ��ڵ��ڷ�ֵ�����б�����Ϣ
  declare
    cursor baseInfo_sor is
      select
          r.clientno,
          t.transno,
          t.contno,
          r.policyphone
      from
          cr_trans t,
          cr_rel r
      where
          t.contno = r.contno
      and exists(
          select 1
          from
              LXAssistA a
          where
              r.clientno = a.customerno
          and r.policyphone=a.args2
          and r.contno = a.policyno
          and a.args1 = 'A0700_3'
          )
      and r.custype in ('O', 'I', 'B') -- �ͻ����ͣ�O-Ͷ����/I-������/B-������
      and t.transtype = 'AA001' -- �������ͣ�����Լ
      and t.conttype = '1'      -- �������ͣ�1-����
      and r.policyphone is not null
      order by
          r.policyphone,
          t.transdate desc,
          t.contno desc;

    -- �����α����
    c_clientno cr_rel.clientno%type; -- �ͻ���
    c_phone cr_rel.policyphone%type; -- ��ϵ��ʽ
    c_transno cr_trans.transno%type; -- ���ױ��
    c_contno cr_trans.contno%type;   -- ������

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno, c_phone;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

		    if v_phone is null or c_phone <> v_phone then

            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)
			      v_phone := c_phone; -- ���¿����������ϵ��ʽ

			      -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
			      PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0700', i_baseLine);
			      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
			      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

            -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
  			    PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

            v_iscount := 'n'; -- ������´����в��ٶԿ��ɽ�����ϸ��Ϣ����
        else
            v_iscount := 'y'; -- ������´�������Ҫ�Կ��ɽ�����ϸ��Ϣ����
  			end if;

        -- �����Ƿ������ϸ����ָ���ж���ϸ��Ĳ���
		    if v_iscount = 'y' then
			      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
			      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
  			end if;

  			-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
  			PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

  			-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
  			PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

  			-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
  			PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

    end loop;
    close baseInfo_sor;
  end;

  -- ɾ��������A0700�ĸ�������
  delete from LXAssistA where Args1 like 'A0700%';
end proc_aml_A0700;
/

prompt
prompt Creating procedure PROC_AML_A0801
prompt =================================
prompt
create or replace procedure proc_aml_A0801(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --   ����Ͷ����Ϊ���߷��տͻ�
  --   1) ��ȡ����ά��
  --   ? ����������OLAS��IGM��
  --   ? ��ȡ��ǰһ����Ч�ı�����
  --   2) Ͷ����Ϊ���߷��տͻ�
  --   3) ���������������÷�ֵ
  --   4���������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/20
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

  declare
    cursor baseInfo_sor is
      select
          r.clientno,
          t.transno,
          t.contno
      from
          cr_client c,
          cr_rel r,
          cr_trans t
      where c.clientno=r.clientno
      and t.contno = r.contno
      and exists(
          select 1
          from
              lxriskinfo rinfo
          where
            (r.clientno = rinfo.code or c.ORIGINALCLIENTNO = rinfo.code)
          and rinfo.recordtype='01'       -- �������ͣ�01-��Ȼ��
          and rinfo.risklevel='4'         -- ���յȼ���4-���߷��յȼ�
          )
      and r.custype = 'O'              -- �ͻ����ͣ�O-Ͷ����
      and t.transtype = 'AA001'         -- ��������ΪͶ��
      and isValidCont(t.contno)='yes'  -- ��Ч����
      and t.conttype = '1'             -- �������ͣ�1-����
      and trunc(t.transdate) = trunc(i_baseLine)
      order by
          r.clientno,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type;  -- �ͻ���
    c_transno cr_trans.transno%type;     -- ���׺�
    c_contno cr_trans.contno%type;       -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0801', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0801;
/

prompt
prompt Creating procedure PROC_AML_A0802
prompt =================================
prompt
create or replace procedure proc_aml_A0802(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --   ����Ͷ����Ϊ���߷��տͻ������ڱ�����Ч�ڼ��ڴ����ʽ����
  --   1) ��ȡ����ά��
  --   ? ����������OLAS��IGM��
  --      ���߷��յĿͻ���
  --   2����ȡ��ǰһ�����ʽ�����ı�����
  --   3) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --   4) ���������������÷�ֵ
  --   1���ʽ�������ͣ��������뽻�ף�AB001,AB002,FC***,WT001,WT005,NP370,HK001�е��շѲ��֣���
  --      ��ʵ��ƥ�����ڡ��᰸��Ϊ��׼
  --   2���ʽ��������ͣ�
  --      �˱�����ȡ�˻���ֵ�����FPDF��Coupon��maturity��dividend�����ٱ���ı����˷ѡ�
  --      major���⡢minor���⡣���ϴ�payment����Ϊ��׼
  --   ���ͽ�������췢�������н������漰��ʣ�������ϸ��
  --
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/20
  -- Changes log:
  --     Author     Date     Description
  --     baishuai  2020/1/6  �ų����������ͽ��ɱ���
  -- =============================================

  declare
    cursor baseInfo_sor is
      select
          r.clientno,
          t.transno,
          t.contno
      from
          cr_trans t,
          cr_rel r,
          cr_policy p
      where
          t.contno = r.contno
      and t.contno = p.contno
      and exists(
          select 1
          from
              lxriskinfo rinfo,
              cr_client c
          where (c.clientno = rinfo.code or c.originalclientno=rinfo.code)
          and c.clientno = r.clientno
          and rinfo.recordtype='01'       -- �������ͣ�01-��Ȼ��
          and rinfo.risklevel='4'         -- ���յȼ���4-���߷��յȼ�
          )
      and exists(
          select 1
          from
              cr_trans tmp_t
          where
              t.contno = tmp_t.contno
          and t.payway in ('01','02')
          and t.transtype  in(select code from ldcode where codetype='aml_monitor_A0802')
          and trunc(t.transdate) = trunc(i_baseLine)
          )
      and t.payway in ('01','02')      -- ����֧����ʽΪ�պ͸�
      and r.custype = 'O'              -- �ͻ����ͣ�O-Ͷ����
      and t.conttype = '1'             -- �������ͣ�1-����
      and t.transtype  in(select code from ldcode where codetype='aml_monitor_A0802')
      and trunc(t.transdate) >= trunc(p.effectivedate) -- ��������>=������Ч��
      and trunc(t.transdate) < trunc(p.expiredate)     -- ��������<������ֹ��
      order by
          r.clientno,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type;  -- �ͻ���
    c_transno cr_trans.transno%type;     -- ���׺�
    c_contno cr_trans.contno%type;       -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0802', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_A0802;
/

prompt
prompt Creating procedure PROC_AML_A0900
prompt =================================
prompt
create or replace procedure proc_aml_A0900(i_baseLine in date,i_oprater in varchar2)
is
  v_dealNo lxistrademain.dealno%type;	-- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;	-- �ͻ���

	v_threshold_money number := getparavalue('SA0900', 'M1'); -- ��ֵ ��Ч�ڼ����ʽ�����ϼ�

begin
  -- =============================================
	-- Rule:
  --      ����Ͷ����Ϊ�߷��տͻ������ڱ�����Ч�ڼ��ڴ����ʽ������
  --      �ҽ����ڵ��ڷ�ֵ���ʽ�����Ծ���ֵ��ʽ�ϲ��ۼ�ͳ�ƣ����뷧ֵ���бȶԣ�
  --      1) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ��ȡ��ǰһ�����ʽ�����ı�����ͬ�ϣ���
  --      2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --      3) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  --      ע���ʽ�����Ծ���ֵ��ʽ�ϲ��ۼ�ͳ�ƣ����뷧ֵ���бȶ�
  --
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/20
	-- Changes log:
	--     Author     Date     Description
  --      baishuai  2019/1/19   �ۼƽ���ų����������ͽ��ɱ���
	-- =============================================

  -- ��ȡ����Ͷ����Ϊ�߷��տͻ������ڱ�����Ч�ڼ��ڴ����ʽ�������ҽ����ڵ��ڷ�ֵ�Ŀͻ��ͱ���
  insert into LXAssistA(
    Args1,     -- �����ʶ
    Customerno,-- �ͻ���
    Policyno)  -- ������
      select distinct
          'A0900' as args1,
          r.clientno,
          t.contno
      from
          cr_trans t,
          cr_rel r,
          cr_policy p
      where
          t.contno = r.contno
      and t.contno = p.contno
      and exists(
          select 1
          from
              LXRISKINFO rinfo,
              cr_client c
          where (c.clientno = rinfo.code or c.originalclientno=rinfo.code)
          and c.clientno = r.clientno
          and rinfo.risklevel = '3'   -- ���յȼ���3-�߷���
          and rinfo.recordtype = '01' -- 01-��Ȼ��
          )
      and exists (
          select 1
          from
              cr_trans tmp_t
          where
              t.contno = tmp_t.contno
          and tmp_t.payway in ('01','02') -- �����ʽ����
          and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype = 'O'         -- �ͻ����ͣ�O-Ͷ����
      and t.payway in ('01','02') -- �����ʽ����
      and t.transtype in (select code from ldcode where codetype='aml_monitor_A0900')
      and trunc(t.transdate) >= trunc(p.effectivedate) -- ��������>=������Ч��
      and trunc(t.transdate) < trunc(p.expiredate)     -- ��������<������ֹ��
      and t.conttype = '1' -- �������ͣ�1-����
			group by
          r.clientno,
          t.contno
			having
					sum(abs(t.payamt)) >= v_threshold_money;

  -- ��ȡ������Ч�ڼ��ڴ����ʽ�����Ľ�����Ϣ
  declare
    cursor baseInfo_sor is
			select
          r.clientno,
          t.transno,
          t.contno
      from
				  cr_trans t,
          cr_rel r,
          cr_policy p
      where
          t.contno = r.contno
      and t.contno = p.contno
			and exists(
					select 1
					from
							LXAssistA a
					where
              r.clientno = a.customerno
          and t.contno = a.policyno
          and a.args1 = 'A0900'
          )
      and r.custype = 'O'         -- �ͻ����ͣ�O-Ͷ����
      and t.payway in ('01','02') -- �����ʽ����
      and t.transtype  in (select code from ldcode where codetype='aml_monitor_A0900')
      and t.conttype = '1'        -- �������ͣ�1-����
      and trunc(t.transdate) >= trunc(p.effectivedate) -- ��������>=������Ч��
      and trunc(t.transdate) < trunc(p.expiredate)     -- ��������<������ֹ��
      order by
          r.clientno,t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type;	-- �ͻ���
    c_transno cr_trans.transno%type;		-- �ͻ����֤������
    c_contno cr_trans.contno%type;			-- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽����
        if v_clientno is null or c_clientno <> v_clientno then

            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SA0900', i_baseLine);

            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ1��
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp����ϸ����ָ��Ϊ�գ�
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;
  end;
  -- ɾ��������A0900�ĸ�������
  delete from LXAssistA where Args1 like 'A0900%';
end proc_aml_A0900;
/

prompt
prompt Creating procedure PROC_AML_B0101
prompt =================================
prompt
create or replace procedure proc_aml_B0101(i_baseLine in date, i_oprater in varchar2)
is
    v_dealNo lxistrademain.dealno%type; -- ���ױ��(ҵ���)
    v_clientno cr_client.clientno%type; -- �ͻ���
    i_ddd cr_client%rowtype;

    v_threshold_money number := getparavalue('SB0101', 'M1'); -- ��ֵ �ۼƱ��ѽ��
    v_threshold_month number := getparavalue('SB0101', 'D1'); -- ��ֵ ��Ȼ��
    v_threshold_count number := getparavalue('SB0101', 'N1'); -- ��ֵ �������

begin
  -- ============================================
  -- Rule:
  --     Ͷ����3�����ڱ���������Σ����������Σ���ϵ�绰���Ҹ�Ͷ������ΪͶ���˵�
  --     ������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --     1) �����ϵ�绰��ͳ��ͨ�ŵ�ַ�ı����������ͬһͶ���˱�����������ϵ�绰
  --        �������ϵ�绰��ͬ�ģ�������������кϲ���Ϊһ�α����
  --     2) �ۼ��ѽ������߼�ͬ7.1.1
  --     3) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ǰһ������ϵ�绰��Ч��ȫ�ı�����
  --     4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     5) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

  -- �ҳ����췢�������ϵ�绰��Ͷ�������������ڣ�ǰ�����б����ϵ�绰�ļ�¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
    args1,
    args2,
    args3,
    args4,
    args5)
      select
          r.clientno,
          t.transno,
          t.contno,
          (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
          t.requestdate,
          t.transdate,
          t.transtype,
          td.remark,
          td.ext1,
          td.ext2,
          'B0101_1'
      from
          cr_trans t,
          cr_rel r,
          cr_transdetail td
      where
          t.contno = r.contno
      and t.contno = td.contno
      and t.transno = td.transno
      and exists(
          select 1
          from
              cr_trans tmp_t,
              cr_rel tmp_r,
              cr_transdetail tmp_td
          where
              r.clientno = tmp_r.clientno
          and trunc(t.requestdate) > trunc(add_months(tmp_t.requestdate,v_threshold_month*(-1)))  --������3����ǰ
          and trunc(t.requestdate) < trunc(add_months(tmp_t.requestdate,v_threshold_month))   --������3���º�
          and tmp_t.contno = tmp_r.contno
          and tmp_t.contno = tmp_td.contno
          and tmp_t.transno = tmp_td.transno
          and tmp_r.custype='O'          -- Ͷ����
          and tmp_td.remark in ('mobile','ownerMobile')
          and tmp_t.transtype in ('COMM','BG001','BG002')
          and tmp_t.conttype='1'         -- ����
          and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and td.remark in('mobile','ownerMobile')
      and t.transtype in ('COMM','BG001','BG002')
      and t.conttype='1'
      and isValidCont(t.contno)='yes';

  --ͬһͶ����3�����ڣ�ǰ��3�Σ�������3�����ϱ����ϵ�绰���ۼ��ѽ����Ѵ��ڷ�ֵ
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TimeArgs1,
    TranMoney,
    args5,
    args4)
      select
          CustomerNo,
          TranId,
          PolicyNo,
          TimeArgs1,
          TranMoney,
          'B0101_2',
          args4
      from
          LXAssistA a
      where exists(
            select 1
            from
                LXAssistA tmp
            where
                tmp.customerno = a.customerno
            group by
                tmp.customerno
            having  -- ��֤���Ϊͬһ��ϵ�绰���������
                count(distinct tmp.args4) > v_threshold_count
            )
      and (       -- ��������������Ч�����ۼ��ѽ������ܶ�
           select
               sum(nvl(p.sumprem,0))
           from
               cr_rel r,
               cr_policy p
           where
               r.clientno = a.customerno
           and r.contno = p.contno
           and isValidCont(r.contno) = 'yes'
           and r.custype='O') >= v_threshold_money
      order by
          a.customerno,
          a.timeargs1;

  -- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
  declare
    cursor baseInfo_sor is
      select
          CustomerNo,
          PolicyNo,
          TimeArgs1
      from
          LXAssistA a
      where exists (          -- ��ÿ��Ϊ��������3�������Ƿ�������
            select 1
            from
                LXAssistA tmp
            where
                tmp.customerno = a.customerno
            and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
            and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
            and tmp.args5 = 'B0101_2'
            group by
                tmp.customerno
            having
                count(distinct tmp.args4) > v_threshold_count
            )
        and a.args5 = 'B0101_2'
        order by
            a.CustomerNo,
            a.TimeArgs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_contno cr_trans.contno%type;      -- ������
    c_requestdate cr_trans.requestdate%type;

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_contno, c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- �Լ�¼ͷ�����������ڵļ�¼
      declare
        cursor baseInfo_sor_date is
          select *
          from
              lxassista
          where
              trunc(TimeArgs1) >= trunc(c_requestdate)
          and trunc(TimeArgs1) < trunc(add_months(c_requestdate, v_threshold_month))
          and args5 = 'B0101_2'
          and customerno = c_clientno;

        c_row baseInfo_sor_date%rowtype;

      begin
      for c_row in baseInfo_sor_date loop
        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
        if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0101', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');
        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
      end loop;
      end;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('B0101_1','B0101_2');
end proc_aml_B0101;
/

prompt
prompt Creating procedure PROC_AML_B0102
prompt =================================
prompt
create or replace procedure proc_aml_B0102(i_baseLine in date, i_oprater in varchar2) is

    v_threshold_money number := getparavalue('SB0102', 'M1'); -- ��ֵ �ۼƱ��ѽ��
		v_threshold_month number := getparavalue('SB0102', 'D1'); -- ��ֵ ��Ȼ��
		v_threshold_count number := getparavalue('SB0102', 'N1'); -- ��ֵ �������
		v_dealNo lxistrademain.dealno%type;												-- ���ױ��(ҵ���)
		v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --     Ͷ����3�����ڱ���������Σ����������Σ�ͨ�ŵ�ַ���Ҹ�Ͷ������ΪͶ���˵�
  --     ������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --     1) ���ͨ�ŵ�ַ��ͳ��ͨ�ŵ�ַ�ı����������ͬһͶ���˱���������ͨ�ŵ�ַ
  --        �����ͨ�ŵ�ַ��ͬ�ģ�������������кϲ���Ϊһ�α����
  --     2) �ۼ��ѽ������߼�ͬ7.1.1
  --     3) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ǰһ����ͨ�ŵ�ַ��Ч��ȫ�ı�����
  --     4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     5) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- ============================================

  -- �ҳ����췢�����ͨ�ŵ�ַ��Ͷ�������������ڣ�ǰ�����б��ͨ�ŵ�ַ�ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
    args1,
    args3,
    args4,
		args5)
      select distinct
        r.clientno,
        t.transno,
        t.contno,
        (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
        t.requestdate,
        t.transdate,
        t.transtype,
        (select distinct tr.ext1 from cr_transdetail tr where tr.remark in ('regiona','commAddress1') and tr.transno=t.transno)
        ||(select distinct tr.ext1 from cr_transdetail tr where tr.remark in ('regionb','commAddress2') and tr.transno=t.transno)
        ||(select distinct tr.ext1 from cr_transdetail tr where tr.remark in ('regionc','commAddress3') and tr.transno=t.transno)
        ||(select distinct tr.ext1 from cr_transdetail tr where tr.remark in ('regiond','commAddress4') and tr.transno=t.transno)
        as ext1,
        (select distinct tr.ext2 from cr_transdetail tr where tr.remark in ('regiona','commAddress1') and tr.transno=t.transno)
        ||(select distinct tr.ext2 from cr_transdetail tr where tr.remark in ('regionb','commAddress2') and tr.transno=t.transno)
        ||(select distinct tr.ext2 from cr_transdetail tr where tr.remark in ('regionc','commAddress3') and tr.transno=t.transno)
        ||(select distinct tr.ext2 from cr_transdetail tr where tr.remark in ('regiond','commAddress4') and tr.transno=t.transno)
        as ext2,
				'B0102_1'
      from
        cr_trans t,cr_rel r,cr_transdetail td
      where
          t.contno=r.contno
      and t.contno=td.contno
      and t.transno=td.transno
      and exists(
          select 1
          from
              cr_trans tmp_t, cr_rel tmp_r, cr_transdetail tmp_td
          where
              r.clientno = tmp_r.clientno
          and tmp_t.contno = tmp_r.contno
          and tmp_t.contno=tmp_td.contno
          and tmp_t.transno=tmp_td.transno
          and tmp_r.custype='O'          -- Ͷ����
          and tmp_t.conttype='1'         -- ����
          and trunc(t.requestdate) > trunc(add_months(tmp_t.requestdate,v_threshold_month*(-1)))  --������3����ǰ
          and trunc(t.requestdate) < trunc(add_months(tmp_t.requestdate,v_threshold_month))   --������3���º�
          and tmp_td.remark in('regiona','regionb','regionc','regiond','commAddress1','commAddress2','commAddress3','commAddress4')
          and tmp_t.transtype in ('COMM','BG001','BG002')-- ����Ǳ��Ͷ���ˣ��򲻹���remark��ע��Ϣ
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and td.remark in('regiona','regionb','regionc','regiond','commAddress1','commAddress2','commAddress3','commAddress4')
      and t.transtype in('COMM','BG001','BG002')     -- ���ͨ�ŵ�ַ
      and isValidCont(t.contno)='yes'
      and t.conttype='1';


    --ͬһͶ����3�����ڣ�ǰ��3�Σ�������3�����ϱ��ͨ�ŵ�ַ���ۼ��ѽ����Ѵ��ڷ�ֵ
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
		TimeArgs1,
		TranMoney,
    args5,
		args4)
      select
        CustomerNo,
        TranId,
        PolicyNo,
				TimeArgs1,
				TranMoney,
				'B0102_2',
				args4
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having  -- ��֤���Ϊͬһ��ϵ�绰���������  by zhouqk
            count(distinct tmp.args4)>v_threshold_count
        )
    and (			-- ��������������Ч�����ۼ��ѽ������ܶ�
				select
					sum(nvl(policy.sumprem,0))
					from cr_rel rel,cr_policy policy
					where rel.contno=policy.contno
					and rel.clientno = a.customerno
					and isValidCont(rel.contno)='yes'
					and rel.custype='O')
				>=v_threshold_money

      order by a.customerno, a.timeargs1;

-- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
declare
       cursor baseInfo_sor is
          select
            CustomerNo,
            PolicyNo,
						TimeArgs1
          from
            LXAssistA a
          where
						exists (					-- ��ÿ��Ϊ��������3�������Ƿ�������
							select 1
							from LXAssistA tmp
							where tmp.customerno = a.customerno
							and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
							and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
							and tmp.args5 = 'B0102_2'
							group by
								tmp.customerno
							having
								count(distinct tmp.args4)>v_threshold_count
						)
						and a.args5 = 'B0102_2'
						order by CustomerNo,TimeArgs1 desc;


    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷ�����������ڵļ�¼
			declare
				cursor baseInfo_sor_date is
					select *
					from lxassista
					where trunc(TimeArgs1) >= trunc(c_requestdate)
					and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
					and args5 = 'B0102_2' and customerno = c_clientno;

			c_row baseInfo_sor_date%rowtype;

		begin
		for c_row in baseInfo_sor_date loop
			-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
      v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

      -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
      PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0102', i_baseLine);
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
      v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

      end if;

			-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
			PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

			-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
			PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

			-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
			PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

			-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
			PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
		end loop;

		end;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('B0102_1','B0102_2');
end proc_aml_B0102;
/

prompt
prompt Creating procedure PROC_AML_B0103
prompt =================================
prompt
create or replace procedure proc_aml_B0103(i_baseLine in date, i_oprater in varchar2) is

    v_threshold_money number := getparavalue('SB0103', 'M1'); -- ��ֵ �ۼƱ��ѽ��
		v_threshold_month number := getparavalue('SB0103', 'D1'); -- ��ֵ ��Ȼ��
		v_threshold_count number := getparavalue('SB0103', 'N1'); -- ��ֵ �������
		v_dealNo lxistrademain.dealno%type;												-- ���ױ��(ҵ���)
		v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --     Ͷ����3�����ڱ���������Σ����������Σ�ְҵ��ǩ���������˻�����ˣ��Ҹ�Ͷ������ΪͶ���˵�
  --     ������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --     1) ���ͨ�ŵ�ַ��ͳ��ְҵ��ǩ���������˻�����˵ı����������ͬһͶ���˱���������ְҵ��ǩ���������˻�����ˣ�
  --        �����ְҵ��ǩ���������˻��������ͬ�ģ�������������кϲ���Ϊһ�α��
  --     2) �ۼ��ѽ������߼�ͬ7.1.1
  --     3) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ǰһ����ְҵ��ǩ���������˻��������Ч��ȫ�ı���
  --     4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     5) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����췢�����Ͷ�������������ڣ�ǰ�����б����¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
    args1,
    args2,
    args3,
    args4,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
        t.requestdate,
        t.transdate,
        t.transtype,
        td.remark,
        td.ext1,
        td.ext2,
        'B0103_1'
      from
        cr_trans t,cr_rel r,cr_transdetail td
      where
          t.contno=r.contno
      and t.contno=td.contno
      and t.transno=td.transno
      and exists(
          select 1
          from
              cr_trans tmp_t, cr_rel tmp_r, cr_transdetail tmp_td
          where
              tmp_r.clientno = r.clientno
          and tmp_t.contno = tmp_r.contno
          and tmp_t.contno = tmp_td.contno
          and tmp_t.transno = tmp_td.transno
          and trunc(t.requestdate) > trunc(add_months(tmp_t.requestdate,v_threshold_month*(-1)))  --������3����ǰ
          and trunc(t.requestdate) < trunc(add_months(tmp_t.requestdate,v_threshold_month))   --������3���º�
          and tmp_r.custype = 'O'
          and tmp_t.conttype='1'
          and (tmp_td.remark in ('OwnOccupation','editSignStyle','���������') or tmp_td.remark like 'operateType%')
          and tmp_t.transtype in ('COMM','BG002','BG005','FC0OO','FC0OD','FC0II','AGT01')
          and trunc(tmp_t.transdate)=trunc(i_baseline)
          )
      and r.custype = 'O'
      and (td.remark in ('OwnOccupation','editSignStyle','���������') or td.remark like 'operateType%')
      and t.transtype in ('COMM','BG002','BG005','FC0OO','FC0OD','FC0II','AGT01')
      and isValidCont(t.contno) = 'yes'
      and t.conttype = '1';

	 insert into LXAssistA(
			CustomerNo,
			TranId,
			PolicyNo,
			TimeArgs1,
			TranMoney,
			args2,
			args5,
			args4)
      select
        CustomerNo,
        TranId,
        PolicyNo,
				TimeArgs1,
				TranMoney,
				args2,
				'B0103_2',
				args4
      from
        LXAssistA a
      where (									-- ���Ϊͬһְҵ�����˴�����ֻ��һ�Σ����ǩ����ȥ��
        nvl((
          select count(distinct tmp.args4)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and (tmp.args2 in('OwnOccupation','AGT01'))
          group by
            tmp.customerno
				),0)
				+
				nvl((
          select count(1)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and tmp.args2='editSignStyle'
          group by
            tmp.customerno
				),0)
        +
        nvl((
          select count(distinct tranid)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and tmp.args2 like 'operateType%'
          group by
            tmp.customerno
				),0)>=v_threshold_count
     )
    and (				-- ��������������Ч�����ۼ��ѽ������ܶ�
				select
					sum(nvl(policy.sumprem,0))
					from cr_rel rel,cr_policy policy
					where rel.contno=policy.contno
					and rel.clientno = a.customerno
					and isValidCont(rel.contno)='yes'
					and rel.custype='O')
				>=v_threshold_money
			order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
	declare
       cursor baseInfo_sor is
          select
            CustomerNo,
            PolicyNo,
						TimeArgs1
          from
            LXAssistA a
          where
						(									-- ���Ϊͬһְҵ�����˴�����ֻ��һ�Σ����ǩ����ȥ��
							nvl((
								select count(distinct tmp.args4)
								from
									LXAssistA tmp
								where tmp.customerno = a.customerno
								and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
								and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
								and (tmp.args2 in('OwnOccupation','���������')or tmp.args2 like 'operateType%')
								and tmp.args5='B0103_2'
								group by
									tmp.customerno
							),0)
							+
							nvl((
								select count(tmp.args4)
								from
									LXAssistA tmp
								where tmp.customerno = a.customerno
								and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
								and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
								and tmp.args2 ='editSignStyle'
								and tmp.args5='B0103_2'
								group by
									tmp.customerno
							),0)
              +
              nvl((
                  select count(distinct tranid)
                  from
                    LXAssistA tmp
                  where tmp.customerno = a.customerno
					        and tmp.args2 like 'operateType%'
                  group by
                    tmp.customerno
				      ),0)>=v_threshold_count
					 )
				and a.args5 = 'B0103_2'
				order by CustomerNo,TimeArgs1 desc;

     -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷ�����������ڵļ�¼
			declare
				cursor baseInfo_sor_date is
					select *
					from lxassista
					where trunc(TimeArgs1) >= trunc(c_requestdate)
					and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
					and args5 = 'B0103_2' and customerno = c_clientno;

			c_row baseInfo_sor_date%rowtype;

		begin
		for c_row in baseInfo_sor_date loop
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
      v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

      -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
      PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0103', i_baseLine);
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
      v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

      end if;

			-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
			PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

			-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
			PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

			-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
			PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

			-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
			PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
		end loop;

		end;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('B0103_1','B0103_2');
end proc_aml_B0103;
/

prompt
prompt Creating procedure PROC_AML_B0200
prompt =================================
prompt
create or replace procedure proc_aml_B0200(i_baseLine in date,i_oprater in VARCHAR2) is
	v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
	v_clientno cr_client.clientno%type;  -- �ͻ���
begin
	-- =============================================
	-- Rule: ��ȡǰһ����Ч�ı�����
	-- δ�ṩFATCA��CRS�����ļ��ı���
  -- ��ȡ��ǰһ����Ч�ı���
	-- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/22
	-- Changes log:
	--     Author     Date          Description
  --     zhouqk  2019/04/21         ����
	-- =============================================
	declare
			cursor baseInfo_sor is
				select
					c.clientno,
					t.transno,
					t.contno
					from
						cr_trans t, cr_rel r, cr_client c
					where
								t.contno = r.contno
						and r.clientno = c.clientno
						and c.IsFATCAandCRS='0'									  -- ��FATCA��CRS�����ļ�
						and t.transtype = 'AA001'									-- ��������ΪͶ��
            and isValidCont(t.contno)='yes'
						and r.custype = 'O'             	 		    -- �ͻ����ͣ�O-Ͷ����
            and t.conttype = '1'            			    -- �������ͣ�1-����
						and trunc(t.transdate) = trunc(i_baseLine)
					order by c.clientno,t.transdate desc;    	                  --����ʱ��

    -- �����α����
		c_clientno cr_client.clientno%type;        -- �ͻ���
    c_transno cr_trans.transno%type;    			 -- �ͻ����֤������
    c_contno cr_trans.contno%type;     				 -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;  -- �α�ѭ������

				-- ͬһ��������������
				if v_clientno is null or c_clientno <> v_clientno then

					v_dealNo :=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��

					-- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
					PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0200', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
   				PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

					v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
				  PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

				end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
				PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
				PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
				PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
				PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;
  end;
  

end proc_aml_B0200;
/

prompt
prompt Creating procedure PROC_AML_B0300
prompt =================================
prompt
create or replace procedure proc_aml_B0300(i_baseLine in date,i_oprater in VARCHAR2) is
	v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
	v_clientno cr_client.clientno%type;  -- �ͻ���
begin
	-- =============================================
	-- ��ȡ������Ч��+90�����ڱ���16�ŵ��¸���15��֮�䣻����
  -- Ͷ�������������֤δͨ��( [���У���](��ṹ��FR002)��[��֤״̬]=��N��)
  -- ��ȡ��ǰһ����Ч�ı���
	-- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- parameter in: i_baseLine ��������
	-- parameter in: i_dataBatchNo ���κ�
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/05/27
	-- Changes log:
	--     Author       Date       Description
  --     zhouqk    2019/05/27       ����
	-- =============================================
  insert into LXAssistA(
    PolicyNo,
		args5)
      select
        p.contno,
				'B0300'
      from
        cr_policy p
      where
          (p.effectivedate+90) >= to_date(concat(to_char(i_baseline,'yyyy-mm'),'-16'),'yyyy-mm-dd')                --������Ч��+90����ڱ���16��
			and (p.effectivedate+90) <= to_date(concat(to_char(add_months(i_baseline,1),'yyyy-mm'),'-15'),'yyyy-mm-dd')  --������Ч��+90��С����һ����15��
      and p.conttype = '1';		-- �������ͣ�1-����

  declare
			cursor baseInfo_sor is
				select
						c.clientno,
						t.transno,
						t.contno
					from
						cr_trans t, cr_rel r, cr_client c
					where
								t.contno = r.contno
						and r.clientno = c.clientno
						and c.IDverifystatus='0'   								-- �����֤δͨ��
            and r.custype = 'O'             	 		    -- �ͻ����ͣ�O-Ͷ����
            and t.transtype='AA001'                   -- ȡͶ���Ľ�����������ϸ
            and exists(
                select 1
                from lxassista lx
                where lx.policyno=r.contno
            )
					  order by c.clientno,t.transdate desc;

					-- �����α����
					c_clientno cr_client.clientno%type;        -- �ͻ���
					c_transno cr_trans.transno%type;    			 -- �ͻ����֤������
					c_contno cr_trans.contno%type;     				 -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;  -- �α�ѭ������

				-- ͬһ��������������
        if v_clientno is null or c_clientno <> v_clientno then

          v_dealNo :=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0300', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
				PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
				PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
				PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
				PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;
  end;
  delete from LXAssistA where args5 in ('B0300');
end proc_aml_B0300;
/

prompt
prompt Creating procedure PROC_AML_B0400
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_B0400(i_baseLine in date,i_oprater in VARCHAR2) is
	v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
  v_threshold_year number := getparavalue('SB0101', 'D1'); 	-- ���޷�ֵ
	v_threshold_count number := getparavalue('SB0101', 'N1'); -- ����������ֵ
  v_clientno cr_rel.clientno%type;  -- �ͻ���
begin
	-- =============================================
	-- Rule: ��ȡǰһ����Ч�ı�����
	-- һ���ڣ���3�����ϱ���Ͷ���˱��Ϊͬһ�ˣ���ԭͶ���˲�ͬ
	-- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater 	������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/22
	-- Changes log:
	--     Author     Date     Description
	-- =============================================

  -- ��ȡǰһ�췢��Ͷ���˱���Ŀͻ���������һ���ڷ���Ͷ���˱����������Ч������
  insert into LXAssistA(
    Customerno,
    Policyno,
    Args2,
    Args3,
    Args4,
    Args1)
      select
          r.clientno,
          t.contno,
          (select c.cardid from cr_client c where c.clientno = r.clientno) as cardid,
          (select distinct td.ext1 from cr_transdetail td where td.contno = t.contno and td.transno = t.transno and td.remark='OwnCertNumber') as ext1,
          (select distinct td.ext2 from cr_transdetail td where td.contno = t.contno and td.transno = t.transno and td.remark='OwnCertNumber') as ext2,
          'B0400'
      from
          cr_rel r,
          cr_trans t
      where
          r.contno = t.contno
      and exists (
          select 1
          from
              cr_trans tmp_t,
              cr_rel tmp_r
          where
              r.clientno = tmp_r.clientno
          and tmp_r.contno = tmp_t.contno
          and isValidCont(tmp_r.contno) = 'yes' -- ��Ч����
          and tmp_t.transtype = 'BG003'         -- ��������ΪͶ���˱��
          and tmp_t.conttype = '1'              -- �������ͣ�1-����
          and trunc(tmp_t.transdate) = trunc(i_baseLine)
          )
      and r.custype = 'O'               -- �ͻ����ͣ�O-Ͷ����
      and isValidCont(r.contno) = 'yes' -- ��Ч����
      and t.transtype = 'BG003'         -- ��������Ϊ��Ͷ���˱����
      and t.conttype = '1'              -- �������ͣ�1-����
      and trunc(t.transdate) > trunc(add_months(i_baseLine, -12 * v_threshold_year))
      and trunc(t.transdate) <= trunc(i_baseLine);

  declare
	  cursor baseInfo is
      select
				  r.clientno,
				  t.transno,
				  t.contno
			from
				  cr_trans t,
          cr_rel r
			where
					t.contno = r.contno
		  and exists (
					select 1
					from
              LXAssistA a
					where
              r.clientno = a.customerno
          and a.args2 = a.args4
          group by
              a.customerno
          having
              count(distinct a.args3) >= v_threshold_count
				  )
			and r.custype = 'O'							-- �ͻ����ͣ�O-Ͷ����
			and isValidCont(t.contno)='yes' -- ��Ч����
			and t.transtype='BG003'					-- ��������ΪͶ���˱��
			and t.conttype = '1'						-- �������ͣ�1-����
      and trunc(t.transdate) > trunc(add_months(i_baseLine, -12 * v_threshold_year))
      and trunc(t.transdate) <= trunc(i_baseLine)
			order by
          r.clientno,
          t.transdate desc;

	  -- �����α����
	  c_clientno cr_rel.clientno%type;	-- �ͻ���
	  c_transno cr_trans.transno%type;	-- ���ױ��
	  c_contno cr_trans.contno%type;		-- ������


begin
  open baseInfo;
	loop
	  fetch baseInfo into c_clientno, c_transno, c_contno;
	  exit when baseInfo%notfound;

			-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
			if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

				-- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
				PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0400', i_baseLine);
				-- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
				PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

				v_clientno := c_clientno; -- ���¿�������Ŀͻ���
			else
				-- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
				PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');
			end if;

				-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
				PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

				-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
				PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

				-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
				PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

				-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
				PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

  end loop;
  close baseInfo;

end;
-- ɾ��������ĸ�������
  delete from LXAssistA;
end proc_aml_B0400;
/

prompt
prompt Creating procedure PROC_AML_C0101
prompt =================================
prompt
create or replace procedure proc_aml_C0101(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0101', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day number := getparavalue('SC0101', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0101', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;  -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- ͬһͶ����7����3�Σ�����3����������׷��Ͷ�ʡ��µ����ѡ���Ͷ�ﵽ30�򣬼���ϵͳץȡ�����ɿ��ɽ���
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��������׷��Ͷ�ʣ�T�����µ����ѣ�I��7������Ͷ��Q���ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ30��ʵ��Ϊ��������ʽ
  -- parameter in:  i_baseLine ��������
  --                i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- ============================================

  -- �ҳ����촥������׷��Ͷ�ʡ��µ����ѡ���Ͷ��Ͷ���������ڣ�ǰ�����д����ļ�¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
        t.transtype,
				'C0101_1'
      from
        cr_trans t,cr_rel r
      where
          t.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate) > trunc(tmp_t.requestdate) - v_threshold_day  --������7��ǰ
          and trunc(t.requestdate) < trunc(tmp_t.requestdate) + v_threshold_day  --������7���
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='01'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (t.transtype like 'FC%' and t.payway='01'));


    --ͬһͶ���������ڣ�ǰ��3�Σ�����3���������ۼ��ѽ����Ѵ��ڷ�ֵ
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
        CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0101_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%' ) tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money --��ֵ�������AA003\AA004
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼������������������Ľ�����Ϊ��¼ͷ
	declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  (args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%')
								and args5='C0101_2') tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(a.TimeArgs1)+v_threshold_day
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
		and a.args5='C0101_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;


begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴���������Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
				 and args5 = 'C0101_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ�����ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
							and args5 = 'C0101_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					  -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0101', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;


            -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
            PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

            -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
            PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

            -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
            PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

            -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
            PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0101_1','C0101_2');
end proc_aml_C0101;
/

prompt
prompt Creating procedure PROC_AML_C0102
prompt =================================
prompt
create or replace procedure proc_aml_C0102(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0102', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day number := getparavalue('SC0102', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0102', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;               -- ���ױ��(ҵ���)
	v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- ͬһͶ����30����5�Σ�����5����������׷��Ͷ�ʡ��µ����ѡ���Ͷ�ﵽ50�򣬼���ϵͳץȡ�����ɿ��ɽ���
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��������׷��Ͷ�ʣ�T�����µ����ѣ�I��7������Ͷ��Q���ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ50��ʵ��Ϊ��������ʽ
  -- parameter in:  i_baseLine ��������
  --                i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- ============================================

-- �ҳ����촥������׷��Ͷ�ʡ��µ����ѡ���Ͷ��Ͷ������ʮ���ڣ�ǰ�����д����ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0102_1'
      from
        cr_trans t,cr_rel r
      where
          t.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate) > trunc(tmp_t.requestdate) - v_threshold_day  --������30��ǰ
          and trunc(t.requestdate) < trunc(tmp_t.requestdate) + v_threshold_day  --������30���
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='01'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (t.transtype like 'FC%' and t.payway='01'));

--ͬһͶ������ʮ���ڣ�ǰ��5�Σ�����5���������ۼ��ѽ����Ѵ��ڷ�ֵ
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0102_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%' ) tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money --��ֵ�������AA003\AA004
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼������������������Ľ�����Ϊ��¼ͷ
declare
    --�����α꣺
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  (args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%')
								and args5='C0102_2') tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(a.TimeArgs1)+v_threshold_day
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
		and a.args5='C0102_2'
    order by a.customerno, a.timeargs1 desc;

   -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴��������ʮ���Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
				 and args5 = 'C0102_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ��ʮ���ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
							and args5 = 'C0102_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					  -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
              v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

              -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
              PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0102', i_baseLine);
              -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
              PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
              v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
              -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
              PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0102_1','C0102_2');
end proc_aml_C0102;
/

prompt
prompt Creating procedure PROC_AML_C0103
prompt =================================
prompt
create or replace procedure proc_aml_C0103(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0103', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_month number := getparavalue('SC0103', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0103', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;               -- ���ױ��(ҵ���)
	v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- ͬһͶ����6������8�Σ�����8����������׷��Ͷ�ʡ��µ����ѡ���Ͷ�ﵽ100�򣬼���ϵͳץȡ�����ɿ��ɽ���
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��������׷��Ͷ�ʣ�T�����µ����ѣ�I��7������Ͷ��Q���ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ100��ʵ��Ϊ��������ʽ
  -- parameter in:  i_baseLine ��������
  --                i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- ============================================

-- �ҳ����촥������׷��Ͷ�ʡ��µ����ѡ���Ͷ��Ͷ�����������ڣ�ǰ�����д����ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0103_1'
      from
        cr_trans t,cr_rel r
      where
          t.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate)>trunc(add_months(tmp_t.requestdate,-abs(v_threshold_month))) --������6����ǰ
          and trunc(t.requestdate)<trunc(add_months(tmp_t.requestdate,abs(v_threshold_month)))        --������6���º�
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='01'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('AA001','AA003','AA004','WT001','AB002','WT005')) or (t.transtype like 'FC%' and t.payway='01'));

    --ͬһͶ����6������8�Σ�����8����������׷��Ͷ�ʡ��µ����ѡ���Ͷ�ﵽ100��
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0103_2'
      from
        LXAssistA a
      where
       exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%' ) tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money --��ֵ�������AA003\AA004
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            (select
                distinct
                  CustomerNo,TimeArgs1,PolicyNo
               from
                  LXAssistA
               where
                  (args1 in ('AA001','WT001','AB002','WT005')
                 or args1 like 'FC%')
								and args5='C0103_2') tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count --�������㲻����AA003\AA004
        )
		and a.args5='C0103_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴�������������Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
				 and args5 = 'C0103_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ�������ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
							and args5 = 'C0103_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0103', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0103_1','C0103_2');
end proc_aml_C0103;
/

prompt
prompt Creating procedure PROC_AML_C0201
prompt =================================
prompt
create or replace procedure proc_aml_C0201(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0201', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day number := getparavalue('SC0201', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0201', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;               -- ���ױ��(ҵ���)
     	v_clientno cr_client.clientno%type;  -- �ͻ���

begin
 -- =============================================
  -- Rule:
  -- ͬһͶ������7�����˱�3�Σ�����3����������ͬ�ﵽ50��ֻȡӦ�����������˱�������ط��ã�����ϵͳץȡ�����ɿ��ɽ��ף�
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM��
  --    ��ȡǰһ������˱���ȫ��ı�����
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ50��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  -- 							 i_oprater ������
  -- parameter out: none
  -- Author: xiesf
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- ============================================

-- �ҳ����촥���˱���Ͷ���������ڣ�ǰ�����д����ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0201_1'
      from
        cr_trans t,cr_rel r
      where
          t.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate) > trunc(tmp_t.requestdate) - v_threshold_day  --������7��ǰ
          and trunc(t.requestdate) < trunc(tmp_t.requestdate) + v_threshold_day  --������7���
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('TB001','LQ002')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='02'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('TB001','LQ002')) or (t.transtype like 'FC%' and t.payway='02'));


    --�����α꣺ͬһͶ����7����3�Σ�����3�������˱��ﵽ50��
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0201_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼������������������Ľ�����Ϊ��¼ͷ
declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(a.TimeArgs1)+v_threshold_day
						and tmp.args5='C0201_2'
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count
        )
		and a.args5='C0201_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴�����������Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
				 and args5 = 'C0201_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ�����ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
							and args5 = 'C0201_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0201', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0201_1','C0201_2');
end proc_aml_C0201;
/

prompt
prompt Creating procedure PROC_AML_C0202
prompt =================================
prompt
create or replace procedure proc_aml_C0202(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0202', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day number := getparavalue('SC0202', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0202', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;               -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- ͬһͶ������30�����˱�5�Σ�����5�����ϴﵽ100�򡣣�ֻȡӦ�����������˱�������ط��ã�����ϵͳץȡ�����ɿ��ɽ��ף�
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM
  --    ��ȡǰһ������˱���ȫ��ı�����
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ100��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  -- 							 i_oprater ������
  -- parameter out: none
  -- Author: xiesf
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����촥������׷��Ͷ�ʡ��µ����ѡ���Ͷ��Ͷ������ʮ���ڣ�ǰ�����д����ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0202_1'
      from
        cr_trans t,cr_rel r,cr_policy p
      where
          t.contno=r.contno
      and p.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate) > trunc(tmp_t.requestdate) - v_threshold_day  --������30��ǰ
          and trunc(t.requestdate) < trunc(tmp_t.requestdate) + v_threshold_day  --������30���
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('TB001','LQ002')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='02'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('TB001','LQ002')) or (t.transtype like 'FC%' and t.payway='02'));


    --�����α꣺ͬһͶ����30����5�Σ�����5�������˱��ﵽ100��
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0202_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼������������������Ľ�����Ϊ��¼ͷ
declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(a.TimeArgs1)+v_threshold_day
						and tmp.args5='C0202_2'
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count
        )
		and a.args5='C0202_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;



begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴��������ʮ���Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
				 and args5 = 'C0202_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ��ʮ���ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(c_requestdate)+v_threshold_day
							and args5 = 'C0202_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0202', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0202_1','C0202_2');
end proc_aml_C0202;
/

prompt
prompt Creating procedure PROC_AML_C0203
prompt =================================
prompt
create or replace procedure proc_aml_C0203(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0203', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_year number := getparavalue('SC0203', 'D1');     -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0203', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;                          -- ���ױ��(ҵ���)
	v_clientno cr_client.clientno%type;                          -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- ͬһͶ������һ�����˱�8�Σ�����8�����ϴﵽ300�򡣣�ֻȡӦ�����������˱�������ط��ã�����ϵͳץȡ�����ɿ��ɽ��ף�
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM
  --    ��ȡǰһ������˱���ȫ��ı�����
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ300��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  -- 							 i_oprater ������
  -- parameter out: none
  -- Author: xiesf
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����촥������׷��Ͷ�ʡ��µ����ѡ���Ͷ��Ͷ����һ���ڣ�ǰ�����д����ļ�¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0203_1'
      from
        cr_trans t,cr_rel r,cr_policy p
      where
          t.contno=r.contno
      and p.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate) > trunc(add_months(tmp_t.requestdate,v_threshold_year*(-12)))  --������һ��ǰ
          and trunc(t.requestdate) < trunc(add_months(tmp_t.requestdate,v_threshold_year*(12)))   --������һ���
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and ((tmp_t.transtype in ('TB001','LQ002')) or (tmp_t.transtype like 'FC%' and tmp_t.payway='02'))
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and ((t.transtype in ('TB001','LQ002')) or (t.transtype like 'FC%' and t.payway='02'));


    --�����α꣺ͬһͶ����һ������8�Σ�����8�������˱��ﵽ300��
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0203_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼������������������Ľ�����Ϊ��¼ͷ
declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_year*(12)))
						and tmp.args5='C0203_2'
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count
        )
		and a.args5='C0203_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴������һ���Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_year*(12)))
				 and args5 = 'C0203_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷһ���ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_year*(12)))
							and args5 = 'C0203_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0203', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0203_1','C0203_2');
end proc_aml_C0203;
/

prompt
prompt Creating procedure PROC_AML_C0300
prompt =================================
prompt
create or replace procedure proc_aml_C0300(i_baseLine in date,i_oprater in varchar2) is

  v_threshold_money number := getparavalue('SC0300', 'M1');    -- ��ֵ �ۼƱ��ѽ��
  v_threshold_month number := getparavalue('SC0300', 'D1');      -- ��ֵ ��Ȼ��
  v_threshold_count number := getparavalue('SC0300', 'N1');    -- ��ֵ ׷�ӱ��Ѵ���
  v_dealNo lxistrademain.dealno%type;               -- ���ױ��(ҵ���)
	v_clientno cr_client.clientno%type;  -- �ͻ���

begin
-- =============================================
  -- Rule:
  -- ͬһͶ����3�����ڣ��������3�Σ�����3�����ϣ��Ҵ�����֮��200������
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM
  --     ��ȡǰһ��������ȫ��ı�����
  --  4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  5) ��������ֵΪ200��ʵ��Ϊ��������ʽ
  -- parameter in:	i_baseLine ��������
  -- 								i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����촥�������Ͷ�����������ڣ�ǰ�����д����ļ�¼
insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
		args1,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        t.payamt,
        t.requestdate,
        t.transdate,
				t.transtype,
				'C0300_1'
      from
        cr_trans t,cr_rel r
      where
          t.contno=r.contno
      and exists(
          select 1
          from
              cr_trans tmp_t,cr_rel tmp_r
          where
              tmp_t.contno=tmp_r.contno
          and tmp_r.clientno=r.clientno
          and trunc(t.requestdate)>trunc(add_months(tmp_t.requestdate,-abs(v_threshold_month))) --������3����ǰ
          and trunc(t.requestdate)<trunc(add_months(tmp_t.requestdate,abs(v_threshold_month)))  --������3���º�
          and tmp_t.conttype='1'         -- ����
          and tmp_r.custype='O'
          and tmp_t.transtype = 'JK001'
					and trunc(tmp_t.transdate) = trunc(i_baseline)
          )
      and r.custype='O'  --ͬһͶ����
      and t.conttype='1'
      and (t.transtype = 'JK001');

--ͬһͶ�����������ڣ�ǰ��3�Σ�����3���������ۼ��ѽ����Ѵ��ڷ�ֵ
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
		args1,
		args5)
      select
				CustomerNo,
        TranId,
        PolicyNo,
				TranMoney,
				TimeArgs1,
				args1,
				'C0300_2'
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
          group by
            tmp.customerno
          having
              count(tmp.customerno) >= v_threshold_count
        )
    and exists(
      select 1
      from
        LXAssistA tmp
      where
        tmp.customerno = a.customerno
      group by
        tmp.customerno
      having sum(tmp.tranmoney) >= v_threshold_money
    )
      order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
	declare
    cursor baseInfo_sor is
      select
         CustomerNo,
         TranId,
         TimeArgs1
      from
        LXAssistA a
      where
        exists(
          select 1
          from
            LXAssistA tmp
          where
            tmp.customerno = a.customerno
						and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
						and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
						and tmp.args5='C0300_2'
          group by
            tmp.customerno
          having
            count(tmp.customerno) >= v_threshold_count
        )
		and a.args5='C0300_2'
    order by a.customerno, a.timeargs1 desc;

    -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;
		v_money cr_trans.payamt%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷÿ����¼�鿴�������������Ƿ�������ֵ
			select sum(temp.tranmoney) into v_money from
				(select tranmoney from lxassista where
				 trunc(TimeArgs1) >= trunc(c_requestdate)
				 and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
				 and args5 = 'C0300_2' and customerno = c_clientno) temp;

			-- ��������ֵ�ļ�¼ͷ�������ڵļ�¼Ϊ���ռ�¼
			if v_money>=v_threshold_money THEN
					declare
						cursor baseInfo_sor_date is
							select *
							from lxassista
							where trunc(TimeArgs1) >= trunc(c_requestdate)
							and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
							and args5 = 'C0300_2' and customerno = c_clientno;

					c_row baseInfo_sor_date%rowtype;

				begin
				for c_row in baseInfo_sor_date loop
					-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
            if v_clientno is null or c_clientno <> v_clientno then
            v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

            -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
            PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_row.customerno,c_row.policyno, i_oprater, 'SC0300', i_baseLine);
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
            v_clientno := c_clientno; -- ���¿�������Ŀͻ���

            else
            -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
            PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

            end if;

					-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
					PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

					-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
					PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

					-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
					PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

					-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
					PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
				end loop;

				end;
			end if;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('C0300_1','C0300_2');
end proc_aml_C0300;
/

prompt
prompt Creating procedure PROC_AML_C0400
prompt =================================
prompt
create or replace procedure proc_aml_C0400(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC0400', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
  v_clientno cr_client.clientno%type;                       -- �ͻ���

begin
  -- =============================================
  -- Rule:
  -- Ͷ���ˡ�����������ĵ������˻����ɱ��ѣ���׷�ӱ��ѣ����ҽ��ﵽ��ֵ
  --  1)��ȡ����ά��
  --    ����������OLAS��IGM
  --    ��ȡǰһ��Ͷ���ˡ�����������ĵ������˻����ɱ��ѵı�������Autopay�еĽ��Ѽ�¼��
  --  2)��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/18
  -- Changes log:
  --     Author     Date        Description
  --     ���쿭   2019/05/20    ���㷧ֵ�޸�Ϊͨ�������Ž��з���ͳ��
  --     baishuai 2019/1/6      �ϵ���ֵΪ �����ڻ����20��;ȥ������Ȩ����ǩԼ�ĵ�����

  -- =============================================
 declare
         cursor baseInfo_sor is
               select
                r.clientno,
                t.transno,
                t.contno
              from
                cr_trans t, cr_rel r
              where
                    t.contno = r.contno
               -- ���㱣���½����ܶ�����ֵ�Ƚ�
               and exists (
                      select 1
                      from
                        cr_trans temp_t,cr_rel temp_r
                      where r.contno = temp_t.contno
                        and r.clientno=temp_r.clientno
                        and temp_r.contno=temp_t.contno
                        and temp_r.custype='O'
                        and isthirdaccount(temp_t.contno,temp_t.accname,'1')='yes'--������
                        and temp_t.payway='01'
                        and temp_t.conttype='1'
                        and temp_t.transtype not in( 'HK001','PAY01','PAY02','PAY03','PAY04') -- ����(HK001)����������ʽ���뽻��
                      group by temp_t.contno
                        having sum(abs(temp_t.payamt))>=v_threshold_money
                  )
                and exists(
                    select
                          1
                      from cr_trans tr, cr_rel re
                       where
                            tr.contno = re.contno
                        and r.contno=re.contno
                        and isthirdaccount(tr.contno,tr.accname,'1')='yes'
                        and re.custype='O'
                        and tr.conttype='1'
                        and tr.payway='01'
                        and tr.transtype not in( 'HK001','PAY01','PAY02','PAY03','PAY04')    -- ����(HK001)����������ʽ���뽻��
                        and trunc(tr.transdate) = trunc(i_baseLine)
                )
                and isthirdaccount(t.contno,t.accname,'1')='yes'          -- ʹ�õ������˻�
                and t.transtype not in( 'HK001','PAY01','PAY02','PAY03')
                and t.payway='01'
                and r.custype = 'O'                -- �ͻ����ͣ�O-Ͷ����
                and t.conttype = '1'              -- �������ͣ�1-����
                order by r.clientno,t.transdate desc;




        -- �����α����
        c_clientno cr_client.clientno%type;   -- �ͻ���
        c_transno cr_trans.transno%type;      -- ���ױ��
        c_contno cr_trans.contno%type;        -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ͬһ��������������
        if v_clientno is null or c_clientno <> v_clientno then

          v_dealNo :=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0400', i_baseLine);

          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');

          v_clientno := c_clientno; -- ���¿�������Ŀͻ���
        else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

        end if;

        -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
        PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

        -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
        PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

        -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
        PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

        -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
        PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;
  end;
end proc_aml_C0400;
/

prompt
prompt Creating procedure PROC_AML_C0500
prompt =================================
prompt
create or replace procedure proc_aml_C0500(i_baseLine in date,i_oprater in VARCHAR2) is

	v_threshold_money number := getparavalue('SC0500', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
	v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
	-- Rule:
	-- ��ȫ�����ĸ������֧����Ͷ��������ĵ������˻����ҽ��ﵽ��ֵ
	--  1)��ȡ����ά��
	--		����������OLAS��IGM
	--		��ȡǰһ����������ౣȫ��ı�����
  --  2)��������ֵΪ5��ʵ��Ϊ��������ʽ
	-- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
  --     Author     Date        Description
  --     baishuai   2019/01/06      �ϵ���ֵΪ �����ڻ����20��;ȥ������Ȩ����ǩԼ�ĵ�����

	-- =============================================
 declare

        cursor baseInfo_sor is
               select
                r.clientno,
                t.transno,
                t.contno
              from
                cr_trans t, cr_rel r
              where
                    t.contno = r.contno
               -- ���㱣���½����ܶ�����ֵ�Ƚ�
               and exists (
                      select 1
                      from
                        cr_trans temp_t, cr_rel temp_r
                      where r.contno = temp_r.contno
                        and r.clientno = temp_r.clientno
                        and temp_r.contno = temp_t.contno
                        and temp_r.custype='O'
                        and isthirdaccount(temp_t.contno,temp_t.accname,'2')='yes'
                        and temp_t.payway='02'
                        and temp_t.conttype='1'
                        and temp_t.transtype not in('CLM01','CLM02','CLM03','PAY01','PAY02','PAY03','PAY04')-- ��������������ʽ���������
                      group by temp_r.clientno,temp_r.contno
                        having sum(abs(temp_t.payamt))>=v_threshold_money
                  )
                and exists(
                    select
                          1
                      from cr_trans tr, cr_rel re
                       where
                            tr.contno = r.contno
                        and r.clientno=re.clientno
                        and r.contno=re.contno
                        and isthirdaccount(tr.contno,tr.accname,'2')='yes'
                        and re.custype='O'
                        and tr.payway='02'
                        and tr.conttype='1'
                        and tr.transtype not in('CLM01','CLM02','CLM03','PAY01','PAY02','PAY03','PAY04')   -- ��������������ʽ���������
                        and trunc(tr.transdate) = trunc(i_baseLine)
                )
                and isthirdaccount(t.contno,t.accname,'2')='yes'				-- ʹ�õ������˻�
                and t.transtype not in('CLM01','CLM02','CLM03','PAY01','PAY02','PAY03','PAY04') -- ��������������ʽ���������
                and t.payway='02'
                and r.custype = 'O'                -- �ͻ����ͣ�O-Ͷ����
                and t.conttype = '1'              -- �������ͣ�1-����
                order by r.clientno,t.transdate desc;

        -- �����α����
        c_clientno cr_client.clientno%type;   -- �ͻ���
        c_transno cr_trans.transno%type;      -- �ͻ����֤������
        c_contno cr_trans.contno%type;        -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0500', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;
  end;
end proc_aml_C0500;
/

prompt
prompt Creating procedure PROC_AML_C0600
prompt =================================
prompt
create or replace procedure proc_aml_C0600(i_baseLine in date,i_oprater in VARCHAR2) is

  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��
  v_threshold_money number := getparavalue('SC0600', 'M1'); -- ��ֵ

begin
-- =============================================
	-- Rule:
	-- �����Ϣ��payment�󣬽��е�����˱����
	--  1)��ȡ����ά��
	--		����������OLAS��IGM
	--		��ȡǰһ����payment�ϲ���������˱�����ı�����
  --  2)���������������÷�ֵ
	-- �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
  --     Author     Date        Description
	-- =============================================
 declare
    cursor baseInfo_sor is
       select
        r.clientno,
        t.transno,
        t.contno
      from cr_trans t, cr_rel r
      where
						t.contno = r.contno
        and exists(
          select
               1
            from
              cr_rel re,cr_trans tr
            where
              r.clientno=re.clientno
            and
              r.contno=re.contno
            and
              re.contno=tr.contno
            and
              re.custype='O'
            and
              tr.payway='02'
            and
              tr.transtype in ('PAY01','PAY02','PAY03','PAY04')
            and
              tr.IsThirdAccount= '1'					       -- ʹ�õ������˻�
            and
              tr.conttype='1'
            group by
              re.clientno,tr.contno
            having
              sum(abs(tr.payamt))>=v_threshold_money -- ��ֵ������
          )
        and exists(
            select
                  1
              from cr_trans tr, cr_rel re
               where
                    tr.contno = r.contno
                and r.clientno=re.clientno
                and tr.transtype in( 'PAY01','PAY02','PAY03','PAY04')
                and tr.IsThirdAccount= '1'					-- ʹ�õ������˻�
                and tr.conttype='1'
                and re.custype='O'
                and tr.payway='02'
                and trunc(tr.transdate) = trunc(i_baseLine)
        )
				and t.transtype in( 'PAY01','PAY02','PAY03','PAY04')
        and r.custype='O'
				and t.IsThirdAccount= '1'					-- ʹ�õ������˻�
        and t.payway='02'
        and t.conttype = '1'							-- �������ͣ�1-����
        order by r.clientno,t.transdate desc;



				 -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

				-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0600', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;

  end;
end proc_aml_C0600;
/

prompt
prompt Creating procedure PROC_AML_C0700
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_C0700 (i_baseLine in date,i_oprater in varchar2) is
	v_dealNo lxistrademain.dealno%type;													-- ���ױ��(ҵ���)
	v_threshold_money number := getparavalue('SC0700', 'M1');		-- ��ֵ �ۼƱ��ѽ��
	v_clientno cr_client.clientno%type;  -- �ͻ���
BEGIN
	-- =============================================
	-- Rule:
	-- ��Ͷ��������ĵ������˻��������ҽ��ﵽ��ֵ
	-- 1) ��ȡ����ά��
	--    ��������OLAS��IGM
	--    ��ȡǰһ�컹���ı�������Autopay�л����ķ��ü�¼��
	-- 2)  �������˻��жϹ���PRELA NOT IN (��O1��)
	-- 3) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- 4) ��������ֵΪ5��ʵ��Ϊ��������ʽ
  -- 5����Ͷ���˵ĵ��컹������ǵ����������ۼƸ�Ͷ������ΪͶ�������µ�������Ч�����ĵ���������
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater ������
	-- parameter out: none
	-- Author: xiesf
	-- Create date: 2019/04/02
	-- Changes log:
	--     Author     Date         Description
  --    zhouqk  2019/05/20    ���㷧ֵ����Ϊͨ�������Ž��з���ͳ�Ʒ�ֵ�����ж�
  --    zhouqk  2019/05/23    ���㷧ֵʹ�ÿͻ�����������Ч�����Ľ��׽�����ֵ���бȽ�
	-- =============================================
	DECLARE
		    --�����α� ��ѯͶ��������ĵ������˻��������ҽ��ﵽ��ֵ����Ϣ
        cursor baseInfo_sor is
               select
                r.clientno,
                t.transno,
                t.contno
              from
                cr_trans t, cr_rel r
              where
                    t.contno = r.contno
                 -- ���㱣���½����ܶ�����ֵ�Ƚ�
                 and exists (
                      select 1
                      from
                        cr_trans temp_t, cr_rel temp_r
                      where r.clientno = temp_r.clientno
                        and temp_r.contno = temp_t.contno
                        and temp_t.transtype ='HK001'       -- ��������Ϊ����
                        and (temp_t.isthirdaccount='1' or isthirdaccount(temp_t.contno,temp_t.accname,'2')='yes')
                        and isvalidcont(temp_t.contno)='yes'-- ��Ч����
                        and temp_r.custype='O'
                        and temp_t.conttype='1'
                      group by temp_r.clientno
                        having sum(abs(temp_t.payamt))>=v_threshold_money
                  )
                and exists(
                    select
                          1
                      from cr_trans tr, cr_rel re
                       where
                            tr.contno = re.contno
                        and r.clientno=re.clientno
                        and re.custype='O'
                        and tr.conttype='1'
                        and tr.transtype ='HK001'           -- ��������Ϊ����
                        and (tr.isthirdaccount='1' or isthirdaccount(tr.contno,tr.accname,'2')='yes')
                        and trunc(tr.transdate) = trunc(i_baseLine)
                )
                and t.transtype = 'HK001'
                and r.custype='O'
                and (t.IsThirdAccount= '1'or isthirdaccount(t.contno,t.accname,'2')='yes')					-- ʹ�õ������˻�
                and t.conttype = '1'							          -- �������ͣ�1-����
                order by r.clientno,t.transdate desc;

			-- �����α����
			c_clientno cr_client.clientno%type;	-- �ͻ���
			c_transno cr_trans.transno%type;		-- �ͻ����֤������
			c_contno cr_trans.contno%type;			-- ������

  begin
		open baseInfo_sor;
		loop
			-- ��ȡ��ǰ�α�ֵ����ֵ������
			fetch baseInfo_sor into c_clientno,c_transno,c_contno;
			exit when baseInfo_sor%notfound;  -- �α�ѭ������
				-- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0700', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
		end loop;
		close baseInfo_sor;
	END;
end PROC_AML_C0700;
/

prompt
prompt Creating procedure PROC_AML_C0801
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_C0801 (i_baseLine in date,i_oprater in varchar2) is
  v_dealNo lxistrademain.dealno%type;                         -- ���ױ��(ҵ���)
  v_threshold_count number := getparavalue('SC0801', 'N1');   -- ��ֵ �ۼƴ���
  v_threshold_month NUMBER := getparavalue ('SC0801', 'D1' ); -- ��ֵ ��Ȼ��
BEGIN
  -- =============================================
  -- Rule:
  -- ��ͬһͶ���˵ı����������ౣȫ��Ŀ������ͬһ�������˻�������ﵽ���μ����ϡ�
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM��
  --    ��ȡǰһ�츶���ౣȫ��Ч�ı�����
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ3�Σ�ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- i_oprater ������
  -- parameter out: none
  -- Author: xiesf
  -- Create date: 2019/04/02
  -- Changes log:
  --     Author     Date     Description
  -- =============================================
  DECLARE
  -- �����α꣺ͬһͶ���˰����ڸ����ౣȫ��Ŀ����ͬһ�������˻�����3�μ�����
  cursor baseInfo_sor is
      select r.clientno, t.transno, t.contno
        from cr_trans t, cr_rel r
       where t.contno = r.contno
            -- �жϰ�����֧������������ĵ������˻�3�μ�����
         and exists
       (select 1
                from cr_trans tr, cr_rel re
               where re.clientno = r.clientno
                 and tr.contno = re.contno
                    -- �������ڵ��췢����������¼�
                 and exists
               (select 1
                        from cr_trans tmp_tr, cr_rel tmp_re
                       where re.clientno = tmp_re.clientno
                         and tmp_tr.contno = tmp_re.contno
                         and tmp_re.custype = 'O'
                         and tmp_tr.IsThirdAccount = '1' -- �Ƿ�ʹ�õ������˻�����
                         and tmp_tr.transtype in ('PAY01', 'PAY02') -- �������ͣ��������
                         and tmp_tr.conttype = '1'
                         and tmp_tr.payway = '02'
                         and trunc(tmp_tr.transdate) = trunc(i_baseLine) -- �������ڵ���
                      )
                 and re.custype = 'O'
                 and tr.IsThirdAccount = '1' -- �Ƿ�ʹ�õ������˻�����
                 and tr.transtype in ('PAY01', 'PAY02') -- �������ͣ��������
                 and tr.conttype = '1'
                 and tr.payway = '02'
                 and trunc(tr.transdate) >
                     trunc(ADD_MONTHS(i_baseLine, -v_threshold_month)) -- ���������ڰ�����
                 and trunc(tr.transdate) <= trunc(i_baseLine) -- ���������ڰ�����
               group by re.clientno,tr.accname
              having count(tr.transno) >= v_threshold_count)
         and r.custype = 'O'
         and t.conttype = '1'
         and t.payway = '02'
         and t.transtype in ('PAY01', 'PAY02')
         and trunc(t.transdate) >
             trunc(ADD_MONTHS(i_baseLine, -v_threshold_month)) -- ���������ڰ�����
         and trunc(t.transdate) <= trunc(i_baseLine) -- ���������ڰ�����
       order by r.clientno, t.transdate desc;

     -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0801', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;

  end;
END PROC_AML_C0801;
/

prompt
prompt Creating procedure PROC_AML_C0802
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_C0802(i_baseLine in date,i_oprater in varchar2) is

	v_dealNo lxistrademain.dealno%type;													-- ���ױ��(ҵ���)
	v_threshold_count number := getparavalue('SC0802', 'N1');		-- ��ֵ �ۼƴ���
	v_threshold_month NUMBER := getparavalue ('SC0802', 'D1' );		-- ��ֵ ��Ȼ��

BEGIN
	-- ============================================
	-- Rule:
	-- ��ʰ������������֧��������������ĵ������˻�������ﵽ���μ�����
	-- 1) ��ȡ����ά��
	--    ��������OLAS��IGM
	--    ��ȡǰһ�츶���ౣȫ��Ч�ı������⸶������᰸�ı���
	-- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
	-- 3) ��������ֵΪ3�Σ�ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	-- 							 i_oprater ������
	-- parameter out: none
	-- Author: xiesf
	-- Create date: 2019/04/01
	-- Changes log:
	--     Author     Date     Description
  --     baishuai  2020/1/19 ȥ������Ȩ����ǩԼ�ĵ����� 
	-- ============================================
  DECLARE
  -- �����α꣺������������������֧��������������ĵ������˻�����3�μ�����
  cursor baseInfo_sor is
        select r.clientno, t.transno, t.contno
          from cr_trans t, cr_rel r
         where t.contno = r.contno
              -- �жϰ�����֧������������ĵ������˻�3�μ�����
           and exists
         (select 1
                  from cr_trans tr, cr_rel re
                 where re.clientno = r.clientno
                   and tr.contno = re.contno
                   and not exists (select 1
                          from cr_client cl, cr_rel res
                         where cl.clientno = res.clientno
                           and res.contno = re.contno
                           and cl.name = tr.accname
                           and res.custype='B')
                      -- �������ڵ��췢����������¼�
                   and exists
                 (select 1
                          from cr_trans tmp_tr, cr_rel tmp_re
                         where re.clientno = tmp_re.clientno
                           and tmp_tr.contno = tmp_re.contno
                           and tmp_re.custype = 'O'
                           and isthirdaccount(tmp_tr.contno,tmp_tr.accname,'3')='yes'      -- �Ƿ�ʹ�õ������˻�����
                           and tmp_tr.transtype = 'PAY03' -- �������ͣ��������
                           and tmp_tr.conttype = '1'
                           and tmp_tr.payway = '02'
                           and trunc(tmp_tr.transdate) = trunc(i_baseLine) -- �������ڵ���
                        )
                        and re.custype = 'O'
                   and isthirdaccount(tr.contno,tr.accname,'3')='yes'     -- �Ƿ�ʹ�õ������˻�����
                   and tr.transtype = 'PAY03' -- �������ͣ��������
                   and tr.conttype = '1'
                   and tr.payway = '02'
                   and trunc(tr.transdate) >
                       trunc(ADD_MONTHS(i_baseLine, -v_threshold_month)) -- ���������ڰ�����
                   and trunc(tr.transdate) <= trunc(i_baseLine) -- ���������ڰ�����
                 group by re.clientno
                having count(tr.IsThirdAccount) >= v_threshold_count and count(distinct tr.accname)= 1)
           and r.custype = 'O'
           and t.conttype = '1'
           and t.payway = '02'
           and t.transtype = 'PAY03'
           and trunc(t.transdate) >
               trunc(ADD_MONTHS(i_baseLine, -v_threshold_month)) -- ���������ڰ�����
           and trunc(t.transdate) <= trunc(i_baseLine) -- ���������ڰ�����
         order by r.clientno, t.transdate desc;



      -- �����α����
      c_clientno cr_client.clientno%type;   -- �ͻ���
      c_transno cr_trans.transno%type;      -- �ͻ����֤������
      c_contno cr_trans.contno%type;        -- ������

      v_clientno cr_client.clientno%type;   -- �ͻ���

  begin

    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno,c_transno,c_contno;

        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0802', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
      end loop;
    close baseInfo_sor;

  end;
end PROC_AML_C0802;
/

prompt
prompt Creating procedure PROC_AML_C0900
prompt =================================
prompt
create or replace procedure proc_aml_C0900 ( i_baseLine in date, i_oprater in varchar2 ) is

  v_dealNo lxistrademain.dealno%type;                            -- ���ױ��
  v_threshold_money NUMBER := getparavalue ( 'SC0900', 'M1' );   -- ��ֵ Ӧ�����
  v_threshold_year NUMBER := getparavalue ( 'SC0900', 'D1' );    -- ��ֵ ��Ȼ��

begin
  -- =============================================
  -- Rule:
  -- ���Ͷ���˺�һ���ڰ�������ౣȫҵ����Ӧ�����ﵽ��ֵ
  -- 1) ��ȡ����ά��
  --    ��������OLAS��IGM
  --    ��ȡ��ǰһ�ղ��������ౣȫҵ���payment���ü�¼��
  -- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 3) ��������ֵΪ5��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --                             i_oprater  ������
  -- i_oprater ������
  -- parameter out: none
  -- Author: xiesf
  -- Create date: 2019/03/27
  -- Changes log:
  --     Author     Date     Description
  -- =============================================
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    Trantime,
    args5)
  select
    r.clientno,
    t.transno,
    r.contno,
    t.payamt,
    t.transdate,
    'C0900'
  from
    cr_rel r,cr_trans t
  where r.contno=t.contno
  -- �ж�һ��֮�ڷ�����Ͷ���˱��
  and exists(
        select
            1
        from
            cr_trans tr
        where
            tr.contno = t.contno
        and trunc(tr.transdate) <= trunc(t.transdate)
        and tr.transtype = 'BG003'      -- ��������Ϊ���Ͷ����
        and trunc(tr.transdate) > trunc(add_months(i_baseLine, -12*v_threshold_year))
        and trunc(tr.transdate) <= trunc(i_baseLine)
    )
	-- �жϵ��췢�������ౣȫҵ��
	and exists(
        select
            1
        from
            cr_trans tr
        where
            tr.contno=t.contno        -- ͬһ�����ڽ������ڵ��췢�������ౣȫҵ��
        and tr.payway='02'            -- ������
        and tr.transtype not in ( 'CLM01','CLM02','CLM03','PAY01','PAY02','PAY03','PAY04')      -- ��������Ϊ�����ౣȫҵ��
        and trunc(tr.transdate) = trunc(i_baseLine)
    )
	and r.custype = 'O'
	and t.conttype = '1'
	and t.payway='02'
	and t.transtype not in ('CLM01','CLM02','CLM03','PAY01','PAY02','PAY03','PAY04')              -- ��������Ϊ�����ౣȫҵ��
	and trunc(t.transdate) > trunc(add_months(i_baseLine, -12*v_threshold_year))
	and trunc(t.transdate) <= trunc(i_baseLine);

  declare
  -- �����α꣺�����ܹ���������������Ϣ
  cursor baseInfo_sor is
    select
      CustomerNo,
      TranId,
      PolicyNo
    from
      lxassista l
    where exists(
      select
          1
      from
          lxassista lx
      where l.CustomerNo=lx.CustomerNo
      and   l.PolicyNo=lx.PolicyNo
      group by
          CustomerNo,PolicyNo
      having
          sum(abs(TranMoney)) >= v_threshold_money
    )
    order by
        CustomerNo,
        Trantime desc;

        -- �����α����
        c_clientno cr_client.clientno%type;   -- �ͻ���
        c_transno cr_trans.transno%type;      -- �ͻ����֤������
        c_contno cr_trans.contno%type;        -- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC0900', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
  delete from LXAssistA where args5 in ('C0900');
END PROC_AML_C0900;
/

prompt
prompt Creating procedure PROC_AML_C1000
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_C1000 ( i_baseLine IN DATE, i_oprater IN VARCHAR2 ) is

  v_dealNo lxistrademain.dealno % TYPE;                              -- ���ױ��
  v_threshold_money NUMBER := getparavalue ( 'SC1000', 'M1' );      -- ��ֵ Ӧ�����
  --v_threshold_percentage NUMBER := getparavalue ( 'SC1000', 'P1' );  -- ��ֵ

BEGIN
-- =============================================
-- Rule:
-- ֵ���������˱����˱�Ӧ�����С���ۼ��ѽ����ѵ�50%���˱������ڵ��ڷ�ֵ
-- 1) ��ȡ����ά��
--    ��������OLAS��IGM
--    ��ȡ��ǰһ�ղ��������˱���ȫ��ı�����
-- 2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
-- 3) ��������ֵΪ5��ʵ��Ϊ��������ʽ
-- parameter in: i_baseLine ��������
--                i_oprater ������
-- parameter out: none
-- Author: xiesf
-- Create date: 2019/03/27
-- Changes log:
--     Author     Date     Description
--     baishuai   2020/01/02   �˱���ʧ�ļ��㹫ʽ������ ��������ȡ������ֵ�Ľ�Ӧ�����˱���ʧ
-- =============================================
delete from lxassista;
--��ȡ�ñ����µĽ����
insert into lxassista(
       policyno,
       numargs1,
       args5)
  select t.contno, sum(t.payamt), 'SC1000_1'
    from cr_trans t, cr_rel r
   where t.contno = r.contno
     and exists (select 1
            from cr_trans tmp_t, cr_rel tmp_r
           where tmp_t.contno = tmp_r.contno
             and tmp_t.contno = t.contno
             and tmp_t.transtype = 'TB001' --��ȫ����:�����˱�
             and tmp_t.payway = '02'
             and tmp_r.custype = 'O'
             and tmp_t.conttype = '1'
             and trunc(tmp_t.transdate) = trunc(i_baseline))
     and t.transtype = 'JK001'
     and r.Custype = 'O'
     and t.payway = '02'
     and t.conttype = '1'
     and trunc(t.transdate)<= trunc(i_baseLine)
     group by t.contno;
--��ȡ�ñ����µ��ѻ����
insert into lxassista
  (policyno, numargs1, args5)
  select t.contno, sum(t.payamt), 'SC1000_2'
    from cr_trans t, cr_rel r
   where t.contno = r.contno
     and exists (select 1
            from cr_trans tmp_t, cr_rel tmp_r
           where tmp_t.contno = tmp_r.contno
             and tmp_t.contno = t.contno
             and tmp_t.transtype = 'TB001' --��ȫ����:�����˱�
             and tmp_t.payway = '02'
             and tmp_r.custype = 'O'
             and tmp_t.conttype = '1'
             and trunc(tmp_t.transdate) = trunc(i_baseline))
     and t.transtype = 'HK001'
     and r.Custype = 'O'
     and t.payway = '01'
     and t.conttype = '1'
     and trunc(t.transdate) <= trunc(i_baseLine)
     group by t.contno;

  DECLARE
    --�����α��ѯ�����˱�Ӧ�����С���ۼ��ѽ����ѵ�50%���˱������ڵ��ڷ�ֵ
    cursor baseInfo_sor is
      SELECT
        r.clientno,
        t.transno,
        t.contno
      FROM
        cr_policy p,
    		cr_trans t,
				cr_rel r
			WHERE
				p.contno = t.contno
				AND t.contno = r.contno
        and (p.sumprem - NVL((select lx.numargs1 from lxassista lx where lx.policyno=t.contno and lx.args5='SC1000_1'),0)--�˱���ʧ�����ڷ�ֵ
                       + NVL((select la.numargs1 from lxassista la where la.policyno=t.contno and la.args5='SC1000_2'),0)
                       - t.payamt) >= v_threshold_money
        and t.payway='02'
        and r.custype = 'O'
        AND t.transtype = 'TB001'                 --��ȫ����:�����˱�
        and t.conttype='1'
        and trunc(t.transdate)=trunc(i_baseLine)
        order by r.clientno,t.transdate desc;

		-- �����α����
		c_clientno cr_client.clientno % TYPE;		-- �ͻ���
		c_transno cr_trans.transno % TYPE;			-- ���ױ��
		c_contno cr_trans.contno % TYPE;				-- ������
	  v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1000', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
  delete from lxassista;
END PROC_AML_C1000;
/

prompt
prompt Creating procedure PROC_AML_C1100
prompt =================================
prompt
create or replace procedure proc_aml_C1100(i_baseLine in date, i_oprater in varchar2) is

  v_dealNo lxistrademain.dealno%type;	 -- ���ױ��(ҵ���)
  v_clientno cr_client.clientno%type;  -- �ͻ���

  v_threshold_year number := getparavalue('SC1100', 'D1');				-- ��ֵ ��Ȼ��
  v_threshold_prem_before number := getparavalue('SC1100', 'M1'); -- ��ֵ ׷��ǰ����
  v_threshold_prem_after number := getparavalue('SC1100', 'M2');	-- ��ֵ ׷�Ӻ󱣷�

begin
  -- =============================================
  -- Rule:
  -- ���ű�����Ͷ��һ����׷�Ӵ��ѣ���׷��ǰ����С��20��׷�Ӻ󱣷Ѵ���20�򣨼ӱ���ӱ��ѡ�������Լ����Ͷ��
  -- 1) ��׷��ǰ���ѡ���
  --?    =�ѽ�����+��������ڱ��ѣ�mode prem��*ʣ��ɷ�������mode����+ ����Ķ�Ͷ*ʣ��ɷ�����
  -- 2) ��׷�Ӻ󱣷ѡ���
  -- ?   =�ѽ�����+�����ĵ��ڱ��ѣ�mode prem��*ʣ��ɷ�������mode����+ �����Ķ�Ͷ*ʣ��ɷ�����
  -- 3) ��ȡ����ά��
  -- ? ����������OLAS��IGM��
  -- ? ��ȡ��ǰһ�ղ���׷�ӱ��ѵĵı������ұ�����Ч�վ൱ǰʱ��һ���ڣ�
  --    �����������ͣ�WT001/WT004+AB002�����ݽ���жϣ�/FC0C3/FC0C4
  --                  /FC0C5�����ݽ���жϣ�/FC0CA�����ݽ���жϣ�/FC0CM�����ݽ���жϣ�
  -- 4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  -- 5) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  -- parameter in:	i_baseLine ��������
  -- 								i_oprater ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/03/22
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk  2019/03/22  ����
  --     xuexc   2019/05/11  �޸Ĵ����߼�
  -- ===========================================

  -- ����baselineһ��ǰ����Ͷ���������������/��Ͷ������Ϣ
  insert into LXAssistA(
    TranId,
    PolicyNo,
    TranMoney,
    Trantime,
    Args1,
    Args2)
      select
          t.transno,
          t.contno,
          t.payamt,
          t.transdate,
          'C1100',
          t.transtype
      from
          cr_trans t,
          (select
               row_number() over(partition by tmp_t.contno, tmp_t.transtype order by tmp_t.transdate desc) as rn,
               tmp_t.transno,
               tmp_t.contno
           from
               cr_trans tmp_t
           where
               tmp_t.transtype in ('AB001', 'AB002') -- �������ͣ�����/��Ͷ
           and trunc(tmp_t.transdate) > add_months(trunc(i_baseline), v_threshold_year * -12)
           and trunc(tmp_t.transdate) < trunc(i_baseline)
          ) temp
      where
          t.transno = temp.transno
      and t.contno = temp.contno
      and exists(
          select 1
          from
              cr_trans tmp_t
          where
              t.contno = tmp_t.contno
          and tmp_t.transtype = 'AA001'  -- Ͷ��
          and trunc(tmp_t.transdate) > add_months(trunc(i_baseline), v_threshold_year * -12)
          and trunc(tmp_t.transdate) < trunc(i_baseline)
          )
      and temp.rn = 1
      and t.transtype in ('AB001', 'AB002') -- �������ͣ�����/��Ͷ
      and trunc(t.transdate) > add_months(trunc(i_baseline), v_threshold_year * -12)
      and trunc(t.transdate) <= trunc(i_baseline);

  -- ����baselineһ��ǰ����������/��Ͷ��Ͷ������������Ϣ
  insert into LXAssistA(
    TranId,
    PolicyNo,
    TranMoney,
    Trantime,
    Args1,
    Args2)
      select
          t.transno,
          t.contno,
          t.payamt,
          t.transdate,
          'C1100',
          'AB001'
      from
          cr_trans t
      where
      not exists(
          select 1
          from
              LXAssistA la
          where
              t.contno = la.policyno
          and la.args1 = 'C1100'
          )
      and t.transtype = 'AA001'         -- Ͷ��
      and trunc(t.transdate) > add_months(trunc(i_baseline), v_threshold_year * -12)
      and trunc(t.transdate) < trunc(i_baseline);

  declare
    -- �����α꣺��ѯͶ��һ����׷�Ӵ��ѣ���׷��ǰ����С�ڷ�ֵ��׷�Ӻ󱣷Ѵ��ڷ�ֵ�Ľ�����Ϣ
    cursor baseInfo_sor is
        select
            r.clientno, t.transno, t.contno
        from
            cr_trans t, cr_rel r
        where
            t.contno = r.contno
        and exists(
            select 1
            from cr_trans tmp_t, cr_policy tmp_p
            where
                t.contno = tmp_t.contno
            and tmp_t.contno = tmp_p.contno

           -- ׷��ǰ����С�ڷ�ֵ
            and (case when tmp_p.paymethod = '02'          -- �ɷѷ�ʽ��01:�ڽ� / 02:���ɣ�
                      then tmp_p.sumprem-t.payamt          -- ׷��ǰ���ѣ����ɣ�
                      else tmp_p.sumprem-t.payamt + tmp_p.restpayperiod * (
                        nvl((select sum(la.tranmoney) from lxassista la
                            where tmp_p.contno = la.policyno
                              and la.args2 in ('AB001','AB002')
                              and la.args1 = 'C1100'
                              and trunc(la.trantime) < trunc(t.transdate)),0))
                      end) < v_threshold_prem_before


            -- ׷�Ӻ󱣷Ѵ��ڷ�ֵ
            and (case when tmp_p.paymethod = '02'     -- �ɷѷ�ʽ��01:�ڽ� / 02:���ɣ�
                      then tmp_p.sumprem              -- ׷�Ӻ󱣷ѣ����ɣ�
                      else tmp_p.sumprem + tmp_p.restpayperiod * (tmp_p.prem +
                          nvl((select la.tranmoney from lxassista la
                            where tmp_p.contno = la.policyno
                              and la.args2 in ('AB002')
                              and la.args1 = 'C1100'
                              and trunc(la.trantime) <= trunc(t.transdate)),0))
                      end) > v_threshold_prem_after

            and tmp_t.transtype = 'AA001'  -- Ͷ��
            and trunc(tmp_t.transdate) > add_months(trunc(t.transdate), v_threshold_year * -12)
            and trunc(tmp_t.transdate) <= trunc(t.transdate)
            )
        and r.custype = 'O'  -- �ͻ����ͣ�O:Ͷ���ˣ�
        and t.payway = '01'  -- �ʽ��������01:�� / 02:����
        and t.conttype = '1' -- ��������(1:����)
        and t.transtype in( 'WT001','WT004','AB002','FC0C3','FC0C4','FC0C5','FC0CA','FC0CM')
        and trunc(t.transdate) = trunc(i_baseline)
        order by
            r.clientno , t.transdate desc;

        -- �����α����
        c_clientno cr_client.clientno%type; -- �ͻ���
        c_transno cr_trans.transno%type;    -- ���ױ��
        c_contno cr_trans.contno%type;      -- ������

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_clientno, c_transno, c_contno;
        exit when baseInfo_sor%notfound;

        -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1100', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

      end loop;
    close baseInfo_sor;

    -- ɾ��������C1100�ĸ�������
    delete from LXAssistA where Args1 = 'C1100';
  end;
end proc_aml_C1100;
/

prompt
prompt Creating procedure PROC_AML_C1200
prompt =================================
prompt
create or replace procedure proc_aml_C1200(i_baseLine in date,i_oprater in VARCHAR2) is

	v_threshold_count number := getparavalue('SC1200','N1'); 	-- ������ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
-- =============================================
	-- Rule:
	-- 	��ɱ���ΪӦ�ɱ��ѵ�1��
	--  1) ��ȡ����ά��
  --     ����������OLAS��IGM
  --     ��������׷��Ͷ�ʣ�T�����µ����ѣ�I��7������Ͷ��Q���ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ1����ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
	-- =============================================
 declare
    cursor baseInfo_sor is
      select
        r.clientno,
        t.transno,
        t.contno
      from cr_trans t, cr_rel r, cr_policy p
      where t.contno = r.contno
        and r.contno = p.contno
				and p.overprem >= p.prem * v_threshold_count
        and r.custype = 'O'										-- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'									-- �������ͣ�1-����
        and t.transtype='AA001'
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno , t.transdate desc;


				-- �����α����
				c_clientno cr_client.clientno%type;   -- �ͻ���
				c_transno cr_trans.transno%type;      -- �ͻ����֤������
				c_contno cr_trans.contno%type;        -- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1200', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_C1200;
/

prompt
prompt Creating procedure PROC_AML_C1301
prompt =================================
prompt
create or replace procedure proc_aml_C1301(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC1301', 'M1'); -- ��ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
  -- =============================================
	-- Rule:
	-- ͬһͶ�����ֽ���ɱ��ѣ�������׷��Ͷ�ʡ��µ����ѡ���Ͷ�ﵽ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
	--  1) ��ȡ����ά��
  --     ����������OLAS��IGM
  --     ǰһ���������׷��Ͷ�ʣ�T�����µ����ѣ�I��7������Ͷ��Q���ı�����(PMCL�б�����;ΪT��I��7��Q�ļ�¼)
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ5ǧ��ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
	-- ============================================
declare
    cursor baseInfo_sor is
     select
        r.clientno,
        t.transno,
        t.contno
      from
				cr_trans t, cr_rel r
      where
						t.contno = r.contno
        and exists ( -- ���㱣��������i_baseline�ֽ����ܶ�����ֵ�Ƚ�
              select 1
              from
                cr_trans temp_t,cr_rel temp_r
              where r.contno = temp_t.contno
                and r.clientno=temp_r.clientno
                and temp_r.contno=temp_t.contno
                and temp_t.transtype not in ('HK001','PAY01','PAY02','PAY03','PAY04')
                and temp_t.payway='01'
                and temp_r.custype='O'
                and temp_t.paymode='01'
                and temp_t.conttype='1'
                and trunc(temp_t.transdate) = trunc(i_baseLine)
              group by temp_r.clientno,temp_t.contno
                having sum(abs(temp_t.payamt))>=v_threshold_money
          )
        and t.transtype not in ('HK001','PAY01','PAY02','PAY03','PAY04')          --�������ͳ������������շ���
        and t.payway='01'
        and t.paymode='01'                 -- �ֽ�
        and r.custype = 'O'                -- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'               -- �������ͣ�1-����
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno,t.transdate desc;


				-- �����α����
				c_clientno cr_client.clientno%type;   -- �ͻ���
				c_transno cr_trans.transno%type;      -- �ͻ����֤������
				c_contno cr_trans.contno%type;        -- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1301', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;

end proc_aml_C1301;
/

prompt
prompt Creating procedure PROC_AML_C1302
prompt =================================
prompt
create or replace procedure proc_aml_C1302(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC1302', 'M1'); -- ��ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
-- =============================================
	-- Rule:
	-- ���������˱����˱����ѡ���ֽ�֧�����ҽ����ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
	--  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��ȡ��ǰһ��֧�� �����˱� ���õı�����
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ5ǧ��ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
	-- ============================================
 declare
    cursor baseInfo_sor is
     select
        r.clientno,
        t.transno,
        t.contno
      from
				cr_trans t, cr_rel r
      where
						t.contno = r.contno
        -- ���㱣���������ֽ����ܶ�����ֵ�Ƚ�
        and exists (
              select 1
              from
                cr_trans temp_t,cr_rel temp_r
              where r.contno = temp_t.contno
                and r.clientno= temp_r.clientno
                and temp_r.contno=temp_t.contno
                and temp_r.custype='O'
                and temp_t.conttype = '1'
                and temp_t.payway ='02'
                and temp_t.paymode='01'
                and (temp_t.transtype in ( 'TB001','LQ002') -- ��������Ϊ�����˱��������˱������������˷�
                   or
                   temp_t.transtype like 'FC%')
                and trunc(temp_t.transdate) = trunc(i_baseLine)
              group by temp_r.clientno,temp_t.contno
                having sum(abs(temp_t.payamt))>=v_threshold_money
          )
        and r.custype = 'O'              							-- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'            							-- �������ͣ�1-����
        and t.paymode='01'							 							-- ���׷�ʽΪ�ֽ�
        and t.payway='02'                             -- ���׷�ʽΪ֧��
        and(t.transtype in ( 'TB001','LQ002')  				-- ��������Ϊ�����˱��������˱������������˷�
         or
         t.transtype like 'FC%')
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno,t.transdate desc;

				-- �����α����
				c_clientno cr_client.clientno%type;  					-- �ͻ���
				c_transno cr_trans.transno%type;      				-- �ͻ����֤������
				c_contno cr_trans.contno%type;       					-- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1302', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_C1302;
/

prompt
prompt Creating procedure PROC_AML_C1303
prompt =================================
prompt
create or replace procedure proc_aml_C1303(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC1303', 'M1'); -- ��ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
-- =============================================
	-- Rule:
	-- ������ѡ���ֽ�֧�����ҽ����ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
	--  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��ȡ��ǰһ�� ֧������� �ı�������
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ5ǧ��ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/03/18
	-- Changes log:
	-- =============================================
 declare
    cursor baseInfo_sor is
     select
        r.clientno,
        t.transno,
        t.contno
      from
				cr_trans t, cr_rel r
      where
						t.contno = r.contno
         -- ���㱣���������ֽ����ܶ�����ֵ�Ƚ�
         and exists (
							select 1
							from
								cr_trans temp_t,cr_rel temp_r
							where r.contno = temp_t.contno
                and r.clientno=temp_r.clientno
                and temp_t.contno=temp_r.contno
                and temp_t.transtype in('CLM01','CLM02','CLM03')
                and temp_r.custype='O'
                and temp_t.conttype = '1'
                and temp_t.payway ='02'
                and temp_t.paymode='01'
								and trunc(temp_t.transdate) = trunc(i_baseLine)
							group by temp_r.clientno,temp_t.contno
								having sum(abs(temp_t.payamt))>=v_threshold_money
					)
        and r.custype = 'O'              							-- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'            							-- �������ͣ�1-����
        and t.paymode='01'							 							-- ���׷�ʽΪ�ֽ�
        and t.payway='02'                             -- ���׷�ʽΪ��
        and t.transtype in('CLM01','CLM02','CLM03')  	-- ��������Ϊ�ֽ�֧�������
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno��t.transdate desc;

				-- �����α����
				c_clientno cr_client.clientno%type;  					-- �ͻ���
				c_transno cr_trans.transno%type;      				-- �ͻ����֤������
				c_contno cr_trans.contno%type;       					-- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1303', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_C1303;
/

prompt
prompt Creating procedure PROC_AML_C1304
prompt =================================
prompt
create or replace procedure proc_aml_C1304(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC1304', 'M1'); -- ��ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
  -- =============================================
	-- Rule:
	-- ��������ҵ���ֽ𻹴������ֽ�֧������Ҵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
 	--  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��ȡ��ǰһ�մ�����߻����ı�����
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ5ǧ��ʵ��Ϊ��������ʽ
	-- parameter in: i_baseLine ��������
	--							 i_oprater  ������
	-- parameter out: none
	-- Author: zhouqk
	-- Create date: 2019/04/22
	-- Changes log:
  --     Author     Date        Description
  --     zhouqk   2019/04/22       ����
	-- =============================================
 declare
    cursor baseInfo_sor is
     select
        r.clientno,
        t.transno,
        t.contno
      from
				cr_trans t, cr_rel r
      where
						t.contno = r.contno
        and abs(t.payamt)>=v_threshold_money
        and r.custype = 'O'              							-- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'            							-- �������ͣ�1-����
        and t.payway='02'	 							              -- ���׷�ʽΪ��
        and t.paymode='01'                            -- ���׷�ʽΪ�ֽ�
        and t.transtype in( 'JK001','HK001')  				-- ��������Ϊ�ֽ������߻���
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno,t.transdate desc;

				-- �����α����
    c_clientno cr_client.clientno%type;    -- �ͻ���
    c_transno cr_trans.transno%type;       -- ���ױ��
    c_contno cr_trans.contno%type;         -- ������

    v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

     -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1304', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_C1304;
/

prompt
prompt Creating procedure PROC_AML_C1305
prompt =================================
prompt
create or replace procedure proc_aml_C1305(i_baseLine in date,i_oprater in VARCHAR2) is

  v_threshold_money number := getparavalue('SC1305', 'M1'); -- ��ֵ
  v_dealNo lxistrademain.dealno%type;                       -- ���ױ��

begin
-- =============================================
  -- Rule:
  -- �����ϴ���Payment�󣬿ͻ��޸���ʽתΪ�ֽ�֧����
  -- �ֽ�ʽ��ȡ���ڽ���������ֽ�ȿ���Ҵ��ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ���
  --  1) ��ȡ����ά��
  --     ����������OLAS��IGM��
  --     ��ȡ��ǰһ����payment�Ŀ���ı���
  --  2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --  3) ��������ֵΪ5ǧ��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/05/27
  -- Changes log:
  --     Author     Date        Description
  --     zhouqk   2019/05/27       ����
  -- =============================================
 declare
    cursor baseInfo_sor is
     select
        r.clientno,
        t.transno,
        t.contno
      from
        cr_trans t, cr_rel r
      where
            t.contno = r.contno
         -- ���㱣���������ֽ����ܶ�����ֵ�Ƚ�
         and exists (
              select 1
              from
                cr_trans temp_t,cr_rel temp_r
              where r.contno = temp_t.contno
                and r.clientno=temp_r.clientno
                and temp_r.contno=temp_t.contno
                and temp_r.custype='O'
                and temp_t.transtype ='PAY04'
                and temp_t.conttype = '1'
                and temp_t.payway ='02'
                and temp_t.paymode='01'
                and trunc(temp_t.transdate) = trunc(i_baseLine)
              group by temp_r.clientno,temp_t.contno
                having sum(abs(temp_t.payamt))>=v_threshold_money
          )
        and r.custype = 'O'                           -- �ͻ����ͣ�O-Ͷ����
        and t.conttype = '1'                          -- �������ͣ�1-����
        and t.paymode='01'                            -- ���׷�ʽΪ�ֽ�
        and t.payway='02'                             -- ���׷�ʽΪ��
        and t.transtype = 'PAY04'   -- ��������Ϊ�ֽ�֧�������
        and trunc(t.transdate) = trunc(i_baseLine)
        order by r.clientno��t.transdate desc;

        -- �����α����
        c_clientno cr_client.clientno%type;           -- �ͻ���
        c_transno cr_trans.transno%type;              -- �ͻ����֤������
        c_contno cr_trans.contno%type;                -- ������

        v_clientno cr_client.clientno%type;

  begin
    open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_transno,c_contno;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
          if v_clientno is null or c_clientno <> v_clientno then
          v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');  --��ȡ���ױ��(ҵ���)

          -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
          PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno, i_oprater, 'SC1305', i_baseLine);
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'1');
          v_clientno := c_clientno; -- ���¿�������Ŀͻ���

          else
          -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
          PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno,'');

          end if;

          -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
          PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

          -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
          PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

          -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
          PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

          -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
          PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);

    end loop;
    close baseInfo_sor;
  end;
end proc_aml_C1305;
/

prompt
prompt Creating procedure PROC_AML_D0100
prompt =================================
prompt
create or replace procedure proc_aml_D0100(i_baseLine in date,i_oprater in varchar2) is
  v_dealNo lxistrademain.dealno%type; -- ���ױ��
  v_csnm lxistrademain.csnm%type;     -- �ͻ���

begin
  -- =============================================
  -- Description: ��������
  --            1.�Կ��ɱ��汨�ͳɹ����𣬶���ؿͻ����г�����⣬ÿ3������Ϊһ������ڣ�
  --            2.������ڣ�����ÿͻ���Ȼ����ͬ�����������Ŀ��ɽ�����Ϊ��ϵͳ�Զ����ɽ������棬
  --              �ҽ��������к��Ǵ�3���¼�����ڸÿͻ��ÿ����������������ɽ��ף�
  --            3.������ڣ�����ÿͻ�������ͬ�����������Ŀ��ɽ�����Ϊ�����ÿͻ�������������������
  --              ���ɽ�����Ϊ��ϵͳ�����ɽ������档
  -- parameter in:  i_baseLine  ��������
  --                i_oprater   ������
  -- parameter out: none
  -- Author: hujx
  -- Create date: 2019/03/19
  -- Changes log:
  --     Author     Date     Description
  --     hujx    2019/03/19  ����
  --     caizili 2019/04/26  ����ʱ��Ͳ���Ա�������ֶθ��ģ��߼�����
  -- =============================================

  -- ��ȡ�Կ��ɱ��汨�ͳɹ����𣬼�������ٴη������ɽ�����δ���ɽ�������Ľ���
  declare
    cursor baseInfo_sor is
      select
          lxmain.dealno,
          lxmain.csnm,
          lxmain.stcr,
          (select m.orxn from LXMonitor m where lxmain.stcr = m.stcr and lxmain.csnm = m.csnm) as orxn,
          (select m.torp+1 from LXMonitor m where lxmain.stcr = m.stcr and lxmain.csnm = m.csnm) as torp,
          (select m.dealno from LXMonitor m where lxmain.stcr = m.stcr and lxmain.csnm = m.csnm) as m_dealno
      from
          lxistrademain lxmain
      where exists(
          select 1
          from
              LXMonitor m
          where
              lxmain.stcr = m.stcr
          and lxmain.csnm = m.csnm
          and m.nextmonitoringtime = trunc(i_baseLine) --�ѵ����´μ��ʱ��
          )
      and lxmain.orxn is null -- �״��ϱ��ɹ��ı�������
      and trunc(lxmain.makedate) > trunc(add_months(i_baseLine, -3))
      and trunc(lxmain.makedate) <= trunc(i_baseLine)
      order by
          lxmain.csnm;

  -- �����α����
  c_m_dealno LXMonitor.dealno%type;  -- �״��ϱ��ɹ��Ľ��ױ��
  c_dealno lxistrademain.dealno%type;-- ���ױ��
  c_csnm lxistrademain.csnm%type;    -- �ͻ���
  c_stcr lxistrademain.stcr%type;    -- ��������
  c_orxn lxistrademain.orxn%type;    --�״��ϱ��ɹ��ı�������
  c_torp lxistrademain.torp%type;    --�ϱ�����

  begin
    open baseInfo_sor;
      loop
        -- ��ȡ��ǰ�α�ֵ����ֵ������
        fetch baseInfo_sor into c_dealno, c_csnm, c_stcr, c_orxn, c_torp, c_m_dealno;
        exit when baseInfo_sor%notfound;  -- �α�ѭ������

        -- �ͻ��ű���������
		    if v_csnm is null or c_csnm <> v_csnm then
            v_dealNo := NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)
			      v_csnm := c_csnm; -- ���¿�������Ŀͻ���

            --�����ϱ�����
            update lxmonitor set torp = c_torp where dealno = c_m_dealno;

            -- ������ɽ�����Ϣ����
            insert into lxistrademain_temp(
              serialno,--��ˮ��
              dealno, -- ���ױ��
              rpnc,   -- �ϱ��������
              detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
              torp,   -- ���ʹ�����־
              dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
              odrp,   -- �������ͷ���
              tptr,   -- ���ɽ��ױ��津����
              otpr,   -- �������ɽ��ױ��津����
              stcb,   -- �ʽ��׼��ͻ���Ϊ���
              aosp,   -- �ɵ����
              stcr,   -- ���ɽ�������
              csnm,   -- �ͻ���
              senm,   -- ������������/����
              setp,   -- �����������֤��/֤���ļ�����
              oitp,   -- �������֤��/֤���ļ�����
              seid,   -- �����������֤��/֤���ļ�����
              sevc,   -- �ͻ�ְҵ����ҵ
              srnm,   -- �������巨������������
              srit,   -- �������巨�����������֤������
              orit,   -- �������巨���������������֤��/֤���ļ�����
              srid,   -- �������巨�����������֤������
              scnm,   -- ��������عɹɶ���ʵ�ʿ���������
              scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
              ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
              scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
              strs,   -- ���佻�ױ�ʶ
              datastate, -- ����״̬
              filename,  -- ��������
              filepath,  -- ����·��
              rpnm,      -- ���
              operator,  -- ����Ա
              managecom, -- �������
              conttype,  -- �������ͣ�01-����, 02-�ŵ���
              notes,     -- ��ע
              getdatamethod,  -- ���ݻ�ȡ��ʽ��01-�ֹ�¼��, 02-ϵͳץȡ��
              baseline,       -- ���ڻ�׼
              nextfiletype,   -- �´��ϱ���������
              nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
              nextpackagetype,-- �´��ϱ����İ�����
              databatchno,    -- �������κ�
              makedate,       -- ���ʱ��
              maketime,       -- �������
              modifydate,     -- ����������
              modifytime,      -- ������ʱ��
              judgmentdate,   -- ��������
              orxn)-- �Ƿ��������
              select
                getSerialno(sysdate) as serialno,
                LPAD(v_dealNo,20,'0'),
                '@N' as rpnc,
                '01' as detr,  -- ��������̶ȣ�01-���ر������
                c_torp as torp,-- ���ʹ�����ʾ
                '01' as dorp,  -- ���ͷ���01-�����й���ϴǮ���������ģ�
                '@N' as odrp,  -- �������ͷ���
                '01' as tptr,  -- ���ɽ��ױ��津���㣨01-ģ��ɸѡ��
                '@N' as otpr,  -- �������ɽ��ױ��津����
                '' as stcb,    -- �ʽ��׼��ͻ���Ϊ���
                '' as aosp,    -- �ɵ����
                a.stcr as stcr,-- ���ɽ������� ��������Ŀ�������
                a.csnm as csnm,-- �ͻ���
                a.senm as senm,-- ������������
                a.setp as setp,
                a.oitp as oitp,
                a.seid as seid,
                a.sevc as sevc,
                a.srnm as srnm,
                a.srit as srit,
                a.orit as orit,
                a.srid as srid,
                a.scnm as scnm,
                a.scit as scit,
                a.ocit as ocit,
                a.scid as scid,
                '@N' as strs,
                null as datastate,
                '' as filename,
                '' as filepath,
                i_oprater as rpnm,
                i_oprater as operator,
                a.managecom as managecom,
                a.conttype as conttype,
                '' as notes,
                '01' as getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ��
                i_baseLine as baseline,
                '' as nextfiletype,
                '' as nextreferfileno,
                '' as nextpackagetype,
                null as databatchno,
                to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
                to_char(sysdate,'hh24:mi:ss') as maketime,
                null as modifydate,-- ������ʱ��
                null as modifytime,
                null as judgmentdate,--��������
                c_orxn as ORXN --���������״��ϱ��ɹ��ı�������
              from lxistrademain a
              where a.dealno = c_m_dealno;

            -- ���뽻��������ϵ��ʽ
            insert into lxaddress_temp(
              serialno,
              DealNo,
              ListNo,
              CSNM,
              Nationality,
              LinkNumber,
              Adress,
              CusOthContact,
              DataBatchNo,
              MakeDate,
              MakeTime,
              ModifyDate,
              ModifyTime)
              select
                getSerialno(sysdate) as serialno,
                LPAD(v_dealNo,20,'0'),
                a.listno AS ListNo,
                a.csnm AS CSNM,
                a.nationality AS Nationality,
                a.linknumber AS LinkNumber,
                a.adress AS Adress,
                a.cusothcontact AS CusOthContact,
                NULL AS DataBatchNo,
                a.makedate AS MakeDate,
                a.maketime AS MakeTime,
                a.modifydate AS ModifyDate,
                a.modifytime AS ModifyTime
              from lxaddress a
              where a.dealno = c_m_dealno;
  			end if;

        -- ������ɽ�����ϸ��Ϣ
        insert into LXISTRADEDETAIL_temp(
          serialno,
          DealNo,
          TICD,
          ICNM,
          TSTM,
          TRCD,
          ITTP,
          CRTP,
          CRAT,
          CRDR,
          CSTP,
          CAOI,
          TCAN,
          ROTF,
          DataState,
          DataBatchNo,
          MakeDate,
          MakeTime,
          ModifyDate,
          ModifyTime)
          select
            getSerialno(sysdate) as serialno,
            LPAD(v_dealNo,20,'0'),
            a.ticd AS TICD,
            a.icnm AS ICNM,
            a.tstm AS TSTM,
            a.trcd AS TRCD,
            a.ittp AS ITTP,
            a.crtp AS CRTP,
            a.crat AS CRAT,
            a.crdr AS CRDR,
            a.cstp AS CSTP,
            a.caoi AS CAOI,
            a.tcan AS TCAN,
            a.rotf AS ROTF,
            '' as DataState,
            NULL AS DataBatchNo,
            a.makedate AS MakeDate,
            a.maketime AS MakeTime,
            a.modifydate AS ModifyDate,
            a.modifytime AS ModifyTime
          from lxistradedetail a
          where a.dealno = c_dealno;

        --������ɽ��׺�ͬ��Ϣ
        insert into lxistradecont_temp(
          serialno,
          DealNo,
          CSNM,
          ALNM,
          AppNo,
          ContType,
          AITP,
          OITP,
          ALID,
          ALTP,
          ISTP,
          ISNM,
          RiskCode,
          Effectivedate,
          Expiredate,
          ITNM,
          ISOG,
          ISAT,
          ISFE,
          ISPT,
          CTES,
          FINC,
          DataBatchNo,
          MakeDate,
          MakeTime,
          ModifyDate,
          ModifyTime)
          select
            getSerialno(sysdate) as serialno,
            LPAD(v_dealNo,20,'0'),
            a.csnm AS CSNM,
            a.alnm AS ALNM,
            a.appno AS APPNO,
            a.conttype AS ContType,
            a.aitp AS AITP,
            a.oitp AS OITP,
            a.alid AS ALID,
            a.altp AS ALTP,
            a.istp AS ISTP,
            a.isnm AS ISNM,
            a.riskcode AS RiskCode,
            a.effectivedate AS Effectivedate,
            a.expiredate AS Expiredate,
            a.itnm AS ITNM,
            a.isog AS ISOG,
            a.isat AS ISAT,
            a.isfe AS ISFE,
            a.ispt AS ISPT,
            a.ctes AS CTES,
            a.finc AS FINC,
            NULL AS DataBatchNo,
            a.makedate AS MakeDate,
            a.maketime AS MakeTime,
            a.modifydate AS ModifyDate,
            a.modifytime AS ModifyTime
          from lxistradecont a
          where a.dealno = c_dealno;

        -- ������ɽ��ױ�������Ϣ
        insert into lxistradeinsured_temp(
          serialno,
          DEALNO,
          CSNM,
          INSUREDNO,
          ISTN,
          IITP,
          OITP,
          ISID,
          RLTP,
          DataBatchNo,
          MakeDate,
          MakeTime,
          ModifyDate,
          ModifyTime)
          select
            getSerialno(sysdate) as serialno,
            LPAD(v_dealNo,20,'0') AS DealNo,
            a.csnm AS CSNM,
            a.insuredno AS INSUREDNO,
            a.istn AS ISTN,
            a.iitp AS IITP,
            a.oitp AS OITP,
            a.isid AS ISID,
            a.rltp AS RLTP,
            NULL AS DataBatchNo,
            a.makedate AS MakeDate,
            a.maketime AS MakeTime,
            a.modifydate AS ModifyDate,
            a.modifytime AS ModifyTime
          from lxistradeinsured a
          where a.dealno = c_dealno;

        -- ������ɽ�����������Ϣ
        insert into lxistradebnf_temp(
          serialno,
          DealNo,
          CSNM,
          InsuredNo,
          BnfNo,
          BNNM,
          BITP,
          OITP,
          BNID,
          DataBatchNo,
          MakeDate,
          MakeTime,
          ModifyDate,
          ModifyTime)
          select
            getSerialno(sysdate) as serialno,
            LPAD(v_dealNo,20,'0') AS DealNo,
            a.csnm AS CSNM,
            a.insuredno AS InsuredNo,
            a.bnfno AS BnfNo,
            a.bnnm AS BNNM,
            a.bitp AS BITP,
            a.oitp AS OITP,
            a.bnid AS BNID,
            NULL AS DataBatchNo,
            a.makedate AS MakeDate,
            a.maketime AS MakeTime,
            a.modifydate AS ModifyDate,
            a.modifytime AS ModifyTime
          from lxistradebnf a
          where a.dealno = c_dealno;

      end loop;
    close baseInfo_sor;

    -- �����´μ���ʱ��
    update lxmonitor set NextMonitoringtime = add_months(NextMonitoringtime, 3)
        where trunc(NextMonitoringtime) = trunc(i_baseLine);
  end;
end proc_aml_D0100;
/

prompt
prompt Creating procedure PROC_AML_D0600
prompt =================================
prompt
create or replace procedure PROC_AML_D0600(i_baseLine in date,
                                       i_oprater  in varchar2) is
  v_threshold_money number := getparavalue('D0600', 'M1'); -- ��ֵ ���׽��
  v_dealNo          lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno        cr_client.clientno%type; -- �ͻ���
begin
  -- =============================================
  -- Rule:
  --���ָ��:����ڱ������ڵı�����ʧЧ����
  --ָ�����:����ڱ������ڵ�Ͷ���ջ������ձ�����ʧЧ����,�ҽ��׽�����ֵ
  --��ֵ����ֵ=RMB 50��Ԫ
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date:  2020/01/02
  -- Changes log:
  --     Author     Date        Description
  --
  -- =============================================

  --��ѯ���׽���50w�Ҵ��ڻָ����պ�ͬЧ����ȡ���������ڵı�����Ϣ
 declare
    cursor baseInfo_sor is
      select  r.clientno, t.transno, t.contno
        from cr_trans t, cr_rel r
       where t.contno = r.contno
         and t.payamt >= v_threshold_money --���׽����ڷ�ֵ
         and r.custype='O'    --Ͷ����
         and t.conttype = '1' --1����
         and t.transtype in ('NP200', 'NP441') --�ָ����պ�ͬЧ����ȡ����������
         and trunc(t.transdate) = trunc(i_baseLine)
       order by r.clientno, t.transdate desc;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno  cr_trans.transno%type; -- �ͻ����֤������
    c_contno   cr_trans.contno%type; -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound; -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SD0600',
                                   i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');

      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    end loop;
    close baseInfo_sor;
  end;

end PROC_AML_D0600;
/

prompt
prompt Creating procedure PROC_AML_D0701
prompt =================================
prompt
create or replace procedure PROC_aml_D0701(i_baseLine in date,
                                       i_oprater  in varchar2) is
  v_threshold_money      number := getparavalue('D0701', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day        number := getparavalue('D0701', 'D1'); -- ��ֵ ��Ȼ��
  v_threshold_percentage number := getparavalue('D0701', 'P1'); -- ��ֵ �ٷֱ�
  v_dealNo               lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno             cr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --���ָ��:�����ڴ�����������
  --ָ�����:�������ֵ��ָ���������ۼƻ����һ������
  --��ֵ��"��ֵ=RMB30��Ԫ������=7�죬�������=60%"
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date:  2019/12/12
  -- Changes log:
  --     Author     Date        Description 
  -- =============================================
  --��ո�����
  delete from lxassista;

  --��ȡ�������������еĴ����ܶ�
  insert into lxassista
    (CustomerNo, NumArgs1, args5)
    select r.clientno, sum(t.payamt), 'D0701_01'
      from cr_trans t, cr_rel r
     where t.contno = r.contno
       and r.custype = 'O'
       and t.payway = '02' --01�� 02��
       and t.transtype = 'JK001' --����
       and t.conttype = '1' --1����
       and trunc(t.transdate) <= trunc(i_baseLine)
       and trunc(t.transdate) > trunc(i_baseLine - v_threshold_day)
     group by r.clientno
    having sum(t.payamt) >= v_threshold_money;

    --��ȡ�������������еĻ�����
    insert
      into lxassista(CustomerNo, NumArgs1, args5)
            select r.clientno, sum(t.payamt), 'D0701_02'
              from cr_trans t, cr_rel r
             where t.contno = r.contno
               and r.custype = 'O'
               and t.payway = '01' --01�� 02��
               and t.transtype = 'HK001' --����
               and t.conttype = '1' --1����
               and trunc(t.transdate) <= trunc(i_baseLine)
               and trunc(t.transdate) > trunc(i_baseLine - v_threshold_day)
             group by r.clientno;

declare
      cursor baseInfo_sor is
      --��ȡ���������Ŀͻ��ͱ�����Ϣ
       select r.clientno, t.transno, t.contno
       from cr_trans t, cr_rel r
       where t.contno = r.contno
       and exists
       (select 1  from lxassista la, lxassista lx
       where la.customerno = r.clientno
       and la.customerno = lx.customerno
       and NVL(la.Numargs1,0) >= NVL(lx.numargs1,0) * v_threshold_percentage
       and lx.args5 = 'D0701_01'
       and la.args5 = 'D0701_02')
       and r.custype = 'O'
       and t.payway = '01' --01�� 02��
       and t.transtype = 'HK001' --����
       and t.conttype = '1' --1����
       and trunc(t.transdate) = trunc(i_baseLine)
       order by r.clientno,t.transdate desc;




  -- �����α����
  c_clientno cr_client.clientno%type; -- �ͻ���
  c_transno cr_trans.transno%type; -- �ͻ����֤������
  c_contno cr_trans.contno%type; -- ������


  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor
        into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound; -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SD0701',
                                   i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');

      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    end loop;
    close baseInfo_sor;
  end;
  --��ո�����
  delete from lxassista;
end PROC_aml_D0701;
/

prompt
prompt Creating procedure PROC_AML_D0702
prompt =================================
prompt
create or replace procedure PROC_aml_D0702(i_baseLine in date, i_oprater  in varchar2) is
  v_threshold_money number := getparavalue('D0702', 'M1'); -- ��ֵ �ۼƱ��ѽ��
  v_threshold_day   number := getparavalue('D0702', 'D1'); -- ��ֵ ��Ȼ��
  v_dealNo          lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno        cr_client.clientno%type; -- �ͻ���
begin
  -- =============================================
  -- Rule:
  --���ָ��:Ͷ������ٴ���
  --ָ�����:���򱣵�������ڽ����ۼƴ������ֵ
  --��ֵ��"��ֵ=RMB50��Ԫ������=30��"
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date:  2019/12/16
  -- Changes log:
  --     Author     Date        Description
  -- =============================================
  declare
    cursor baseInfo_sor is
      select r.clientno, t.transno, t.contno
        from cr_trans t, cr_rel r
       where t.contno = r.contno
         and exists (select 1    --30�����ۼƽ�����ֵ
                from cr_trans tmp_t, cr_rel tmp_r
               where tmp_r.contno = tmp_t.contno
                     and tmp_t.contno=t.contno
                     and tmp_r.custype = 'O' --Ͷ����
                     and tmp_t.payway = '02' --01�� 02��
                     and tmp_t.transtype = 'JK001' --���
                     and tmp_t.conttype = '1' --1����
                     and trunc(tmp_t.transdate) <= trunc(i_baseLine)
                     and trunc(tmp_t.transdate) >trunc(i_baseLine - v_threshold_day)
                     group by tmp_r.contno
                     having sum(tmp_t.payamt) >= v_threshold_money)
         and exists ( --30���ڷ���Ͷ���ı���
              select 1
                from cr_trans tmp_t
               where tmp_t.contno = t.contno
                 and tmp_t.payway = '01'
                 and tmp_t.transtype = 'AA001'
                 and tmp_t.conttype = '1'
                 and trunc(tmp_t.transdate) <= trunc(i_baseLine)
                 and trunc(tmp_t.transdate) >trunc(i_baseLine - v_threshold_day))  
         and r.custype = 'O'
         and t.payway = '02' --01�� 02��
         and t.transtype = 'JK001' --���
         and t.conttype = '1' --1����
         and trunc(t.transdate) = trunc(i_baseLine)
         order by r.clientno,t.transdate;

    -- �����α����
    c_clientno cr_client.clientno%type; -- �ͻ���
    c_transno  cr_trans.transno%type; -- �ͻ����֤������
    c_contno   cr_trans.contno%type; -- ������


  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound; -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno, c_contno, i_oprater, 'SD0702',i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');

      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    end loop;
    close baseInfo_sor;
  end;
end PROC_aml_D0702;
/

prompt
prompt Creating procedure PROC_AML_D0703
prompt =================================
prompt
create or replace procedure PROC_aml_D0703(i_baseLine in date,i_oprater  in varchar2) is

  v_threshold_money      number := getparavalue('D0703', 'M1'); -- ��ֵ ������
  v_threshold_day        number := getparavalue('D0703', 'D1'); -- ��ֵ ��Ȼ��
  v_threshold_percentage number := getparavalue('D0703', 'P1'); -- ��ֵ �ٷֱ�
  v_dealNo               lxistrademain.dealno%type; -- ���ױ��(ҵ���)
  v_clientno             cr_client.clientno%type; -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --���ָ��:�˱�ʱ����δ��
  --����ͬһͶ���˵ĵ��ű������ۼƴ�������ۼ��ѽ����ѵ�50%��������ֵ���Ҵ����һ�δ�������ڵ�7���������˱�������ϵͳץȡ�����ɿ��ɽ��ף�
  --1) ��ȡ����ά��
  --����������OLAS��IGM
  --2) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --3) ��������ֵΪ20��ʵ��Ϊ��������ʽ
  --���ű����ۼƴ����� - �ۼ��ѽ�����>20��
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date:  2019/12/12
  -- Changes log:
  --     Author     Date        Description
  -- =============================================
  --��ո�����
  delete from lxassista;

  --��ȡ7���ڴ��ڴ���ı���
  insert into lxassista
    (PolicyNo, args5)
    select distinct t.contno, 'D0703_1'
      from cr_trans t, cr_rel r
     where t.contno = r.contno
       and r.custype = 'O'
       and t.payway = '02'
       and t.transtype = 'JK001'
       and t.conttype = '1'
       and trunc(t.transdate) <= trunc(i_baseLine)
       and trunc(t.transdate) > trunc(i_baseLine - v_threshold_day);

  --��ѯ���ű����µĴ����ܶ�
  insert into lxassista
    (policyno, numargs1, args5)
    select t.contno, sum(t.payamt), 'D0703_2'
      from cr_trans t, cr_rel r
     where t.contno = r.contno
       and exists (select 1
              from lxassista la
             where la.policyno = t.contno
               and la.args5 = 'D0703_1')
       and r.custype = 'O'
       and t.payway = '02'
       and t.transtype = 'JK001'
       and t.conttype = '1'
       and trunc(t.transdate) <= trunc(i_baseLine)
     group by t.contno;

   --�����α�
declare
    cursor baseInfo_sor is
      select  r.clientno, t.transno,t.contno
      from cr_trans t, cr_rel r, cr_policy p
      where t.contno = r.contno
      and t.contno = p.contno
      and exists                 --�ۼƴ���������ۼ��ѽ����ѵ�50%
      (select 1 from lxassista la
       where la.policyno = t.contno
             and la.numargs1 > p.SumPrem * v_threshold_percentage
             and la.numargs1-p.sumprem  > v_threshold_money --���ű����ۼƴ����� - �ۼ��ѽ�����>��ֵ
             and la.args5 = 'D0703_2'
       )      
      and t.payway = '02'
      and r.custype='O'
      and t.transtype = 'TB001'
      and t.conttype = '1'
      and trunc(t.transdate) = trunc(i_baseLine)
      order by r.clientno,t.transdate desc;




  -- �����α����
  c_clientno cr_client.clientno%type; -- �ͻ���
  c_transno cr_trans.transno%type; -- �ͻ����֤������
  c_contno cr_trans.contno%type; -- ������


  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound; -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SD0703',
                                   i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');

      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    end loop;
    close baseInfo_sor;
  end;
  --��ո�����
  delete from lxassista;
end PROC_aml_D0703;
/

prompt
prompt Creating procedure PROC_AML_D0800
prompt =================================
prompt
create or replace procedure PROC_aml_D0800(i_baseLine in date, i_oprater  in varchar2) is
        v_threshold_money number := getparavalue('D0800', 'M1'); -- ��ֵ �ۼƱ��ѽ��
        v_threshold_day   number := getparavalue('D0800', 'D1'); -- ��ֵ ��Ȼ��
        v_threshold_count number := getparavalue('D0800', 'N1'); -- ��ֵ ��ͬ���ָ���
        v_dealNo          lxistrademain.dealno%type; -- ���ױ��(ҵ���)
        v_clientno        cr_client.clientno%type; -- �ͻ���
begin
  -- =============================================
  -- Rule:
  --���ָ��:ͬһͶ���˹�������ͬ����
  --ָ�����:һ�������ڣ�ͬһͶ���˹�����ͬ���� ��Ͷ���ա������գ�3�ݻ����ϣ��ұ����ˡ���������ͬ���ϼƱ��ѳ�����ֵ
  --��ֵ��"����=30��,��ֵ= �껯����50��,��ͬ���� >= 3��"
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: baishuai
  -- Create date:  2019/12/19
  -- Changes log:
  --     Author     Date        Description
  -- =============================================
 
  --��ո�����
  delete from lxassista;
  
   --��ȡһ�������ڣ�ͬһͶ���˹������ͬ����3�ݻ����ϵı�����Ϣ
  insert into lxassista(PolicyNo, customerno, args1, args5)
    select  t.contno, r.clientno, rk.policytype, 'D0800_1'
      from cr_trans t, cr_rel r, cr_risk rk
     where t.contno = r.contno
       and t.contno = rk.contno
        and exists  --�������Ͷ�����߸�����
     (select 1
              from cr_trans cms_t, cr_rel cms_r
             where cms_r.contno = cms_t.contno
               and r.clientno = cms_r.clientno --ͬһ�ͻ�
               and cms_t.payway = '01'
               and cms_r.custype = 'O'
               and cms_t.transtype in('AA001','FC0C4')
               and cms_t.conttype = '1'
               and trunc(cms_t.transdate) =trunc(i_baseLine)
            )
       and exists(--��ͬ���ֳ���3��
           select 1 from cr_trans tmp_t,cr_rel tmp_r,cr_risk tmp_rk
           where tmp_t.contno=tmp_r.contno
           and tmp_t.contno=tmp_rk.contno
           and tmp_r.clientno=r.clientno--ͬһͶ����
           and tmp_rk.policytype=rk.policytype--��ͬ����
           and tmp_t.payway='01'
           and tmp_r.custype='O'
           and tmp_t.transtype in ('AA001','FC0C4')
           and tmp_t.conttype='1'
           and trunc(tmp_t.transdate) > trunc(i_baseLine - v_threshold_day)
           and trunc(tmp_t.transdate) <= trunc(i_baseLine)
           group by tmp_r.clientno,tmp_rk.policytype
           having count(tmp_rk.contno)>=v_threshold_count   
       )       
       and t.payway = '01'
       and r.custype = 'O'
       and t.transtype in('AA001','FC0C4')
       and t.conttype = '1'
       and trunc(t.transdate) > trunc(i_baseLine - v_threshold_day)
       and trunc(t.transdate) <= trunc(i_baseLine)
       order by r.clientno desc;

  --��ȡ�����˺������˵ı�����Ϣ   
insert into lxassista(PolicyNo, customerno, args5)
  select lx.policyNo, lx.customerno, 'D0800_2'
    from cr_trans t,lxassista lx
   where lx.policyno = t.contno
     and lx.args5 = 'D0800_1'
     and t.payway = '01'
     and t.transtype in('AA001','FC0C4')
     and t.conttype = '1'
     --������
    and exists(
       --ͨ���Ӳ�ѯ�鵽�����˵Ŀͻ��Ŷ�Ӧ�ı�����
       select  1  from cr_rel rr where exists
       (
       --��ѯ�����˵Ŀͻ���
          select 1 from cr_rel r where exists
              (
             select 1 from cr_rel tmp_r where tmp_r.clientno = lx.customerno
                and tmp_r.custype = 'O'
                and tmp_r.contno = r.contno
              )
              and r.custype = 'I'
              and rr.clientno = r.clientno
              group by r.clientno having count(r.clientno) >= v_threshold_count
        ) 
          and t.contno = rr.contno
          and rr.custype = 'I'
       )           
     --������
      and exists(
       --ͨ���Ӳ�ѯ�鵽�����˵Ŀͻ��Ŷ�Ӧ�ı�����
       select  1  from cr_rel rr where exists
       (
       --��ѯ�����˵Ŀͻ���
          select 1 from cr_rel r where exists
              (
             select 1 from cr_rel tmp_r where tmp_r.clientno = lx.customerno
                and tmp_r.custype = 'O'
                and tmp_r.contno = r.contno
              )
              and r.custype = 'B'
              and rr.clientno = r.clientno
              group by r.clientno having count(r.clientno) >= v_threshold_count
        ) 
          and t.contno = rr.contno
          and rr.custype = 'B'
       )               
     and trunc(t.transdate) > trunc(i_baseLine - v_threshold_day)
     and trunc(t.transdate) <= trunc(i_baseLine);

    --Ͷ�����ۼ��껯���Ѵ���50w
     declare
             cursor baseInfo_sor is
                    select r.clientno, t.transno, t.contno
                      from cr_trans t, cr_rel r
                     where t.contno = r.contno
                       and exists
                     (select 1
                              from lxassista lx, cr_policy p
                             where lx.customerno = r.clientno
                               and lx.policyno = p.contno
                               and lx.args5 = 'D0800_2'
                             group by lx.customerno
                            having sum(p.yearprem) >= v_threshold_money)
                       and exists
					               (
                       select 1 from lxassista la
                       where
                       la.policyno=t.contno
                       and la.args5='D0800_2'
                       )
                       and t.payway = '01'
                       and r.custype = 'O'
                       and t.transtype in('AA001','FC0C4')
                       and t.conttype = '1'
                       and trunc(t.transdate) = trunc(i_baseLine)
                       order by r.clientno,t.transdate desc;

                    -- �����α����
                     c_clientno cr_client.clientno%type; -- �ͻ���
                     c_transno cr_trans.transno%type; -- �ͻ����֤������
                     c_contno cr_trans.contno%type; -- ������

  begin
    open baseInfo_sor;
    loop
      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor
        into c_clientno, c_transno, c_contno;
      exit when baseInfo_sor%notfound; -- �α�ѭ������

      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
        v_dealNo := NEXTVAL2('AMLDEALNO', 'SN'); --��ȡ���ױ��(ҵ���)

        -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
        PROC_AML_INS_LXISTRADEMAIN(v_dealNo,
                                   c_clientno,
                                   c_contno,
                                   i_oprater,
                                   'SD0800',
                                   i_baseLine);
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '1');
        v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
        -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
        PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_contno, c_transno, '');

      end if;

      -- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
      PROC_AML_INS_LXISTRADECONT(v_dealNo, c_clientno, c_contno);

      -- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
      PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_contno);

      -- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
      PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_contno);

      -- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
      PROC_AML_INS_LXADDRESS(v_dealNo, c_clientno);
    end loop;
    close baseInfo_sor;
  end;
  --��ո�����
  delete from lxassista where args5 in ('D0800_1','D0800_2');
end PROC_aml_D0800;
/

prompt
prompt Creating procedure PROC_AML_EXTRAMID
prompt ====================================
prompt
create or replace procedure proc_aml_extraMID(
  startDate in VARCHAR2,
  endDate in VARCHAR2
) is
  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ
  v_errormsg LLogTrace.DealDesc%type;
  v_TraceId LLogTrace.TraceId%type;
begin
    -- =============================================
  -- Description: ��mid���е����ݷ��뵽ƽ̨����
  -- parameter in:    startDate   ��ʼ����
  --                  endDate     ��������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/04/29
  -- Changes log:
  --     Author     Date     Description
  --     czl     2019/04/29     ����
  -- =============================================
  SELECT TO_char(sysdate, 'yyyymmddHH24mmss') into v_TraceId from dual;

 -- �Ȳ���켣
   insert into LLogTrace
    (TraceId,
     FuncCode,
     StartTime,
     DealState,
     DealDesc,
     DataBatchNo,
     DataState,
     Operator,
     InsertTime,
     ModifyTime)
  values
    (v_TraceId,
     '000001',
     sysdate,
     '00',
     'ִ����',
     v_TraceId,
     '01',
     'system',
     sysdate,
     sysdate);
     commit;

 --����MID���CR���е����ݽ���ȥ�ز���
 DELETE FROM CR_Policy WHERE EXISTS(SELECT 1 FROM MID_Policy a WHERE a.ContNo = CR_POLICY.CONTNO) ;
 DELETE FROM CR_Address WHERE EXISTS(SELECT 1 FROM MID_Address a WHERE a.clientNo = CR_Address.clientNo) ;
 DELETE FROM CR_Rel WHERE EXISTS(SELECT 1 FROM MID_Rel a WHERE a.ContNo = CR_REL.ContNo);
 DELETE FROM CR_Risk WHERE EXISTS(SELECT 1 FROM MID_Risk a WHERE a.ContNo = CR_RISK.CONTNO) ;
 DELETE FROM CR_Client WHERE EXISTS(SELECT 1 FROM MID_Client a WHERE a.ClientNo = CR_CLIENT.CLIENTNO) ;
 DELETE FROM CR_Trans WHERE EXISTS(SELECT 1 FROM MID_Trans a WHERE A.TransNo = CR_TRANS.TRANSNO) ;
 DELETE FROM CR_TransDetail WHERE EXISTS(SELECT 1 FROM MID_TransDetail a WHERE A.TransNo = CR_TransDetail.TransNo AND a.contno = CR_TRANSDETAIL.CONTNO) ;

--CR_Address(�ͻ�����������������ȡ)
  INSERT INTO CR_ADDRESS (
    clientno,
    ListNo,
    clienttype,
    LinkNumber,
    Adress,
    CusOthContact,
  nationality,
    country,
    MakeDate,
    MakeTime,
    batchno,
    conttype)
  (
    select
      A.clientno AS clientno,
      ROW_NUMBER () OVER (ORDER BY clientno) AS ListNo,
      A.ClientType AS clienttype,
      A.linknumber AS LinkNumber,
      A.adress AS Adress,
      A.CusOthContact AS CusOthContact,
      A.Nationality AS nationality,
      A.Country AS country,
      A.MakeDate,
      A.MakeTime,
      v_TraceId AS batchno,
      A.conttype AS conttype
    from
     MID_Address  A
  );

--cr_client(�ͻ�������Ϣ��������ȡ)
    INSERT INTO CR_CLIENT
  select clientno,
        originalclientno,
        source,
        name,
        birthday,
        age,
        sex,
        grade,
        cardtype,
        othercardtype,
        cardid,
        cardexpiredate,
        clienttype,
        workphone,
        familyphone,
        telephone,
        occupation,
        businesstype,
        income,
        grpname,
        address,
        otherclientinfo,
        zipcode,
        nationality,
        comcode,
        conttype,
        businesslicenseno,
        orgcomcode,
        taxregistcertno,
        legalperson,
        legalpersoncardtype,
        otherlpcardtype,
        legalpersoncardid,
        linkman,
        comregistarea,
        comregisttype,
        combusinessarea,
        combusinessscope,
        appntnum,
        comstaffsize,
        grpnature,
        founddate,
        holderkey,
        holdername,
        holdercardtype,
        otherholdercardtype,
        holdercardid,
        holderoccupation,
        holderradio,
        holderotherinfo,
        relaspecarea,
        fatctry,
        countrycode,
        suspiciouscode,
        fundsource,
        Makedate,
        MakeTime,
        v_TraceId,
        idverifystatus,
        isfatcaandcrs
        from mid_client;

--CR_Policy(������Ϣ��������ȡ)
  INSERT INTO CR_POLICY
  select contno,
         conttype,
         locid,
         prem,
         amnt,
         paymethod,
         contstatus,
         effectivedate,
         expiredate,
         accountno,
         sumprem,
         mainyearprem,
         yearprem,
         agentcode,
         grpflag,
         source,
         inssubject,
         investflag,
         remainaccount,
         payperiod,
         salechnl,
         insuredpeoples,
         payinteval,
         othercontinfo,
         cashvalue,
         instfrom,
         policyaddress,
         makedate,
         maketime,
         v_TraceId,
         overprem,
         phone,
         primeyearprem,
         restpayperiod
       from MID_POLICY;

--CR_Rel(�ͻ�����������������ȡ)
  insert into CR_Rel
  select contno,
         clientno,
         custype,
         relaappnt,
         makedate,
         maketime,
         v_TraceId,
         policyphone,
         usecardtype,
         useothercardtype,
         usecardid
       from MID_Rel;

--CR_RISK(������Ϣ��������ȡ)
  insert into CR_RISK(
         contno,
         riskcode,
         riskname,
         mainflag,
         risktype,
         insamount,
         prem,
         payinteval,
         effectivedate,
         expiredate,
         yearprem,
		     salechnl,
		     makedate,
		     maketime,
         BatchNo
  )
  select contno,
         riskcode,
         riskname,
         mainflag,
         risktype,
         insamount,
         prem,
         payinteval,
         effectivedate,
         expiredate,
         yearprem,
		     salechnl,
		     makedate,
		     maketime,
         v_TraceId
       from MID_RISK;

--cr_trans(���׼�¼��������ȡ)
  insert into CR_TRANS
  select transno,
         contno,
         conttype,
         transmethod,
         transtype,
         transdate,
         transfromregion,
         transtoregion,
         curetype,
         payamt,
         payway,
         paymode,
         paytype,
         accbank,
         accno,
         accname,
         acctype,
         agentname,
         agentcardtype,
         agentothercardtype,
         agentcardid,
         agentnationality,
         opposidefinaname,
         opposidefinatype,
         opposidefinacode,
         opposidezipcode,
         tradecusname,
         tradecuscardtype,
         tradecusothercardtype,
         tradecuscardid,
         tradecusacctype,
         tradecusaccno,
         source,
         busimark,
         relationwithregion,
         useoffund,
         makedate,
         maketime,
         v_TraceId,
         accopentime,
         bankcardtype,
         bankcardothertype,
         bankcardnumber,
         rpmatchnotype,
         rpmatchnumber,
         noncountertrantype,
         noncounterothtrantype,
         noncountertrandevice,
         bankpaymenttrancode,
         foreigntranscode,
         crmb,
         cusd,
         remark,
         visitreason,
         isthirdaccount,
         nvl(requestdate,transdate)
       from MID_TRANS;

--cr_transDetail(���׼�¼��ϸ��������ȡ)
  insert into CR_TRANSDETAIL
  select transno,
         contno,
         subno,
         notes,
         ext1,
         ext2,
         ext3,
         ext4,
         ext5,
         makedate,
         maketime,
         v_TraceId
       from MID_TRANSDETAIL;
       commit;

  --����MID������
  insert into MID_client_bak select * from MID_Client;
  insert into MID_TransDetail_bak select * from MID_TransDetail;
  insert into MID_Trans_bak select * from MID_Trans;
  insert into MID_Policy_bak select * from MID_Policy;
  insert into MID_Risk_bak select * from MID_Risk;
  insert into MID_Rel_bak select * from MID_Rel;
  insert into MID_Address_bak select * from MID_Address;

  --������ȡ�����MID��
  delete from  MID_Trans;
  delete from  MID_TransDetail;
  delete from  MID_Client;
  delete from  MID_Policy;
  delete from  MID_Risk;
  delete from  MID_Rel;
  delete from  MID_Address;

   --��������ͬ��

  -- ִ����ϣ����¹켣״̬
    update LLogTrace
     set dealstate  = '01',
       dealdesc   = '�ɹ�����',
       InsertTime = to_date(startDate,'YYYY-MM-DD'),
       modifytime = to_date(startDate,'YYYY-MM-DD'),
       endtime = sysdate
     where traceid = v_TraceId;
     commit;
   -- �쳣����
    EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=errorCode||errorMsg;

  -- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
  update LLogTrace
     set dealstate  = '02',
       dealdesc   = v_errormsg,
       InsertTime = to_date(startDate,'YYYY-MM-DD'),
       modifytime = to_date(startDate,'YYYY-MM-DD')
     where traceid = v_TraceId;
  commit;

end proc_aml_extraMID;
/

prompt
prompt Creating procedure PROC_AML_EXTRAMID_ETA
prompt ========================================
prompt
create or replace procedure PROC_AML_EXTRAMID_ETA(
  startDate in VARCHAR2,
  endDate in VARCHAR2
) is
  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ
  v_errormsg LLogTrace.DealDesc%type;
  v_TraceId LLogTrace.TraceId%type;
begin
    -- =============================================
  -- Description: ��mid���е����ݷ��뵽ƽ̨����
  -- parameter in:    startDate   ��ʼ����
  --                  endDate     ��������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/04/29
  -- Changes log:
  --     Author     Date     Description
  --     czl     2019/04/29     ����
  --     czl     2019/07/11     eTA�ͻ�����
  -- =============================================
  SELECT TO_char(sysdate, 'yyyymmddHH24mmss') into v_TraceId from dual;

  -- �Ȳ���켣
   insert into LLogTrace
    (TraceId,
     FuncCode,
     StartTime,
     DealState,
     DealDesc,
     DataBatchNo,
     DataState,
     Operator,
     InsertTime,
     ModifyTime)
  values
    (v_TraceId,
     '000001',
     sysdate,
     '00',
     'ִ����',
     v_TraceId,
     '01',
     'system',
     sysdate,
     sysdate);
  commit;

  --���κ�
  update mid_client set BATCHNO= v_TraceId;
  update MID_TransDetail set BATCHNO= v_TraceId;
  update MID_Trans set BATCHNO= v_TraceId;
  update MID_Policy set BATCHNO= v_TraceId;
  update MID_Risk set BATCHNO= v_TraceId;
  update MID_Rel set BATCHNO= v_TraceId;
  update MID_Address set BATCHNO= v_TraceId;


  --����MID������
  /*insert into MID_client_bak select * from MID_Client;
  insert into MID_TransDetail_bak select * from MID_TransDetail;
  insert into MID_Trans_bak select * from MID_Trans;
  insert into MID_Policy_bak select * from MID_Policy;
  insert into MID_Risk_bak select * from MID_Risk;
  insert into MID_Rel_bak select * from MID_Rel;
  insert into MID_Address_bak select * from MID_Address;*/

  --��տͻ�������
  delete from CR_Client_temp;
  delete from lxassista;

  insert into lxassista(
    customerno,
    args1,
    args2,
  args3
  )select
    clientno,
    name,
    cardid,
  source
   from mid_client;

  --OLAS/IGM�ͻ�(���ͻ���ΪOLAS/IGM�ͻ���)���ų�������
  insert into CR_Client_temp
  select m.clientno,
        c.originalclientno,
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        m.BATCHNO,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m
  join cr_client c
  on m.clientno=c.clientno
  and substr(c.clientno,1,1)!='B'
  and substr(m.clientno,1,1)!='B'
  and m.source='1'
  and c.source='1';

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --OLAS/IGM�ͻ�(���ͻ���ΪETA�ͻ���)
  insert into CR_Client_temp
  select c.clientno,
        m.clientno,
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        m.BATCHNO,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m
  join cr_client c
  on m.name=c.name
  and m.cardid=c.cardid
  and substr(c.clientno,1,1)!='B'
  and substr(m.clientno,1,1)!='B'
  and m.source='1';    --OLAS

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --ETA�ͻ�(ƽ̨��ΪOLAS/IGM�ͻ���Ϣ)
  insert into CR_Client_temp
  select c.clientno,
        m.clientno,
        c.source,
        c.name,
        c.birthday,
        c.age,
        c.sex,
        c.grade,
        c.cardtype,
        c.othercardtype,
        c.cardid,
        c.cardexpiredate,
        c.clienttype,
        c.workphone,
        c.familyphone,
        c.telephone,
        c.occupation,
        c.businesstype,
        c.income,
        c.grpname,
        c.address,
        c.otherclientinfo,
        c.zipcode,
        c.nationality,
        c.comcode,
        c.conttype,
        c.businesslicenseno,
        c.orgcomcode,
        c.taxregistcertno,
        c.legalperson,
        c.legalpersoncardtype,
        c.otherlpcardtype,
        c.legalpersoncardid,
        c.linkman,
        c.comregistarea,
        c.comregisttype,
        c.combusinessarea,
        c.combusinessscope,
        c.appntnum,
        c.comstaffsize,
        c.grpnature,
        c.founddate,
        c.holderkey,
        c.holdername,
        c.holdercardtype,
        c.otherholdercardtype,
        c.holdercardid,
        c.holderoccupation,
        c.holderradio,
        c.holderotherinfo,
        c.relaspecarea,
        c.fatctry,
        c.countrycode,
        c.suspiciouscode,
        c.fundsource,
        m.Makedate,
        m.MakeTime,
        m.BATCHNO,
        c.idverifystatus,
        c.isfatcaandcrs
    from mid_client m
  join cr_client c
  on m.name=c.name
  and m.cardid=c.cardid
  and substr(c.clientno,1,1)!='B'
  and substr(m.clientno,1,1)!='B'
  and m.source='3'
  and c.source='1';    --OLAS

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --ETA�ͻ�(ƽ̨��ΪETA�ͻ���Ϣ)
  insert into CR_Client_temp
  select c.clientno,
        c.originalclientno,
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        m.BATCHNO,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m
  join cr_client c
  on m.cardid=c.cardid
  and m.name=c.name
  and substr(m.clientno,1,1)!='B'
  and substr(c.clientno,1,1)!='B'
  and m.source='3'
  and c.source='3';

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --ץȡ���Ĺ����ķ������˵��¿ͻ�
  insert into CR_Client_temp
  select m.clientno,
        (select c.clientno from mid_client c where c.clientno!=m.clientno and c.name=m.name and c.cardid=m.cardid and substr(c.clientno,1,1)!='B'and c.source='3') as originalclientno,
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        v_TraceId,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m
  where substr(m.clientno,1,1)!='B'
  and m.source='1';

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --ץȡ��������eTA�ͻ�
  insert into CR_Client_temp
  select m.clientno,
        '',
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        v_TraceId,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m
  where m.source='3';

  --ɾ���ѷ���ͻ������������+ID
  delete from mid_client m where exists (select 1 from CR_Client_temp c where c.name=m.name and c.cardid=m.cardid);

  --ץȡ���Ĺ�������������
  insert into CR_Client_temp
  select m.clientno,
        '',
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        v_TraceId,
        m.idverifystatus,
        m.isfatcaandcrs
    from mid_client m;

  --����MID���CR���е����ݽ���ȥ�ز���
 DELETE FROM CR_Policy WHERE EXISTS(SELECT 1 FROM MID_Policy a WHERE a.ContNo = CR_POLICY.CONTNO) ;
 DELETE FROM CR_Address WHERE EXISTS(SELECT 1 FROM CR_Client_temp a WHERE a.clientNo = CR_Address.clientNo) ;
 DELETE FROM CR_Rel WHERE EXISTS(SELECT 1 FROM MID_Rel a WHERE a.ContNo = CR_REL.ContNo);
 DELETE FROM CR_Risk WHERE EXISTS(SELECT 1 FROM MID_Risk a WHERE a.ContNo = CR_RISK.CONTNO) ;
 DELETE FROM CR_Client WHERE EXISTS(SELECT 1 FROM CR_Client_temp a WHERE a.ClientNo = CR_CLIENT.CLIENTNO) ;
 DELETE FROM CR_Trans WHERE EXISTS(SELECT 1 FROM MID_Trans a WHERE A.TransNo = CR_TRANS.TRANSNO) ;
 DELETE FROM CR_TransDetail WHERE EXISTS(SELECT 1 FROM MID_TransDetail a WHERE A.TransNo = CR_TransDetail.TransNo AND a.contno = CR_TRANSDETAIL.CONTNO);



  --cr_client(�ͻ�������Ϣ��������ȡ)
    INSERT INTO CR_CLIENT
    select
        m.clientno,
        m.originalclientno,
        m.source,
        m.name,
        m.birthday,
        m.age,
        m.sex,
        m.grade,
        m.cardtype,
        m.othercardtype,
        m.cardid,
        m.cardexpiredate,
        m.clienttype,
        m.workphone,
        m.familyphone,
        m.telephone,
        m.occupation,
        m.businesstype,
        m.income,
        m.grpname,
        m.address,
        m.otherclientinfo,
        m.zipcode,
        m.nationality,
        m.comcode,
        m.conttype,
        m.businesslicenseno,
        m.orgcomcode,
        m.taxregistcertno,
        m.legalperson,
        m.legalpersoncardtype,
        m.otherlpcardtype,
        m.legalpersoncardid,
        m.linkman,
        m.comregistarea,
        m.comregisttype,
        m.combusinessarea,
        m.combusinessscope,
        m.appntnum,
        m.comstaffsize,
        m.grpnature,
        m.founddate,
        m.holderkey,
        m.holdername,
        m.holdercardtype,
        m.otherholdercardtype,
        m.holdercardid,
        m.holderoccupation,
        m.holderradio,
        m.holderotherinfo,
        m.relaspecarea,
        m.fatctry,
        m.countrycode,
        m.suspiciouscode,
        m.fundsource,
        m.Makedate,
        m.MakeTime,
        v_TraceId,
        m.idverifystatus,
        m.isfatcaandcrs
    from CR_Client_temp m
  join (select row_number() over(partition by clientNo order by clientNo,source asc) as rowno,clientNo, source from CR_Client_temp) tmp
  on m.source=tmp.source  --ȥ�أ�����ȡ���Ĺ����Ŀͻ�
  and m.clientNo=tmp.clientNo
  and tmp.rowno=1;

  --ƽ̨����OLAS/IGM����ϵ��ַ����ɾ���м����ͬһ���ͻ�ETA��������ϵ��ַ
  delete from mid_address m where exists (select 1 from lxassista l where l.customerno=m.clientNo and not exists (select 1 from cr_client_temp c where c.clientno=l.customerno and c.source='3') and l.args3='3');

  --CR_Rel(�ͻ�����������������ȡ)
  insert into CR_Rel
  select distinct
     m.contno,
         c.clientno,
         m.custype,
         m.relaappnt,
         m.makedate,
         m.maketime,
         v_TraceId,
         m.policyphone,
         m.usecardtype,
         m.useothercardtype,
         m.usecardid
       from MID_Rel m
     join lxassista lx
     on m.clientno=lx.customerno
     join CR_Client_temp c
     on  c.name=lx.args1
     and c.cardid=lx.args2
     and m.usecardid=c.cardid;

  --CR_Address(��ϵ��ַ����ȡ)
  INSERT INTO CR_ADDRESS (
    clientno,
    ListNo,
    clienttype,
    LinkNumber,
    Adress,
    CusOthContact,
  nationality,
    country,
    MakeDate,
    MakeTime,
    batchno,
    conttype)
  (
    select distinct
      c.clientno AS clientno,
      ROW_NUMBER () OVER (partition by a.clientNo ORDER BY a.clientno) AS ListNo,
      A.ClientType AS clienttype,
      A.linknumber AS LinkNumber,
      A.adress AS Adress,
      A.CusOthContact AS CusOthContact,
      A.Nationality AS nationality,
      A.Country AS country,
      sysdate,
      to_char(sysdate,'hh24:mm:ss'),
      v_TraceId AS batchno,
      A.conttype AS conttype
    from MID_Address a
  join CR_Client_temp c
  on (a.clientno=c.clientNo or a.clientNo=c.originalclientno)
  );

  --CR_Policy(������Ϣ��������ȡ)
  INSERT INTO CR_POLICY
  select contno,
         conttype,
         nvl(
         (select distinct d.TARGETCODE from mid_trans t,ldcodemapping d where m.contno=t.contno and t.transfromregion=d.BASICCODE and d.CODETYPE='aml_com_trcd' ),
         (select distinct d.TARGETCODE from cr_trans t,ldcodemapping d where m.contno=t.contno and t.transfromregion=d.BASICCODE and d.CODETYPE='aml_com_trcd')
         ),
         prem,
         amnt,
         paymethod,
         contstatus,
         effectivedate,
         expiredate,
         accountno,
         sumprem,
         mainyearprem,
         yearprem,
         agentcode,
         grpflag,
         source,
         inssubject,
         investflag,
         remainaccount,
         payperiod,
         salechnl,
         insuredpeoples,
         payinteval,
         othercontinfo,
         cashvalue,
         instfrom,
         policyaddress,
         makedate,
         maketime,
         BATCHNO,
         overprem,
         phone,
         primeyearprem,
         restpayperiod
       from MID_POLICY m;

  --CR_RISK(������Ϣ��������ȡ)
  insert into CR_RISK(
         contno,
         riskcode,
         riskname,
         mainflag,
         risktype,
         insamount,
         prem,
         payinteval,
         effectivedate,
         expiredate,
         yearprem,
		     salechnl,
		     makedate,
		     maketime,
         BatchNo
  )
  select contno,
         riskcode,
         riskname,
         mainflag,
         risktype,
         insamount,
         prem,
         payinteval,
         effectivedate,
         expiredate,
         yearprem,
         salechnl,
         makedate,
         maketime,
         v_TraceId
       from MID_RISK;

  --cr_trans(���׼�¼��������ȡ)
  insert into CR_TRANS
  select transno,
         contno,
         conttype,
         transmethod,
         transtype,
         transdate,
         transfromregion,
         transtoregion,
         curetype,
         payamt,
         payway,
         paymode,
         paytype,
         accbank,
         accno,
         accname,
         acctype,
         agentname,
         agentcardtype,
         agentothercardtype,
         agentcardid,
         agentnationality,
         opposidefinaname,
         opposidefinatype,
         opposidefinacode,
         opposidezipcode,
         tradecusname,
         tradecuscardtype,
         tradecusothercardtype,
         tradecuscardid,
         tradecusacctype,
         tradecusaccno,
         source,
         busimark,
         relationwithregion,
         useoffund,
         makedate,
         maketime,
         v_TraceId,
         accopentime,
         bankcardtype,
         bankcardothertype,
         bankcardnumber,
         rpmatchnotype,
         rpmatchnumber,
         noncountertrantype,
         noncounterothtrantype,
         noncountertrandevice,
         bankpaymenttrancode,
         foreigntranscode,
         crmb,
         cusd,
         remark,
         visitreason,
         isthirdaccount,
         nvl(requestdate,transdate)
       from MID_TRANS;

  --cr_transDetail(���׼�¼��ϸ��������ȡ)
  insert into CR_TRANSDETAIL
  select transno,
         contno,
         subno,
         notes,
         ext1,
         ext2,
         ext3,
         ext4,
         ext5,
         makedate,
         maketime,
         v_TraceId
       from MID_TRANSDETAIL;

--  --������ȡ�����MID��
  delete from  MID_Trans;
  delete from  MID_TransDetail;
  delete from  MID_Client;
  delete from  cr_client_temp;
  delete from  MID_Policy;
  delete from  MID_Risk;
  delete from  MID_Rel;
  delete from  MID_Address;
  delete from  lxassista;



  -- ִ����ϣ����¹켣״̬
    update LLogTrace
     set dealstate  = '01',
       dealdesc   = '�ɹ�����',
       InsertTime = to_date(startDate,'YYYY-MM-DD'),
       modifytime = to_date(startDate,'YYYY-MM-DD'),
       endtime = sysdate
     where traceid = v_TraceId;
     commit;

   -- �쳣����
    EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=errorCode||errorMsg;

  -- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
  update LLogTrace
     set dealstate  = '02',
       dealdesc   = v_errormsg,
       InsertTime = to_date(startDate,'YYYY-MM-DD'),
       modifytime = to_date(startDate,'YYYY-MM-DD')
     where traceid = v_TraceId;
     delete from LXAssistA;
  commit;

end PROC_AML_EXTRAMID_ETA;
/

prompt
prompt Creating procedure PROC_AML_GB0103
prompt ==================================
prompt
create or replace procedure proc_aml_GB0103(i_baseLine in date, i_oprater in varchar2) is

    v_threshold_money number := getparavalue('GB0103', 'M1'); -- ��ֵ �ۼƱ��ѽ��
		v_threshold_month number := getparavalue('GB0103', 'D1'); -- ��ֵ ��Ȼ��
		v_threshold_count number := getparavalue('GB0103', 'N1'); -- ��ֵ �������
		v_dealNo lxistrademain.dealno%type;												-- ���ױ��(ҵ���)
		v_clientno cr_client.clientno%type;  -- �ͻ���

begin
  -- =============================================
  -- Rule:
  --     Ͷ����3������(����������ռ��㣩�������ϣ��������Σ���������ˡ���ϵ�ˡ����������˻��߸����ˣ��Ҹ�Ͷ����λ��������Ч�������ۼ��ѽ������ܶ���ڵ��ڷ�ֵ������ϵͳץȡ�����ɿ��ɽ��ף�
  --     1) ͬһͶ����λ������ű��������ˡ���ϵ�ˡ����������˻��߸�������ͬ�ģ�������������кϲ���Ϊһ�α��������ͬ������ͬһ��᰸��Ϊһ�Σ���
--          ���������˵ı����ͳ�ƿھ�Ϊ�����������ˡ�ɾ�������ˡ��޸������ˣ������ϵ�ˡ����������˻��߻����˵�ͳ�ƿھ���Ϊ����˵�����
  --     2) �ۼ��ѽ������߼�ͬ7.1.1
  --     3) ��ȡ����ά��
  --        ����������OLAS��IGM��
  --        ǰһ����ְҵ��ǩ���������˻��������Ч��ȫ�ı���
  --     4) �������ݸ�ʽͬ���п��ɽ��׸�ʽ
  --     5) ��������ֵΪ200��ʵ��Ϊ��������ʽ
  -- parameter in: i_baseLine ��������
  --               i_oprater ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2020/01/06
  -- Changes log:
  --     Author     Date     Description
  -- =============================================

-- �ҳ����췢�����Ͷ����λ�������������б����¼
  insert into LXAssistA(
    CustomerNo,
    TranId,
    PolicyNo,
    TranMoney,
    TimeArgs1,
    Trantime,
    args1,
    args2,
    args3,
    args4,
		args5)
      select
        r.clientno,
        t.transno,
        t.contno,
        (select p.sumprem from cr_policy p where p.contno = t.contno) as sumprem,
        t.requestdate,
        t.transdate,
        t.transtype,
        td.remark,
        td.ext1,
        td.ext2,
        'GB0103_1'
      from
        cr_trans t,cr_rel r,cr_transdetail td
      where
          t.contno=r.contno
      and t.contno=td.contno
      and t.transno=td.transno
      and exists(
          select 1
          from
              cr_trans tmp_t, cr_rel tmp_r, cr_transdetail tmp_td
          where
              tmp_r.clientno = r.clientno
          and tmp_t.contno = tmp_r.contno
          and tmp_t.contno = tmp_td.contno
          and tmp_t.transno = tmp_td.transno
          and tmp_r.custype = 'O'
          and tmp_t.conttype='1'
          and tmp_td.remark ='name'  
          and tmp_t.transtype  in('AC', 'BC')
          and trunc(tmp_t.transdate)=trunc(i_baseline)
          )
      and r.custype = 'O'
      and td.remark ='name'     
      and t.transtype  in('AC', 'BC')
      and isValidCont(t.contno) = 'yes'
      and t.conttype = '1'
      and trunc(t.transdate) > trunc(add_months(i_baseLine,v_threshold_month*(-1)))  --��������3����ǰ
      and trunc(t.transdate) < trunc(i_baseLine);   --�����յ���;

-- �ж��ۼƴ�������ֵ
	 insert into LXAssistA(
			CustomerNo,
			TranId,
			PolicyNo,
			TimeArgs1,
			TranMoney,
			args2,
			args5,
			args4)
      select
        CustomerNo,
        TranId,
        PolicyNo,
				TimeArgs1,
				TranMoney,
				args2,
				'B0103_2',
				args4
      from
        LXAssistA a
      where (									-- ���Ϊͬһְҵ�����˴�����ֻ��һ�Σ����ǩ����ȥ��
        nvl((
          select count(distinct tmp.args4)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and (tmp.args2 in('OwnOccupation','AGT01'))
          group by
            tmp.customerno
				),0)
				+
				nvl((
          select count(1)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and tmp.args2='editSignStyle'
          group by
            tmp.customerno
				),0)
        +
        nvl((
          select count(distinct tranid)
          from
            LXAssistA tmp
          where tmp.customerno = a.customerno
					and tmp.args2 like 'operateType%'
          group by
            tmp.customerno
				),0)>=v_threshold_count
     )
    and (				-- ��������������Ч�����ۼ��ѽ������ܶ�
				select
					sum(nvl(policy.sumprem,0))
					from cr_rel rel,cr_policy policy
					where rel.contno=policy.contno
					and rel.clientno = a.customerno
					and isValidCont(rel.contno)='yes'
					and rel.custype='O')
				>=v_threshold_money
			order by a.customerno, a.timeargs1 desc;

-- �ҳ���ÿһ����¼��������������������Ľ�����Ϊ��¼ͷ
	declare
       cursor baseInfo_sor is
          select
            CustomerNo,
            PolicyNo,
						TimeArgs1
          from
            LXAssistA a
          where
						(									-- ���Ϊͬһְҵ�����˴�����ֻ��һ�Σ����ǩ����ȥ��
							nvl((
								select count(distinct tmp.args4)
								from
									LXAssistA tmp
								where tmp.customerno = a.customerno
								and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
								and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
								and (tmp.args2 in('OwnOccupation','���������')or tmp.args2 like 'operateType%')
								and tmp.args5='B0103_2'
								group by
									tmp.customerno
							),0)
							+
							nvl((
								select count(tmp.args4)
								from
									LXAssistA tmp
								where tmp.customerno = a.customerno
								and trunc(tmp.TimeArgs1) >= trunc(a.TimeArgs1)
								and trunc(tmp.TimeArgs1) < trunc(add_months(a.TimeArgs1,v_threshold_month))
								and tmp.args2 ='editSignStyle'
								and tmp.args5='B0103_2'
								group by
									tmp.customerno
							),0)
              +
              nvl((
                  select count(distinct tranid)
                  from
                    LXAssistA tmp
                  where tmp.customerno = a.customerno
					        and tmp.args2 like 'operateType%'
                  group by
                    tmp.customerno
				      ),0)>=v_threshold_count
					 )
				and a.args5 = 'B0103_2'
				order by CustomerNo,TimeArgs1 desc;

     -- �����α����
    c_clientno cr_client.clientno%type;									-- �ͻ���(���ڱ��潻����������������׷��Ͷ�ʡ��µ����Ѷ�Ͷ�Ľ�����Ϣ)
    c_contno cr_trans.contno%type;											-- ������
		c_requestdate cr_trans.requestdate%type;

begin
open baseInfo_sor;
    loop

      -- ��ȡ��ǰ�α�ֵ����ֵ������
      fetch baseInfo_sor into c_clientno,c_contno,c_requestdate;
      exit when baseInfo_sor%notfound;  -- �α�ѭ������

			-- �Լ�¼ͷ�����������ڵļ�¼
			declare
				cursor baseInfo_sor_date is
					select *
					from lxassista
					where trunc(TimeArgs1) >= trunc(c_requestdate)
					and trunc(TimeArgs1) < trunc(add_months(c_requestdate,v_threshold_month))
					and args5 = 'B0103_2' and customerno = c_clientno;

			c_row baseInfo_sor_date%rowtype;

		begin
		for c_row in baseInfo_sor_date loop
      -- ���췢���Ĵ��������ף����뵽�����У���ϸ����ָ��Ϊ1
      if v_clientno is null or c_clientno <> v_clientno then
      v_dealNo:=NEXTVAL2('AMLDEALNO', 'SN');	--��ȡ���ױ��(ҵ���)

      -- ������ɽ�����Ϣ����-��ʱ�� Lxistrademain_Temp
      PROC_AML_INS_LXISTRADEMAIN(v_dealNo, c_clientno,c_contno,i_oprater, 'SB0103', i_baseLine);
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'1');
      v_clientno := c_clientno; -- ���¿�������Ŀͻ���

      else
      -- ������ɽ�����ϸ��Ϣ-��ʱ�� Lxistradedetail_Temp
      PROC_AML_INS_LXISTRADEDETAIL(v_dealNo, c_row.policyno, c_row.tranid,'');

      end if;

			-- ������ɽ��׺�ͬ��Ϣ-��ʱ�� Lxistradecont_Temp
			PROC_AML_INS_LXISTRADECONT(v_dealNo, c_row.customerno, c_row.policyno);

			-- ������ɽ��ױ�������Ϣ-��ʱ�� Lxistradeinsured_Temp
			PROC_AML_INS_LXISTRADEINSURED(v_dealNo, c_row.policyno);

			-- ������ɽ�����������Ϣ-��ʱ�� Lxistradebnf_Temp
			PROC_AML_INS_LXISTRADEBNF(v_dealNo, c_row.policyno);

			-- ���뽻��������ϵ��ʽ-��ʱ�� Lxaddress_Temp
			PROC_AML_INS_LXADDRESS(v_dealNo, c_row.customerno);
		end loop;

		end;

    end loop;
    close baseInfo_sor;
  end;

  delete from LXAssistA where args5 in ('B0103_1','B0103_2');
end proc_aml_GB0103;
/

prompt
prompt Creating procedure PROC_AML_INSERTCR
prompt ====================================
prompt
create or replace procedure proc_aml_insertCR(i_count in number)
is

begin
  -- =============================================
  -- ��ƽ̨���в����������
  -- parameter in: i_count Ҫ�������������
  -- parameter out: none
  -- Author: zhouqk
  -- Create date: 2019/06/17
  -- Changes log:
  --     Author     Date        Description
  --     zhouqk   2019/06/17      ����
  -- ============================================

  declare
     v_first_num number;
     v_end_num number;

  begin

    for v_count in 1..i_count loop
      
            v_first_num:=nextval2('LDPARA','SN');

            insert into cr_client select

            nextval2('LDPARA','SN'),

            OriginalClientNo,Source,Name,Birthday,Age,Sex,Grade,CardType,OtherCardType,CardID,CardExpireDate,ClientType,WorkPhone,FamilyPhone,Telephone,Occupation,BusinessType,Income,GrpName,Address,OtherClientInfo,ZipCode,Nationality,ComCode,ContType,BusinessLicenseNo,OrgComCode,TaxRegistCertNo,LegalPerson,LegalPersonCardType,OtherLPCardType,LegalPersonCardID,LinkMan,ComRegistArea,ComRegistType,ComBusinessArea,ComBusinessScope,AppntNum,ComStaffSize,GrpNature,FoundDate,HolderKey,HolderName,HolderCardType,OtherHolderCardType,HolderCardID,HolderOccupation,HolderRadio,HolderOtherInfo,RelaSpecArea,FATCTRY,CountryCode,SuspiciousCode,fundsource,MakeDate,MakeTime,BatchNo,IDverifystatus,IsFATCAandCRS from cr_client;

            v_end_num:=nextval2('LDPARA','SN');


            for i_no in (v_first_num+1)..(v_end_num-1) loop
              --  �ͻ��ţ������źͽ��ױ�Ŷ���i_no   �˴�������
              
              insert into CR_Policy(ContNo,ContType,LocId,Prem,Amnt,PayMethod,ContStatus,Effectivedate,Expiredate,AccountNo,SumPrem,MainYearPrem,YearPrem,AgentCode,GrpFlag,Source,InsSubject,InvestFlag,RemainAccount,PayPeriod,SaleChnl,InsuredPeoples,PayInteval,OtherContInfo,CashValue,INSTFROM,PolicyAddress,Makedate,MakeTime,BatchNo,OverPrem,phone,PrimeYearPrem)
              values(i_no,'1','N000001','100000','200000','01','20',to_date('2018-03-22','yyyy-mm-dd'),to_date('2020-03-22','yyyy-mm-dd'),'6228273156301755774','100000','','','','','1','����','','','0','05','1','0','@N','',to_date('2018-03-22','yyyy-mm-dd'),'',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','20190521151031','','16738490927','100000');
             
              insert into CR_Rel(ContNo,ClientNo,CusType,RelaAppnt,BatchNo,Makedate,MakeTime,PolicyPhone,UseCardType,UseOtherCardType,UseCardID)
              values(i_no,i_no,'O','1','20190521151031',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','16738490927','01','01','310112198001010439');
           
              insert into CR_Rel(ContNo,ClientNo,CusType,RelaAppnt,BatchNo,Makedate,MakeTime,PolicyPhone,UseCardType,UseOtherCardType,UseCardID)
              values(i_no,i_no,'B','1','20190521151031',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','16738490927','01','01','310112198001010439');

              insert into CR_Rel(ContNo,ClientNo,CusType,RelaAppnt,BatchNo,Makedate,MakeTime,PolicyPhone,UseCardType,UseOtherCardType,UseCardID)
              values(i_no,i_no,'I','1','20190521151031',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','16738490927','01','01','310112198001010439');
             
              insert into CR_Risk(ContNo,RiskCode,RiskName,MainFlag,RiskType,InsAmount,Prem,PayInteval,Effectivedate,Expiredate,YearPrem,SaleChnl,Makedate,MakeTime,BatchNo)
              values(i_no,'20GAA102886A','����֤������ϱ���-Ʒ��A','00','01','200000','100000','0',to_date('2018-03-22','yyyy-mm-dd'),to_date('2020-03-22','yyyy-mm-dd'),'','01',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','20190521151031');
              
              insert into CR_Trans(TransNo,ContNo,ContType,TransMethod,TransType,Transdate,TransFromRegion,TransToRegion,CureType,PayAmt,PayWay,PayMode,PayType,AccBank,AccNo,AccName,AccType,AgentName,AgentCardType,AgentOtherCardType,AgentCardID,AgentNationality,OpposideFinaName,OpposideFinaType,OpposideFinaCode,OpposideZipCode,TradeCusName,TradeCusCardType,TradeCusOtherCardType,TradeCusCardID,TradeCusAccType,TradeCusAccNo,Source,BusiMark,RelationWithRegion,UseOfFund,AccOpenTime,BankCardType,BankCardOtherType,BankCardnumber,RPMatchNoType,RPMatchNumber,NonCounterTranType,NonCounterOthTranType,NonCounterTranDevice,BankPaymentTranCode,ForeignTransCode,CRMB,CUSD,Remark,Makedate,MakeTime,BatchNo,visitReason,IsThirdAccount,RequestDate)
              values(i_no,i_no,'1','','AA001',to_date('2018/6/15','yyyy-MM-dd HH24:mi:ss'),'CHN310106','CHN310106','RMB','100000','01','02','','�й���������','6212260443425','����','@N','@N','@N','@N','@N','CN','@N','@N','@N','@N','@N','@N','@N','@N','@N','@N','1','FYA07001001','@N','@N',to_date('','yyyy-mm-dd'),'@N','@N','@N','@N','@N','@N','@N','@N','@N','@N','','','@N',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','20190521151031','','0',to_date('2018-5-1','yyyy-mm-dd'));
              
              insert into CR_TransDetail(TransNo,ContNo,subno,remark,ext1,ext2,ext3,ext4,ext5,Makedate,MakeTime,BatchNo)
              values(i_no,i_no,'0018','','','','','','',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','20190521151031');
              
              insert into CR_Address(ClientNo,ListNo,ClientType,LinkNumber,Adress,CusOthContact,Nationality,Country,MakeDate,MakeTime,BatchNo,ContType)
              values(i_no,'20','03','16738490927','�Ϻ��о�����','16738490927','CN','',to_date('2018-5-1','yyyy-mm-dd'),'15:10:31','20190521151031','1');
              
              insert into lxblacklist(seqNo,recordType,nameType,name,ename,sex,birthday,idNumber,nationality,type,Description1,Description2,Description3,dataSource,risktype,risklevel,isactive,creator,operator,makedate,maketime,modifydate,modifytime)
              values(i_no,'01','','����','zh','2',to_date('1980-1-1','yyyy-mm-dd'),'110101198903230044','CHN','1','1','1','','21','','','0','urp','aml',to_date('2019-03-13','yyyy-mm-dd'),'15:10:31',to_date('2019-03-13','yyyy-mm-dd'),'15:10:31');
              
              insert into lxriskinfo(seqno,recordtype,code,name,ename,sex,birthday,idNumber,nationality,risktype,risklevel,isActive,creator,operator,makedate,maketime,modifydate,modifytime)
              values(i_no,'01','SA0802_01','��Ϊ','huwei','1',to_date('1994/10/04','yyyy-mm-dd'),'310106199410040038','CHN','','4','01','zhouqk','aml',to_date('2019/4/28','yyyy-mm-dd'),'13:25:11',to_date('2019/4/28','yyyy-mm-dd'),'13:25:11');

            end loop; 


    end loop;



  end;
end proc_aml_insertCR;
/

prompt
prompt Creating procedure PROC_AML_INS_G_LXISTRADEBNF
prompt ==============================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_INS_G_LXISTRADEBNF (
	i_dealno in NUMBER,
	i_contno in VARCHAR2
) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lLXISTRADEBNF_TEMP��
  -- parameter in: i_dealno ���ױ��(ҵ���)
  --               i_contno ������
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/12/31  ����
  -- =============================================

  insert into LXISTRADEBNF_TEMP(
    serialno,
		DealNo,
		CSNM,
		InsuredNo,
		BnfNo,
		BNNM,
		BITP,
		OITP,
		BNID,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime)
(
			SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_contno AS CSNM,
			c.clientno AS InsuredNo,
			c.clientno AS BnfNo,
			c.NAME AS BNNM,
			c.cardtype AS BITP,
			nvl(c .OtherCardType, '@N') AS OITP,
      nvl((case c.cardtype when 'Ӫҵִ�պ�' then c.BUSINESSLICENSENO when '��֯����֤��' then c.ORGCOMCODE  when '˰��ǼǺ�' then c.TAXREGISTCERTNO else c.cardid end),'@N') as BNID,
			NULL AS DataBatchNo,
			sysdate AS MakeDate,
			to_char(sysdate,'HH:mm:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime
			FROM
					cr_client c,
					cr_rel r
			WHERE
					c.clientno = r.clientno
			AND r.custype = 'B'
			and r.contno=i_contno

  );
end PROC_AML_INS_G_LXISTRADEBNF;
/

prompt
prompt Creating procedure PROC_AML_INS_G_LXISTRADEDETAIL
prompt =================================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_INS_G_LXISTRADEDETAIL (
i_dealno in NUMBER,
	i_contno in VARCHAR2,
	i_transno in VARCHAR2,
	i_triggerflag in VARCHAR2
	) is
begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������LXISTRADEDETAIL_TEMP��
  -- parameter in: i_dealno   ���ױ��(ҵ���)
  --               i_ocontno  ������
  --               i_transno  ���ױ��(ƽ̨��)
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     zhouqk    2019/12/31  ����
  -- =============================================


  insert into LXISTRADEDETAIL_TEMP(
    serialno,
    DealNo,
		TICD,
		ICNM,
		TSTM,
		TRCD,
		ITTP,
		CRTP,
		CRAT,
		CRDR,
		CSTP,
		CAOI,
		TCAN,
		ROTF,
		DataState,
		DataBatchNo,
		MakeDate,
		MakeTime,
		ModifyDate,
		ModifyTime,
		TRIGGERFLAG)
  (
    SELECT
      getSerialno(sysdate) as serialno,
			LPAD(i_dealno,20,'0') AS DealNo,
			i_transno AS TICD,
			i_contno AS ICNM,
			to_char(t.transdate,'yyyymmddHHmmss') AS TSTM,
			t.transfromregion AS TRCD,
			t.transtype AS ITTP,
			t.curetype AS CRTP,
			t.payamt AS CRAT,
			T.PAYWAY AS CRDR,
			T.PAYMODE AS CSTP,
			nvl(t.accbank,'@N') AS CAOI,
			nvl(t.accno,'@N') AS TCAN,
			nvl(t.remark, '@N') AS ROTF,
      'A01' as DataState,
			NULL  AS DataBatchNo,
		  to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') AS MakeDate,
			to_char(sysdate,'HH24:mi:ss') AS MakeTime,
			NULL AS ModifyDate,
			NULL AS ModifyTime,
			i_triggerflag AS TRIGGERFLAG
		from
			cr_trans t
		where
				t.contno = i_contno
		and t.transno = i_transno
  );

end PROC_AML_INS_G_LXISTRADEDETAIL;
/

prompt
prompt Creating procedure PROC_AML_INS_G_LXISTRADEMAIN
prompt ===============================================
prompt
CREATE OR REPLACE PROCEDURE PROC_AML_INS_G_LXISTRADEMAIN (
	i_dealno in NUMBER,
  i_clientno in varchar2,
  i_contno in varchar2,
  i_operator in varchar2,
  i_stcr in varchar2 ,
  i_baseLine in DATE) is

begin
  -- =============================================
  -- Description: ���ݹ���ɸѡ�������lxistrademain_temp��
  -- parameter in: i_clientno �ͻ���
  --               i_dealno   ���ױ��
	--               i_operator ������
  --               i_stcr     ���ɽ�����������
	--               i_baseLine ���ڻ�׼
  -- parameter out: none
  -- Author: xn
  -- Create date: 2019/12/31
  -- Changes log:
  --     Author     Date     Description
  --     xn    2019/12/31  ����
  -- =============================================

  insert into lxistrademain_temp(
    serialno,
    dealno, -- ���ױ��
    rpnc,   -- �ϱ��������
    detr,   -- ���ɽ��ױ�������̶ȣ�01-���ر����, 02-�ر������
    torp,   -- ���ʹ�����־
    dorp,   -- ���ͷ���01-�����й���ϴǮ���������ģ�
    odrp,   -- �������ͷ���
    tptr,   -- ���ɽ��ױ��津����
    otpr,   -- �������ɽ��ױ��津����
    stcb,   -- �ʽ��׼��ͻ���Ϊ���
    aosp,   -- �ɵ����
    stcr,   -- ���ɽ�������
    csnm,   -- �ͻ���
    senm,   -- ������������/����
    setp,   -- �����������֤��/֤���ļ�����
    oitp,   -- �������֤��/֤���ļ�����
    seid,   -- �����������֤��/֤���ļ�����
    sevc,   -- �ͻ�ְҵ����ҵ
    srnm,   -- �������巨������������
    srit,   -- �������巨�����������֤������
    orit,   -- �������巨���������������֤��/֤���ļ�����
    srid,   -- �������巨�����������֤������
    scnm,   -- ��������عɹɶ���ʵ�ʿ���������
    scit,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    ocit,   -- ��������عɹɶ���ʵ�ʿ������������֤��/֤���ļ�����
    scid,   -- ��������عɹɶ���ʵ�ʿ��������֤��/֤���ļ�����
    strs,   -- ���佻�ױ�ʶ
    datastate, -- ����״̬
    filename,  -- ��������
    filepath,  -- ����·��
    rpnm,      -- ���
    operator,  -- ����Ա
    managecom, -- �������
    conttype,  -- �������ͣ�01-����, 02-�ŵ���
    notes,     -- ��ע
		baseline,       -- ���ڻ�׼
    getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ,02-�ֹ�¼�룩
    nextfiletype,   -- �´��ϱ���������
    nextreferfileno,-- �´��ϱ������ļ����������ԭ�ļ�����
    nextpackagetype,-- �´��ϱ����İ�����
    databatchno,    -- �������κ�
    makedate,       -- ���ʱ��
    maketime,       -- �������
    modifydate,     -- ����������
    modifytime,			-- ������ʱ��
		judgmentdate,   -- ��������
    ORXN,           -- ���������״��ϱ��ɹ��ı�������
		ReportSuccessDate)-- �ϱ��ɹ�����
(
    select
      getSerialno(sysdate) as serialno,
      LPAD(i_dealno,20,'0') as dealno,
      '@N' as rpnc,
      '01' as detr,  -- ��������̶ȣ�01-���ر������
      '1' as torp,
      '01' as dorp,  -- ���ͷ���01-�����й���ϴǮ���������ģ�
      '@N' as odrp,
      '01' as tptr,  -- ���ɽ��ױ��津���㣨01-ģ��ɸѡ��
      '@N' as otpr,
      '' as stcb,
      '' as aosp,
      i_stcr as stcr,
      c.clientno as csnm,
      c.name as senm,
      nvl(c.cardtype,'@N') as setp,
      nvl(c.othercardtype,'@N') as oitp,
      --�ŵ���ȡ Ӫҵִ�պŻ���֯����֤�Ż�˰��ǼǺ�
      nvl((case c.cardtype when 'Ӫҵִ�պ�' then c.BUSINESSLICENSENO when '��֯����֤��' then c.ORGCOMCODE  when '˰��ǼǺ�' then c.TAXREGISTCERTNO else c.cardid end),'@N') as seid,
      nvl(c.occupation,'@N') as sevc,
      nvl(c.legalperson,'@N') as srnm,
      nvl(c.legalpersoncardtype,'@N') as srit,
      nvl(c.otherlpcardtype,'@N') as orit,
      nvl(c.legalpersoncardid,'@N') as srid,
      nvl(c.holdername,'@N') as scnm,
      nvl(c.holdercardtype,'@N') as scit,
      nvl(c.otherholdercardtype,'@N') as ocit,
      nvl(c.holdercardid,'@N') as scid,
      '@N' as strs,
      'A01' as datastate,
      '' as filename,
      '' as filepath,
      (select username from lduser where usercode = i_operator) as rpnm,
      i_operator as operator,
      (select locid from cr_policy where contno=i_contno) as managecom,
      c.conttype as conttype,
      '' as notes,
      i_baseLine as baseline,
      '01' as getdatamethod,  -- ���ݻ�ȡ��ʽ��01-ϵͳץȡ��
      '' as nextfiletype,
      '' as nextreferfileno,
      '' as nextpackagetype,
      null as databatchno,
      to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') as makedate,
      to_char(sysdate,'hh24:mi:ss') as maketime,
      null as modifydate,  -- ������ʱ��
      null as modifytime,
			null as judgmentdate,--��������
      null as ORXN,        -- ���������״��ϱ��ɹ��ı�������
			null as ReportSuccessDate--�ϱ��ɹ�����
    from
      cr_client c
    where
     c.clientno = i_clientno
  );

end PROC_AML_INS_G_LXISTRADEMAIN;
/

prompt
prompt Creating procedure PROC_AML_RULE
prompt ================================
prompt
create or replace procedure proc_aml_rule(i_baseLine in date,i_oprater in VARCHAR2) is
begin
  -- =============================================
  -- Description:  ���ô��/���ɸ�ɸѡ������ش���
  -- parameter in: i_baseLine ��������
  --               i_oprater  ������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/02/22
  -- Changes log:
  --     Author        Date      Description
  --     xuexc      2019/02/27      ����
  --     zhouqk     2019/05/27   ���������B0300��Ϊÿ��15������һ��
  -- =============================================

  --proc_aml_0501(i_baseLine,i_oprater);
  aml_0501(i_baseLine,i_oprater);

  PROC_AML_A0101_TEST(i_baseLine,i_oprater);

  PROC_AML_A0102_TEST(i_baseLine,i_oprater);

  PROC_AML_A0103_TEST(i_baseLine,i_oprater);

  PROC_AML_A0104_TEST(i_baseLine,i_oprater);

  proc_aml_A0200(i_baseLine,i_oprater);

  proc_aml_A0300(i_baseLine,i_oprater);

  proc_aml_A0400(i_baseLine,i_oprater);

  proc_aml_A0500(i_baseLine,i_oprater);

  proc_aml_A0601(i_baseLine,i_oprater);

  proc_aml_A0602(i_baseLine,i_oprater);

  proc_aml_A0700(i_baseLine,i_oprater);

  proc_aml_A0801(i_baseLine,i_oprater);

  proc_aml_A0802(i_baseLine,i_oprater);

  proc_aml_A0900(i_baseLine,i_oprater);

  proc_aml_B0101(i_baseLine,i_oprater);

  proc_aml_B0102(i_baseLine,i_oprater);

  proc_aml_B0103(i_baseLine,i_oprater);

  proc_aml_B0200(i_baseLine,i_oprater);

  --B0300����ÿ��15����һ��
  if to_char(i_baseline,'dd')='15'then
     proc_aml_B0300(i_baseLine,i_oprater);
  end if;

  proc_aml_B0400(i_baseLine,i_oprater);

  proc_aml_C0101(i_baseLine,i_oprater);

  proc_aml_C0102(i_baseLine,i_oprater);

  proc_aml_C0103(i_baseLine,i_oprater);

  proc_aml_C0201(i_baseLine,i_oprater);

  proc_aml_C0202(i_baseLine,i_oprater);

  proc_aml_C0203(i_baseLine,i_oprater);

  proc_aml_C0300(i_baseLine,i_oprater);

  proc_aml_C0400(i_baseLine,i_oprater);

  proc_aml_C0500(i_baseLine,i_oprater);

  proc_aml_C0600(i_baseLine,i_oprater);

  proc_aml_C0700(i_baseLine,i_oprater);

  proc_aml_C0801(i_baseLine,i_oprater);

  proc_aml_C0802(i_baseLine,i_oprater);

  proc_aml_C0900(i_baseLine,i_oprater);

  proc_aml_C1000(i_baseLine,i_oprater);

  proc_aml_C1100(i_baseLine,i_oprater);

  proc_aml_C1200(i_baseLine,i_oprater);

  proc_aml_C1301(i_baseLine,i_oprater);

  --proc_aml_C1302(i_baseLine,i_oprater);
  aml_C1302(i_baseLine,i_oprater);

  --proc_aml_C1303(i_baseLine,i_oprater);
  aml_C1303(i_baseLine,i_oprater);

  --proc_aml_C1304(i_baseLine,i_oprater);
  aml_C1304(i_baseLine,i_oprater);

  proc_aml_C1305(i_baseLine,i_oprater);
  
  --��������5
  --AML_XX0005(i_baseLine,i_oprater);
  proc_aml_d0600(i_baseLine,i_oprater);
  
  --�¹���7 
  --aml_xx0007(i_baseLine,i_oprater);
  proc_aml_d0701(i_baseLine,i_oprater);
  -- �¹��� 8
  --aml_xx0008(i_baseLine,i_oprater);
  proc_aml_d0702(i_baseLine,i_oprater);

  --�¹��� 13
  --aml_xx0013(i_baseLine,i_oprater);
  proc_aml_d0703(i_baseLine,i_oprater);
  
  --�¹��� 14
  --aml_xx0014(i_baseLine,i_oprater);
  proc_aml_d0800(i_baseLine,i_oprater);
end proc_aml_rule;
/

prompt
prompt Creating procedure PROC_AML_MAIN
prompt ================================
prompt
create or replace procedure proc_aml_main(i_startDate in varchar, i_endDate in varchar,i_oprater in varchar) is
  v_dataBatchNo varchar2(28);
  v_startDate date := to_date(i_startDate, 'YYYY-MM-DD');
  v_endDate date := to_date(i_endDate, 'YYYY-MM-DD');
  v_baseLine date := v_startDate;

  v_errormsg ldbatchlog.errormsg%type;
  errorCode number; --�쳣����
  errorMsg varchar2(1000);--�쳣��Ϣ

begin
  -- =============================================
  -- Description:	���/����ɸѡ����ץȡ������/���������Ľ��׼�¼
  --              ����ץȡ�Ľ��׼�¼���������/����ҵ�����
  -- parameter in: i_startDate ���׿�ʼ����
  --               i_endDate ���׽�������
  -- parameter out: none
  -- Author: xuexc
  -- Create date: 2019/02/22
  -- Changes log:
  --     Author     Date     Description
  --     xuexc   2019/02/27  ����
  --     hujx    2019/03/01  1.��ȡv_dataBatchNo2����ʱ���Ӳ���
  -- ============================================
  -- ��մ��/����ҵ����ʱ��
  delete from Lxihtrademain_Temp;   -- ��������-��ʱ��
  delete from Lxihtradedetail_Temp; -- ������ϸ��-��ʱ��
  delete from Lxistrademain_Temp;   -- ���ɽ�����Ϣ����-��ʱ��
  delete from Lxistradedetail_Temp; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  delete from Lxistradecont_Temp;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  delete from Lxistradeinsured_Temp;-- ���ɽ��ױ�������Ϣ-��ʱ��
  delete from Lxistradebnf_Temp;    -- ���ɽ�����������Ϣ-��ʱ��
  delete from Lxaddress_Temp;       -- ����������ϵ��ʽ-��ʱ��

  -- ʹ��sequences��ȡ���µ�dataBatchNo
	select CONCAT(to_char(sysdate,'yyyymmdd'),LPAD(SEQ_dataBatchNo.nextval,20,'0')) into v_dataBatchNo from dual;

  loop
    begin
      proc_aml_rule(v_baseLine,i_oprater);
			v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;


  -- ���´��/����ҵ����ʱ���е����κ�
  update Lxihtrademain_Temp set Databatchno = v_dataBatchNo;   -- ��������-��ʱ��
  update Lxihtradedetail_Temp set Databatchno = v_dataBatchNo; -- ������ϸ��-��ʱ��
  update Lxistrademain_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ�����Ϣ����-��ʱ��
  update Lxistradedetail_Temp set Databatchno = v_dataBatchNo; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  update Lxistradecont_Temp set Databatchno = v_dataBatchNo;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  update Lxistradeinsured_Temp set Databatchno = v_dataBatchNo;-- ���ɽ��ױ�������Ϣ-��ʱ��
  update Lxistradebnf_Temp set Databatchno = v_dataBatchNo;    -- ���ɽ�����������Ϣ-��ʱ��
  update Lxaddress_Temp set Databatchno = v_dataBatchNo;       -- ����������ϵ��ʽ-��ʱ��



	--����ʱ��ת��
	proc_aml_mappingcode(v_dataBatchNo);

	--�������治��Ҫת�룬��������
	-- ����v_baseLine
	v_baseLine := v_startDate;
	loop
    begin
      proc_aml_D0100(v_baseLine,i_oprater);
			v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;

	-- ���¿���ҵ����ʱ���е����κ�
  update Lxistrademain_Temp set Databatchno = v_dataBatchNo where Databatchno is null;   -- ���ɽ�����Ϣ����-��ʱ��
  update Lxistradedetail_Temp set Databatchno = v_dataBatchNo where Databatchno is null; -- ���ɽ�����ϸ��Ϣ-��ʱ��
  update Lxistradecont_Temp set Databatchno = v_dataBatchNo where Databatchno is null;   -- ���ɽ��׺�ͬ��Ϣ-��ʱ��
  update Lxistradeinsured_Temp set Databatchno = v_dataBatchNo where Databatchno is null;-- ���ɽ��ױ�������Ϣ-��ʱ��
  update Lxistradebnf_Temp set Databatchno = v_dataBatchNo where Databatchno is null;    -- ���ɽ�����������Ϣ-��ʱ��
  update Lxaddress_Temp set Databatchno = v_dataBatchNo where Databatchno is null;       -- ����������ϵ��ʽ-��ʱ��

	-- ʵ�����Ṧ�ܣ��ж�ҵ������Ƿ�洢�Ѿ���ȡ�����ݣ����ҵ��������ɾ����ʱ����������ݣ�����ҵ������������
	-- ����v_baseLine
	v_baseLine := v_startDate;
	loop
    begin
      PROC_AML_DELETE_LXIHTRADE(v_baseLine);											 --ɾ�����ҵ������������
			PROC_AML_DELETE_LXISTRADE(v_baseLine);											 --ɾ������ҵ������������
			v_baseLine := v_baseLine + 1;
    end;
    exit when (v_endDate - v_baseLine) < 0;
  end loop;

  -- ����켣��(���м��ͳ�����ݲ��뵽�켣���У���ʱ�м������û��ȥ�أ������������������ȥ��)
  proc_aml_dealoperatordata(v_dataBatchNo);

  -- �����/����ҵ����ʱ��������Ǩ�Ƶ�ҵ���ȥ�أ�
  proc_aml_data_migration(v_dataBatchNo);

	-- ����ҵ������Ѿ���������ݼ�¼����ȡ��־����
  PROC_AML_INS_LX_LXCALLOG(i_oprater,v_dataBatchNo);

	-- ���ɹ���ȡ�����ݼ�¼����ȡ�������
	PROC_AML_INS_LDBATCHLOG(v_dataBatchNo,'IS','01',trunc(sysdate),to_char(v_baseLine-1,'yyyy-mm-dd')||'���չ�����ȡ�ɹ���');

  commit;

--�쳣����
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;

  errorCode:= SQLCODE;
  errorMsg:= SUBSTR(SQLERRM, 1, 200);
  v_errormsg:=to_char((v_baseLine),'yyyy-mm-dd')||errorCode||errorMsg;

	-- ����ȡʧ�ܵ���Ϣ��¼����ȡ�������
	PROC_AML_INS_LX_LDBATCHLOG(v_dataBatchNo,'00',trunc(sysdate),v_errormsg);
  commit;


end proc_aml_main;
/


prompt Done
spool off
set define on
