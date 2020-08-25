/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */

package com.nicico.training.iservice;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.service.MasterDataService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface IMasterDataService {
    String authorize() throws IOException;

    TotalResponse<PersonnelDTO.Info> getPeople(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    TotalResponse<CompetenceDTO.Info> getCompetencies(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    TotalResponse<CompetenceWebserviceDTO> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    TotalResponse<ViewPostDTO.Info> getPosts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    List<CompetenceWebserviceDTO> getDepartmentsByParentCode(String xUrl) throws IOException;

    List<CompetenceWebserviceDTO> getDepartmentsChilderenByParentCode(List<Long> xUrl) throws IOException;

    List<CompetenceWebserviceDTO> getDepartmentsByParams(String convertedCriteriaStr, String count, String operator, String startIndex, String sortBy) throws IOException;

    CompetenceWebserviceDTO getDepartmentsById(Long id) throws IOException;

    PersonnelDTO.Info getParentEmployee(Long id) throws IOException;

    /*List<PersonnelDTO.Info> getChildrenEmployee(Long id) throws IOException;*/

    List<PersonnelDTO.Info> getSiblingsEmployee(Long id) throws IOException;

    List<PersonnelDTO.Info> getPersonByNationalCode(String nationalCode) throws IOException;
}
