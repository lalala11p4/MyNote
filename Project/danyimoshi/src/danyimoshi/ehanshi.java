package danyimoshi;

public class ehanshi {
	public static void main(String[] args) {
		Teacher teacher1 = Teacher.getTeacher();
		Teacher teacher2 = Teacher.getTeacher();
		System.out.println(teacher1==teacher2);
	}
}

/**
 * ����ģʽ������ʽ7h* @author Lenovo
 *	�����Ա��������Ϊ��̬��final���ε�ʵ�廯����
 *	ͬʱ������Ϊ�򵥹�����������super()������Ϊ��̬���������ڳ�Ա�����д�����ʵ��
 *
 */
class Teacher{
	private static final Teacher teacher =new Teacher();
	
	private Teacher() {
		super();
	}
	
	public static Teacher getTeacher() {
		return teacher;
	}
	
}