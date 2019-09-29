/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.IPostService;
import com.nicico.training.model.Post;
import com.nicico.training.repository.PostDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService implements IPostService {

    private final PostDAO postDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public List<PostDTO.Info> list() {
        return modelMapper.map(postDAO.findAll(), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public Page<Post> listByJobId(Long jobId, Pageable pageable) {
        return postDAO.findAllByJobId(jobId, pageable);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(postDAO, request, post -> modelMapper.map(post, PostDTO.Info.class));
    }
}
