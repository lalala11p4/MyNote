package com.sinosoft;

import java.io.File;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;


public class Test1 {
	public static void main(String[] args) throws Exception {
		// ����Freemarker����ʵ��
//		Configuration cfg = new Configuration();
//		cfg.setDirectoryForTemplateLoading(new File("templates"));
//
//		// ��������ģ��
//		Map<String, Object> root = new HashMap<String, Object>();
//		root.put("user", "�쿭");
//		root.put("random", new Random().nextInt(100));
//		
//		List<Address> list = new ArrayList<Address>();
//		list.add(new Address("�й�", "������"));
//		list.add(new Address("�й�", "�Ϻ�"));
//		list.add(new Address("����", "ŦԼ"));
//		root.put("list", list);
//		root.put("date1", new Date());
//		
//		// ����ģ���ļ�
//		Template t1 = cfg.getTemplate("a.ftl");
//
//		// ��ʾ���ɵ�����
//		/**
//		 * ���������̨
//		 * �����Զ��������һ��socket���ļ�����socket.getOutputStream
//		 * 
//		 */
//		Writer out = new OutputStreamWriter(System.out);
//		t1.process(root, out);
//		out.flush();
//		out.close();
	}
}
