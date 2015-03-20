package com.it.demo.model;

import android.graphics.Color;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.it.core.serialization.JsonDateDeserializer;

import java.io.Serializable;
import java.util.Date;

/**
 * Описание подключения к серверу БД
 */
@JsonIgnoreProperties(ignoreUnknown=true)
public class Connection implements Serializable {

	/**
	 * Идентификатор подключения к серверу БД
	 */
	@JsonProperty("SPID")
	private int id;

	/**
	 * Дата последней передачи данных
	 */
	@JsonProperty("LASTDATE")
	@JsonDeserialize(using = JsonDateDeserializer.class)
	private Date dateTransfer;

	/**
	 * Статус подключения
	 */
	@JsonProperty("STATUS")
	private String status;

	/**
	 * Цвет статуса подключения
	 */
	@JsonProperty("STATUSCOLOR")
	private String statusColor;

	/**
	 * ФИО
	 */
	@JsonProperty("FIO")
	private String fio;

	/**
	 * Наименование функции
	 */
	@JsonProperty("FUNCTIONNAME")
	private String function;

	/**
	 * Логин пользователя в системе IT
	 */
	@JsonProperty("USERLOGIN")
	private String userLogin;

	//region Standard getters & setters
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }

	public Date getDateTransfer() { return dateTransfer; }
	public void setDateTransfer(Date dateTransfer) { this.dateTransfer = dateTransfer; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public String getStatusColor() {
		return statusColor;
	}
	public void setStatusColor(String statusColor) { this.statusColor = statusColor; }

	public String getFio() { return fio; }
	public void setFio(String fio) { this.fio = fio; }

	public String getFunction() { return function; }
	public void setFunction(String function) { this.function = function; }

	public String getUserLogin() { return userLogin; }
	public void setUserLogin(String userLogin) { this.userLogin = userLogin; }
	//endregion
}