package com.it.demo;


import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.it.core.notifications.Dialog;
import com.it.core.tools.DateTimeFormatter;
import com.it.core.tools.TextViewTools;
import com.it.core.tools.ViewTools;
import com.it.demo.listener.OnConnectionDetailsLoaded;
import com.it.demo.manager.ConnectionManager;
import com.it.demo.model.Connection;
import com.it.demo.model.ConnectionDetails;


/**
 * Фрагмент отображения детальной информации о соединении
 */
public class ConnectionDetailsFragment extends Fragment implements OnConnectionDetailsLoaded {

	private static final String ARG_CONNECTION_ID = "ConnectionId";

	private View mRootView;
	private int mConnectionId;

	/**
	 * Создание экземпляра фрагмента ConnectionDetailsFragment с параметрами
	 * @param connectionId Идентификатор соединения
	 * @return Экземпляр фрагмента ConnectionDetailsFragment
	 */
	public static ConnectionDetailsFragment newInstance(int connectionId) {
		ConnectionDetailsFragment fragment = new ConnectionDetailsFragment();
		Bundle args = new Bundle();
		args.putInt(ARG_CONNECTION_ID, connectionId);
		fragment.setArguments(args);
		return fragment;
	}

	public ConnectionDetailsFragment() {
		// Required empty public constructor
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (getArguments() != null) {
			mConnectionId = getArguments().getInt(ARG_CONNECTION_ID);
		}
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		mRootView = inflater.inflate(R.layout.fragment_connection_details, container, false);
		ConnectionManager.getInstance().loadConnectionDetails(getActivity(), mConnectionId, this);
		return mRootView;
	}

	@Override
	public void onConnectionDetailsLoaded(ConnectionDetails details) {
		Connection listConnection = ConnectionManager.getInstance().getConnectionById(mConnectionId);
		if ((details.getFio() == null && details.getStatus() == null && details.getFunction() == null) ||
				!details.getFio().equals(listConnection.getFio())) {
			Dialog.showPopupWithBack(getActivity(), R.string.no_info_about_connection, R.string.need_update_connection_list);
			getActivity().setResult(Activity.RESULT_OK);
			return;
		}
		// Заполнить представление
		fillView(details);
		// Обновить значения функции, статуса и даты последней передачи данных
		listConnection.setFunction(details.getFunction());
		listConnection.setDateTransfer(details.getDateTransfer());
		listConnection.setStatus(details.getStatus());
		listConnection.setStatusColor(details.getStatusColor());
	}

	/**
	 * Заполнить представление данными
	 * @param details Детальное описание подключения
	 */
	private void fillView(ConnectionDetails details) {
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_function, details.getFunction());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_date, DateTimeFormatter.getStringDate(getActivity(), details.getDateTransfer()));
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_status, details.getStatus());
		ViewTools.setCircleImageView((ImageView) mRootView.findViewById(R.id.fragment_connection_details_status_color), Color.parseColor(details.getStatusColor()));
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_sql_login, details.getSqlLogin());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_windows_login, details.getWinLogin());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_it_login, details.getItLogin());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_host, details.getHost());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_fio, details.getFio());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_db, details.getDataBase());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_server, details.getServer());
//		ViewTools.setText(mRootView, R.id.fragment_connection_details_object, details.getObject());
		TextViewTools.setText(mRootView, R.id.fragment_connection_details_application, details.getApplication());
	}
}