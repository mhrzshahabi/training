package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.model.RequestItem;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.List;

public interface IRequestItemService {

    RequestItem create(RequestItem competenceRequest);

    RequestItemWithDiff update(RequestItem requestItem, Long id);

    RequestItem get(Long id);

    void delete(Long id);

    List<RequestItem> getList();

    Integer getTotalCount();

    List<RequestItem> search(SearchDTO.SearchRq request);

    RequestItemDto createList(List<RequestItem> requestItem);

    List<RequestItem> getListWithCompetenceRequest(Long id);

    List<RequestItemDTO.Info> getItemListWithCompetenceRequest(Long id);
}
