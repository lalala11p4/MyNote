package CreateExcelAndZipFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

public class CreateExcelFile {
	/**
	 * @param args
	 * @throws IOException
	 * @throws WriteException
	 * @throws RowsExceededException
	 */
	public static void main(String[] args) throws RowsExceededException, WriteException, IOException {
		String path = "F:\\Test";
		// �����ļ���;
		createFile(path);
		// ����Excel�ļ�;
		createExcelFile(path);
		// ����.zip�ļ�;
		craeteZipPath(path);
		// ɾ��Ŀ¼�����е��ļ�;
		//File file = new File(path);
		// ɾ���ļ�;
		//deleteExcelPath(file);
		// ���´����ļ�;
		//file.mkdirs();

	}

	/**
	 * �����ļ���D:\document\excel; ��D���д���document�ļ��У��������洴��excel�ļ���
	 * 
	 * @param path
	 * @return
	 */
	public static String createFile(String path) {
		File file = new File(path);
		// �ж��ļ��Ƿ����;
		if (!file.exists()) {
			// �����ļ�;
			boolean bol = file.mkdirs();
			if (bol) {
				System.out.println(path + " ·�������ɹ�!");
			} else {
				System.out.println(path + " ·������ʧ��!");
			}
		} else {
			System.out.println(path + " �ļ��Ѿ�����!");
		}
		return path;
	}

