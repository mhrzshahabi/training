package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.BankBranchDTO;

import java.util.List;

public interface IBankBranchService {
    BankBranchDTO.Info get(Long id);

    List<BankBranchDTO.Info> list();

    BankBranchDTO.Info create(BankBranchDTO.Create request);

    BankBranchDTO.Info update(Long id, BankBranchDTO.Update request);

    void delete(Long id);

    void delete(BankBranchDTO.Delete request);

    SearchDTO.SearchRs<BankBranchDTO.Info> search(SearchDTO.SearchRq request);

}
