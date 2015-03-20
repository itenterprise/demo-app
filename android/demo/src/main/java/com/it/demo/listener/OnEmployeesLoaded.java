package com.it.demo.listener;

import com.it.demo.model.Employee;

import java.util.ArrayList;

/**
 * Обработчик загрузки списка сотрудников
 */
public interface OnEmployeesLoaded {
	public void onEmployeesLoaded(ArrayList<Employee> employees);
}
