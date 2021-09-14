package com.nicico.training.iservice;

public interface IMobileVerifyService {

    boolean add(String nationalCode, String number);

    boolean remove(String nationalCode, String number);

    boolean checkVerification(String nationalCode, String number);
}
