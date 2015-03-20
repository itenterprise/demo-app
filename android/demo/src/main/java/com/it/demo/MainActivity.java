package com.it.demo;

import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;

import com.it.core.activity.ActivityBase;
import com.it.core.menu.SideMenuItem;

import java.util.ArrayList;


/**
 * Главная активность
 */
public class MainActivity extends ActivityBase {

	private static final int EMPLOYEES_MENU_ITEM = 101;
	private static final int CONNECTIONS_MONITOR_MENU_ITEM = 102;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.activity_main);
		// Инициализация меню
		ArrayList<SideMenuItem> menuItems = new ArrayList<SideMenuItem>();
		menuItems.add(new SideMenuItem(EMPLOYEES_MENU_ITEM, getString(R.string.employees), R.drawable.ic_employees, false));
		menuItems.add(new SideMenuItem(CONNECTIONS_MONITOR_MENU_ITEM, getString(R.string.connections_monitor), R.drawable.ic_connections_monitor, false));
		setNavigationDrawer(R.layout.activity_main, R.id.main_container, R.id.drawer_layout, R.id.navigation_drawer,
				R.menu.main, R.menu.global, R.string.demo_app_name, menuItems, 0);
		super.onCreate(savedInstanceState);
	}

	@Override
	protected void onAfterCreate() {
		super.onAfterCreate();
	}

	@Override
	protected boolean needsAuthentication(){
		return true;
	}

	@Override
	protected boolean needsCheckVersion() {
		return false;
	}

	@Override
	public void onNavigationDrawerItemSelected(SideMenuItem item) {
		// update the main content by replacing fragments
		Fragment checkedFragment;
		switch (item.Id) {
			case CONNECTIONS_MONITOR_MENU_ITEM:
				checkedFragment = new ConnectionMonitorFragment();
				break;
			case EMPLOYEES_MENU_ITEM:
			default:
				checkedFragment = new EmployeeFragment();
				break;
		}
		setFragmentActive(checkedFragment);
		super.onNavigationDrawerItemSelected(item);
	}

	/**
	 * Установить фрагмент активним
	 * @param fragment Фрагмент
	 */
	private void setFragmentActive(Fragment fragment) {
		// update the main content by replacing fragments
		FragmentManager fragmentManager = getFragmentManager();
		fragmentManager.beginTransaction()
				.replace(R.id.main_container, fragment)
				.commitAllowingStateLoss();
	}
}