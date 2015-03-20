package com.it.demo;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;

import com.it.core.tools.KeyboardHelper;
import com.it.demo.manager.ConnectionManager;
import com.it.demo.manager.EmployeeManager;


/**
 * Активность отображения детального описания
 */
public class DetailsActivity extends FragmentActivity {

	public static final String FRAGMENT_ID_KEY = "FRAGMENT_ID";
	public static final int EMPLOYEE_DETAILS_FRAGMENT_ID = 0;
	public static final int CONNECTION_DETAILS_FRAGMENT_ID = 1;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_details);
		// Запуск необходимого фрагмента по идентификатору из намерения (Intent)
		Intent intent = getIntent();
		int currentFragmentId = intent.getIntExtra(FRAGMENT_ID_KEY, 0);
		Fragment newFragment;
		int titleId;
		switch (currentFragmentId) {
			// Фрагмент с детальним описанием подключения
			case CONNECTION_DETAILS_FRAGMENT_ID:
				newFragment = ConnectionDetailsFragment.newInstance(intent.getIntExtra(ConnectionManager.CONNECTION_ID_KEY, 0));
				titleId = R.string.connection;
				break;
			// Фрагмент детальной информации о сотруднике
			case EMPLOYEE_DETAILS_FRAGMENT_ID:
			default:
				newFragment = EmployeeDetailsFragment.newInstance(intent.getStringExtra(
						EmployeeManager.EMPLOYEE_NKDK_KEY), intent.getStringExtra(EmployeeManager.EMPLOYEE_LOGIN_KEY));
				titleId = R.string.employee;
				break;
		}
		setTitle(titleId);
		// update the main content by replacing fragments
		FragmentManager fragmentManager = getSupportFragmentManager();
		fragmentManager.beginTransaction()
				.replace(R.id.details_container, newFragment)
				.commit();
	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.details, menu);
		getActionBar().setDisplayHomeAsUpEnabled(true);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		switch (item.getItemId()) {
			case android.R.id.home:
				super.onBackPressed();
				return true;
			default:
				return super.onOptionsItemSelected(item);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		return KeyboardHelper.toggleKeyboard(this, event, super.dispatchTouchEvent(event));
	}
}