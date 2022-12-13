package com.nicico.training.iservice;

import com.nicico.training.model.SynonymOAUser;

import java.util.List;

public interface ISynonymOAUserService {

    String getNationalCodeByUserId(Long userId);

    String getFullNameByNationalCode(String nationalCode);

    String getFullNameByUserId(Long userId);

    List<SynonymOAUser> listOfUser(List<Long> ids);
}
