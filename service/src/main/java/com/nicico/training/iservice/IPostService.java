/*
ghazanfari_f, 8/29/2019, 11:50 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;

import java.util.List;

public interface IPostService {

    List<PostDTO.Info> list();

    SearchDTO.SearchRs<PostDTO.Info> search(SearchDTO.SearchRq rq);
}
