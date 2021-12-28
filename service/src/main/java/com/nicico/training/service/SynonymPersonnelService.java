package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;


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

    @Transactional
    public ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<SynonymPersonnel> optPersonnel = dao.findByPersonnelNoAndDeleted(personnelCode,0);
        final SynonymPersonnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, ViewActivePersonnelDTO.PersonalityInfo.class);
    }

}
