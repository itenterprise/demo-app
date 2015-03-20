package com.it.core.service;

import com.it.core.application.ApplicationBase;
import com.it.core.serialization.SerializeHelper;
import com.it.core.model.UserInfo;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class WebServiceExecuteExecutor extends WebServiceExecutor {

	private String calc;
	private Object params;
	
	public WebServiceExecuteExecutor(String calc, Object params) {
		super("ExecuteEx");
		this.calc = calc;
		this.params = params;
	}

    @Override
    protected String getJSONRequestParams() {
        String parameters = "";
        try {
	        String ticket = UserInfo.getTicket() != null ? UserInfo.getTicket() : ApplicationBase.getInstance().getTicket();
            parameters = String.format("calcId=%s&args=%s&ticket=%s",
                    calc, params != null ? URLEncoder.encode(SerializeHelper.serialize(params), CHARSET): "", ticket != null ? ticket : "");
            int index = 0;
            while (parameters.substring(index).contains("Date%28")) {
                int begin = parameters.indexOf("Date%28", index);
                int end = parameters.indexOf("%22", begin);
                parameters = new StringBuilder(parameters).insert(end, "%5c%2F").toString();
                parameters = new StringBuilder(parameters).insert(begin, "%5c%2F").toString();
                index = end;
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        catch (Exception e) {
	        e.printStackTrace();
        }
        return parameters;
    }
}