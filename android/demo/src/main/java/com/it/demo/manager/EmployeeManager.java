package com.it.demo.manager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;

import com.it.core.internalstorage.InternalStorageSerializer;
import com.it.core.notifications.Dialog;
import com.it.core.service.IService;
import com.it.core.service.OnTaskCompleted;
import com.it.core.service.ServiceFactory;
import com.it.demo.R;
import com.it.demo.listener.OnConnectionsLoaded;
import com.it.demo.listener.OnEmployeesLoaded;
import com.it.demo.model.Connection;
import com.it.demo.model.Employee;

import java.util.ArrayList;
import java.util.List;

import io.realm.Realm;
import io.realm.RealmResults;

/**
 * Класс управления сотрудниками
 */
public class EmployeeManager {

	public static final String EMPLOYEE_NKDK_KEY = "EMPLOYEE_NKDK";
	public static final String EMPLOYEE_LOGIN_KEY = "EMPLOYEE_LOGIN";

	private static EmployeeManager sInstance;
	private static Context mContext;
	private static Realm mRealm;
	private ArrayList<Employee> mEmployees;
	private ProgressDialog mProgress;

	private EmployeeManager(){}

	public static EmployeeManager getInstance(Context context) {
		if (mContext != null && sInstance != null) {
			return sInstance;
		}
		sInstance = new EmployeeManager();
		mContext = context;
		mRealm = Realm.getInstance(context);
		return sInstance;
	}

	/**
	 * Получить список сотрудников
	 * @return Список сотрудников
	 */
	public ArrayList<Employee> getEmployees(){
		return getEmployees("");
	}

	/**
	 * Получить отфильтрованный список сотрудников
	 * @param searchText Текст поиска
	 * @return Список сотрудников
	 */
	public ArrayList<Employee> getEmployees(String searchText) {
		if (mEmployees == null) {
			return new ArrayList<Employee>();
		}
		if (searchText == null || searchText.isEmpty()) {
			return new ArrayList<Employee>(mEmployees);
		}
		ArrayList<Employee> filteredList = new ArrayList<Employee>();
		String upperText = searchText.toUpperCase();
		for (Employee employee : mEmployees) {
			// Добавить в отфильтрованный список
			// если ФИО пользователя содержит текст поиска
			// или наименование подразделения содержит текст поиска
			if (employee.getFio().toUpperCase().contains(upperText) ||
					employee.getDepartment().toUpperCase().contains(upperText)) {
				filteredList.add(employee);
			}
		}
		return filteredList;
	}

	/**
	 * Загрузить список сотрудников
	 * @param activity Активность
	 * @param employeesLoadedListener Обработчик завершения загрузки списка сотрудников
	 */
	public void loadEmployees(final Activity activity, final OnEmployeesLoaded employeesLoadedListener) {
		mProgress = Dialog.showProgressDialog(activity, R.string.employees_loading);
		ServiceFactory.ServiceParams p = new ServiceFactory.ServiceParams(activity);
		final Object params = new Object(){ public List USERS = toDictionary(findAll()); };
		// Установка кеширования результата
		p.setCache(true);
		final IService service = ServiceFactory.createService(p);
		service.setOnExecuteCompletedHandler(new OnTaskCompleted() {
			@Override
			public void onTaskCompleted(Object result) {
				ArrayList<Employee> employees = result != null ? (ArrayList<Employee>)result : new ArrayList<Employee>();
				fillOnline(employees);
				update(employees);
				mEmployees = employees;
				employeesLoadedListener.onEmployeesLoaded(mEmployees);
				Dialog.hideProgress(mProgress);
			}
		});
		// Загрузка списка подключений (необходимо для установки статуса онлайн/офлайн)
		ConnectionManager.getInstance().loadConnections(activity, new OnConnectionsLoaded() {
			@Override
			public void onConnectionsLoaded(ArrayList<Connection> connections) {
				service.ExecObjects("_DEMO.GETEMPLOYEES", params, Employee.class, activity);
			}
		}, false);
	}

	/**
	 * Найти всех сохраненных сотрудников
	 * @return Список сотрудников
	 */
	public ArrayList<Employee> findAll() {
		return new ArrayList<Employee>(mRealm.where(Employee.class).findAllSorted("fio"));
	}

	/**
	 * Найти сохраненного сотрудника по идентификатору N_KDK
	 * @param nkdk N_KDK
	 * @param login Логин сотрудника
	 * @return Сотрудник
	 */
	public Employee findByNkdkAndLogin(String nkdk, String login) {
		return nkdk == null
				? null
				: mRealm.where(Employee.class).equalTo("nkdk", nkdk).equalTo("login", login).findFirst();
	}

