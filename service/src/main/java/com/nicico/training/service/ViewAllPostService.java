/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/07/26
 */

package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.ViewAllPostDTO;
import com.nicico.training.iservice.IViewAllPostService;
import com.nicico.training.model.PostGroup;
import com.nicico.training.repository.PostGroupDAO;
import com.nicico.training.repository.ViewAllPostReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class ViewAllPostService implements IViewAllPostService {
    private final ViewAllPostReportDAO viewAllPostReportDAO;
    private final PostGroupDAO postGroupDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewAllPostReportDAO, request, converter);
    }

    @Override
    @Transactional
    public List<ViewAllPostDTO.Info> getAllPosts(Long postGroupID) {
        final PostGroup postGroup = postGroupDAO.findById(postGroupID).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        return modelMapper.map(viewAllPostReportDAO.findViewAllPostByGroupid(postGroup.getId()), new TypeToken<List<ViewAllPostDTO.Info>>() {
        }.getType());
    }
}