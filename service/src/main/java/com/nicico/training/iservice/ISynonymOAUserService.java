package com.nicico.training.iservice;

public interface ISynonymOAUserService {

    String getNationalCodeByUserId(Long userId);

    String getFullNameByUserId(Long userId);

}
