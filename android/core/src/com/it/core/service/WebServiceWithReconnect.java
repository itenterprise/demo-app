package com.it.core.service;

import android.app.Activity;

import com.it.core.R;
import com.it.core.application.ApplicationBase;
import com.it.core.login.LoginService;
import com.it.core.login.OnLoginCompleted;
import com.it.core.model.UserInfo;
import com.it.core.notifications.Dialog;

import com.it.core.session.OnSessionUpdated;
import com.it.core.session.UpdateSessionService;

public class WebServiceWithReconnect extends WebServiceBase {
	
	private String method;
	private Object params;
	private Activity activity;
	
	/**
	 * Выполнить расчет
	 * @param method Наименование расчета
	 * @param params Параметры вызова
	 * @param activity Активность
	 */
	@Override
	public void execute(String method, Object params, Activity activity) {
		this.method = method;
		this.params = params;
		this.activity = activity;
		super.execute(method, params, activity);
	}
	
	private void reExec(){
		super.execute(method, params, activity);
	}
	
	@Override
	public void OnCompleted(String result) {
		if ("WRONG_TICKET".equals(result)) {
			LoginService login = (LoginService)ServiceFactory.createLoginService(activity);
			login.setOnLoginSuccessHandler(new OnLoginCompleted() {
				
				@Override
				public void onSuccess(boolean needUpdateSession) {
					if (needUpdateSession) {
						onTicketUpdated();
					} else {
						reExec();
					}
				}
				
				@Override
				public void onFail() {
					UserInfo.removeTicketAndName();
					UserInfo.removeCredentials();
					ApplicationBase.getInstance().navigateToLogin();
				}

				@Override
				public void onError() {
					OnCompleted(null);
				}
			});
			login.loginFromStoredCredentials();
		} else {
			if (result == null) {
				String message = activity.getString(R.string.no_connection_to_application_server);
				Dialog.showPopup(activity, message);
			}
			super.OnCompleted(result);
		}
	}

    private void onTicketUpdated() {
        UpdateSessionService sessionService = (UpdateSessionService)ServiceFactory.createUpdateSessionService(activity);
        sessionService.setOnSessionUpdatedHandler(new OnSessionUpdated() {
            @Override
            public void onUpdated() {
                reExec();
            }
        });
        sessionService.update();
    }
}