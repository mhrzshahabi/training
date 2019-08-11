package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationLicenseDTO;

import java.util.List;

public interface IEducationLicenseService {
    EducationLicenseDTO.Info get(Long id);

    List<EducationLicenseDTO.Info> list();

    EducationLicenseDTO.Info create(EducationLicenseDTO.Create request);

    EducationLicenseDTO.Info update(Long id, EducationLicenseDTO.Update request);

    void delete(Long id);

    void delete(EducationLicenseDTO.Delete request);


    SearchDTO.SearchRs<EducationLicenseDTO.Info> search(SearchDTO.SearchRq request);

    //------------------------
}
