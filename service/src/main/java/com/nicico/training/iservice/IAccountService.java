package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AccountDTO;

import java.util.List;

public interface IAccountService {
    AccountDTO.Info get(Long id);

    List<AccountDTO.Info> list();

    AccountDTO.Info create(AccountDTO.Create request);

    AccountDTO.Info update(Long id, AccountDTO.Update request);

    void delete(Long id);

    void delete(AccountDTO.Delete request);

    SearchDTO.SearchRs<AccountDTO.Info> search(SearchDTO.SearchRq request);

}
