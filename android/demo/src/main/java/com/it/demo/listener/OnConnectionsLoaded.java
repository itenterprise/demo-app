package com.it.demo.listener;

import com.it.demo.model.Connection;

import java.util.ArrayList;

/**
 * Обработчик загрузки списка подключений
 */
public interface OnConnectionsLoaded {
	public void onConnectionsLoaded(ArrayList<Connection> connections);
}