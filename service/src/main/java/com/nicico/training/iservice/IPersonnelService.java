package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ImportedPersonnelAndPostModel;
import com.nicico.training.dto.ImportedPersonnelAndPostRequest;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.SysUserInfoModel;
import com.nicico.training.model.Personnel;
import java.util.Set;

import java.util.List;
import java.util.Optional;

public interface IPersonnelService {

    List<PersonnelDTO.Info> list();

    PersonnelDTO.Info get(Long id);

    Personnel getPersonnel(Long id);

    SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq rq);

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request);

    List<PersonnelDTO.InfoForStudent> checkPersonnelNos(List<String> personnelNos,Long courseId);

    List<PersonnelDTO.Info> getByPostCode(Long postId);

    List<Personnel> getByPostCode(String postCode);

    List<PersonnelDTO.Info> getByJobNo(String jobNo);

    PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);


    PersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode);

    List<PersonnelDTO.Info> findAllStatisticalReportFilter(String reportType);

    PersonnelDTO.DetailInfo findPersonnel(Long personnelType,Long personnelId,String nationalCode, String personnelNo);

    PersonnelDTO.Info getByPersonnelCodeAndNationalCode(String nationalCode, String personnelNo);

    SearchDTO.SearchRs<PersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName);

    List<Long> inDepartmentIsPlanner(String mojtameCode);

    Optional<Personnel> getOneByNationalCodeAndDeleted(String nationalCode, int i);

//    <R> R getPOrRegisteredP(Long id, Function<Object, R> converter);

    boolean isPresent(String nationalCode);

    SysUserInfoModel minioValidate();

    Personnel getByPersonnelNumber(String personnelCode);

    Set<ImportedPersonnelAndPostModel> getImportPostAndPersonnel(List<ImportedPersonnelAndPostRequest> personnelNos);

    Optional<Personnel> findById(Long PersonnelId);

    String getPersonnelFullName(Long id);

    boolean changeComplex(Long id,String complex);

    Long getDepartmentIdByNationalCode(String nationalCode);

    boolean changeEmploymentDate(Long id);

    boolean changeDepartment(Long id, Long depId);
    boolean isPresentByNationalCode(String nationalCode);
}
