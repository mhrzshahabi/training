package com.nicico.training.iservice;


import com.nicico.training.dto.SelfDeclarationDTO;
import com.nicico.training.dto.UserDetailDTO;
import com.nicico.training.model.SelfDeclaration;

import java.util.List;

public interface ISelfDeclarationService {
    SelfDeclaration create(SelfDeclarationDTO declarationDTO);

    boolean remove(String nationalCode,String mobileNumber);

    boolean findByNumber(String number);

    List<SelfDeclaration> findByNationalCode(String nationalCode);

    UserDetailDTO findDetailByNationalCode(String nationalCode);

    List<SelfDeclaration> findAll();
}
