package com.it.core.network;

import com.it.core.application.ApplicationBase;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class NetworkParams {
	
	/**
	 * Проверка интернет соединения (наследуется ActivityBase)
	 */
	public static boolean isNetworkConnected() {
        return isNetworkConnected(ApplicationBase.getInstance());
	}

    /**
     * Проверка интернет соединения
     */
    public static boolean isNetworkConnected(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
	    return activeNetwork != null && activeNetwork.isConnected();
    }
}