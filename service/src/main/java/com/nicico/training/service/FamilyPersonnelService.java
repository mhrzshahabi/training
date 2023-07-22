package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IFamilyPersonnelService;
import com.nicico.training.model.FamilyPersonnel;
import com.nicico.training.repository.FamilyPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class FamilyPersonnelService implements IFamilyPersonnelService {

    private final FamilyPersonnelDAO familyPersonnelDAO;


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs search(SearchDTO.SearchRq searchRq, Function converter) {
        return SearchUtil.search(familyPersonnelDAO, searchRq, converter);
    }

    @Transactional(readOnly = true)
    @Override
    public FamilyPersonnel getById(Long id) {
        return familyPersonnelDAO.getById(id);
    }
}
