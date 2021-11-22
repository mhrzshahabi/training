package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class SynonymPersonnelService  {
    private final SynonymPersonnelDAO dao;

    public TotalResponse<SynonymPersonnel> getData(NICICOCriteria nicicoCriteria) {
        GridResponse<SynonymPersonnel> gridResponse = new GridResponse<>();
        gridResponse.setData(dao.getData());
        gridResponse.setEndRow(5);
        gridResponse.setTotalRows(5);
        gridResponse.setStartRow(nicicoCriteria.get_startRow());
        return new TotalResponse<>(gridResponse);
    }

}
