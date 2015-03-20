package com.it.core.internalstorage;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInput;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

/**
 * Сохранение объектов в внутреннем хранилище для возможности работы приложения в offline-режиме
 */
public class InternalStorageSerializer {

	private static final String IMAGES_DIRECTORY = "images";

	/**
	 * Сохранить объект
	 */
	public boolean saveJsonObject(Context context, String method, Object params, Object obj) {
		if (obj == null) {
			return false;
		}
		try {
			String fileName = createFileNameFromMethodAndParams(method, params);
			File file = new File(context.getFilesDir(), fileName);
			if (file.exists()){
				file.delete();
			}
			// Создать потоки для записи
			FileOutputStream fos = context.openFileOutput(fileName, Context.MODE_PRIVATE);
			fos.write(((String) obj).getBytes());
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * Получить один объект из внутренней памяти
	 * @param context Контекст выполнения
	 * @param method Веб-расчет
	 * @param params Параметры для отбора
	 * @return
	 */
	public String getJsonObject(Context context, String method, Object params) {
		String fileName = createFileNameFromMethodAndParams(method, params);
		File file = new File(context.getFilesDir(), fileName);
		if (file.exists()){
			try {
				FileInputStream fis = context.openFileInput(fileName);
				StringBuilder sb = new StringBuilder();
				try{
					BufferedReader reader = new BufferedReader(new InputStreamReader(fis, "UTF-8"));
					String line = null;
					while ((line = reader.readLine()) != null) {
						sb.append(line).append("\n");
					}
					fis.close();
				} catch(OutOfMemoryError om){
					om.printStackTrace();
				} catch(Exception ex){
					ex.printStackTrace();
				}
				String result = sb.toString();
				return result;
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * Сохранить картинку
	 */
	public boolean saveBitmap(Context context, String fileName, Bitmap bitmap) {
		if (bitmap == null) {
			return false;
		}
		// Create imageDir
		File file = new File(getPrivateImagesDirectory(context), fileName);
		try {
			FileOutputStream fos = new FileOutputStream(file);
			// Use the compress method on the BitMap object to write image to the OutputStream
			bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * Получить картинку из внутренней памяти
	 * @param context Контекст
	 * @param fileName Название файла
	 * @return Картинка
	 */
	public Bitmap getBitmap(Context context, String fileName) {
		File file = new File(getPrivateImagesDirectory(context), fileName);
		if (!file.exists()){
			return null;
		}
		Bitmap bitmap = null;
		try {
			bitmap = BitmapFactory.decodeStream(new FileInputStream(file));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return bitmap;
	}

	/**
	 * Получить файл картинки из внутренней памяти
	 * @param context Контекст
	 * @param fileName Название файла
	 * @return Файл картинки
	 */
	public File getImageFile(Context context, String fileName) {
		File file = new File(getPrivateImagesDirectory(context), fileName);
		if (!file.exists()) {
			return null;
		}
		return file;
	}

	public void putSerializable(Context context, String fileName, Serializable object) {
		if(object == null){
			return;
		}
		FileOutputStream fos = null;
		ObjectOutputStream oos = null;
		try {
			fos = context.openFileOutput(fileName, Context.MODE_PRIVATE);
			oos = new ObjectOutputStream(fos);
			oos.writeObject(object);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (oos != null){
					oos.close();
				}
				if (fos != null)
					fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public Serializable getSerializable(Context context, String fileName) {
		FileInputStream fis = null;
		ObjectInputStream ois = null;
		Serializable object = null;
		try {
			fis = context.openFileInput(fileName);
			ois = new ObjectInputStream(fis);
			object = (Serializable) ois.readObject();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (ois != null){
					ois.close();
				}
				if (fis != null){
					fis.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return object;
	}

	/**
	 * Создать имя файла по названию метода и параметрам запроса
	 * @param params
	 * @return
	 */
	private String createFileNameFromMethodAndParams(String methodName, Object params) {
		String fileName = methodName;
		try {
			for (Field field : params.getClass().getFields()) {
				Object fieldValue = field.get(params);
				if (fieldValue != null){
					fileName += fieldValue.toString();
				}
			}
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return fileName;
	}

	/**
	 * Получить приватную директорию картинок приложения
	 * @param context Контекст
	 * @return Директория (файл)
	 */
	private File getPrivateImagesDirectory(Context context) {
		return context.getDir(IMAGES_DIRECTORY, Context.MODE_PRIVATE);
	}
}