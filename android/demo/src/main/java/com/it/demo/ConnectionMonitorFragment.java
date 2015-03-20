package com.it.demo;


import android.app.Activity;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.app.Fragment;
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
import com.it.demo.adapter.ConnectionAdapter;
import com.it.demo.listener.OnConnectionsLoaded;
import com.it.demo.manager.ConnectionManager;
import com.it.demo.model.Connection;

import java.util.ArrayList;


/**
 * Фрагмент отображения монитора подключений
 */
public class ConnectionMonitorFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener, SearchView.OnQueryTextListener, SearchView.OnCloseListener, OnConnectionsLoaded {

	private SwipeRefreshLayout mSwipeLayout;
	private ListView mConnectionsListView;
	private SearchView mSearchView;

	private ArrayList<Connection> mFilteredConnections;
	private ConnectionAdapter mConnectionAdapter;

	public ConnectionMonitorFragment() {
		// Required empty public constructor
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Активация ActionBar
		setHasOptionsMenu(true);
		// Inflate the layout for this fragment
		View rootView = inflater.inflate(R.layout.fragment_connection_monitor, container, false);
		initView(rootView);
		// Инициализация контрола "Потяни, чтоб обновить"
		mSwipeLayout = ViewTools.initSwipeToRefresh(rootView, R.id.swipe_container, this);
		loadConnections();
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
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (resultCode == Activity.RESULT_OK && requestCode == ConnectionManager.CONNECTION_DETAILS_REQUEST_CODE) {
			loadConnections();
		} else {
			if (mConnectionAdapter != null) {
				mConnectionAdapter.notifyDataSetChanged();
			}
		}
	}

	@Override
	public void onRefresh() {
		loadConnections();
	}

	@Override
	public boolean onQueryTextSubmit(String query) {
		updateConnectionsList(query);
		mSearchView.clearFocus();
		return false;
	}

	@Override
	public boolean onQueryTextChange(String newText) {
		updateConnectionsList(newText);
		return false;
	}

	@Override
	public boolean onClose() {
		return false;
	}

	@Override
	public void onConnectionsLoaded(ArrayList<Connection> connections) {
		mSwipeLayout.setRefreshing(false);
		updateConnectionsList(ViewTools.getSearchText(mSearchView));
	}

	/**
	 * Инициализация представления фрагмента
 	 */
	private void initView(View rootView) {
		mConnectionsListView = (ListView)rootView.findViewById(R.id.connections_list);
		mConnectionsListView.setEmptyView(rootView.findViewById(R.id.no_connections_text_view));
		// Задать обработчик клика по елементу списка
		mConnectionsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent i = new Intent(getActivity(), DetailsActivity.class);
				i.putExtra(DetailsActivity.FRAGMENT_ID_KEY, DetailsActivity.CONNECTION_DETAILS_FRAGMENT_ID);
				i.putExtra(ConnectionManager.CONNECTION_ID_KEY, mFilteredConnections.get(position).getId());
				// Запуск новой активности с параметрами
				startActivityForResult(i, ConnectionManager.CONNECTION_DETAILS_REQUEST_CODE);
			}
		});
	}

	/**
	 * Фильтрация списка сотрудников
	 * @param searchText Текст поиска
	 */
	private void updateConnectionsList(String searchText) {
		mFilteredConnections = ConnectionManager.getInstance().getConnections(searchText);
		if (mFilteredConnections == null) {
			return;
		}
		if (mConnectionAdapter != null) {
			mConnectionAdapter.clear();
			mConnectionAdapter.addAll(mFilteredConnections);
			mConnectionAdapter.notifyDataSetChanged();
		} else {
			mConnectionAdapter = new ConnectionAdapter(getActivity(), mFilteredConnections);
			mConnectionsListView.setAdapter(mConnectionAdapter);
		}
	}

	/**
	 * Загрузка подключений
	 */
	private void loadConnections() {
		ConnectionManager.getInstance().loadConnections(getActivity(), this);
	}
}