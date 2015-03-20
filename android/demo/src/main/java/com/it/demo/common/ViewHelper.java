package com.it.demo.common;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import com.it.core.internalstorage.InternalStorageSerializer;
import com.it.core.tools.PreferenceHelper;
import com.it.demo.R;
import com.it.demo.listener.OnImageLoaded;
import com.it.demo.manager.EmployeeManager;
import com.it.demo.model.Employee;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.io.File;

/**
 * Вспомогательный класс для работы с элементами View
 */
public class ViewHelper {

	/**
	 * Установить фотографию сотрудника в ImageView
	 * @param context Контекст
	 * @param view ImageView
	 * @param nkdk Идентификатор nkdk
	 * @param login Логин пользователя в системе IT
	 * @param imageLoadedListener Обработчик загрузки фотографии
	 */
	public static void setPhoto(Context context, final ImageView view, String nkdk, String login, final OnImageLoaded imageLoadedListener) {
		if (nkdk == null || login == null) {
			return;
		}
		final EmployeeManager employeeManager = EmployeeManager.getInstance(context);
		final Employee employee = employeeManager.findByNkdkAndLogin(nkdk, login);
		// Если не нашли пользователя, тогда задать картинку по-умолчанию
		if (employee == null) {
			view.setImageResource(R.drawable.ic_user_photo);
			return;
		}
		String photoFileName = employee.getPhotoName();
		// Если не задано имя файла фотографии, тогда задать картинку по-умолчанию
		if (photoFileName == null || photoFileName.isEmpty()) {
			view.setImageResource(R.drawable.ic_user_photo);
			return;
		}
		Picasso picasso = Picasso.with(context);
		// Попробовать загрузить фотографию с InternalStorage
		File photo = new InternalStorageSerializer().getImageFile(context, photoFileName);
		if (photo != null) {
			// Установка сохраненной фотографии
			picasso.load(photo).placeholder(R.drawable.ic_user_photo).error(R.drawable.ic_user_photo).into(view);
		} else {
			// Загрузка фотографии с сервера
			String serverFilePath = PreferenceHelper.getFileUrl(employee.getPhotoName());
			picasso.load(serverFilePath).resize(100, 100).into(new Target() {
				@Override
				public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom loadedFrom) {
					// Сохранение фотографии в InternalStorage
					employeeManager.setPhoto(employee, bitmap);
					// Установка фотографии в ImageView
					view.setImageBitmap(bitmap);
					if (imageLoadedListener != null) {
						// Вызов обработчика загрузки фотографии
						imageLoadedListener.onImageLoaded();
					}
				}

				@Override
				public void onBitmapFailed(Drawable drawable) {
				}

				@Override
				public void onPrepareLoad(Drawable drawable) {
				}
			});
		}
	}
}