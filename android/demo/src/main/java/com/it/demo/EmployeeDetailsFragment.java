package com.it.demo;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.TextView;

import com.it.core.tools.TextViewTools;
import com.it.core.view.ExpandableHeightListView;
import com.it.demo.adapter.ConnectionAdapter;
import com.it.demo.common.ViewHelper;
import com.it.demo.listener.OnConnectionsLoaded;
import com.it.demo.manager.ConnectionManager;
import com.it.demo.manager.EmployeeManager;
import com.it.demo.model.Connection;
import com.it.demo.model.Employee;

import java.util.ArrayList;


/**
 * Фрагмент отображения детальной информации о сотруднике
 */
public class EmployeeDetailsFragment extends Fragment implements OnConnectionsLoaded{

	private static final String ARG_EMPLOYEE_NKDK = "Employee_Nkdk";
	private static final String ARG_EMPLOYEE_LOGIN = "Employee_Login";

	private Employee mEmployee;
	private ArrayList<Connection> mConnections;
	private ExpandableHeightListView mConnectionsListView;
	private ConnectionAdapter mConnectionsAdapter;
	private View mActiveFunctionsLayout;

	/**
	 * Создание экземпляра фрагмента EmployeeDetailsFragment с параметрами
	 * @param nkdk Идентфикатор nkdk
	 * @param login Логин пользователя в системе ІТ
	 * @return Экземпляр фрагмента EmployeeDetailsFragment
	 */
	public static EmployeeDetailsFragment newInstance(String nkdk, String login) {
		EmployeeDetailsFragment fragment = new EmployeeDetailsFragment();
		Bundle args = new Bundle();
		args.putString(ARG_EMPLOYEE_NKDK, nkdk);
		args.putString(ARG_EMPLOYEE_LOGIN, login);
		fragment.setArguments(args);
		return fragment;
	}

	public EmployeeDetailsFragment() {
		// Required empty public constructor
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (getArguments() != null) {
			mEmployee = EmployeeManager.getInstance(getActivity()).findByNkdkAndLogin(
					getArguments().getString(ARG_EMPLOYEE_NKDK), getArguments().getString(ARG_EMPLOYEE_LOGIN));
			loadActiveFunctions(mEmployee.getLogin());
		}
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View rootView = inflater.inflate(R.layout.fragment_employee_details, container, false);
		initView(rootView);
		return rootView;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (resultCode == Activity.RESULT_OK && requestCode == ConnectionManager.CONNECTION_DETAILS_REQUEST_CODE) {
			loadActiveFunctions(mEmployee.getLogin());
		} else {
			if (mConnectionsAdapter != null) {
				mConnectionsAdapter.notifyDataSetChanged();
			}
		}
	}

	@Override
	public void onConnectionsLoaded(ArrayList<Connection> connections) {
		mConnections = connections;
		updateConnectionsList();
	}

	private void initView(View rootView) {
		if (mEmployee == null) {
			return;
		}
		ViewHelper.setPhoto(getActivity(), (ImageView)rootView.findViewById(R.id.fragment_employee_details_photo), mEmployee.getNkdk(), mEmployee.getLogin(), null);
		TextViewTools.setText((TextView) rootView.findViewById(R.id.fragment_employee_details_name), mEmployee.getFio());
		if (mEmployee.getIsOnline()) {
			TextViewTools.setText((TextView)rootView.findViewById(R.id.fragment_employee_details_online_status), getString(R.string.online));
		}
		TextViewTools.setText((TextView)rootView.findViewById(R.id.fragment_employee_details_department), mEmployee.getDepartment());
		TextViewTools.setText((TextView)rootView.findViewById(R.id.fragment_employee_details_phone), mEmployee.getPhone());
		TextViewTools.setText((TextView)rootView.findViewById(R.id.fragment_employee_details_email), mEmployee.getEmail());

		mActiveFunctionsLayout = rootView.findViewById(R.id.fragment_employee_details_functions_layout);
		mConnectionsListView = (ExpandableHeightListView) rootView.findViewById(R.id.fragment_employee_details_active_functions_list);
		mConnectionsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent i = new Intent(getActivity(), DetailsActivity.class);
				i.putExtra(DetailsActivity.FRAGMENT_ID_KEY, DetailsActivity.CONNECTION_DETAILS_FRAGMENT_ID);
				i.putExtra(ConnectionManager.CONNECTION_ID_KEY, mConnections.get(position).getId());
				startActivityForResult(i, ConnectionManager.CONNECTION_DETAILS_REQUEST_CODE);
			}
		});
	}

	private void loadActiveFunctions(String login) {
		if (login != null && !login.isEmpty()) {
			ConnectionManager.getInstance().loadConnections(getActivity(), login, this);
		}
	}

	private void updateConnectionsList() {
		mConnections = ConnectionManager.getInstance().getConnections();
		if (mConnections == null || mConnections.isEmpty()) {
			mActiveFunctionsLayout.setVisibility(View.GONE);
			return;
		}
		mActiveFunctionsLayout.setVisibility(View.VISIBLE);
		if (mConnectionsAdapter != null) {
			mConnectionsAdapter.clear();
			mConnectionsAdapter.addAll(mConnections);
			mConnectionsAdapter.notifyDataSetChanged();
		} else {
			mConnectionsAdapter = new ConnectionAdapter(getActivity(), mConnections, true);
			mConnectionsListView.setAdapter(mConnectionsAdapter);
			mConnectionsListView.setExpanded(true);
		}
	}
}