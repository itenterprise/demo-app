package com.it.demo.listener;

import com.it.demo.model.ConnectionDetails;

/**
 * Обработчик загрузки детального описания подключения
 */
public interface OnConnectionDetailsLoaded {
	public void onConnectionDetailsLoaded(ConnectionDetails details);
}