package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AccountInfoDTO;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IInstituteAccountService {
    List<AccountInfoDTO.Info> get(Long id, Pageable pageable);

    List<AccountInfoDTO.Info> list();

    AccountInfoDTO.CreateOrUpdate create(Object request);

    AccountInfoDTO.CreateOrUpdate update(Long id, Object request);

    void delete(Long id);

    void delete(AccountInfoDTO.Delete request);

    SearchDTO.SearchRs<AccountInfoDTO.Info> search(SearchDTO.SearchRq request);

    List<AccountInfoDTO.Info> getAllAccountForExcel(Long instituteId);

}
