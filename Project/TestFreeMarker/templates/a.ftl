��ã�${user},�������ɫ����
--------------------------------------
����if���
<#if user=="�쿭">
	��ܰ��
</#if>
--------------------------------------
<#if random gte 90>
	����
<#elseif random gte 60>
	����
<#else>
	������
</#if>
--------------------------------------
����list����
<#list list as bianliang>
	<b>${bianliang.country}</b></br>
</#list>
--------------------------------------
���԰���ָ��
<#include "included.txt">
--------------------------------------
���Ժ�ָ��

����꣺
<#macro m1>  <#-- ����ָ��m1 -->
	<b>aaabbbccc</b>
	<b>dddeeefff</b>
</#macro>

���ú꣺
<@m1 /><@m1 /><@m1 /><@m1 />

����������ĺ�
<#macro m2 a b c>
	${a}--${b}--${c}
</#macro>

���ú꣺
<@m2 "hai" "nihao" "helo"/>
<@m2 "zhou" "qing" "kai"/>

--------------------------------------
<#-- nestedָ�� -->
<#macro border h>   <#-- �вλ����޲���border������ӱ��� -->
	<table border=4 cellspacing=0 cellpadding=4>
		<tr>
			<td>
			  ${h}			
			</td>
		</tr>
	</table>
</#macro>

���ú꣺
<@border "�����вε�nestedָ��"/>
--------------------------------------
<#-- nestedָ�� -->
<#macro bord>   <#-- �вλ����޲���border������ӱ��� -->
	<table border=4 cellspacing=0 cellpadding=4>
		<tr>
			<td>
				<#nested>			
			</td>
		</tr>
	</table>
</#macro>
���ú꣺
<@bord>
	border�ı��м������  ʹ��#nested����
</@bord>

--------------------------------------
����namespace�����ռ�

<#-- һ����Ҫ�Ĺ������·����Ӧ�ð�����д��ĸ��Ϊ�˷ָ���ʹ���»��� -->

<#import "b.ftl" as bb/>
<@bb.copyright date="2010-2011"/>
${bb.mail}
<#assign mail="aaaaaaaaaa@163.com" />
${mail}
<#assign mail="aaaatobbbb@163.com" in bb />
${bb.mail}
--------------------------------------
������������

<#-- Freemarker����javaBean�Ĵ����EL���ʽһֱ�����Ϳ��Զ�ת�����ǳ����� -->

<#assign b="sss">
${date1?string("yyyy-MM-dd HH:mm:ss")}
--------------------------------------
���Կ�ֵ����
<#--  ${sss} û�ж����������  �ᱨ�쳣 �ں�����ϣ�  ��ʾ  û���������  ��Ĭ��ֵ��   -->
<#--  û�ж������������Ĭ���ַ�����abcd -->
${sss!} 
${sss!"abcd"}
?? ��ʾ�ж��Ƿ�Ϊtrue  ����ֵboolean
<#if user??>Welcome ${user}</#if>
--------------------------------------





