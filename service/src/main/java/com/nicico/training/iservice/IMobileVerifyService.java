package com.nicico.training.iservice;

import com.nicico.training.dto.UserDetailDTO;
import com.nicico.training.model.MobileVerify;

public interface IMobileVerifyService {

    MobileVerify add(String nationalCode, String number);

    boolean remove(String nationalCode, String number);

    boolean checkVerificationIfNotPresentAdd(String nationalCode, String number);

    boolean changeStatus(String nationalCode, String number,boolean status);

    UserDetailDTO findDetailByNationalCode(String nationalCode);
}
