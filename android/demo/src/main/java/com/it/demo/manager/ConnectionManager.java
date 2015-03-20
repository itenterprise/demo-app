package com.it.demo.manager;

import android.app.Activity;

import com.it.core.service.IService;
import com.it.core.service.OnTaskCompleted;
import com.it.core.service.ServiceFactory;
import com.it.demo.R;
import com.it.demo.listener.OnConnectionDetailsLoaded;
import com.it.demo.listener.OnConnectionsLoaded;
import com.it.demo.model.Connection;
import com.it.demo.model.ConnectionDetails;

import java.util.ArrayList;

/**
 * Класс управления подключениями к серверу БД
 */
public class ConnectionManager {

	public static final String CONNECTION_ID_KEY = "CONNECTION_ID";
	public static final int CONNECTION_DETAILS_REQUEST_CODE = 101;

	private ArrayList<Connection> mConnections;
	private static ConnectionManager sInstance;

	private ConnectionManager(){}

	public static ConnectionManager getInstance() {
		if (sInstance == null) {
			sInstance = new ConnectionManager();
		}
		return sInstance;
	}

	/**
	 * Получить список подключений
	 * @return Список подключений
	 */
	public ArrayList<Connection> getConnections(){
		return getConnections("");
	}

	/**
	 * Получить отфильтрованный список подключений
	 * @param searchText Текст поиска
	 * @return Список подключений
	 */
	public ArrayList<Connection> getConnections(String searchText) {
		if (mConnections == null) {
			return new ArrayList<Connection>();
		}
		if (searchText == null || searchText.isEmpty()) {
			return new ArrayList<Connection>(mConnections);
		}
		// Получить отфильтрованный список согласно тексту поиска
		ArrayList<Connection> filteredList = new ArrayList<Connection>();
		String upperText = searchText.toUpperCase();
		for (Connection connection : mConnections) {
			// Добавить в отфильтрованный список
			// если ФИО пользователя содержит текст поиска
			// или наименование функции содержит текст поиска
			if (connection.getFio().toUpperCase().contains(upperText) ||
					connection.getFunction().toUpperCase().contains(upperText)) {
				filteredList.add(connection);
			}
		}
		return filteredList;
	}

	/**
	 * Получить подключение по идентификатору
	 * @param id Идентификаор подключения
	 * @return Подключение
	 */
	public Connection getConnectionById(int id) {
		if (mConnections == null || id == 0) {
			return null;
		}
		Connection result = null;
		for (Connection connection : mConnections) {
			if (connection.getId() == id) {
				result = connection;
				break;
			}
		}
		return result;
	}

	/**
	 * Загрузить список подключений к серверу БД
	 * @param activity Активность
	 * @param connectionsLoadedListener Обработчик завершения загрузки списка подключений к серверу БД
	 */
	public void loadConnections(Activity activity, final OnConnectionsLoaded connectionsLoadedListener) {
		loadConnections(activity, null, connectionsLoadedListener, true);
	}

	/**
	 * Загрузить список подключений к серверу БД
	 * @param activity Активность
	 * @param connectionsLoadedListener Обработчик завершения загрузки списка подключений к серверу БД
	 */
	public void loadConnections(Activity activity, final OnConnectionsLoaded connectionsLoadedListener, boolean showProgress) {
		loadConnections(activity, null, connectionsLoadedListener, showProgress);
	}

	/**
	 * Загрузить список подключений пользователя к серверу БД
	 * @param activity Активность
	 * @param login Логин пользователя в системе ІТ
	 * @param connectionsLoadedListener Обработчик завершения загрузки списка подключений к серверу БД
	 */
	public void loadConnections(Activity activity, final String login, final OnConnectionsLoaded connectionsLoadedListener) {
		loadConnections(activity, login, connectionsLoadedListener, true);
	}

	/**
	 * Загрузить список подключений пользователя к серверу БД
	 * @param activity Активность
	 * @param login Логин пользователя в системе ІТ
	 * @param showProgress Отобразить процесс загрузки
	 * @param connectionsLoadedListener Обработчик завершения загрузки списка подключений к серверу БД
	 */
	private void loadConnections(Activity activity, final String login, final OnConnectionsLoaded connectionsLoadedListener, boolean showProgress) {
		ServiceFactory.ServiceParams p = new ServiceFactory.ServiceParams(activity);
		if (showProgress) {
			p.setProgressParams(new ServiceFactory.ProgressParams(activity.getString(R.string.connections_loading)));
		}
		p.setCache(true);
		IService service = ServiceFactory.createService(p);
		service.setOnExecuteCompletedHandler(new OnTaskCompleted() {
			@Override
			public void onTaskCompleted(Object result) {
				mConnections = result != null ? (ArrayList<Connection>)result : new ArrayList<Connection>();
				connectionsLoadedListener.onConnectionsLoaded(mConnections);
			}
		});
		Object params = login == null ? new Object() : new Object() { public String USERLOGIN = login; };
		service.ExecObjects("BASEMON.GETCONNECTIONS", params, Connection.class, activity);
	}

	/**
	 * Загрузить детальное описание подключения к серверу БД
	 * @param activity Активность
	 * @param id Логин пользователя в системе ІТ
	 * @param connectionDetailsLoadedListener Обработчик завершения загрузки детальной информации о подключений к серверу БД
	 */
	public void loadConnectionDetails(Activity activity, final int id, final OnConnectionDetailsLoaded connectionDetailsLoadedListener) {
		ServiceFactory.ServiceParams p = new ServiceFactory.ServiceParams(activity);
		p.setProgressParams(new ServiceFactory.ProgressParams(activity.getString(R.string.connection_loading)));
		p.setCache(true);
		IService service = ServiceFactory.createService(p);
		service.setOnExecuteCompletedHandler(new OnTaskCompleted() {
			@Override
			public void onTaskCompleted(Object result) {
				ConnectionDetails d = (ConnectionDetails)result;
				connectionDetailsLoadedListener.onConnectionDetailsLoaded((ConnectionDetails)result);
			}
		});
		service.ExecObject("BASEMON.GETCONNECTIONINFO", new Object() {
			public int SPID = id;
		}, ConnectionDetails.class, activity);
	}
}