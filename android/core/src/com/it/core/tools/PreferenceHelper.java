package com.it.core.tools;

import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.preference.PreferenceManager;

import com.it.core.activity.SettingsActivity;
import com.it.core.application.ApplicationBase;

/**
 * Вспомогательный класс для работы с настройками
 */
public class PreferenceHelper {

	public static String getWebServiceUrl() {
		SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(ApplicationBase.getInstance());
		String url = pref.getString(SettingsActivity.WEB_SERVICE_URL_PREFERENCE, "").toLowerCase();
		if (url.isEmpty()) {
			return url;
		}
		if (!url.startsWith("http://") && !url.startsWith("https://")) {
			url = "http://" + url;
		}
		String webServiceUrl = "ws/webservice.asmx";
		if (!url.contains(webServiceUrl)) {
			if (!url.endsWith("/")) {
				url = url + "/";
			}
			url = url + webServiceUrl;
		}
		return url;
	}

	public static String getUploadUrl() {
		String url = getWebServiceUrl();
		return url.isEmpty() ? url : url.replace("webservice.asmx", "addfile.ashx");
	}

	public static String getFileUrl(String tempFileName) {
		String url = getWebServiceUrl();
		return url.isEmpty() ? url : url.replace("webservice.asmx", "getfile.ashx?file=") + tempFileName;
	}

	public static void setApplicationVersion(){
		SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(ApplicationBase.getInstance());
		try {
			pref.edit().putString("appVersion", ApplicationBase.getInstance().getPackageManager().getPackageInfo(ApplicationBase.getInstance().getPackageName(), 0).versionName).apply();
		} catch (PackageManager.NameNotFoundException e) {
			e.printStackTrace();
		}
	}
}