package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.InstituteDTO;

import java.util.List;

public interface IInstituteService {

    InstituteDTO.Info get(Long id);

    List<InstituteDTO.Info> list();

    InstituteDTO.Info create(InstituteDTO.Create request);

    InstituteDTO.Info update(Long id, InstituteDTO.Update request);

    void delete(Long id);

    void delete(InstituteDTO.Delete request);

    SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request);
}
