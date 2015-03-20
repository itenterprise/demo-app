package com.it.demo;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.app.Fragment;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SearchView;


import com.it.core.tools.ViewTools;
import com.it.demo.adapter.EmployeeAdapter;
import com.it.demo.listener.OnEmployeesLoaded;
import com.it.demo.manager.EmployeeManager;
import com.it.demo.model.Employee;

import java.util.ArrayList;

/**
 * Фрагмент отображения сотрудников
 */
public class EmployeeFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener, SearchView.OnQueryTextListener,	SearchView.OnCloseListener, OnEmployeesLoaded {

	private SwipeRefreshLayout mSwipeLayout;
	private ListView mEmployeesListView;
	private SearchView mSearchView;

	private ArrayList<Employee> mFilteredEmployees;
	private EmployeeAdapter mEmployeeAdapter;

	public EmployeeFragment() {
		// Required empty public constructor
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Активация ActionBar
		setHasOptionsMenu(true);
		// Inflate the layout for this fragment
		View rootView = inflater.inflate(R.layout.fragment_employee, container, false);
		initView(rootView);
		// Инициализация контрола "Потяни, чтоб обновить"
		mSwipeLayout = ViewTools.initSwipeToRefresh(rootView, R.id.swipe_container, this);
		loadEmployees();
		return rootView;
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
		MenuItem actionSearch = menu.findItem(R.id.action_search);
		// Задать действие поиска
		if (actionSearch != null) {
			actionSearch.setVisible(true);
			mSearchView = (SearchView) actionSearch.getActionView();
			mSearchView.setOnQueryTextListener(this);
			mSearchView.setOnCloseListener(this);
		}
		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public void onEmployeesLoaded(ArrayList<Employee> employees) {
		mSwipeLayout.setRefreshing(false);
		updateEmployeesList(ViewTools.getSearchText(mSearchView));
	}

	@Override
	public void onRefresh() {
		loadEmployees();
	}

	@Override
	public boolean onClose() {
		return false;
	}

	@Override
	public boolean onQueryTextSubmit(String query) {
		updateEmployeesList(query);
		mSearchView.clearFocus();
		return false;
	}

	@Override
	public boolean onQueryTextChange(String newText) {
		updateEmployeesList(newText);
		return true;
	}

	/**
	 * Инициализация представления фрагмента
	 */
	private void initView(View rootView) {
		mEmployeesListView = (ListView)rootView.findViewById(R.id.employees_list);
		mEmployeesListView.setEmptyView(rootView.findViewById(R.id.no_employees_text_view));
		mEmployeesListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent i = new Intent(getActivity(), DetailsActivity.class);
				i.putExtra(DetailsActivity.FRAGMENT_ID_KEY, DetailsActivity.EMPLOYEE_DETAILS_FRAGMENT_ID);
				i.putExtra(EmployeeManager.EMPLOYEE_NKDK_KEY, mFilteredEmployees.get(position).getNkdk());
				i.putExtra(EmployeeManager.EMPLOYEE_LOGIN_KEY, mFilteredEmployees.get(position).getLogin());
				startActivity(i);
			}
		});
	}

	/**
	 * Фильтрация списка сотрудников
	 * @param searchText Текст поиска
	 */
	private void updateEmployeesList(String searchText) {
		mFilteredEmployees = EmployeeManager.getInstance(getActivity()).getEmployees(searchText);//findByText(searchText);
		if (mEmployeeAdapter != null) {
			mEmployeeAdapter.clear();
			mEmployeeAdapter.addAll(mFilteredEmployees);
			mEmployeeAdapter.notifyDataSetChanged();
		} else {
			mEmployeeAdapter = new EmployeeAdapter(getActivity(), mFilteredEmployees);
			mEmployeesListView.setAdapter(mEmployeeAdapter);
		}
	}

	/**
	 * Загрузка сотрудников
	 */
	private void loadEmployees() {
		EmployeeManager.getInstance(getActivity()).loadEmployees(getActivity(), this);
	}
}