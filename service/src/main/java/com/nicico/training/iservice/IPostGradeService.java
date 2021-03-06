/*
ghazanfari_f, 8/29/2019, 11:50 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGradeDTO;

import java.util.List;

public interface IPostGradeService {

    List<PostGradeDTO.Info> list();

    SearchDTO.SearchRs<PostGradeDTO.Info> search(SearchDTO.SearchRq rq);

    SearchDTO.SearchRs<PostGradeDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    PostGradeDTO.Info get(Long id);

    List<PostDTO.TupleInfo> getPosts(Long id);
}
