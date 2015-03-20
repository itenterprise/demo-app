package com.it.demo.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

import io.realm.RealmObject;
import io.realm.annotations.Ignore;

/**
 * Описание сотрудника
 */
@JsonIgnoreProperties(ignoreUnknown=true)
public class Employee extends RealmObject implements Serializable {

	/**
	 * Логин пользователя в системе IT
	 */
	@JsonProperty("USERLOGIN")
	private String login;

	/**
	 * Идентификатор N_KDK
	 */
	@JsonProperty("NKDK")
	private String nkdk;

	/**
	 * Телефон
	 */
	@JsonProperty("PHONE")
	private String phone;

	/**
	 * Почта
	 */
	@JsonProperty("EMAIL")
	private String email;

	/**
	 * ФИО пользователя
	 */
	@JsonProperty("FIO")
	private String fio;

	/**
	 * Подразделение
	 */
	@JsonProperty("DEPARTMENT")
	private String department;

	/**
	 * Фото (имя в Temp каталоге)
	 */
	@JsonProperty("PHOTO")
	private String photoName;

	/**
	 * Хеш
	 */
	@JsonProperty("HASH")
	private String hash;

	/**
	 * Признак online
	 */
	private boolean isOnline;

	//region Standard getters & setters
	public String getLogin() { return login; }
	public void setLogin(String login) { this.login = login != null ? login : ""; }

	public String getPhone() { return phone; }
	public void setPhone(String phone) { this.phone = phone != null ? phone : ""; }

	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email != null ? email : ""; }

	public String getPhotoName() { return photoName; }
	public void setPhotoName(String photoName) { this.photoName = photoName != null ? photoName : ""; }

	public String getNkdk() { return nkdk; }
	public void setNkdk(String nkdk) { this.nkdk = nkdk; }

	public String getFio() { return fio; }
	public void setFio(String fio) { this.fio = fio; }

	public String getDepartment() { return department; }
	public void setDepartment(String department) { this.department = department; }

	public String getHash() { return hash; }
	public void setHash(String hash) { this.hash = hash != null ? hash : ""; }

	public boolean getIsOnline() { return isOnline; }
	public void setIsOnline(boolean isOnline) { this.isOnline = isOnline; }
	//endregion
}