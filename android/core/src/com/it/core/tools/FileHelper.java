package com.it.core.tools;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.webkit.MimeTypeMap;

import com.it.core.R;
import com.it.core.application.ApplicationBase;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Класс для работы с файлами
 */
public class FileHelper {

    /**
     * Получить временный каталог
     * @return Каталог
     */
    public static File getTempDir(){
        Context context = ApplicationBase.getInstance().getApplicationContext();
        File dir = context.getExternalCacheDir();
        if (dir == null){
            dir = context.getCacheDir();
        }
        return dir;
    }

    /**
     * Удаление файлов из временного каталога
     */
    public static void deleteFilesFromTemp(){
        File directory = getTempDir();
        if (directory.isDirectory()) {
            String[] children = directory.list();
            for (String aChildren : children) {
                new File(directory, aChildren).delete();
            }
        }
    }

    /**
     * Получить имя файла без расширения
     *
     * @param fileName Имя файла (с расширением)
     * @return Имя файла без расширения
     */
    public static String getNameWithoutType(String fileName){
        return fileName.substring(0, fileName.lastIndexOf("."));
    }

    /**
     * Получить расширение файла
     * @param fileName Имя файла
     * @return Расширение файла (без точки)
     */
    public static String getExtenstion(String fileName) {
        return fileName.substring(fileName.lastIndexOf(".") + 1);
    }

    /**
     * Открыть файл
     * @param path Путь к файлу
     */
    public static void openFile(Activity activity, String path){
        if(path == null || activity == null) { return; }
        File f = new File(path);
        Intent newIntent = new Intent(Intent.ACTION_VIEW);

        String mimeType = new FileHelper().getMimeType(f);
        newIntent.setDataAndType(Uri.fromFile(f), mimeType);
        newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            if(f.exists()) {
                activity.startActivity(newIntent);
            }
        } catch (android.content.ActivityNotFoundException e) {

        }
    }

    /**
     * Получить файл в виде строки
     * @param filePath Путь к файлу
     * @return Строка
     * @throws Exception
     */
    public String GetStringFromFile (String filePath) throws Exception {
        File file = new File(filePath);
        if (!file.exists()){
            return null;
        }
        FileInputStream fin = new FileInputStream(file);
        String ret = convertStreamToString(fin);
        fin.close();
        return ret;
    }

    /**
     * Получить иконку, соответствующую к формату документа
     *
     * @param fileName - название документа (с расширением)
     * @return идентификатор иконки
     */
    public int getIconByFileName(String fileName){
        String type = fileName.substring(fileName.lastIndexOf(".") + 1).toUpperCase();
        return getIconByExtension(type);
    }

    public int getIconByExtension(String fileExtension){
        int iconId = 0;
        Formats currentFormat;
        try{
            currentFormat = Formats.valueOf(fileExtension.toUpperCase());
        }
        catch(Exception e){
            currentFormat = Formats.DOCUMENT;
        }
        switch (currentFormat) {
            case PDF:
                iconId = R.drawable.ic_pdf;
                break;
            case DOC:
            case DOCX:
                iconId = R.drawable.ic_word;
                break;
            case PTT:
            case PTTX:
                iconId = R.drawable.ic_power_point;
                break;
            case XLS:
            case XLSX:
                iconId = R.drawable.ic_excel;
                break;
            case ZIP:
                iconId = R.drawable.ic_zip;
                break;
            case JPG:
            case JPEG:
                iconId = R.drawable.ic_jpg;
                break;
            case PNG:
                iconId = R.drawable.ic_png;
                break;
            default:
                iconId = R.drawable.ic_document;
                break;
        }
        return iconId;
    }

    /**
     * Конвертировать поток в строку
     * @param is Входящий поток
     * @return Строка
     * @throws Exception
     */
    private String convertStreamToString(InputStream is) throws Exception {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line = null;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        reader.close();
        return sb.toString();
    }

    private String getMimeType(File file){
        return MimeTypeMap.getSingleton().
                getMimeTypeFromExtension(getType(file.toString()).substring(1));
    }

    private String getType(String url){
        if (url.indexOf("?")>-1) {
            url = url.substring(0,url.indexOf("?"));
        }
        if (url.lastIndexOf(".") == -1) {
            return null;
        } else {
            String ext = url.substring(url.lastIndexOf(".") );
            if (ext.indexOf("%")>-1) {
                ext = ext.substring(0,ext.indexOf("%"));
            }
            if (ext.indexOf("/")>-1) {
                ext = ext.substring(0,ext.indexOf("/"));
            }
            return ext.toLowerCase();
        }
    }

    /**
     * Форматы файлов
     */
    private enum Formats {
        PDF,
        DOC,
        DOCX,
        PTT,
        PTTX,
        XLS,
        XLSX,
        ZIP,
        JPG,
        JPEG,
        PNG,
        DOCUMENT
    }
}