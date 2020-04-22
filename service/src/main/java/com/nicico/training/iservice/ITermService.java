package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TermDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ITermService {

    TermDTO.Info get(Long id);

    List<TermDTO.Info> list();

    TermDTO.Info create(TermDTO.Create request);

    TermDTO.Info update(Long id, TermDTO.Update request);

    void delete(Long id);

    void delete(TermDTO.Delete request);

    SearchDTO.SearchRs<TermDTO.Info> search(SearchDTO.SearchRq request);

    String checkForConflict(String sData, String eData);

    String checkConflictWithoutThisTerm(String sData, String eData, Long id);

    String LastCreatedCode(String code);

    @Transactional
    TotalResponse<TermDTO.Info> search(NICICOCriteria request);

    @Transactional
    TotalResponse<TermDTO.Year> ySearch(NICICOCriteria request);
}
