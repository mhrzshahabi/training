package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.model.SynonymPersonnel;

public interface ISynonymPersonnelService {

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria nicicoCriteria);

    ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

    SynonymPersonnel getByNationalCode(String nationalCode);

    SynonymPersonnel getByPersonnelNo2(String personnelNo2);
}
