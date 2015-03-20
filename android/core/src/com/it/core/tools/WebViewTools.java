package com.it.core.tools;

import android.view.View;
import android.view.View.OnLongClickListener;
import android.webkit.WebView;

/**
 * Класс для работы с елементом WebView
 */

public class WebViewTools {

	/**
	 * Загрузка HTML данных в WebView
	 * @param webView Елемент WebView
	 * @param data HTML данные
	 */
	public static void loadData(WebView webView, String data) {
		if(!data.isEmpty()){
			webView.loadData(data, "text/html; charset=UTF-8", null);
		} else {
			webView.setVisibility(View.GONE);
		}
	}

	/**
	 * Загрузка HTML данных в WebView
	 * @param webView Елемент WebView
	 * @param data HTML данные
	 * @param fontSize Размер шрифта
	 */
	public static void loadData(WebView webView, String data, int fontSize) {
		String formatedData = String.format("<body style=\"" +
				"font-size: %spx !important\"> %s</body>", fontSize, data);
		loadData(webView, formatedData);
	}

	/**
	 * Загрузка HTML данных в WebView со специальним форматом
	 * @param webView Елемент WebView
	 * @param data HTML данные
	 */
	public static void loadDataFormatted(WebView webView, String data) {
		if(!data.isEmpty()){
			String formatedData = String.format("<body style=\"margin: 0; " +
					"padding: 0; " +
					"color:#B0B0B0; " +
					"font-size: 14px\"> %s</body>", data);
			webView.loadData(formatedData, "text/html; charset=UTF-8", null);
			webView.refreshDrawableState();
			webView.reload();
		} else {
			webView.setVisibility(View.GONE);
		}
	}

	/**
	 * Отключить обработку "длинного клика"
	 * @param webView Елемент WebView
	 */
	public static void disableLongClick(WebView webView) {
		webView.setOnLongClickListener(new OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				return true;
			}
		});
		webView.setClickable(false);
		webView.setLongClickable(false);
		webView.setFocusable(false);
		webView.setFocusableInTouchMode(false);
	}
}