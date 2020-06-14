/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */

package com.nicico.training.iservice;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.service.MasterDataService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public interface IMasterDataService {
    String authorize() throws IOException;

    TotalResponse<PersonnelDTO.Info> getPeople(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    TotalResponse<CompetenceDTO.Info> getCompetencies(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;

    TotalResponse<MasterDataService.CompetenceWebserviceDTO> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException;
}
