package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.model.ClassContract;

import java.util.function.Function;

public interface IClassContractService {

    ClassContract getClassContract(Long id);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

}
