package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.RequestItem;
import com.nicico.training.repository.RequestItemDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final RequestItemDAO requestItemDAO;
    private final ICompetenceRequestService competenceRequestService;

    @Override
    @Transactional
    public RequestItem create(RequestItem requestItem) {
        CompetenceRequest competenceRequest= competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        return requestItemDAO.save(requestItem);
    }

    @Override
    public RequestItem update(RequestItem newData, Long id) {
        RequestItem requestItem=get(id);
        requestItem.setAffairs(newData.getAffairs());
        requestItem.setCompetenceReq(newData.getCompetenceReq());
        requestItem.setCompetenceReqId(newData.getCompetenceReqId());
        requestItem.setLastName(newData.getLastName());
        requestItem.setName(newData.getName());
        requestItem.setWorkGroupCode(newData.getWorkGroupCode());
        requestItem.setPersonnelNumber(newData.getPersonnelNumber());
        requestItem.setPost(newData.getPost());
        requestItem.setState(newData.getState());
        return create(requestItem);
    }

    @Override
    public RequestItem get(Long id) {
        return requestItemDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public void delete(Long id) {
        requestItemDAO.deleteById(id);
    }

    @Override
    public List<RequestItem> getList() {
        return requestItemDAO.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(requestItemDAO.count());
    }

    @Override
    public List<RequestItem> search(SearchDTO.SearchRq request) {
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
       return all.getContent();
        } else {
            return requestItemDAO.findAll(NICICOSpecification.of(request));
        }

    }

    @Override
    @Transactional
    public void createList(List<RequestItem> requestItems) {
        for (RequestItem requestItem:requestItems){
            create(requestItem);
        }
    }

    @Override
    public List<RequestItem> getListWithCompetenceRequest(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id);
    }


}
