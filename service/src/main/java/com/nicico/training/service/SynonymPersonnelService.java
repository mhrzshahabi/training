package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@RequiredArgsConstructor
public class SynonymPersonnelService  {
    private final SynonymPersonnelDAO dao;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(dao, request, SynonymPersonnel -> modelMapper.map(SynonymPersonnel, PersonnelDTO.Info.class));
    }

    public SynonymPersonnel getByNationalCode(String nationalCode) {
        return dao.findSynonymPersonnelDataByNationalCode(nationalCode);
    }
}
