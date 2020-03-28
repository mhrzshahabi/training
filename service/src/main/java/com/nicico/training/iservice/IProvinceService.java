package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ProvinceDTO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface IProvinceService {
    ProvinceDTO.Info get(long id);

    List<ProvinceDTO.Info> list();

    ProvinceDTO.Info create(ProvinceDTO.Create request, HttpServletResponse response);

    ProvinceDTO.Info update(Long id,ProvinceDTO.Update request, HttpServletResponse response);

    void delete(Long id);

    void delete(ProvinceDTO.Delete request);

    SearchDTO.SearchRs<ProvinceDTO.Info> search(SearchDTO.SearchRq request);
}
