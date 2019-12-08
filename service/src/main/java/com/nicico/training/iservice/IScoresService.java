package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ScoresDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IScoresService {

    ScoresDTO.Info get(Long id);


    List<ScoresDTO.Info> list();


    ScoresDTO.Info create(ScoresDTO.Create request);


    ScoresDTO.Info update(Long id, ScoresDTO.Update request);


    void delete(Long id);


    void delete(ScoresDTO.Delete request);

    SearchDTO.SearchRs<ScoresDTO.Info> search(SearchDTO.SearchRq request);
}
