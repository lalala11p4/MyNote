package danyimoshi;

public class lanhanshi {
	public static void main(String[] args) {
		Student student1 = Student.getStudent();
		Student student2 = Student.getStudent();
		System.out.println(student1==student2);
		
	}
}

/**
 * ��̬�ĳ�Ա������������˽�л�
 * @author Lenovo
 *	��̬�������ж������Ƿ�Ϊ�գ���Ϊ�ռ����������Ϊ�����.class  �ļ�
 *	���������ʵ��
 */

class Student{
	
	private static Student student;
	
	private Student() {
		System.out.println("123");
	}
	
	public static Student getStudent() {
		if (student==null) {
			synchronized(Student.class) {
				student=new Student();
			}
		}
		return student;
	}
	
}