	public ArrayList<Employee> findByText(String text) {
		if (text == null || text.isEmpty()) {
			return findAll();
		}
		// TODO: раскомментировать когда пофиксят баг
//		return new ArrayList<Employee>(mRealm.where(Employee.class)
//				.beginsWith("fio", text, false)
//				.or().contains("fio", text, false)
//				.or().beginsWith("department", text, false)
//				.or().contains("department", text, false)
//				.findAll());
		ArrayList<Employee> filteredList = new ArrayList<Employee>();
		String upperText = text.toUpperCase();
		for (Employee employee : findAll()) {
			if (employee.getFio().toUpperCase().contains(upperText) ||
					employee.getDepartment().toUpperCase().contains(upperText)) {
				filteredList.add(employee);
			}
		}
		return filteredList;
	}

	/**
	 * Обновить список сотрудников в Realm
	 * @param updatedEmployees Обновленный список сотрудников
	 */
	public void update(ArrayList<Employee> updatedEmployees) {
		mRealm.beginTransaction();
		RealmResults<Employee> oldEmployees = mRealm.where(Employee.class).findAll();
		// Удаление устарелых сотрудников
		// Если сохраненного сотрудника нет в обновленном списке, тогда удалить из Realm
		for (int i = 0; i < oldEmployees.size(); i++) {
			Employee oldEmployee = oldEmployees.get(i);
			boolean notUsed = true;
			for (Employee newEmployee: updatedEmployees) {
				if (newEmployee.getNkdk().equals(oldEmployee.getNkdk())) {
					notUsed = false;
					break;
				}
			}
			if (notUsed) {
				oldEmployee.removeFromRealm();
			}
		}
		// Если сохраненный сотрудник есть в обновленном списке
		// тогда обновить
		// иначе добавить нового сотрудника
		for (Employee employee: updatedEmployees) {
			Employee oldEmployee = mRealm.where(Employee.class)
					.equalTo("nkdk", employee.getNkdk())
					//TODO: если nkdk уникальный, то удалить следующую строку
					.equalTo("login", employee.getLogin())
					.findFirst();
			if (oldEmployee != null) {
				String newPhoto = employee.getPhotoName();
				if (newPhoto != null && !newPhoto.isEmpty()) {
					oldEmployee.setPhotoName(newPhoto);
				}
				oldEmployee.setIsOnline(employee.getIsOnline());
			} else {
				createRealmEmployee(employee);
			}
		}
		mRealm.commitTransaction();
	}

	/**
	 * Сохранить фотографию в InternalStorage
	 * @param employee Сотрудник
	 * @param photo Фотография (Bitmap)
	 */
	public void setPhoto(Employee employee, Bitmap photo){
		InternalStorageSerializer iss = new InternalStorageSerializer();
		iss.saveBitmap(mContext, employee.getPhotoName(), photo);
	}

	/**
	 * Создать новый объект Сотрудник с привязкой к базе Realm
	 * @param employee Сотрудник
	 * @return Сотрудник с привязкой к базе Realm
	 */
	private Employee createRealmEmployee(Employee employee){
		if (employee.getNkdk() == null || employee.getNkdk().isEmpty()) {
			return null;
		}
		// Создать новый объект Сотрудник
		Employee newEmployee = mRealm.createObject(Employee.class);
		newEmployee.setLogin(employee.getLogin());
		newEmployee.setNkdk(employee.getNkdk());
		newEmployee.setEmail(employee.getEmail());
		newEmployee.setPhone(employee.getPhone());
		newEmployee.setFio(employee.getFio());
		newEmployee.setDepartment(employee.getDepartment());
		newEmployee.setPhotoName(employee.getPhotoName());
		newEmployee.setHash(employee.getHash());
		newEmployee.setIsOnline(employee.getIsOnline());
		return newEmployee;
	}

	/**
	 * Заполнить онлайн статус сотрудников
	 * @param employees Список сотрудников
	 */
	private void fillOnline(ArrayList<Employee> employees) {
		ArrayList<Connection> connections = ConnectionManager.getInstance().getConnections();
		// Проверка наличия сотрудника в списке подключений
		for (Employee employee: employees) {
			if (employee.getLogin() == null || employee.getLogin().isEmpty()) {
				continue;
			}
			for (Connection connection: connections) {
				if (connection.getUserLogin() != null && employee.getLogin().toUpperCase().equals(connection.getUserLogin().toUpperCase())) {
					employee.setIsOnline(true);
					break;
				}
			}
		}
	}

	/**
	 * Получить из списка сотрудников словарь идентификаторов пользователей
	 * @param employees Список сотрудников
	 * @return Словарь идентификаторов
	 */
	private ArrayList toDictionary(ArrayList<Employee> employees) {
		ArrayList userIds = new ArrayList();
		for (final Employee employee : employees) {
			userIds.add(new Object(){
				public String NKDK = employee.getNkdk();
				public String HASH = employee.getHash();
			});
		}
		return userIds;
	}
}