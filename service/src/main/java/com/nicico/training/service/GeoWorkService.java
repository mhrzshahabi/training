package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GeoWorkDTO;
import com.nicico.training.iservice.IGeoWorkService;
import com.nicico.training.repository.GeoWorkDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class GeoWorkService implements IGeoWorkService {

    private final GeoWorkDAO geoWorkDAO;
    private final ModelMapper modelMapper;


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GeoWorkDTO> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(geoWorkDAO, request, o -> modelMapper.map(o, GeoWorkDTO.class));
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GeoWorkDTO> getCompanyList(SearchDTO.SearchRq request) {
        setCriteria(request, makeNewCriteria("peopleType", "ContractorPersonal", EOperator.equals, null));
        return search(request);
    }
}