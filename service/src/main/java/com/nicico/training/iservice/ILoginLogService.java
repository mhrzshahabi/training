package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.LoginLogDTO;

public interface ILoginLogService {

    SearchDTO.SearchRs<LoginLogDTO> search(SearchDTO.SearchRq request);
}
