package com.it.core.activity;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.RingtonePreference;
import android.text.TextUtils;
import android.view.MenuItem;

import java.util.List;

import com.google.zxing.client.android.CaptureActivity;
import com.it.core.R;
import com.it.core.application.ApplicationBase;

/**
 * A {@link PreferenceActivity} that presents a set of application settings. On
 * handset devices, settings are presented as a single list. On tablets,
 * settings are split by category, with category headers shown to the left of
 * the list of settings.
 * <p>
 * See <a href="http://developer.android.com/design/patterns/settings.html">
 * Android Design: Settings</a> for design guidelines and the <a
 * href="http://developer.android.com/guide/topics/ui/settings.html">Settings
 * API Guide</a> for more information on developing a Settings UI.
 */
public class SettingsActivity extends PreferenceActivity implements SharedPreferences.OnSharedPreferenceChangeListener {
	
	/**
	 * Determines whether to always show the simplified settings UI, where
	 * settings are presented in a single list. When false, settings are shown
	 * as a master/detail two-pane view on tablets. When true, a single pane is
	 * shown on tablets.
	 */
	private static final boolean ALWAYS_SIMPLE_PREFS = true;
	private static final int SCAN_BARCODE_REQUEST_CODE = 0;
	private static final int WEB_SERVICE_ADDRESS_REQUEST_CODE = 1;

	public static final String WEB_SERVICE_URL_PREFERENCE = "webServiceAddressPref";

	private String mOldUrl;

	@Override
	protected void onPostCreate(Bundle savedInstanceState) {
		super.onPostCreate(savedInstanceState);
		setupPreferencesScreen();
        getPreferenceScreen().getSharedPreferences().registerOnSharedPreferenceChangeListener(this);
		// Enabling Up / Back navigation
        getActionBar().setDisplayHomeAsUpEnabled(true);
	}

