/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PersonnelService implements IPersonnelService {

    private final PersonnelDAO PersonnelDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public List<PersonnelDTO.Info> list() {
        return modelMapper.map(PersonnelDAO.findAll(), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(PersonnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(PersonnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }
}
