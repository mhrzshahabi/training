/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.iservice.IPostGradeService;
import com.nicico.training.model.PostGrade;
import com.nicico.training.repository.PostGradeDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PostGradeService implements IPostGradeService {

    private final PostGradeDAO postGradeDAO;
    private final ModelMapper modelMapper;
    private final WorkGroupService workGroupService;

    @Transactional(readOnly = true)
    @Override
    public List<PostGradeDTO.Info> list() {
        return modelMapper.map(postGradeDAO.findAll(), new TypeToken<List<PostGradeDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGradeDTO.Info> search(SearchDTO.SearchRq request) {
        request.setCriteria(workGroupService.applyPermissions(request.getCriteria(), PostGrade.class, SecurityUtil.getUserId()));
        return SearchUtil.search(postGradeDAO, request, postGrade -> modelMapper.map(postGrade, PostGradeDTO.Info.class));
    }
}
