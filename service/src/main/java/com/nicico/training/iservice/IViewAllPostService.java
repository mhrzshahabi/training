/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/07/26
 */

package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.ViewAllPostDTO;

import java.util.List;
import java.util.function.Function;

public interface IViewAllPostService {
    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    List<ViewAllPostDTO.Info> getAllPosts(Long postGroupID);
}