	/**
	 * ��ָ��Ŀ¼�´���Excel�ļ�; ��excel�ļ����·���������excel�ļ�����������ʽ������
	 * 
	 * @param path
	 * @throws IOException
	 * @throws WriteException
	 * @throws RowsExceededException
	 */
	public static void createExcelFile(String path) throws IOException, RowsExceededException, WriteException {
		for (int i = 0; i < 3; i++) {
			// ����Excel;
			WritableWorkbook workbook = Workbook.createWorkbook(new File(
					path + "/" + new SimpleDateFormat("yyyyMMddHHmmsss").format(new Date()) + "_" + (i + 1) + ".xls"));
			// ������һ��sheet�ļ�;
			WritableSheet sheet = workbook.createSheet("����Excel�ļ�", 0);
			// ����Ĭ�Ͽ��;
			sheet.getSettings().setDefaultColumnWidth(30);

			// ��������;
			WritableFont font1 = new WritableFont(WritableFont.ARIAL, 14, WritableFont.BOLD, false,
					UnderlineStyle.NO_UNDERLINE, Colour.RED);

			WritableCellFormat cellFormat1 = new WritableCellFormat(font1);
			// ���ñ�����ɫ;
			cellFormat1.setBackground(Colour.BLUE_GREY);
			// ���ñ߿�;
			cellFormat1.setBorder(Border.ALL, BorderLineStyle.DASH_DOT);
			// �����Զ�����;
			cellFormat1.setWrap(true);
			// �������־��ж��뷽ʽ;
			cellFormat1.setAlignment(Alignment.CENTRE);
			// ���ô�ֱ����;
			cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);
			// ������Ԫ��
			Label label1 = new Label(0, 0, "��һ�е�һ����Ԫ��(�����Ƿ��Զ�����!)", cellFormat1);
			Label label2 = new Label(1, 0, "��һ�еڶ�����Ԫ��", cellFormat1);
			Label label3 = new Label(2, 0, "��һ�е�������Ԫ��", cellFormat1);
			Label label4 = new Label(3, 0, "��һ�е��ĸ���Ԫ��", cellFormat1);
			// ��ӵ�����;
			sheet.addCell(label1);
			sheet.addCell(label2);
			sheet.addCell(label3);
			sheet.addCell(label4);

			// д��Excel�����;
			workbook.write();
			// �ر���;
			workbook.close();
		}
	}

	/**
	 * ����.zip�ļ�,��excel�ļ�ѹ��Ϊѹ����;
	 * 
	 * @param path
	 * @throws IOException
	 */
	public static void craeteZipPath(String path) throws IOException {
		ZipOutputStream zipOutputStream = null;
		File file = new File(path + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".zip");
		zipOutputStream = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(file)));
		File[] files = new File(path).listFiles();
		FileInputStream fileInputStream = null;
		byte[] buf = new byte[1024];
		int len = 0;

		if (files != null && files.length > 0) {
			for (File excelFile : files) {
				String fileName = excelFile.getName();
				fileInputStream = new FileInputStream(excelFile);
				// ����ѹ��zip����;
				zipOutputStream.putNextEntry(new ZipEntry(path + "/" + fileName));

				// ��ȡ�ļ�;
				while ((len = fileInputStream.read(buf)) > 0) {
					zipOutputStream.write(buf, 0, len);
				}
				// �ر�;
				zipOutputStream.closeEntry();
				if (fileInputStream != null) {
					fileInputStream.close();
				}
			}
		}

		if (zipOutputStream != null) {
			zipOutputStream.close();
		}
	}

	/**
	 * @throws FileNotFoundException
	 * 
	 */

	public void CreateZipFile() throws Exception {
		String path = "F:\\Test";
		File file = new File(path);
		//��·���������ļ�����������
		File[] files = file.listFiles();
		//�����Լ���zip�ļ�����ָ��ȫ·��
		File zip = new File(path + "/" + "myZip.zip");
		//����ѹ���ļ��������
		ZipOutputStream zos = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zip)));
		byte[] b = new byte[1024];
		int len = 0;

		FileInputStream fis = null;
		//ѭ��  Ϊÿһ���ļ�ѹ����ѹ���ļ���
		for (File file2 : files) {
			//��ȡ�ļ���
			String fileName = file2.getName();
			try {
				//��ȡ������
				fis = new FileInputStream(file2);
				//����zipѹ������
				zos.putNextEntry(new ZipEntry(path + "/" + fileName));
				// ��ȡ�ļ�;
				while ((len = fis.read(b)) > 0) {
					zos.write(b, 0, len);
				}
				//�ر�ÿ�η������
				zos.closeEntry();
				//�رն�ȡ����
				if (fis != null) {
					fis.close();
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		}
		/**
		 * �ر������ѹ���ļ���
		 * �����ѭ���йرգ�ֻ��д��һ���ļ���
		 */
		if (zos!=null) {
			zos.close();
		}
	}

	/**
	 * ɾ��Ŀ¼�����е��ļ�;
	 * 
	 * @param path
	 */
	public static boolean deleteExcelPath(File file) {
		String[] files = null;
		if (file != null) {
			files = file.list();
		}

		if (file.isDirectory()) {
			for (int i = 0; i < files.length; i++) {
				boolean bol = deleteExcelPath(new File(file, files[i]));
				if (bol) {
					System.out.println("ɾ���ɹ�!");
				} else {
					System.out.println("ɾ��ʧ��!");
				}
			}
		}
		return file.delete();
	}

	/**
	 * �Լ�ѧϰ�ıʼǣ������Լ���Ҫ��Excel�ļ�
	 * 
	 * @throws IOException
	 * @throws WriteException
	 */
	public void CreateExcel() throws IOException, WriteException {
		// �����½�Excel�ļ����ļ���
		String path = "F:\\Test";
		File dir = new File(path);
		if (dir.isDirectory()) {
			System.out.println("�ļ����Ѿ�����");
			File[] listFiles = dir.listFiles();
			for (File file : listFiles) {
				if (file.isFile()) {
					file.delete();
				}
			}
		} else {
			dir.mkdir();
			System.out.println("�����ļ��гɹ�");
		}

		// ����Ĭ�Ͽ��
		// ����WritableWorkbook Excel�ļ�ʱ��Ҫһ��ִ������������û���
		WritableWorkbook workBook = Workbook.createWorkbook(new File(path + "/" + "�쿭��Excel�ļ���ʱ��Ϊ��"
				+ new SimpleDateFormat("yyyyMMddHHmmsss").format(new Date()) + "_" + 1 + ".xls"));

		WritableSheet sheet = workBook.createSheet("�쿭�ĵ�һ��sheet", 0);

		sheet.getSettings().setDefaultColumnWidth(30);
		// ��������;
		WritableFont font1 = new WritableFont(WritableFont.ARIAL, 14, WritableFont.BOLD, false,
				UnderlineStyle.NO_UNDERLINE, Colour.RED);

		WritableCellFormat cellFormat1 = new WritableCellFormat(font1);
		// ���ñ�����ɫ;
		cellFormat1.setBackground(Colour.BLUE_GREY);
		// ���ñ߿�;
		cellFormat1.setBorder(Border.ALL, BorderLineStyle.DASH_DOT);
		// �����Զ�����;
		cellFormat1.setWrap(true);
		// �������־��ж��뷽ʽ;
		cellFormat1.setAlignment(Alignment.CENTRE);
		// ���ô�ֱ����;
		cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);

		// ������Ԫ��
		Label label1 = new Label(0, 0, "��һ�е�һ����Ԫ��(�����Ƿ��Զ�����!)", cellFormat1);
		Label label2 = new Label(1, 0, "��һ�еڶ�����Ԫ��", cellFormat1);
		Label label3 = new Label(2, 0, "��һ�е�������Ԫ��", cellFormat1);
		Label label4 = new Label(3, 0, "��һ�е��ĸ���Ԫ��", cellFormat1);

		// ��ӵ�����;
		sheet.addCell(label1);
		sheet.addCell(label2);
		sheet.addCell(label3);
		sheet.addCell(label4);

		// ���ڶ������ñ�����������ɫ�����뷽ʽ�ȵ�;
		WritableFont font2 = new WritableFont(WritableFont.ARIAL, 14, WritableFont.NO_BOLD, false,
				UnderlineStyle.NO_UNDERLINE, Colour.BLUE2);
		WritableCellFormat cellFormat2 = new WritableCellFormat(font2);
		cellFormat2.setAlignment(Alignment.CENTRE);
		cellFormat2.setBackground(Colour.PINK);
		cellFormat2.setBorder(Border.ALL, BorderLineStyle.THIN);
		cellFormat2.setWrap(true);

		// ������Ԫ��;
		Label label11 = new Label(0, 1, "�ڶ��е�һ����Ԫ��(�����Ƿ��Զ�����!)", cellFormat2);
		Label label22 = new Label(1, 1, "�ڶ��еڶ�����Ԫ��", cellFormat2);
		Label label33 = new Label(2, 1, "�ڶ��е�������Ԫ��", cellFormat2);
		Label label44 = new Label(3, 1, "�ڶ��е��ĸ���Ԫ��", cellFormat2);

		sheet.addCell(label11);
		sheet.addCell(label22);
		sheet.addCell(label33);
		sheet.addCell(label44);

		/**
		 * ����ͨ��workBook����д�룬���еĲ�������������н��� sheetΪExcelһ����� cellΪ��ʽ label��Ԫ��
		 */
		WritableSheet sheet2 = workBook.createSheet("�쿭�ĵڶ���sheet", 1);
		sheet2.getSettings().setDefaultColumnWidth(30);
		WritableFont font = new WritableFont(WritableFont.ARIAL, 14, WritableFont.BOLD, false,
				UnderlineStyle.NO_UNDERLINE, Colour.RED);
		WritableCellFormat cell = new WritableCellFormat(font);
		cell.setAlignment(Alignment.CENTRE);
		cell.setBackground(Colour.BLACK);
		cell.setWrap(true);
		// ������Ԫ��
		Label lable211 = new Label(0, 0, "��һ�е�һ�е�ֵ", cell);
		Label lable212 = new Label(1, 0, "��һ�еڶ��е�ֵ", cell);
		Label lable213 = new Label(2, 0, "��һ�е����е�ֵ", cell);
		Label lable214 = new Label(3, 0, "��һ�е����е�ֵ", cell);
		Label lable215 = new Label(4, 0, "��һ�е����е�ֵ", cell);
		sheet2.addCell(lable211);
		sheet2.addCell(lable212);
		sheet2.addCell(lable213);
		sheet2.addCell(lable214);
		sheet2.addCell(lable215);

		// д��Excel�����;
		workBook.write();
		// �ر���;
		workBook.close();

	}

}
