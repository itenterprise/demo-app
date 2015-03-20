package com.it.demo.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.it.demo.R;

import java.io.Serializable;

/**
 * Детальное описание подключения к серверу БД
 */
@JsonIgnoreProperties(ignoreUnknown=true)
public class ConnectionDetails extends Connection implements Serializable {

	/**
	 * Наименование сервера БД
	 */
	@JsonProperty("SERVERNAME")
	private String server;

	/**
	 * Наименование БД
	 */
	@JsonProperty("DBNAME")
	private String dataBase;

	/**
	 * Логин SQL
	 */
	@JsonProperty("LOGIN")
	private String sqlLogin;

	/**
	 * Логин Windows
	 */
	@JsonProperty("WINDOWSUSER")
	private String winLogin;

	/**
	 * Логин ІТ
	 */
	@JsonProperty("USERID")
	private String itLogin;

	/**
	 * Наименование приложения
	 */
	@JsonProperty("PRGNAME")
	private String application;

	/**
	 * Сетевое имя рабочей машины пользователя
	 */
	@JsonProperty("HOSTNAME")
	private String host;

	//region Standard getters & setters
	public String getServer() { return server; }
	public void setServer(String server) { this.server = server; }

	public String getDataBase() { return dataBase; }
	public void setDataBase(String dataBase) { this.dataBase = dataBase; }

	public String getSqlLogin() { return sqlLogin; }
	public void setSqlLogin(String sqlLogin) { this.sqlLogin = sqlLogin; }

	public String getWinLogin() { return winLogin; }
	public void setWinLogin(String winLogin) { this.winLogin = winLogin; }

	public String getItLogin() { return itLogin; }
	public void setItLogin(String itLogin) { this.itLogin = itLogin; }

	public String getApplication() { return application; }
	public void setApplication(String application) { this.application = application; }

	public String getHost() { return host; }
	public void setHost(String host) { this.host = host; }
	//endregion
}