	/**
	 * Shows the simplified settings UI if the device configuration if the
	 * device configuration dictates that a simplified, single-pane UI should be
	 * shown.
	 */
	public void setupPreferencesScreen() {
		if (!isSimplePreferences(this)) {
			return;
		}
		addPreferencesFromResource(R.xml.preferences);
        for(String s: getPreferenceScreen().getSharedPreferences().getAll().keySet()){
            bindPreferenceSummaryToValue(findPreference(s));
        }
		Preference webServiceUrl = findPreference(WEB_SERVICE_URL_PREFERENCE);
		mOldUrl = PreferenceManager.getDefaultSharedPreferences(ApplicationBase.getInstance()).getString(WEB_SERVICE_URL_PREFERENCE, "").toLowerCase();
		if (mOldUrl.isEmpty()) {
			mOldUrl = webServiceUrl.getSummary().toString();
			putStringToPreferences(WEB_SERVICE_URL_PREFERENCE, mOldUrl);
		}
//		bindPreferenceSummaryToValue(findPreference("webServiceAddressPref"));

		//bindPreferenceSummaryToValue(findPreference(WEB_SERVICE_URL_PREFERENCE));
//		webServiceUrl.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
//			@Override
//			public boolean onPreferenceChange(Preference preference, Object newValue) {
//				ApplicationBase.getInstance().setInited(false);
//				String newUrl = ((String)newValue).toLowerCase();
//				SettingsActivity.this.setResult(newUrl.equals(mOldUrl) ? RESULT_CANCELED : RESULT_OK);
//				return true;
//			}
//		});
		Preference scanQr = (Preference)findPreference("scanQr");
        if(scanQr != null){
            scanQr.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
                @Override
                public boolean onPreferenceClick(Preference preference) {
                    Intent intent = new Intent(SettingsActivity.this, CaptureActivity.class);
                    intent.setAction("com.google.zxing.client.android.SCAN");
                    intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
                    startActivityForResult(intent, SCAN_BARCODE_REQUEST_CODE);
                    return false;
                }
            });
        }
		Preference webServiceAddress = (Preference)findPreference(WEB_SERVICE_URL_PREFERENCE);
		if(webServiceAddress != null){
			webServiceAddress.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					Intent intent = new Intent(SettingsActivity.this, WebServiceAddressActivity.class);
					startActivityForResult(intent, WEB_SERVICE_ADDRESS_REQUEST_CODE);
					return false;
				}
			});
		}
	}

    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
		bindPreferenceSummaryToValue(findPreference(key));
		if (key.equals(WEB_SERVICE_URL_PREFERENCE)) {
			ApplicationBase.getInstance().setInited(false);
			String newUrl = sharedPreferences.getString(key, "").toLowerCase();
			SettingsActivity.this.setResult(newUrl.equals(mOldUrl) ? RESULT_CANCELED : RESULT_OK);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == RESULT_OK) {
			String newUrl = null;
			if (requestCode == SCAN_BARCODE_REQUEST_CODE) {
				newUrl = data.getStringExtra("SCAN_RESULT");
			}
			if (requestCode == WEB_SERVICE_ADDRESS_REQUEST_CODE) {
				newUrl = data.getStringExtra(SettingsActivity.WEB_SERVICE_URL_PREFERENCE);
			}
			fillWebServiceUrl(newUrl);
		}
	}

	/** {@inheritDoc} */
	@Override
	public boolean onIsMultiPane() {
		return isXLargeTablet(this) && !isSimplePreferences(this);
	}

	/**
	 * Helper method to determine if the device has an extra-large screen. For
	 * example, 10" tablets are extra-large.
	 */
	private static boolean isXLargeTablet(Context context) {
		return (context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_XLARGE;
	}

	/**
	 * Determines whether the simplified settings UI should be shown. This is
	 * true if this is forced via {@link #ALWAYS_SIMPLE_PREFS}, or the device
	 * doesn't have newer APIs like {@link PreferenceFragment}, or the device
	 * doesn't have an extra-large screen. In these cases, a single-pane
	 * "simplified" settings UI should be shown.
	 */
	private static boolean isSimplePreferences(Context context) {
		return ALWAYS_SIMPLE_PREFS
				|| Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB
				|| !isXLargeTablet(context);
	}

	/** {@inheritDoc} */
	@Override
	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	public void onBuildHeaders(List<Header> target) {
		if (!isSimplePreferences(this)) {
			loadHeadersFromResource(R.xml.pref_headers, target);
		}
	}

	/**
	 * A preference value change listener that updates the preference's summary
	 * to reflect its new value.
	 */
	private static Preference.OnPreferenceChangeListener sBindPreferenceSummaryToValueListener = new Preference.OnPreferenceChangeListener() {
		@Override
		public boolean onPreferenceChange(Preference preference, Object value) {
			String stringValue = value.toString();
			if (preference instanceof ListPreference) {
				// For list preferences, look up the correct display value in
				// the preference's 'entries' list.
				ListPreference listPreference = (ListPreference) preference;
				int index = listPreference.findIndexOfValue(stringValue);

				// Set the summary to reflect the new value.
				preference
						.setSummary(index >= 0 ? listPreference.getEntries()[index]
								: null);
			} else if (preference instanceof RingtonePreference) {
				// For ringtone preferences, look up the correct display value
				// using RingtoneManager.
				if (TextUtils.isEmpty(stringValue)) {
					// Empty values correspond to 'silent' (no ringtone).
					preference.setSummary(R.string.pref_ringtone_silent);
				} else {
					Ringtone ringtone = RingtoneManager.getRingtone(
							preference.getContext(), Uri.parse(stringValue));

					if (ringtone == null) {
						// Clear the summary if there was a lookup error.
						preference.setSummary(null);
					} else {
						// Set the summary to reflect the new ringtone display
						// name.
						String name = ringtone
								.getTitle(preference.getContext());
						preference.setSummary(name);
					}
				}
			} else {
				// For all other preferences, set the summary to the value's
				// simple string representation.
				preference.setSummary(stringValue);
			}
			return true;
		}
	};

	/**
	 * Binds a preference's summary to its value. More specifically, when the
	 * preference's value is changed, its summary (line of text below the
	 * preference title) is updated to reflect the value. The summary is also
	 * immediately updated upon calling this method. The exact display format is
	 * dependent on the type of preference.
	 *
	 * @see #sBindPreferenceSummaryToValueListener
	 */
	public static void bindPreferenceSummaryToValue(Preference preference) {
		if (preference == null) {
			return;
		}
		// Set the listener to watch for value changes.
		preference
				.setOnPreferenceChangeListener(sBindPreferenceSummaryToValueListener);
		// Trigger the listener immediately with the preference's
		// current value.
		sBindPreferenceSummaryToValueListener.onPreferenceChange(
				preference,
				PreferenceManager.getDefaultSharedPreferences(
						preference.getContext()).getString(preference.getKey(),
						""));
	}

	/**
	 * Заполнить адрес веб-сервиса
	 * @param url Адрес
	 */
	private void fillWebServiceUrl(String url) {
		if (url == null || url.isEmpty()) {
			return;
		}
		putStringToPreferences(WEB_SERVICE_URL_PREFERENCE, url);
		refreshPreferenceSummary(WEB_SERVICE_URL_PREFERENCE, url);
	}

	private void putStringToPreferences(String key, String value) {
		SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
		SharedPreferences.Editor prefEditor = sharedPref.edit();
		prefEditor.putString(key, value);
		prefEditor.apply();
	}

	private void refreshPreferenceSummary(String key, String value) {
		Preference myPrefText = (Preference) findPreference(key);
		myPrefText.setSummary(value);
	}

	/**
	 * This fragment shows data and sync preferences only. It is used when the
	 * activity is showing a two-pane settings UI.
	 */
	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	public static class WebServiceAddressPreferenceFragment extends PreferenceFragment {
		@Override
		public void onCreate(Bundle savedInstanceState) {
			super.onCreate(savedInstanceState);
			addPreferencesFromResource(R.xml.preferences);

			// Bind the summaries of EditText/List/Dialog/Ringtone preferences
			// to their values. When their values change, their summaries are
			// updated to reflect the new value, per the Android Design
			// guidelines.
			bindPreferenceSummaryToValue(findPreference("webServiceAddressPref"));
		}
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
			// Обработка нажатия по кнопке "Back"
			case android.R.id.home:
				finish();
				return true;
			default:
				return super.onOptionsItemSelected(item);
		}
	}
}
