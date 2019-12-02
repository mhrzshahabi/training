package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AccountInfoDTO;

import java.util.List;

public interface IAccountInfoService {
    AccountInfoDTO.Info get(Long id);

    List<AccountInfoDTO.Info> list();

    AccountInfoDTO.Info create(AccountInfoDTO.Create request);

    AccountInfoDTO.Info update(Long id, AccountInfoDTO.Update request);

    void delete(Long id);

    void delete(AccountInfoDTO.Delete request);

    SearchDTO.SearchRs<AccountInfoDTO.Info> search(SearchDTO.SearchRq request);

    AccountInfoDTO.Info createOrUpdate(AccountInfoDTO.Create request);
}
