package com.it.core.login;

/**
 * Должен реализовывать класс, который будет обрабатывать результат попытки входа в систему
 * @author bened
 *
 */
public interface OnLoginCompleted {
	/**
	 * Будет вызван в случае успешного входа
	 * @param needUpdateSession Признак необходимости обновить сессию пользователя
	 */
	void onSuccess(boolean needUpdateSession);
	
	/**
	 * Будет вызван в случае неудачного входа
	 */
	void onFail();
	
	/**
	 * Будет вызван в случае получения ошибки
	 */
	void onError();
}