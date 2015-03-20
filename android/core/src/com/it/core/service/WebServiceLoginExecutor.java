package com.it.core.service;

import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.util.Locale;

public class WebServiceLoginExecutor extends WebServiceExecutor {

	private String login;
	private String password;
	
	public WebServiceLoginExecutor(String login, String password) {
		super("LoginEx");
		this.login = login;
		this.password = password;
	}

	protected void fillRequestHeaders(HttpURLConnection connection){
		connection.setRequestProperty("Accept-Language", Locale.getDefault().getLanguage());
	}


    @Override
    protected String getJSONRequestParams() {
		try {
			return String.format("login=%s&password=%s", URLEncoder.encode(login, CHARSET), URLEncoder.encode(password, CHARSET));
		} catch (UnsupportedEncodingException e) {
			return String.format("login=%s&password=%s", login, password);
		}
	}
}