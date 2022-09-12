package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.PostGradeGroupDTO;
import com.nicico.training.model.PostGradeGroup;

import java.util.List;
import java.util.Set;

public interface IPostGradeGroupService {

    PostGradeGroupDTO.Info get(Long id);

    PostGradeGroupDTO.Info create(PostGradeGroupDTO.Create request);

    PostGradeGroupDTO.Info update(Long id, PostGradeGroupDTO.Update request);

    void delete(Long id);

    void delete(PostGradeGroupDTO.Delete request);

    List<PostGradeGroupDTO.Info> list();

    SearchDTO.SearchRs<PostGradeGroupDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<PostGradeGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    List<PostGradeDTO.Info> getPostGrades(Long postGradeGroupID);

    void addPostGrades(Long postGradeGroupId, Set<Long> postGradeIds);

    void removePostGrades(Long postGradeGroupId, Set<Long> postGradeIds);

    List<PostGradeGroup> getPostGradeGroupsByTrainingPostId(Long objectId);

}
