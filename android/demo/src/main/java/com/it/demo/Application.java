package com.it.demo;

import com.it.core.application.ApplicationBase;

public class Application extends ApplicationBase{

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public Class<?> getMainActivityClass() {
        return MainActivity.class;
    }

    @Override
    public String getDefaultPackage() {
        return "com.it.demo";
    }
}