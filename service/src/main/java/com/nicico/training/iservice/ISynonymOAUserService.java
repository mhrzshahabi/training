package com.nicico.training.iservice;

public interface ISynonymOAUserService {

    String getNationalCodeByUserId(Long userId);

    String getFullNameByNationalCode(String nationalCode);

    String getFullNameByUserId(Long userId);
}
